extends Node

# The port we will listen to.
const PORT = 9080
# Our WebSocketServer instance.
var _server = WebSocketServer.new()
var player_one_client_id
var player_two_client_id

var action_player_one =  InputEventAction.new()
var next_step_player_one = false
var action_player_two =  InputEventAction.new()
var next_step_player_two = false

var Ball = preload("Ball.tscn")
var ball = Ball.instance()
var score_player_one = 0
var score_player_two = 0
var reward_player_one=0
var reward_player_two=0

var playing = false
var score_event = false
var game_done = false

const SPACE_TO_PLAY = "Press SPACE to Play!"
const P1_WIN = "Player 1 won!"
const P2_WIN = "Player 2 won!"
var message = SPACE_TO_PLAY

export var enable_rendering = true
export var learn_with_images = true
export var playtime_per_step = 0.1

func _ready():
    if not enable_rendering:
        VisualServer.render_loop_enabled = false # disable rendering to create a massive boost
    if learn_with_images:
        $DisplayMessage.hide()
        $Player1Score.hide()
        $Player2Score.hide()
    
    # Connect base signals to get notified of new client connections,
    # disconnections, and disconnect requests.
    _server.connect("client_connected", self, "_connected")
    _server.connect("client_disconnected", self, "_disconnected")
    _server.connect("client_close_request", self, "_close_request")
    # This signal is emitted when not using the Multiplayer API every time a
    # full packet is received.
    # Alternatively, you could check get_peer(PEER_ID).get_available_packets()
    # in a loop for each connected peer.
    _server.connect("data_received", self, "_on_data")
    # Start listening on the given port.
    var err = _server.listen(PORT)
    if err != OK:
        print("Unable to start server")
        set_process(false)
        
    set_ball()
    $PlayerOne.start($StartPositionPlayerOne.position)
    $PlayerTwo.start($StartPositionPlayerTwo.position)
    display_message()
    update_score()
    pause()


func _input(_event):
    if Input.is_key_pressed(KEY_SPACE):
        play()

func play():
    if game_done: # if game was done, reset states to start a fresh game
        game_done = false
        score_player_one = 0
        score_player_two = 0
        message = SPACE_TO_PLAY
        update_score()    
    playing = true
    ball.set_playing(playing)
    $DisplayMessage.visible = false


func _process(delta):
    # Call this in _process or _physics_process.
    # Data transfer, and signals emission will only happen when calling this function.
    _server.poll()

    check_point_scored()
    handle_score_event()
    handle_game_end()
    
func check_point_scored():
    if ball.position.x <= 0:
        score_event = true
        score_player_two += 1
        reward_player_one=(-1)
        reward_player_two=1
        print("player two won")
    if ball.position.x >= 1024:
        score_event = true
        score_player_one += 1
        reward_player_one=1
        reward_player_two=(-1)
        print("player one won")
    update_score()
    if score_player_one == 5 or score_player_two == 5:
        game_done = true

func handle_score_event():
    if score_event:
        remove_ball()
        set_ball()
        reset_paddle_positions()
        display_message()
        playing = false
        score_event = false

    
func update_score():
    $Player1Score.text = str(score_player_one)
    $Player2Score.text = str(score_player_two)

func display_message():
    $DisplayMessage.text = message
    $DisplayMessage.visible = true
    

func new_game():
    score_player_one = 0
    score_player_two = 0
    reward_player_one = 0
    reward_player_two = 0
    $PlayerOne.start($StartPositionPlayerOne.position)
    $PlayerTwo.start($StartPositionPlayerTwo.position)
    $StartTimer.start()

func remove_ball():
    remove_child(ball)

func set_ball():
    ball = Ball.instance()
    add_child(ball)
    ball.start($StartPositionBall.position)

func reset_paddle_positions():
    $PlayerOne.start($StartPositionPlayerOne.position)
    $PlayerTwo.start($StartPositionPlayerTwo.position)

func handle_game_end():
    if game_done:
        if score_player_one == 5:
            message = P1_WIN
        else:
            message = P2_WIN
        display_message()




func _on_PlayerTwo_hit():
    ball.ball_hit_paddle($PlayerTwo.position, $PlayerTwo/CollisionShape2D.shape.extents, false)
    pass # Replace with function body.


func _on_PlayerOne_hit():
    ball.ball_hit_paddle($PlayerOne.position, $PlayerOne/CollisionShape2D.shape.extents, true)
    pass # Replace with function body.




func _connected(id, proto):
    # This is called when a new peer connects, "id" will be the assigned peer id,
    # "proto" will be the selected WebSocket sub-protocol (which is optional)
    #print("Client %d connected with protocol: %s" % [id, proto])
    pass

func _close_request(id, code, reason):
    # This is called when a client notifies that it wishes to close the connection,
    # providing a reason string and close code.
    #print("Client %d disconnecting with code: %d, reason: %s" % [id, code, reason])
    pass

func _disconnected(id, was_clean = false):
    # This is called when a client disconnects, "id" will be the one of the
    # disconnecting client, "was_clean" will tell you if the disconnection
    # was correctly notified by the remote peer before closing the socket.
    if( player_one_client_id == id ):
        player_one_client_id = null
        #print("Player One with Client %d disconnected, clean: %s" % [id, str(was_clean)])
    if(player_two_client_id== id):
        player_two_client_id = null
        #print("Player Two with Client %d disconnected, clean: %s" % [id, str(was_clean)])
    #else:
        #print("Client %d disconnected, clean: %s" % [id, str(was_clean)])


