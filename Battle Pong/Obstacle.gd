extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var min_speed = 300
var max_speed = 700
var speed=0
var start_position
var playing = false
var is_paused = true
var obstacle_size
var top_position
var bottom_position
# Called when the node enters the scene tree for the first time.
func _ready():
    randomize()
    #speed = rand_range(min_speed, max_speed)
    speed = 500
    
    obstacle_size =$CollisionShape2D.shape.extents
    top_position = 0- obstacle_size.y
    bottom_position = $"/root/GameSettings".display_window_height + obstacle_size.y
    pass # Replace with function body.


func run(delta):
    if playing and not is_paused:
        self.rotation = 0
        #self.linear_velocity = Vector2(dx, dy) * delta * speed
        #var move = velocity.normalized() * delta * speed
        #print(delta)
        #var collision = self.move(move, false)    
        
        
        var velocity = Vector2()  # The player's movement vector.
        # Hier kommt die Erweiterung hin um Obstacles von oben oder unten kommen zu lassen
            #if true:
        velocity.y += 1
        #  else:
        #      velocity.y -= 1
                
        if velocity.length() > 0:
            velocity = velocity.normalized() * speed

        position += velocity * delta
        if position.y >bottom_position:
            position = start_position

func start(pos):
    start_position = pos
    start_position.y = top_position
    position = start_position
    show()

func set_playing(_playing):
    playing = _playing
    
func set_pause(value):
    get_tree().paused=value
    is_paused = value

