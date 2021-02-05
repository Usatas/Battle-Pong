extends Node

# The port we will listen to.
const PORT = 9080
# Our WebSocketServer instance.
var _server = WebSocketServer.new()
var player_one_client_id
var player_two_client_id



var action_player_one =  InputEventAction.new()
var next_step_player_one = false
var action_trainer_one = ""

var action_player_two =  InputEventAction.new()
var next_step_player_two = false
var action_trainer_two = ""

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

var enable_rendering = true
var learn_with_images = true
var game_playtime_per_step = 0.1
var max_wins = 21

func _ready():
    enable_rendering = $"/root/GameSettings".rendering_enabled
    learn_with_images = $"/root/GameSettings".learn_with_images
    game_playtime_per_step = $"/root/GameSettings".game_playtime_per_step
    max_wins = $"/root/GameSettings".game_wins_to_reset
    
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
    var server_err = _server.listen(PORT)
    if server_err != OK:
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
        if score_player_one >= max_wins:
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
    if(player_two_client_id == id):
        player_two_client_id = null

func _on_data(id):
    
   # Print the received packet, you MUST always use get_peer(id).get_packet to receive data,
    # and not get_packet directly when not using the MultiplayerAPI.
    var pkt = _server.get_peer(id).get_packet()
    #print("Got data from client %d: %s ... echoing" % [id, pkt.get_string_from_utf8()])
    
    var data = (JSON.parse(pkt.get_string_from_utf8())).get_result()
    print(data)
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
                    return_value = yield(get_yielded_return_value(), "completed")
                else:
                    return_value = get_return_value()
                    
                if (player_one_client_id != null) and (player_one_client_id == id):    
                    _server.get_peer(id).put_packet((JSON.print(return_value['player_one'])).to_utf8())
                elif player_two_client_id != null and player_two_client_id == id:
                    _server.get_peer(id).put_packet((JSON.print(return_value['player_two'])).to_utf8())
                else:
                    _server.get_peer(id).put_packet((JSON.print(return_value)).to_utf8()) # Fallback, if the id is unknown
                pass
                
            if($"/root/GameSettings".trainings_mode_enabled):
                if(i=="player_one_training"):
                    next_step_player_one = true
                    # is w pressed => up
                    #elif is s pressed => down
                    # else => nothing
                    if(Input.is_action_pressed("player_one_up")):
                        action_trainer_one = "up"
                    elif Input.is_action_pressed("player_one_down"):
                        action_trainer_one = "down"
                    else:
                        action_trainer_one = "nothing"
                if(i=="player_two_training"):
                    next_step_player_two = true
                    # is arrow_up pressed => up
                    #elif is arrow_down pressed => down
                    # else => nothing          
                    if(Input.is_action_pressed("player_two_up")):
                        action_trainer_two = "up"
                    elif Input.is_action_pressed("player_two_down"):
                        action_trainer_two = "down"
                    else:
                        action_trainer_two = "nothing"          
                        
    if(next_step_player_one and next_step_player_two):
        if($"/root/GameSettings".trainings_mode_enabled and $"/root/GameSettings".trainer_realtime_enabled):
            yield(get_tree().create_timer(game_playtime_per_step), "timeout")
        unpause()
        $PlayerOne.run(game_playtime_per_step)
        $PlayerTwo.run(game_playtime_per_step)
        ball.run(game_playtime_per_step)
        timeout()
    
        
func get_observation():
    var ball_observation=ball.get_observation()
    var player_one = {"PlayerOne":{"X":$PlayerOne.position.x,"Y":$PlayerOne.position.y, "TrainingAction":action_trainer_one}, "PlayerTwo":{"X":$PlayerTwo.position.x,"Y":$PlayerTwo.position.y, "TrainingAction":action_trainer_two}, "ball":ball_observation['player_one']}
    var player_two = {"PlayerOne":{"X":abs($PlayerTwo.position.x - $"/root/GameSettings".display_window_width),"Y":$PlayerTwo.position.y, "TrainingAction":action_trainer_two}, "PlayerTwo":{"X":abs($PlayerOne.position.x- $"/root/GameSettings".display_window_width),"Y":$PlayerOne.position.y, "TrainingAction":action_trainer_one}, "ball":ball_observation['player_two']}
    return {"player_one":player_one, "player_two":player_two}
        
