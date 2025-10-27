extends Object_


func _process(delta: float):
	pass

func use():
	pass

func damage(n):
	flash_red()
	health -= n
	if health == 0:
		queue_free()
		Global.spawn_item("wood",get_parent(),self.global_position,null)
		
