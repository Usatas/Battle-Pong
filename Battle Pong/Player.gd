extends Area2D
signal hit

# Declare member variables here. Examples:
export var speed = 400 # (pixel/sec)
export var is_player_one = true # Select player one or two
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
    screen_size = get_viewport_rect().size
    #hide()
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    var velocity = Vector2()  # The player's movement vector.
    if is_player_one:
        if Input.is_action_pressed("player_one_down"):
            velocity.y += 1
        if Input.is_action_pressed("player_one_up"):
            velocity.y -= 1
    else:
        
        if Input.is_action_pressed("player_two_down"):
            velocity.y += 1
        if Input.is_action_pressed("player_two_up"):
            velocity.y -= 1
            
    if velocity.length() > 0:
        velocity = velocity.normalized() * speed
        $AnimatedSprite.play()
    else:
        $AnimatedSprite.stop()

    position += velocity * delta
    #position.x = clamp(position.x, 0, screen_size.x) # ändert sich nicht
    position.y = clamp(position.y, 0, screen_size.y)



func _on_Player_body_entered(body):
    emit_signal("hit")
    $CollisionShape2D.set_deferred("disabled", true) # TODO das muss aufgerufen werden, wenn der ball das spielfeld auf der eigenen Seite verlässt
    
func start(pos):
    position = pos
    show()
    $CollisionShape2D.disabled = false