func _on_data(id):
    
   # Print the received packet, you MUST always use get_peer(id).get_packet to receive data,
    # and not get_packet directly when not using the MultiplayerAPI.
    var pkt = _server.get_peer(id).get_packet()
    #print("Got data from client %d: %s ... echoing" % [id, pkt.get_string_from_utf8()])
    
    var data = (JSON.parse(pkt.get_string_from_utf8())).get_result()
    #print(data)
    if(data):
        for i in data:
            #print(i)
            if(i=="player_one"):
                player_one_client_id = id
            if(i=="player_two"):
                player_two_client_id = id
            if(i == "player_one_up"):
                action_player_one = InputEventAction.new()
                action_player_one.action = i
                action_player_one.pressed = true
                Input.parse_input_event(action_player_one)
                next_step_player_one  = true
            if(i == "player_one_down"):
                action_player_one = InputEventAction.new()
                action_player_one.action = i
                action_player_one.pressed = true
                Input.parse_input_event(action_player_one)
                next_step_player_one  = true
            if(i=="player_one_nothing"):
                next_step_player_one  = true
            if(i == "player_two_up"):
                action_player_two = InputEventAction.new()
                action_player_two.action = i
                action_player_two.pressed = true
                Input.parse_input_event(action_player_two)
                next_step_player_two  = true
            if(i == "player_two_down"):
                action_player_two = InputEventAction.new()
                action_player_two.action = i
                action_player_two.pressed = true
                Input.parse_input_event(action_player_two)
                next_step_player_two  = true
            if(i == "player_two_nothing"):
                next_step_player_two  = true
            if(i=="connect_player" or i == "start_game"):
                if(i == "start_game"):
                    play()
                var return_value = null
                if learn_with_images:
                    return_value = yield(get_yielded_return_value_as_utf8_JSON(), "completed")
                else:
                    return_value = get_return_value_as_utf8_JSON()
                _server.get_peer(id).put_packet(return_value)
                pass
    if(next_step_player_one and next_step_player_two):
        unpause()
        $PlayerOne.run(playtime_per_step)
        $PlayerTwo.run(playtime_per_step)
        ball.run(playtime_per_step)
        timeout()
        
func get_observarion():
    return {"PlayerOne":{"X":$PlayerOne.position.x,"Y":$PlayerOne.position.y}, "PlayerTwo":{"X":$PlayerTwo.position.x,"Y":$PlayerTwo.position.y}, "ball":ball.get_observation()}
        
func get_return_value_as_utf8_JSON():
    var observation = get_observarion()
    var return_value = {"observation":observation, "reward":{"PlayerOne":reward_player_one, "PlayerTwo":reward_player_two}, "done":(not playing), "info":{"PlayerOneScore":score_player_one, "PlayerTwoScore":score_player_two}}
    return (JSON.print(return_value)).to_utf8()

func get_yielded_return_value_as_utf8_JSON():
    var observation = get_observarion()
    var screenshot = yield(get_screenshot(), "completed")
    var return_value = {"observation":observation, "reward":{"PlayerOne":reward_player_one, "PlayerTwo":reward_player_two}, "done":(not playing), "info":{"PlayerOneScore":score_player_one, "PlayerTwoScore":score_player_two, "screenshot":screenshot}}
    return (JSON.print(return_value)).to_utf8()

func get_screenshot():
    get_viewport().set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)
    # Wait until the frame has finished before getting the texture.
    yield(VisualServer, "frame_post_draw")

    var thumbnail = get_viewport().get_texture().get_data()
    thumbnail.flip_y()    
    thumbnail.resize(100, 60 )
    thumbnail.convert(Image.FORMAT_RGB8 ) # Farbe
    #thumbnail.convert(Image.FORMAT_L8 ) # S/W
    
    #thumbnail.save_png('test.png') # Save Image as file - to debug

    var array : PoolByteArray = thumbnail.get_data()
    var sg_width = thumbnail.get_width()
    var sg_height = thumbnail.get_height()
    var sg_format = thumbnail.get_format()
    var sg_u_size = array.size()
    var sg_saved_img = Marshalls.raw_to_base64(array)

    var metadata = {"image" : sg_saved_img, "size" : sg_u_size, "width" : sg_width, "height" : sg_height, "format" : sg_format}
    
    return metadata

func timeout():
    pause()  
    action_player_one.pressed = false
    action_player_two.pressed = false
    Input.parse_input_event(action_player_one)
    Input.parse_input_event(action_player_two)
    next_step_player_one = false
    next_step_player_two = false
    
    var return_value = null
    if learn_with_images:
        return_value = yield(get_yielded_return_value_as_utf8_JSON(), "completed")
    else:
        return_value = get_return_value_as_utf8_JSON()
        
    reward_player_one = 0
    reward_player_two = 0
    ##print(return_value)
    if(player_one_client_id):
        _server.get_peer(player_one_client_id).put_packet(return_value)
    if(player_two_client_id):
        _server.get_peer(player_two_client_id).put_packet(return_value)

func pause():
    #print("pause")
    ball.set_pause(true)
    $PlayerOne.set_pause(true)
    $PlayerTwo.set_pause(true)
    
func unpause():
    #print("unpause")
    ball.set_pause(false)
    $PlayerOne.set_pause(false)
    $PlayerTwo.set_pause(false)

