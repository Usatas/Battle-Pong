extends Node

# The port we will listen to.
const PORT = 9080
# Our WebSocketServer instance.
var _server = WebSocketServer.new()
var player_one_client_id
var player_two_client_id
var deltaN = 0
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

func _ready():
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
    # print(delta)
    _server.poll() # in in steuerung durch Timer auslagern, damit der Process durch Pause lahm gelegt werden kann

    check_point_scored()
    handle_score_event()
    handle_game_end()
    
func check_point_scored():
    if ball.position.x <= 0:
        score_event = true
        score_player_two += 1
        reward_player_one=(-1)
        reward_player_two=1
    if ball.position.x >= 1024:
        score_event = true
        score_player_one += 1
        reward_player_one=1
        reward_player_two=(-1)
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
    
func game_over():
    $ScoreTimer.stop()
    $MobTimer.stop()

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
    #if(not player_one_client_id):
    #    player_one_client_id = id
    #if(not player_two_client_id):
    #    player_two_client_id = id
    print("Client %d connected with protocol: %s" % [id, proto])


func _close_request(id, code, reason):
    # This is called when a client notifies that it wishes to close the connection,
    # providing a reason string and close code.
    print("Client %d disconnecting with code: %d, reason: %s" % [id, code, reason])


func _disconnected(id, was_clean = false):
    # This is called when a client disconnects, "id" will be the one of the
    # disconnecting client, "was_clean" will tell you if the disconnection
    # was correctly notified by the remote peer before closing the socket.
    if( player_one_client_id == id ):
        player_one_client_id = null
        print("Player One with Client %d disconnected, clean: %s" % [id, str(was_clean)])
    if(player_two_client_id== id):
        player_two_client_id = null
        print("Player Two with Client %d disconnected, clean: %s" % [id, str(was_clean)])
    else:
        print("Client %d disconnected, clean: %s" % [id, str(was_clean)])


func _on_data(id):
    # Print the received packet, you MUST always use get_peer(id).get_packet to receive data,
    # and not get_packet directly when not using the MultiplayerAPI.
    var pkt = _server.get_peer(id).get_packet()
    print("Got data from client %d: %s ... echoing" % [id, pkt.get_string_from_utf8()])
    
    var data = (JSON.parse(pkt.get_string_from_utf8())).get_result()
    #print(data)
    # var player = data[0]
    # var command = data[1]
    #if(command == "UP"):
    if(data):
        for i in data:
            print(i)
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
            if(i == "start_game"):
                play()
                var return_value = get_return_value_as_utf8_JSON()
                _server.get_peer(id).put_packet(return_value)
                pass
            if(i=="connect_player"):
                var return_value = get_return_value_as_utf8_JSON()
                _server.get_peer(id).put_packet(return_value)
                pass
    if(next_step_player_one and next_step_player_two):
        unpause()
        $RunTimer.start() 


func get_return_value_as_utf8_JSON():
    var observation = {"PlayerOne":{"X":$PlayerOne.position.x,"Y":$PlayerOne.position.y}, "PlayerTwo":{"X":$PlayerTwo.position.x,"Y":$PlayerTwo.position.y}, "ball":ball.get_observation()}
    var return_value = {"observation":observation, "reward":{"PlayerOne":reward_player_one, "PlayerTwo":reward_player_two}, "done":(not playing), "info":{"PlayerOneScore":score_player_one, "PlayerTwoScore":score_player_two}}
    return (JSON.print(return_value)).to_utf8()


func _on_RunTimer_timeout():
    print("_RunTimer_timeout")
    pause()
    
    action_player_one.pressed = false
    action_player_two.pressed = false
    Input.parse_input_event(action_player_one)
    Input.parse_input_event(action_player_two)
    next_step_player_one = false
    next_step_player_two = false
    
    var return_value = get_return_value_as_utf8_JSON()
    reward_player_one = 0
    reward_player_two = 0
    #print(return_value)
    if(player_one_client_id):
        _server.get_peer(player_one_client_id).put_packet(return_value)
    if(player_two_client_id):
        _server.get_peer(player_two_client_id).put_packet(return_value)

func pause():
    print("pause")
    ball.set_pause(true)
    $PlayerOne.set_pause(true)
    $PlayerTwo.set_pause(true)
    
func unpause():
    print("unpause")
    ball.set_pause(false)
    $PlayerOne.set_pause(false)
    $PlayerTwo.set_pause(false)

