extends Node

@onready var sprite_2d: Sprite2D = $"../Sprite2D"
@onready var object: StaticBody2D = $".."
var global
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global = get_node("/root/Global")
	
func register(id,in_data):
	var file = "res://properties.json"
	var json_as_text = FileAccess.get_file_as_string(file)
	var json_as_dict = JSON.parse_string(json_as_text)
	sprite_2d.set_texture(load(json_as_dict["objects"][id]["sprite"]))
	object.set_script(load(json_as_dict["objects"][id]["script"]))
	object.set_process(true)
	object.health = json_as_dict["objects"][id]["health"]
	object.max_health = json_as_dict["objects"][id]["health"]
	if in_data != null:
		object.data = in_data
	object.entity_id = id
	if in_data and in_data.has("health"):
		object.health = in_data["health"]
		
	object._ready()
	object.moved(global)
