extends Object_                                          

var process = "crushing"

func init():
	if Global.keima_cache == []:
		var properties = JSON.parse_string(FileAccess.get_file_as_string("res://properties.json"))["items"]
		for i in properties:
			if properties[i]["alchemical_stats"] is Dictionary:
				Global.keima_cache.append(properties[i]["alchemical_stats"])
				Global.keima_cache[Global.keima_cache.size()-1]["item"] = i
	if Global.keima_processes == {}:
		var properties = JSON.parse_string(FileAccess.get_file_as_string("res://properties.json"))["processes"]
		for i in properties:
			Global.keima_processes[i] = properties[i]
	print(Global.keima_processes)
				
			
func area_trigger(body, area):
	var lengths = []
	var input = body.keima_stats.duplicate()
	for i in Global.keima_processes[process]:
		input[i] = clamp(input[i] + Global.keima_processes[process][i],0,50)
	for i in Global.keima_cache: #get length from vector to all others, might want to change in future
		var stats = {"nobility": i["nobility"]-input["nobility"],"holyness": i["holyness"]-input["holyness"],"stability": i["stability"]-input["stability"],"heat": i["heat"]-input["heat"],"keima": i["keima"]-input["keima"],"aqueous": i["aqueous"]-input["aqueous"],"reactivity": i["reactivity"]-input["reactivity"],"chaos": i["chaos"]-input["chaos"],"item":i["item"]}
		var len = {"len":round(sqrt(round(pow(stats["nobility"],2))+round(pow(stats["holyness"],2))+round(pow(stats["stability"],2))+round(pow(stats["heat"],2))+round(pow(stats["keima"],2))+round(pow(stats["aqueous"],2))+round(pow(stats["reactivity"],2))+round(pow(stats["chaos"],2)))),"item":stats["item"]}
		lengths.append(len)
	lengths.sort_custom(my_sorter)
	print(lengths[0])


func my_sorter(a,b):
	if a["len"] < b["len"]:
		return true
	return false
		

func damage(n):
	flash_red()
	health -= n
	if health == 0:
		queue_free()
		Global.spawn_item("wood",get_parent(),self.global_position,null)
