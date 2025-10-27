extends Object_


func init():
	var global = get_node("/root/Global")


func _process(delta: float):
	pass

func use():
	pass

func damage(n):
	flash_red()
	health -= n
	if health == 0:
		queue_free()
		Global.spawn_item("stone",get_parent(),self.global_position,null)
