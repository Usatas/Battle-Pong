extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"



# Called when the node enters the scene tree for the first time.
func _ready():
    update_gui()


func update_gui():
    $VBoxContainer/grid_settings/vbox_game_settings/grid_game_settings/input_game_playtime_per_step.text = str($"/root/GameSettings".game_playtime_per_step)
    $VBoxContainer/grid_settings/vbox_game_settings/grid_game_settings/input_game_wins_to_reset.text = str($"/root/GameSettings".game_wins_to_reset)
    $VBoxContainer/grid_settings/vbox_game_settings/grid_game_settings/input_game_port.text= str($"/root/GameSettings".game_port)

    $VBoxContainer/grid_settings/vbox_image_settings/grid_image_settings/input_image_format.pressed = $"/root/GameSettings".image_rgb
    $VBoxContainer/grid_settings/vbox_image_settings/grid_image_settings/input_image_height.text = str($"/root/GameSettings".image_heigth)
    $VBoxContainer/grid_settings/vbox_image_settings/grid_image_settings/input_image_width.text = str($"/root/GameSettings".image_width)

    #$VBoxContainer/grid_settings/vbox_trainer_settings/grid_trainer_settings/input_trainer_ip.text = $"/root/GameSettings".trainer_ip
    #$VBoxContainer/grid_settings/vbox_trainer_settings/grid_trainer_settings/input_trainer_port.text = str($"/root/GameSettings".trainer_port)
    #if $"/root/GameSettings".trainer_position =="Left":
    #    $VBoxContainer/grid_settings/vbox_trainer_settings/grid_trainer_settings/input_trainer_position.pressed = false
    #elif $"/root/GameSettings".trainer_position =="Right":
    #    $VBoxContainer/grid_settings/vbox_trainer_settings/grid_trainer_settings/input_trainer_position.pressed = true
    
    #$VBoxContainer/grid_settings/vbox_trainer_settings/grid_trainer_settings/input_trainer_position.text = $"/root/GameSettings".trainer_position
    $VBoxContainer/grid_settings/vbox_trainer_settings/grid_trainer_settings/input_trainer_realtime_enabled.pressed = $"/root/GameSettings".trainer_realtime_enabled

    $VBoxContainer/grid_settings/vbox_ball_settings/grid_ball_settings/input_ball_height.text = str($"/root/GameSettings".ball_height)
    $VBoxContainer/grid_settings/vbox_ball_settings/grid_ball_settings/input_ball_width.text = str($"/root/GameSettings".ball_width)
    $VBoxContainer/grid_settings/vbox_ball_settings/grid_ball_settings/input_ball_speed_min.text = str($"/root/GameSettings".ball_speed_min)
    $VBoxContainer/grid_settings/vbox_ball_settings/grid_ball_settings/input_ball_speed_max.text = str($"/root/GameSettings".ball_speed_max)
    $VBoxContainer/grid_settings/vbox_ball_settings/grid_ball_settings/input_ball_speed_increment.text = str($"/root/GameSettings".ball_speed_increment)

    $VBoxContainer/grid_settings/vbox_player_one_settings/grid_player_one_settings/input_player_one_length.text = str($"/root/GameSettings".player_one_length)
    $VBoxContainer/grid_settings/vbox_player_one_settings/grid_player_one_settings/input_player_one_speed.text = str($"/root/GameSettings".player_one_speed)

    $VBoxContainer/grid_settings/vbox_player_two_settings/grid_player_two_settings/input_player_two_length.text = str($"/root/GameSettings".player_two_length)
    $VBoxContainer/grid_settings/vbox_player_two_settings/grid_player_two_settings/input_player_two_speed.text = str($"/root/GameSettings".player_two_speed)


