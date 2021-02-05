extends Node

export var rendering_enabled = false
export var learn_with_images = true
export var trainings_mode_enabled = false


var game_playtime_per_step
var game_wins_to_reset
var game_port

var image_format
var image_heigth
var image_width

var trainer_ip
var trainer_port
var trainer_position
var trainer_realtime_enabled

var ball_height
var ball_width
var ball_speed_min
var ball_speed_max
var ball_speed_increment

var player_one_length
var player_one_speed

var player_two_length
var player_two_speed

var path="data.json"

var default_data = {
    "game":{
        "playtime_per_step":0.1,
        "wins_to_reset":21,
        "port":9080
       },
    "image":{
        "format":"L8",
        "height":60,
        "width":100
       },
    "trainer":{
        "ip":"127.0.0.1",
        "port":"9080",
        "position":"Right",
        "realtime_enabled":true
       },
    "ball":{
        "height":30,
        "width":30,
        "speed_min":300,
        "speed_max":600,
        "speed_increment":50
       },
    "player_one":{
        "length":60,
        "speed":300
       },
    "player_two":{
        "length":60,
        "speed":300
       }
   }

var data = default_data

# Called when the node enters the scene tree for the first time.
func _ready():
    load_data()
    pass # Replace with function body.
    
func load_data():
    var file = File.new()
    
    if not file.file_exists(path):
        reset_data()
        return
        
    file.open(path, file.READ)
    var text = file.get_as_text()
    data = parse_json(text)
    file.close()
    update_settings()

func save_data():
    data = {
        "game":{
            "playtime_per_step":$"/root/GameSettings".game_playtime_per_step,
            "wins_to_reset":$"/root/GameSettings".game_wins_to_reset,
            "port":$"/root/GameSettings".game_port
        },
        "image":{
            "format":$"/root/GameSettings".image_format,
            "height":$"/root/GameSettings".image_heigth,
            "width":$"/root/GameSettings".image_width
        },
        "trainer":{
            "ip":$"/root/GameSettings".trainer_ip,
            "port":$"/root/GameSettings".trainer_port,
            "position":$"/root/GameSettings".trainer_position,
            "realtime_enabled":$"/root/GameSettings".trainer_realtime_enabled
        },
        "ball":{
            "height":$"/root/GameSettings".ball_height,
            "width":$"/root/GameSettings".ball_width,
            "speed_min":$"/root/GameSettings".ball_speed_min,
            "speed_max":$"/root/GameSettings".ball_speed_max,
            "speed_increment":$"/root/GameSettings".ball_speed_increment
        },
        "player_one":{
            "length":$"/root/GameSettings".player_one_length,
            "speed":$"/root/GameSettings".player_one_speed
        },
        "player_two":{
            "length":$"/root/GameSettings".player_two_length,
            "speed":$"/root/GameSettings".player_two_speed
        }
    }
    var file
    file = File.new()
    file.open(path, File.WRITE)
    file.store_line(to_json(data))
    file.close()
    
func reset_data():
    data = default_data.duplicate(true) 
    update_settings()
    
func update_settings():
    game_playtime_per_step = data["game"]["playtime_per_step"] as float
    game_wins_to_reset = data["game"]["wins_to_reset"] as int
    game_port= data["game"]["port"] as int

    image_format = data["image"]["format"]
    image_heigth = data["image"]["height"] as int
    image_width = data["image"]["width"] as int

    trainer_ip = data["trainer"]["ip"]
    trainer_port = data["trainer"]["port"] as int
    trainer_position = data["trainer"]["position"]
    trainer_realtime_enabled = data["trainer"]["realtime_enabled"] as bool

    ball_height =data["ball"]["height"] as int
    ball_width = data["ball"]["width"] as int
    ball_speed_min = data["ball"]["speed_min"] as int
    ball_speed_max = data["ball"]["speed_max"] as int 
    ball_speed_increment = data["ball"]["speed_increment"] as int

    player_one_length = data["player_one"]["length"] as int
    player_one_speed = data["player_one"]["speed"] as int

    player_two_length = data["player_two"]["length"] as int
    player_two_speed = data["player_two"]["speed"] as int


