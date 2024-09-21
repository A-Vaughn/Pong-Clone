extends ColorRect
@onready var _enter = $SFX/Enter
@onready var _start_up_screen = $"."
var _start_screen_scene


func _input(event):
	
	# Check if the input was the pause key
	if event.is_action_pressed("skip"):
		_enter.play()



func _load_start_screen():
	# Loads and starts the start screen scene
	_start_screen_scene = ResourceLoader.load("res://scenes/start_screen.tscn").instantiate()
	
	# End the start up scene
	_start_up_screen.queue_free()
	
	# Change to the start screen scene
	get_tree().root.add_child(_start_screen_scene)




func _on_select_finished():
	_load_start_screen()


func _on_enter_finished():
	_load_start_screen()
