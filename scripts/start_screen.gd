extends ColorRect

@onready var _start_screen_scene = $"."
@onready var _start_button = $StartButton
@onready var _settings_button = $SettingsButton
@onready var _credits_button = $CreditsButton
@onready var _exit_button = $ExitButton
@onready var _select = $SFX/Select
@onready var _enter = $SFX/Enter

var _to_game_mode : bool
var _exit_game : bool
var _to_settings : bool
var _to_credits: bool


# Called when the node enters the scene tree for the first time.
func _ready():
	
	# Highlights the replay button
	_start_button.grab_focus()
	
	if GameData.first_load == true:
		# Play select sfx
		_select.play()
		Music.play()
		GameData.first_load = false
		


# When the start button is pressed
func _on_start_button_pressed():
	
	# Set _to_game_mode to true
	_to_game_mode = true
	
	# Play enter sfx
	_enter.play()


func _on_settings_button_pressed():
	_to_settings = true
	_enter.play()


func _on_credits_button_pressed():
	_to_credits = true
	_enter.play()


# When the exit button is pressed
func _on_exit_button_pressed():
	
	# Set _exit_game to true
	_exit_game = true
	
	# Play enter sfx
	_enter.play()


# When the mouse enters the start button
func _on_start_button_mouse_entered():
	
	# Highlight the start button
	_start_button.grab_focus()


func _on_settings_button_mouse_entered():
	# Highlight the settings button
	_settings_button.grab_focus()


func _on_credits_button_mouse_entered():
	# Highlight the settings button
	_credits_button.grab_focus()


# When the mouse enters the exit button
func _on_exit_button_mouse_entered():
	
	# Highlight the exit button
	_exit_button.grab_focus()


# When the start button is no longer highlighted
func _on_start_button_focus_exited():
	
	# Play select sfx
	_select.play()


func _on_settings_button_focus_exited():
	
	# Play select sfx
	_select.play()


func _on_credits_button_focus_exited():
	# Play select sfx
	_select.play()


# When the exit button is no longer highlighted
func _on_exit_button_focus_exited():
	
	# Play select sfx
	_select.play()


# When the enter sfx is done playing
func _on_enter_finished():
	
	if _to_game_mode == true:
		
		# Loads and starts the game mode scene
		var _game_mode_scene = ResourceLoader.load("res://scenes/game_mode_screen.tscn").instantiate()
		
		# End the start screen scene scene
		_start_screen_scene.queue_free()
		
		# Change to the game mode scene
		get_tree().root.add_child(_game_mode_scene)
		
		
		## Loads and starts the game scene
		#var _game_scene = ResourceLoader.load("res://scenes/game.tscn").instantiate()
		#
		## End the start screen scene scene
		#_start_screen_scene.queue_free()
		#
		## Change to the game scene
		#get_tree().root.add_child(_game_scene)
		
	elif _exit_game == true:
		
		# Exit the game
		get_tree().quit()
		
	elif _to_settings == true:
		
		# Loads and starts the settings scene
		var _settings_scene = ResourceLoader.load("res://scenes/settings_screen.tscn").instantiate()
		
		# End the start screen scene scene
		_start_screen_scene.queue_free()
		
		
		# Change to the game scene
		get_tree().root.add_child(_settings_scene)
		
	elif _to_credits == true:
		# Loads and starts the settings scene
		var _credits_scene = ResourceLoader.load("res://scenes/credits_screen.tscn").instantiate()
		
		# End the start screen scene scene
		_start_screen_scene.queue_free()
		
		
		# Change to the game scene
		get_tree().root.add_child(_credits_scene)
