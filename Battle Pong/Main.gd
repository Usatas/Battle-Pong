extends Node

var Ball = preload("Ball.tscn")
var ball = Ball.instance()
var score_player_one =0
var score_player_two=0

var playing = false
var score_event = false
var game_done = false




const SPACE_TO_PLAY = "Press SPACE to Play!"
const P1_WIN = "Player 1 won!"
const P2_WIN = "Player 2 won!"
var message = SPACE_TO_PLAY

func _ready():
    set_ball()
    $PlayerOne.start($StartPositionPlayerOne.position)
    $PlayerTwo.start($StartPositionPlayerTwo.position)
    display_message()
    update_score()

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
    check_point_scored()
    handle_score_event()
    handle_game_end()
    
func check_point_scored():
    if ball.position.x <= 0:
        score_event = true
        score_player_two += 1
    if ball.position.x >= 1024:
        score_event = true
        score_player_one += 1
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
    ball.ball_hit_paddle()
    pass # Replace with function body.


func _on_PlayerOne_hit():
    ball.ball_hit_paddle()
    pass # Replace with function body.
