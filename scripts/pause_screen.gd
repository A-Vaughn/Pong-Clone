extends ColorRect

@onready var _pause_screen: ColorRect = $"."
@onready var _resume_button: Button = $ResumeButton
@onready var _settings_button: Button = $SettingsButton
@onready var _quit_button: Button = $QuitButton
@onready var _select: AudioStreamPlayer2D = $SFX/Select
@onready var _enter: AudioStreamPlayer2D = $SFX/Enter

@onready var game: Node2D= $"../.."
@onready var sfx_mute_timer: Timer = $SFXMuteTimer

enum _Next_States {RESUME_GAME, QUIT_GAME, SETTINGS}
var _next_state: _Next_States

# Checks for any inputs
func _input(event):
	
	if _pause_screen.visible == true:
		
		# Check if the input was the pause key
		if event.is_action_pressed("pause"):
			
			# Press the resume button
			_resume_button.emit_signal("pressed")


# Whenever the pause screen is visible or invisible
func _on_visibility_changed():
		
		# Mute the select sfx for the pause screen
		# This was a work around 
		_select.volume_db = -80
		
		# Highlights the replay button
		_resume_button.grab_focus()
		
		# Start sfx mute timer
		# sfx stay muted until timer times out
		sfx_mute_timer.start()


# When the resume button is no longer highlighted
func _on_resume_button_focus_exited():
	
	# Play the select sfx
	_select.play()


# When the settings button is no longer highlighted
func _on_settings_button_focus_exited():
	
	# Play the select sfx
	_select.play()


# When the quit button is no longer highlighted
func _on_quit_button_focus_exited():
	
	# Play the select sfx
	_select.play()


# When the resume button is pressed
func _on_resume_button_pressed():
	
	# Play the enter sfx
	_enter.play()
	
	_next_state = _Next_States.RESUME_GAME


func _on_settings_button_pressed():
	
	# Play the enter sfx
	_enter.play()
	
	_next_state = _Next_States.SETTINGS

# When the quit button is pressed
func _on_quit_button_pressed():
	
	# Play the enter sfx
	_enter.play()
	
	# Play the fade out animation
	SceneTransition.fade_out()
	
	_next_state = _Next_States.QUIT_GAME

# When the enter sfx is done playing
func _on_enter_finished():
	
	match _next_state:
		
		_Next_States.RESUME_GAME:
			
			# Remove the filter effect from the background song
			AudioServer.remove_bus_effect(1,0)
			
			# Resume the game
			get_tree().paused = false
			
			# Hide the pause screen
			_pause_screen.visible = false
			
		_Next_States.QUIT_GAME:
			
			# Remove the filter effect from the background song
			AudioServer.remove_bus_effect(1,0)
			
			# Loads and starts the start screen scene
			var _start_screen_scene: ColorRect = ResourceLoader.load("res://scenes/start_screen.tscn").instantiate()
			
			# Set the game time to normal incase the game was quit while the game was slowed down
			Engine.time_scale = 1
			
			# Resume the game
			get_tree().paused = false
			
			# End the game scene
			game.queue_free()
			
			# Change to the start screen scene
			get_tree().root.add_child(_start_screen_scene)
			
			# Add back decoration particles from memory
			FX.reattach_particles()
			
		_Next_States.SETTINGS:
			
			# Hide the pause screen
			_pause_screen.visible = false
			
			# Loads and starts the settings screen scene
			var _settings_screen_scene: ColorRect = ResourceLoader.load("res://scenes/settings_screen.tscn").instantiate()
			
			# Increase the z index off the settings scene so that it appears above all of the game scene
			_settings_screen_scene.z_index = 1
			
			# Change to the settings screen scene
			get_tree().root.add_child(_settings_screen_scene)

# When the mouse enters the resume button
func _on_resume_button_mouse_entered():
	
	# Highlight the resume button
	_resume_button.grab_focus()


func _on_settings_button_mouse_entered():
	# Highlight the settings button
	_settings_button.grab_focus()


# When the mouse enters the quit button
func _on_quit_button_mouse_entered():
	
	# Highlight the quit button
	_quit_button.grab_focus()


# When the sfx mute timer time is out
func _on_sfx_mute_timer_timeout():
	
	# Unmute select sfx volume
	# This was a workaround
	# Whenever i first pause the game no sound is made which is how it should work but anytime after the first, the select sfx 
	# would play when the game was paused. 
	# By muting the sfx immediately whenever the visibility of the pause screen was changed, the select sfx that plays would be
	# muted.
	# The timer then starts after the select sfx is muted and only lasts 0.1 seconds 
	# When the timer time runs out the select sfx is unmuted, this is enough time to mute the select sfx and return to
	# normal operation
	_select.volume_db = 0
