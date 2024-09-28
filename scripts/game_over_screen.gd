extends ColorRect


@onready var _game_over_screen_scene: ColorRect = $"."
@onready var _game_state: Label = $GameState
@onready var _replay: Button = $Replay
@onready var _quit: Button = $Quit
@onready var _select: AudioStreamPlayer2D = $SFX/Select
@onready var _enter: AudioStreamPlayer2D = $SFX/Enter

enum _Next_States {REPLAY_GAME, QUIT_GAME}
var _next_state: _Next_States

func _ready():
	
	# Highlights the replay button
	_replay.grab_focus()
	
	# Handles what to show after a win or loss in single player mode
	if GameData.single_player_mode == true:
		
		# If the winner from the game scene was the CPU
		if GameData.winner == "CPU":
			 
			# display you lost
			_game_state.text = "You Lost"
			
		# If the winner from the game scene was the player
		else:
			
			# display you won
			_game_state.text = "You Won"
			
	# Handles what to show after a win or loss in two player mode
	else:
		
		# If the winner from the game scene was the CPU
		if GameData.winner == "CPU":
			
			# display you lost
			_game_state.text = "P2 Won"
			
		# If the winner from the game scene was the player
		else:
			
			# display you won
			_game_state.text = "P1 Won"
	


# When the replay button is pressed
func _on_replay_pressed():
	
	_next_state = _Next_States.REPLAY_GAME
	
	# Play the fade out animation
	SceneTransition.fade_out()
	
	# Play enter sfx
	_enter.play()


# When the quit button is pressed
func _on_quit_pressed():

	_next_state = _Next_States.QUIT_GAME

	# Play enter sfx
	_enter.play()


# When the mouse enters the replay button
func _on_replay_mouse_entered():
	
	# Highlight the replay button
	_replay.grab_focus()


# When the mouse enters the _quit button
func _on_quit_mouse_entered():
	
	# Highlight the _quit button
	_quit.grab_focus()


# When the replay button is no longer highlighted
func _on_replay_focus_exited():
	
	# Play the select sfx
	_select.play()


# When the quit button is no longer highlighted
func _on_quit_focus_exited():
	
	# Play the select sfx
	_select.play()


# When the enter sfx is done playing
func _on_enter_finished():
	
	match _next_state:
		
		# If the next state is REPLAY_GAME
		_Next_States.REPLAY_GAME:
			
			# Loads and starts the game scene
			var _game_scene = ResourceLoader.load("res://scenes/game.tscn").instantiate()
			
			# End the game over scene
			_game_over_screen_scene.queue_free()
			
			# Change to the game scene
			get_tree().root.add_child(_game_scene)
			
		# If the next state is QUIT_GAME
		_Next_States.QUIT_GAME:
			
			# Loads and starts the start screen scene
			var _start_screen_scene = ResourceLoader.load("res://scenes/start_screen.tscn").instantiate()
			
			# End the game over scene
			_game_over_screen_scene.queue_free()
			
			# Change to the start screen scene
			get_tree().root.add_child(_start_screen_scene)
