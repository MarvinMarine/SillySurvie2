extends Node
class_name GlobalStuff

var ItemScene = preload("res://scenes/Item_Base.tscn")
var ObejctScene = preload("res://scenes/Object_Base.tscn")
var crafting_list

const chunk_size = 2000
const density = 50.0

var keima_cache = []
var loaded_chunks = []
var generated_chunks = []
var keima_processes = {}

func _ready() -> void:
	crafting_list = JSON.parse_string(FileAccess.get_file_as_string("res://crafting.json"))

func FUCK_YOU():
	var a = [3,2,1]
	var b = [4,3,2]
	print("a - b " + str(subtract(a,b)))
	print("b - a " + str(subtract(b,a)))

func spawn_item(id,node,pos,data):
	var item = ItemScene.instantiate()
	node.add_child(item)
	item.global_position = pos
	item.get_node("Node").register(id,null)
	if data != null: item.data = data
	return item
	
func spawn_object(id,node,pos,data):
	var object = ObejctScene.instantiate()
	node.add_child(object)
	object.global_position = pos
	object.get_node("Node").register(id,data)
	return object
	
func spawn_creature(id,node,pos,data):
	var object = ObejctScene.instantiate()
	node.add_child(object)
	object.global_position = pos
	object.get_node("Node").register(id,data)
	return object
	
func summon(entity,destination):
	if entity["type"] == "object":
		spawn_object(entity["id"],destination,Vector2(entity["position"][0],entity["position"][1]),entity["data"])
	if entity["type"] == "item":
		spawn_item(entity["id"],destination,Vector2(entity["position"][0],entity["position"][1]),entity["data"])
	if entity["type"] == "creature":
		spawn_creature(entity["id"],destination,Vector2(entity["position"][0],entity["position"][1]),entity["data"])
		
func init_chunk(pos):
	var file = FileAccess.open("res://chunks/" + str(pos.x) + "," + str(pos.y) + ".json", FileAccess.WRITE)
	file.store_string(JSON.stringify({"data":[]}))
	file.close()
		
func save_chunk(pos, root, unload):
	if loaded_chunks.has(pos):
		var new_json
		if !load("res://world/" + str(pos)):
			init_chunk(pos)
		var json = JSON.parse_string(FileAccess.get_file_as_string("res://chunks/" + str(pos.x) + "," + str(pos.y) + ".json")) #res://chunks/0,0.json
		for i in root.get_children():
			if root.get_children() != null:
				if i is Item || i is Object_:
					if i.chunk_pos == pos:
						new_json = save(i,pos, json)
						if unload:
							i.queue_free()
		if new_json != null:
			var world = FileAccess.open("res://chunks/" + str(pos.x) + "," + str(pos.y) + ".json", FileAccess.WRITE)
			world.store_string(JSON.stringify(new_json,"  "))
			world.flush()
			world.close()
		if unload:
			loaded_chunks = subtract(loaded_chunks,[pos])


func save(entity, chunk, chunk_file):
	entity.save_data()
	entity.save_data_base()
	chunk_file["data"].append({"type":entity.entity_type,"id":entity.entity_id,"position":[entity.global_position.x,entity.global_position.y],"data":entity.data})
	return chunk_file
	

func to_chunk(pos):
	var npos = floor(pos/chunk_size)
	return npos
	
	
func subtract(a: Array, b: Array) -> Array:
	var result := []
	var bag := {}
	for item in b:
		if not bag.has(item):
			bag[item] = 0
		bag[item] += 1
	for item in a:
		if bag.has(item):
			bag[item] -= 1
			if bag[item] == 0:
				bag.erase(item)
		else:
			result.append(item)
	return result
	
	
func save_world(root):	for i in loaded_chunks:
	save_chunk(i,root,false)
	get_tree().quit()
