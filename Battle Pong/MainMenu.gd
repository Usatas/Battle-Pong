extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func _on_but_local_two_player_pressed():
    pass # Replace with function body.


func _on_but_two_re_with_images_pressed():
    $"/root/GameSettings".rendering_enabled = true
    $"/root/GameSettings".learn_with_images = true
    $"/root/GameSettings".trainings_mode_enabled = false
    get_tree().change_scene("res://Main.tscn")



func _on_but_two_re_with_position_pressed():
    $"/root/GameSettings".rendering_enabled = $vbox_two_learner/HBoxContainer/cb_rendering_enabled.is_pressed()
    $"/root/GameSettings".learn_with_images = false
    $"/root/GameSettings".trainings_mode_enabled = false
    if not $"/root/GameSettings".rendering_enabled:
        $vbox_two_learner.hide()
        $lbl_game_running.show()
        get_viewport().set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)
        # Wait until the frame has finished before getting the texture.
        yield(VisualServer, "frame_post_draw")
        print("Rendering is disabled")
    get_tree().change_scene("res://Main.tscn")



func _on_cb_rendering_enabled_pressed():
    $"/root/GameSettings".rendering_enabled = $vbox_two_learner/HBoxContainer/cb_rendering_enabled.is_pressed()
    if not $"/root/GameSettings".rendering_enabled:
        $vbox_two_learner.hide()
    else:
        $lbl_game_running.show()
    print($"/root/GameSettings".rendering_enabled)



func _on_but_trainer_with_images_pressed():
    $"/root/GameSettings".rendering_enabled = true
    $"/root/GameSettings".learn_with_images = true
    $"/root/GameSettings".trainings_mode_enabled = true
    get_tree().change_scene("res://Main.tscn")
   


func _on_but_trainer_with_position_pressed():
    $"/root/GameSettings".rendering_enabled = true
    $"/root/GameSettings".learn_with_images = false
    $"/root/GameSettings".trainings_mode_enabled = true
    get_tree().change_scene("res://Main.tscn")



func _on_but_settings_pressed():
    get_tree().change_scene("res://SettingsWindow.tscn")

