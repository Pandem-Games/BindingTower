extends RichTextLabel



func _on_Timer_timeout():
	queue_free()
	
func init(damage, global_position):
	text = str(damage)
	rect_global_position = global_position
