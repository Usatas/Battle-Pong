extends KinematicBody2D


# Declare member variables here. 
export var speed = 300 
export var speed_max = 600
export var bounce_degree_max = 100
var ball_size
var playing = false
var velocity = Vector2(100,0)
var y_range = 100



# Called when the node enters the scene tree for the first time.
func _ready():
    set_sync_to_physics(false)
    pass



func _physics_process(delta):
    if playing:
        #change_dy_on_wall_hit()
        self.rotation = 0
        #self.linear_velocity = Vector2(dx, dy) * delta * speed
        var move = velocity.normalized() * delta * speed

        var collision = self.move_and_collide(move, false)
        
        if collision:
            print("I collided with ", collision.collider.name)
            if collision.collider.name == "WallTop" || collision.collider.name == "WallBottom":
                velocity = velocity.bounce(collision.normal)
            elif collision.collider.name == "PlayerOne" || collision.collider.name == "PlayerTwo":
                pass
                # velocity.x *=-1
                # var localCollisionPos = collision.Position - collision.collider.Position;
            

func ball_hit_paddle(player_position, shape):
    # Geschwindigkeitserhöhung
    if speed < speed_max:
        speed +=20
    
    # Ball geht in die andere Richtung
    velocity.x*=-1
    
    var half_player_height = shape.extents.y/2
    
    var collision_height = player_position.y-position.y
    if collision_height<0:
        collision_height = abs(collision_height)
        var bounce_degree = half_player_height / bounce_degree_max * collision_height
        velocity.y+=bounce_degree
    elif collision_height>0:
        collision_height = abs(collision_height)
        var bounce_degree = half_player_height / bounce_degree_max * collision_height
        velocity.y-=bounce_degree


func set_playing(_playing):
    playing = _playing
    
func start(pos):
    position = pos
    show()
    $CollisionShape2D.disabled = false
    ball_size =$CollisionShape2D.shape.extents