func _on_input_trainer_position_pressed():
    if $VBoxContainer/grid_settings/vbox_trainer_settings/grid_trainer_settings/input_trainer_position.is_pressed():
       $VBoxContainer/grid_settings/vbox_trainer_settings/grid_trainer_settings/input_trainer_position.text = "Right"
    else: 
       $VBoxContainer/grid_settings/vbox_trainer_settings/grid_trainer_settings/input_trainer_position.text = "Left" 
    pass # Replace with function body.


func _on_but_save_pressed():
    $"/root/GameSettings".game_playtime_per_step = $VBoxContainer/grid_settings/vbox_game_settings/grid_game_settings/input_game_playtime_per_step.text as float
    $"/root/GameSettings".game_wins_to_reset = $VBoxContainer/grid_settings/vbox_game_settings/grid_game_settings/input_game_wins_to_reset.text as int
    $"/root/GameSettings".game_port = $VBoxContainer/grid_settings/vbox_game_settings/grid_game_settings/input_game_port.text as int

    $"/root/GameSettings".image_rgb = $VBoxContainer/grid_settings/vbox_image_settings/grid_image_settings/input_image_format.pressed
    $"/root/GameSettings".image_heigth = $VBoxContainer/grid_settings/vbox_image_settings/grid_image_settings/input_image_height.text as int
    $"/root/GameSettings".image_width = $VBoxContainer/grid_settings/vbox_image_settings/grid_image_settings/input_image_width.text as int

    #$"/root/GameSettings".trainer_ip = $VBoxContainer/grid_settings/vbox_trainer_settings/grid_trainer_settings/input_trainer_ip.text
    #$"/root/GameSettings".trainer_port = $VBoxContainer/grid_settings/vbox_trainer_settings/grid_trainer_settings/input_trainer_port.text as int
    $"/root/GameSettings".trainer_position = $VBoxContainer/grid_settings/vbox_trainer_settings/grid_trainer_settings/input_trainer_position.text
    $"/root/GameSettings".trainer_realtime_enabled = $VBoxContainer/grid_settings/vbox_trainer_settings/grid_trainer_settings/input_trainer_realtime_enabled.pressed

    $"/root/GameSettings".ball_height = $VBoxContainer/grid_settings/vbox_ball_settings/grid_ball_settings/input_ball_height.text as int
    $"/root/GameSettings".ball_width = $VBoxContainer/grid_settings/vbox_ball_settings/grid_ball_settings/input_ball_width.text as int
    $"/root/GameSettings".ball_speed_min = $VBoxContainer/grid_settings/vbox_ball_settings/grid_ball_settings/input_ball_speed_min.text as int
    $"/root/GameSettings".ball_speed_max = $VBoxContainer/grid_settings/vbox_ball_settings/grid_ball_settings/input_ball_speed_max.text as int
    $"/root/GameSettings".ball_speed_increment = $VBoxContainer/grid_settings/vbox_ball_settings/grid_ball_settings/input_ball_speed_increment.text as int

    $"/root/GameSettings".player_one_length = $VBoxContainer/grid_settings/vbox_player_one_settings/grid_player_one_settings/input_player_one_length.text as int
    $"/root/GameSettings".player_one_speed = $VBoxContainer/grid_settings/vbox_player_one_settings/grid_player_one_settings/input_player_one_speed.text as int

    $"/root/GameSettings".player_two_length = $VBoxContainer/grid_settings/vbox_player_two_settings/grid_player_two_settings/input_player_two_length.text as int
    $"/root/GameSettings".player_two_speed = $VBoxContainer/grid_settings/vbox_player_two_settings/grid_player_two_settings/input_player_two_speed.text as int
    
    $"/root/GameSettings".save_data()
    
    print("new values")
    print($"/root/GameSettings".data)
    
    get_tree().change_scene("res://MainMenu.tscn")
    pass # Replace with function body.


func _on_but_reset_pressed():
    $"/root/GameSettings".reset_data()
    update_gui()
    pass # Replace with function body.


func _on_but_cancel_pressed():
    get_tree().change_scene("res://MainMenu.tscn")
    pass # Replace with function body.
