extends RigidBody2D


# Declare member variables here. 
export var speed = 150 
var playing = false
var dx =100
var dy =0
var y_range = 100


# Called when the node enters the scene tree for the first time.
func _ready():
    
    pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func _physics_process(delta):
    if playing:
        change_dy_on_wall_hit()
        self.rotation = 0
        self.linear_velocity = Vector2(dx, dy) * delta * speed


func ball_hit_paddle():
    dx *= -1
    dy = rand_range(-y_range, y_range)
    if speed < 300:
        speed += 5
    if y_range < 200:
        y_range += 5

func change_dy_on_wall_hit():
    if self.position.y <= 0:
        dy = rand_range(0, y_range)
    if self.position.y >= 600:
        dy = rand_range(-y_range, 0)

func set_playing(_playing):
    playing = _playing
    
func start(pos):
    position = pos
    show()
    $CollisionShape2D.disabled = false
