extends ColorRect


@onready var game_state = $gameState
@onready var replay = $Replay
@onready var quit = $Quit
@onready var game_over = $"."


func _ready():
	
	replay.grab_focus()
	
	# Shows game state to player based on who won
	if GameData.winner == "CPU": 
		game_state.text = "You lost"
	else:
		game_state.text = "You won"




func _on_replay_pressed():
	# Restarts the game
	var gameScene = ResourceLoader.load("res://scenes/game.tscn").instantiate()
	game_over.queue_free()
	get_tree().root.add_child(gameScene)

func _on_quit_pressed():
	# Quits the game
	var startScreenScene = ResourceLoader.load("res://scenes/start_screen.tscn").instantiate()
	game_over.queue_free()
	get_tree().root.add_child(startScreenScene)




func _on_replay_mouse_entered():
	replay.grab_focus()



func _on_quit_mouse_entered():
	quit.grab_focus()
