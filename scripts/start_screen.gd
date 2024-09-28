extends ColorRect

@onready var _start_screen_scene: ColorRect = $"."

@onready var _start_button: Button = $StartButton
@onready var _settings_button: Button = $SettingsButton
@onready var _credits_button: Button = $CreditsButton
@onready var _exit_button: Button = $ExitButton

@onready var _select: AudioStreamPlayer2D = $SFX/Select
@onready var _enter: AudioStreamPlayer2D = $SFX/Enter

enum _Next_States {GAME_MODE, SETTINGS, CREDITS, EXIT}
var _next_state: _Next_States


# Called when the node enters the scene tree for the first time.
func _ready():
	
	# Highlights the replay button
	_start_button.grab_focus()
	
	if GameData.first_load == true:
		
		# Play select sfx
		_select.play()
		
		# Start music and particles
		FX.get_node("AudioStreamPlayer2D").play()
		FX.get_node("GPUParticles2D").emitting = true
		
		GameData.first_load = false
	
	
	#if Engine.has_singleton("JavaScript"):
		#var js = Engine.get_singleton("JavaScript")
		#js.eval("console.log('Hello from JavaScript!');")  # Runs a JS console log
		##js.eval("Y8.init();")  # Initializes the Y8 SDK


# When the start button is pressed
func _on_start_button_pressed():
	
	# Set _to_game_mode to true
	_next_state = _Next_States.GAME_MODE
	
	# Play enter sfx
	_enter.play()


func _on_settings_button_pressed():
	
	_next_state = _Next_States.SETTINGS
	
	# Play enter sfx
	_enter.play()


func _on_credits_button_pressed():
	
	_next_state = _Next_States.CREDITS
	
	# Play enter sfx
	_enter.play()

func _on_exit_button_pressed() -> void:
	
	_next_state = _Next_States.EXIT
	
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


func _on_exit_button_mouse_entered() -> void:
	
	# Highlight the settings button
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


func _on_exit_button_focus_exited() -> void:
	
	# Play select sfx
	_select.play()


# When the enter sfx is done playing
func _on_enter_finished():
	match _next_state:
		
		_Next_States.GAME_MODE:
			
			# Loads and starts the game mode scene
			var _game_mode_scene: ColorRect = ResourceLoader.load("res://scenes/game_mode_screen.tscn").instantiate()
			
			# End the start screen scene scene
			_start_screen_scene.queue_free()
			
			# Change to the game mode scene
			get_tree().root.add_child(_game_mode_scene)
		
		_Next_States.SETTINGS:
			
			# Loads and starts the settings scene
			var _settings_scene:ColorRect = ResourceLoader.load("res://scenes/settings_screen.tscn").instantiate()
			
			# End the start screen scene scene
			_start_screen_scene.queue_free()
			
			# Change to the game scene
			get_tree().root.add_child(_settings_scene)
		_Next_States.CREDITS:
			
			# Loads and starts the settings scene
			var _credits_scene: ColorRect = ResourceLoader.load("res://scenes/credits_screen.tscn").instantiate()
			
			# End the start screen scene scene
			_start_screen_scene.queue_free()
			
			# Change to the game scene
			get_tree().root.add_child(_credits_scene)
			
		_Next_States.EXIT:
			# Exit the game
			get_tree().quit()
