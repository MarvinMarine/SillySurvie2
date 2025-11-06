extends Object_                                          

var items = []

func init():
	var global = get_node("/root/Global")
	if data.has("items"):
		items = data["items"]

func area_trigger(body, area):
	items.append(body.entity_id)
	body.queue_free()

func use():
	if items.size() >= 1:
		Global.spawn_item(items[items.size()-1],get_parent(),global_position + Vector2(0,-100),null)
		items.pop_back()

func damage(n):
	flash_red()
	health -= n
	if health == 0:
		queue_free()
		Global.spawn_item("wood",get_parent(),self.global_position,null)
		
func save_data():
	data["items"] = items
