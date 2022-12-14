extends RigidBody2D
signal hit

# Declare member variables here. Examples:
export var speed = 400 # (pixel/sec)
export var is_player_one = true # Select player one or two
var screen_size
var player_size
# Called when the node enters the scene tree for the first time.
func _ready():
    screen_size = get_viewport_rect().size
    player_size =$CollisionShape2D.shape.extents
    if(is_player_one):
        $ColorRect.color=Color(0,0,0,1)
        speed = $"/root/GameSettings".player_one_speed
    else:
        speed = $"/root/GameSettings".player_two_speed



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
func run(delta):
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

    position += velocity * delta
    #position.x = clamp(position.x, 0, screen_size.x) # ändert sich nicht
    position.y = clamp(position.y, 0+player_size.y, screen_size.y-player_size.y)

func get_shape():
    return $CollisionShape2D.shape.extents

func _on_Player_body_entered(body):
    emit_signal("hit")

    
func start(pos):
    position = pos
    show()
    $CollisionShape2D.disabled = false


func set_pause(value):
    get_tree().paused=value
