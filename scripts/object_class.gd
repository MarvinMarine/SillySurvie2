extends StaticBody2D
class_name Object_

var health : int = 1
var max_health : int = 1
var data = {}
var chunk_pos
var entity_type = "object"
var entity_id 

@onready var area_2d: Area2D = $Area2D

func _ready() -> void:
	init()
	area_2d.area_entered.connect(area_trigger.bind(area_2d))

func init():
	pass
	
func damage(n):
	pass
	
func set_data(in_data):
	data = in_data
	
func flash_red():
	get_node("Sprite2D").modulate = Color(1,0.265,0.231,0.7)
	await get_tree().create_timer(0.1).timeout
	get_node("Sprite2D").modulate = Color(1,1,1,1)
	
func _process(delta: float) -> void:
	pass

func area_trigger(body, area):
	pass

func use():
	pass
	
func moved(global):
	chunk_pos = get_node("/root/Global").to_chunk(self.global_position)
	
func save_data_base():
	data["health"] = health
	
func save_data():
	pass
