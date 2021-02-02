extends Node

export var rendering_enabled = false
export var learn_with_images = true


var game_playtime_per_step
var game_wins_to_reset
var game_port

var image_format
var image_heigth
var image_width

var trainer_ip
var trainer_port
var trainer_position

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
        "format":"RGB8",
        "height":60,
        "width":100
       },
    "trainer":{
        "ip":"127.0.0.1",
        "port":"9080",
        "position":"Right"
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
            "position":$"/root/GameSettings".trainer_position
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
    game_playtime_per_step = str(data["game"]["playtime_per_step"])
    game_wins_to_reset = str(data["game"]["wins_to_reset"])
    game_port= str(data["game"]["port"])

    image_format = data["image"]["format"]
    image_heigth = str(data["image"]["height"])
    image_width = str(data["image"]["width"])

    trainer_ip = data["trainer"]["ip"]
    trainer_port = str(data["trainer"]["port"])
    trainer_position = data["trainer"]["position"]
    

    ball_height = str(data["ball"]["height"])
    ball_width = str(data["ball"]["width"])
    ball_speed_min = str(data["ball"]["speed_min"])
    ball_speed_max = str(data["ball"]["speed_max"])
    ball_speed_increment = str(data["ball"]["speed_increment"])

    player_one_length = str(data["player_one"]["length"])
    player_one_speed = str(data["player_one"]["speed"])

    player_two_length = str(data["player_two"]["length"])
    player_two_speed = str(data["player_two"]["speed"])


