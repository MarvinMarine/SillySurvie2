extends Node2D

@onready var character_body_2d: CharacterBody2D = $CharacterBody2D

@onready var world_gen: WorldGen = $WorldGen
var global

func _ready():
	global = get_node("/root/Global")
	#global.spawn_item("wood",self,Vector2(0,0),null)
	global.FUCK_YOU()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Quit"):
		global.save_world(self)
	if Input.is_action_just_pressed("Test2"):
		global.spawn_object("crafter",self,character_body_2d.global_position, null)
	if Input.is_action_just_pressed("Test1"):
		world_gen.load_chunk(Vector2(0,0))
	if Input.is_action_just_pressed("Test3"):
		global.spawn_object("chest",self,character_body_2d.global_position, null)
