extends ColorRect


@onready var _game_state = $GameState
@onready var _replay = $Replay
@onready var _quit = $Quit
@onready var _game_over_screen_scene = $"."


func _ready():
	
	# Highlights the replay button
	_replay.grab_focus()
	
	# If the winner from the game scene was the CPU
	if GameData.winner == "CPU": 
		# display you lost
		_game_state.text = "You lost"
		
	# If the winner from the game scene was the player
	else:
		# display you won
		_game_state.text = "You won"




# Restarts the game
func _on_replay_pressed():
	
	# Loads and starts the game scene
	var _game_scene = ResourceLoader.load("res://scenes/game.tscn").instantiate()
	
	# End the game over scene
	_game_over_screen_scene.queue_free()
	
	# Change to the game scene
	get_tree().root.add_child(_game_scene)



# Quits the game
func _on_quit_pressed():
	
	# Loads and starts the start screen scene
	var _start_screen_scene = ResourceLoader.load("res://scenes/start_screen.tscn").instantiate()
	
	# End the game over scene
	_game_over_screen_scene.queue_free()
	
	# Change to the start screen scene
	get_tree().root.add_child(_start_screen_scene)



# When the mouse enters the replay button
func _on_replay_mouse_entered():
	
	# Highlight the replay button
	_replay.grab_focus()


# When the mouse enters the _quit button
func _on_quit_mouse_entered():
	
	# Highlight the _quit button
	_quit.grab_focus()
