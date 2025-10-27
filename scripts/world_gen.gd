extends Node
class_name WorldGen

var itterate_ammount
var world_json
var generated_chunks = []
var noise
var global

func _ready():
	global = get_node("/root/Global")
	noise = FastNoiseLite.new()
	itterate_ammount = global.chunk_size / global.density
	var file = "res://world.json"
	var json_as_text = FileAccess.get_file_as_string(file)
	world_json = JSON.parse_string(json_as_text)
	var dir = DirAccess.open("res://chunks/")
	if dir:
		dir.list_dir_begin()
		for i in dir.get_files():
			generated_chunks.append([int(i.replace(".json","").split(",")[0]),int(i.replace(".json","").split(",")[1])])

func generate_chunk(pos):
	for x in itterate_ammount:
		for y in itterate_ammount:
			if noise.get_noise_2d(x*global.density+(pos.x*global.chunk_size),y*global.density+(pos.y*global.chunk_size)) >= 0.4:
				if round(randf_range(1,2)) == 1:
					global.spawn_object("tree",get_parent(),Vector2(x*global.density+(pos.x*global.chunk_size),y*global.density+(pos.y*global.chunk_size)),null)
				else:
					global.spawn_object("rock",get_parent(),Vector2(x*global.density+(pos.x*global.chunk_size),y*global.density+(pos.y*global.chunk_size)),null)

func custom_has_pos(a,b):
	for i in a:
		if i[0] == b.x and i[1] == b.y:
			return true
	return false

func load_chunk(pos):
	var was_generated

	if custom_has_pos(generated_chunks,pos):
		if FileAccess.get_file_as_string("res://chunks/" + str(pos.x) + "," + str(pos.y) + ".json") == null: global.init_chunk(pos)
		var file = "res://chunks/" + str(pos.x) + "," + str(pos.y) + ".json"
		var json_as_text = FileAccess.get_file_as_string(file)
		world_json = JSON.parse_string(json_as_text)
		for entity in world_json["data"]:
			global.summon(entity,get_parent())
	else:
		was_generated = true
		generated_chunks.append([pos.x,pos.y])
		global.generated_chunks = generated_chunks
		generate_chunk(pos)
	global.loaded_chunks.append(pos)
	if was_generated:
		global.save_chunk(pos,get_parent(),false)