func get_return_value():
    var observation = get_observation()
    var return_value_player_one = {"observation":observation['player_one'], "reward":{"PlayerOne":reward_player_one, "PlayerTwo":reward_player_two}, "done":(not playing), "info":{"PlayerOneScore":score_player_one, "PlayerTwoScore":score_player_two}}
    var return_value_player_two = {"observation":observation['player_two'], "reward":{"PlayerOne":reward_player_two, "PlayerTwo":reward_player_one}, "done":(not playing), "info":{"PlayerOneScore":score_player_two, "PlayerTwoScore":score_player_one}}
    return {'player_one':return_value_player_one, 'player_two':return_value_player_two}

func get_yielded_return_value():
    var observation = get_observation()
    var screenshot = yield(get_screenshot(), "completed")

    var return_value_player_one = {"observation":observation['player_one'], "reward":{"PlayerOne":reward_player_one, "PlayerTwo":reward_player_two}, "done":(not playing), "info":{"PlayerOneScore":score_player_one, "PlayerTwoScore":score_player_two, "screenshot":screenshot['player_one']}}
    var return_value_player_two = {"observation":observation['player_two'], "reward":{"PlayerOne":reward_player_two, "PlayerTwo":reward_player_one}, "done":(not playing), "info":{"PlayerOneScore":score_player_two, "PlayerTwoScore":score_player_one, "screenshot":screenshot['player_two']}}
    return {'player_one':return_value_player_one, 'player_two':return_value_player_two}

func get_screenshot():
    get_viewport().set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)
    # Wait until the frame has finished before getting the texture.
    yield(VisualServer, "frame_post_draw")

    var thumbnail = get_viewport().get_texture().get_data()
    thumbnail.flip_y()    
    thumbnail.resize(100, 60 )
    if $"/root/GameSettings".image_format == "RGB8": 
        thumbnail.convert(Image.FORMAT_RGB8 ) # Farbe
    elif $"/root/GameSettings".image_format =="L8":
        thumbnail.convert(Image.FORMAT_L8 ) # S/W
    else:
        thumbnail.convert(Image.FORMAT_L8 ) # Settings
    
    #thumbnail.save_png('test.png') # Save Image as file - to debug

    var sg_width = thumbnail.get_width()
    var sg_height = thumbnail.get_height()
    var sg_format = thumbnail.get_format()
    
    var array_player_one : PoolByteArray = thumbnail.get_data()
    var sg_saved_img_player_one = Marshalls.raw_to_base64(array_player_one)
    var sg_u_size_player_one = array_player_one.size()
    var screenshot_player_one = {"image" : sg_saved_img_player_one, "size" : sg_u_size_player_one, "width" : sg_width, "height" : sg_height, "format" : sg_format}
    
    thumbnail.flip_x()
    var array_player_two : PoolByteArray = thumbnail.get_data()
    var sg_saved_img_player_two = Marshalls.raw_to_base64(array_player_two)
    var sg_u_size_player_two = array_player_two.size()
    var screenshot_player_two = {"image" : sg_saved_img_player_one, "size" : sg_u_size_player_two, "width" : sg_width, "height" : sg_height, "format" : sg_format}
    
    
    return {"player_one":screenshot_player_one, "player_two":screenshot_player_two}


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
        return_value = yield(get_yielded_return_value(), "completed")
    else:
        return_value = get_return_value()
        
    reward_player_one = 0
    reward_player_two = 0
    ##print(return_value)
    if(player_one_client_id):
        _server.get_peer(player_one_client_id).put_packet((JSON.print(return_value['player_one'])).to_utf8())
    if(player_two_client_id):
        _server.get_peer(player_two_client_id).put_packet((JSON.print(return_value['player_two'])).to_utf8())

    
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
