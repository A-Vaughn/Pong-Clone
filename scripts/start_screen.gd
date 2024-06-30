extends ColorRect

@onready var _start_screen_scene = $"."
@onready var _start_button = $StartButton
@onready var _exit_button = $ExitButton
@onready var _select = $SFX/Select
@onready var _enter = $SFX/Enter

var _start_game : bool
var _exit_game : bool


# Called when the node enters the scene tree for the first time.
func _ready():
	
	# Highlights the replay button
	_start_button.grab_focus()


# When the start button is pressed
func _on_start_button_pressed():
	
	# Set _start_game to true
	_start_game = true
	
	# Play enter sfx
	_enter.play()


# When the exit button is pressed
func _on_exit_button_pressed():
	
	# Set _exit_game to true
	_exit_game = true
	
	# Play enter sfx
	_enter.play()


# When the mouse enters the exit button
func _on_exit_button_mouse_entered():
	
	# Highlight the exit button
	_exit_button.grab_focus()


# When the mouse enters the start button
func _on_start_button_mouse_entered():
	
	# Highlight the start button
	_start_button.grab_focus()


# When the start button is no longer highlighted
func _on_start_button_focus_exited():
	
	# Play select sfx
	_select.play()


# When the exit button is no longer highlighted
func _on_exit_button_focus_exited():
	
	# Play select sfx
	_select.play()


# When the enter sfx is done playing
func _on_enter_finished():
	
	if _start_game == true:
		
		# Loads and starts the game scene
		var _game_scene = ResourceLoader.load("res://scenes/game.tscn").instantiate()
		
		# End the start screen scene scene
		_start_screen_scene.queue_free()
		
		# Change to the game scene
		get_tree().root.add_child(_game_scene)
		
	elif _exit_game == true:
			
			# Exit the game
			get_tree().quit()
