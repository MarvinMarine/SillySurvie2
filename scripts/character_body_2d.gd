extends CharacterBody2D

@onready var hand_area: Area2D = $HandArea
@onready var hold_item_pos: Marker2D = $HoldItemPos
@onready var node_2d: Node2D = $".."
var global
@onready var world_gen: WorldGen = $"../WorldGen"

const SPEED = 500
const ROTATE_SPEED = 0.3

var HeldItem : Item
var HoldingItem = false
var chunk_im_in = Vector2(5000,-1000000000)
var chunks_loaded = []

var char_direction : Vector2

func _ready() -> void:
	global = get_node("/root/Global")

func _physics_process(delta: float) -> void:
	
	char_direction.x = Input.get_axis("MoveLeft","MoveRight")
	char_direction.y = Input.get_axis("MoveUp","MoveDown")
	
	if char_direction:
		velocity = char_direction * SPEED
	else: 
		velocity = velocity.move_toward(Vector2.ZERO, SPEED)
		
	if velocity.length() > 1:
		rotation = lerp_angle(rotation,velocity.angle(),ROTATE_SPEED)




	if HoldingItem:
		if is_instance_valid(HeldItem):
			HeldItem.global_position = hold_item_pos.global_position
			HeldItem.use()
			HeldItem.moved(global)
		else: 
			HeldItem = null
			HoldingItem = false

	if Input.is_action_just_pressed("LeftClick"):
		for i in hand_area.get_overlapping_bodies():
			if i.is_in_group("GetsHurt") and i.damage:
				i.damage(1)

	if Input.is_action_just_pressed("RightClick"):
		if HoldingItem == true == true: #fuck you
			HeldItem = null
			HoldingItem = false
			return
		if HoldingItem == false:
			if hand_area.get_overlapping_areas():
				var items = hand_area.get_overlapping_areas()
				items.sort_custom(my_sorter)
				HeldItem=items[0]
				HoldingItem = true
			elif hand_area.get_overlapping_bodies():
				var objects = hand_area.get_overlapping_bodies()
				objects.sort_custom(my_sorter)
				objects[0].use() #this is going to cause problems, add checks for if its actually objects and items that are being clicked on (weed them out before you do the sorter ofc) @pine 
				
	
	

	move_and_slide()
	chunk_loading()
	
func _process(delta: float) -> void:
	pass
	chunk_loading()
	
func my_sorter(a,b):
	if a.global_position.distance_to(hold_item_pos.global_position) < b.global_position.distance_to(hold_item_pos.global_position):
		return true
	return false
	
	
func chunk_loading():
	var old_chunk = chunk_im_in
	chunk_im_in = floor(global_position / global.chunk_size)
	if chunk_im_in != old_chunk:
		var chunks_that_were_loaded = []
		for i in chunks_loaded: chunks_that_were_loaded.append(i)
		chunks_loaded = []
		for i in 3:
			for j in 3:
				chunks_loaded.append(Vector2(chunk_im_in.x+(i-1),chunk_im_in.y+(j-1)))
		for i in global.subtract(chunks_that_were_loaded,chunks_loaded):
			global.save_chunk(i,node_2d,true)

		for i in global.subtract(chunks_loaded,chunks_that_were_loaded):
			world_gen.load_chunk(i)
 
