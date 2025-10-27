extends Object_                                          

var items = []

func init():
	var global = get_node("/root/Global")

func area_trigger(body, area):
	items.append(body.entity_id)
	body.queue_free()
	check_crafting()

func check_crafting():
	for i in Global.crafting_list["crafting"].values():
		print(i["input"].size())

func use():
	Global.spawn_itadaem(items[items.size()-1],get_parent(),global_position + Vector2(0,-100),null)
	items.pop_back()

func damage(n):
	flash_red()
	health -= n
	if health == 0:
		queue_free()
		Global.spawn_item("wood",get_parent(),self.global_position,null)
