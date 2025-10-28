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
		if list_in_another(i["input"],Ritems):
			for j in i["input"].size():
				items.pop_back()
			for l in i["output"]:
				items.append(l)
			check_crafting()


func list_in_another(item,against):
	if item.size() <= against.size():
		var available = false
		for i in item.size():
			available = false
			if against[i-item.size()] == item[i]:
				available = true
			else:
				break
		return available

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
