extends ColorRect

@onready var _start_screen_scene = $"."
@onready var _start_button = $StartButton
@onready var _exit_button = $ExitButton

# Called when the node enters the scene tree for the first time.
func _ready():
	
	# Highlights the replay button
	_start_button.grab_focus()

func _on_start_button_pressed():
	
	# Loads and starts the game scene
	var _game_scene = ResourceLoader.load("res://scenes/game.tscn").instantiate()
	
	# End the start screen scene scene
	_start_screen_scene.queue_free()
	
	# Change to the game scene
	get_tree().root.add_child(_game_scene)



func _on_exit_button_pressed():
	get_tree().quit()

# When the mouse enters the exit button
func _on_exit_button_mouse_entered():
	
	# Highlight the exit button
	_exit_button.grab_focus()

# When the mouse enters the start button
func _on_start_button_mouse_entered():
	
	# Highlight the start button
	_start_button.grab_focus()
