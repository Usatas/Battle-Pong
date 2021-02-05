extends KinematicBody2D


# Declare member variables here. 
export var speed = 300 
export var speed_max = 600
export var bounce_degree_max = 60
var ball_size
var playing = false
var velocity = Vector2(100,0)
var y_range = 100



# Called when the node enters the scene tree for the first time.
func _ready():
    set_sync_to_physics(false)
    pass



#func _physics_process(delta):
func run(delta):
    if playing:
        #change_dy_on_wall_hit()
        self.rotation = 0
        #self.linear_velocity = Vector2(dx, dy) * delta * speed
        var move = velocity.normalized() * delta * speed
        #print(delta)
        var collision = self.move_and_collide(move, false)
        
        if collision:
            #print("I collided with ", collision.collider.name)
            if collision.collider.name == "WallTop" || collision.collider.name == "WallBottom":
                velocity = velocity.bounce(collision.normal)
            elif collision.collider.name == "PlayerOne":
                ball_hit_paddle(get_tree().get_root().find_node("PlayerOne", true, false).position, get_tree().get_root().find_node("PlayerOne", true, false).get_shape(), true) 
            elif collision.collider.name == "PlayerTwo":
                ball_hit_paddle(get_tree().get_root().find_node("PlayerTwo", true, false).position, get_tree().get_root().find_node("PlayerTwo", true, false).get_shape(), false) 
                
                pass
                # velocity.x *=-1
                # var localCollisionPos = collision.Position - collision.collider.Position;
            

func ball_hit_paddle(player_position, player_shape, is_player_one):
    # Geschwindigkeitserhöhung
    if speed < speed_max:
        speed +=20
    
    # Ball geht in die andere Richtung
    velocity.x*=-1
    
    var half_player_height = player_shape.y/2
    if (is_player_one and (player_position.x > position.x-(ball_size.x/2 + player_shape.x/2))):
        velocity.y*=-1
        velocity.x*=-1
        pass
    if (not is_player_one and (player_position.x < position.x + (ball_size.x/2 + player_shape.x/2))):
        velocity.y*=-1
        velocity.x*=-1
        pass
    
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
    
func set_pause(value):
    get_tree().paused=value
    
func start(pos):
    position = pos
    show()
    $CollisionShape2D.disabled = false
    ball_size =$CollisionShape2D.shape.extents
    randomize()
    velocity = Vector2(100, rand_range(-200,200))
    if rand_range(-1,1)<0:
        velocity.x*=-1
    #print(velocity)

func get_observation():
    var move = velocity.normalized()*speed
    var ball_player_one = {"velocity":{"X":move.x,"Y":move.y}, "position":{"X":position.x,"Y":position.y}}
    var ball_player_two = {"velocity":{"X":move.x*(-1),"Y":move.y}, "position":{"X":abs(position.x - $"/root/GameSettings".display_window_width),"Y":position.y}}
    return {'player_one':ball_player_one, 'player_two':ball_player_two}
