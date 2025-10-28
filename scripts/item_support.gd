extends Node

@onready var sprite_2d: Sprite2D = $"../Sprite2D"
@onready var item: Area2D = $".."
var global
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func register(id,in_data):
	var file = "res://properties.json"
	var json_as_text = FileAccess.get_file_as_string(file)
	var json_as_dict = JSON.parse_string(json_as_text)
	item.set_process(true)
	sprite_2d.set_texture(load(json_as_dict["items"][id]["sprite"]))
	item.set_script(load(json_as_dict["items"][id]["script"]))
	if json_as_dict["items"][id].has("data"):
		item.data = json_as_dict["items"][id]["data"]
	if in_data != null:
		item.data = in_data
	item.entity_id = id
	
	item._ready()
	item.moved(global)
