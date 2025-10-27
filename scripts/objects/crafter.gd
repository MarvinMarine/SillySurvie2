extends Object_                                          

var items = []

func save_data():
	data["items"] = items
	
func init():
	if data.has("items"):
		items = data["items"]

func area_trigger(body, area):
	items.append(body.entity_id)
	body.queue_free()
	check_crafting()

func check_crafting():
	var Ritems = items.duplicate()
	for i in Global.crafting_list["crafting"].values():
		var basis = []
		for j in i["input"].size():
			
			if Ritems.size() >= i["input"].size():
				basis.append(Ritems[j])
		if basis == i["input"]:
			print(i["input"].size())
			for j in i["input"].size():
				items.pop_back()
			for l in i["output"]:
				items.append(l)
			check_crafting()


func use():
	if items.size() != 0:
		Global.spawn_item(items[items.size()-1],get_parent(),global_position + Vector2(0,-100),null)
		items.pop_back()

func damage(n):
	flash_red()
	health -= n
	if health == 0:
		queue_free()
		Global.spawn_item("wood",get_parent(),self.global_position,null)
