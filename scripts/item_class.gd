extends Area2D
class_name Item

var data = {}
var chunk_pos
var entity_type = "item"
var entity_id 

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func use():
	pass
	
	
func moved(global):
	chunk_pos = get_node("/root/Global").to_chunk(self.global_position)
	
func save_data_base():
	pass
	
func save_data():
	pass
