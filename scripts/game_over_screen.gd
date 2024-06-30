extends ColorRect


@onready var _game_state = $GameState
@onready var _replay = $Replay
@onready var _quit = $Quit
@onready var _game_over_screen_scene = $"."
@onready var _select = $SFX/Select
@onready var _enter = $SFX/Enter

var _replay_game : bool
var _quit_game : bool


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


# When the replay button is pressed
func _on_replay_pressed():
	
	# Set _replay_game to true
	_replay_game = true
	
	# Play enter sfx
	_enter.play()


# When the quit button is pressed
func _on_quit_pressed():
	
	# Set _quit_game to true
	_quit_game = true
	
	# Play enter sfx
	_enter.play()


# When the mouse enters the replay button
func _on_replay_mouse_entered():
	
	# Play select sfx
	_select.play()
	
	# Highlight the replay button
	_replay.grab_focus()


# When the mouse enters the _quit button
func _on_quit_mouse_entered():
	
	# Play select sfx
	_select.play()
	
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
	if _replay_game == true:
		
		# Loads and starts the game scene
		var _game_scene = ResourceLoader.load("res://scenes/game.tscn").instantiate()
		
		# End the game over scene
		_game_over_screen_scene.queue_free()
		
		# Change to the game scene
		get_tree().root.add_child(_game_scene)
		
	elif _quit_game == true:
		
		# Loads and starts the start screen scene
		var _start_screen_scene = ResourceLoader.load("res://scenes/start_screen.tscn").instantiate()
		
		# End the game over scene
		_game_over_screen_scene.queue_free()
		
		# Change to the start screen scene
		get_tree().root.add_child(_start_screen_scene)
