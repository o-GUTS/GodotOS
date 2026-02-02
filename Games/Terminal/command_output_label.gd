extends Label

class_name CommandOutputLabel


func _process(_delta: float) -> void:
	# When the label goes off the screen deletes itself
	if global_position.y < 0:
		queue_free()
