extends ColorRect
@onready var _game_mode_screen = $"."

@onready var _select = $SFX/Select
@onready var _enter = $SFX/Enter

@onready var _single_player_button = $SinglePlayerButton
@onready var _two_player_button = $TwoPlayerButton
@onready var _back_button = $BackButton

@onready var _p1_label = $P1Label
@onready var _p1_controls = $P1Controls

@onready var _p2_label = $P2Label
@onready var _p2_controls = $P2Controls

@onready var _choose_label = $ChooseLabel

var _back_to_start = false




# Called when the node enters the scene tree for the first time.
func _ready():
	_single_player_button.grab_focus()


func _on_single_player_button_pressed():
	_enter.play()
	GameData.single_player_mode = true


func _on_single_player_button_focus_exited():
	_select.play()


func _on_single_player_button_mouse_entered():
	_single_player_button.grab_focus()


func _on_two_player_button_pressed():
	_enter.play()
	GameData.single_player_mode = false

func _on_two_player_button_focus_exited():
	_select.play()


func _on_two_player_button_mouse_entered():
	_two_player_button.grab_focus()


func _on_back_button_pressed():
	_enter.play()
	_back_to_start = true

func _on_back_button_focus_exited():
	
	_select.play()


func _on_back_button_mouse_entered():
	_back_button.grab_focus()


func _on_single_player_button_focus_entered():
	_p1_label.visible = true
	_p1_controls.visible = true
	_p2_label.visible = false
	_p2_controls.visible = false
	_choose_label.visible = false


func _on_two_player_button_focus_entered():
	_p1_label.visible = true
	_p1_controls.visible = true
	_p2_label.visible = true
	_p2_controls.visible = true
	_choose_label.visible = false


func _on_back_button_focus_entered():
	_choose_label.visible = true
	_p1_label.visible = false
	_p1_controls.visible = false
	_p2_label.visible = false
	_p2_controls.visible = false
	



## Loads and starts the game scene
		#var _game_scene = ResourceLoader.load("res://scenes/game.tscn").instantiate()
		#
		## End the start screen scene scene
		#_start_screen_scene.queue_free()
		#
		## Change to the game scene
		#get_tree().root.add_child(_game_scene)


func _on_enter_finished():
	if _back_to_start == true:
		# Loads and starts the start screen scene
		var _start_screen_scene = ResourceLoader.load("res://scenes/start_screen.tscn").instantiate()
		
		# End the settings screen scene
		_game_mode_screen.queue_free()
		
		# Change to the start screen scene
		get_tree().root.add_child(_start_screen_scene)
	else:
		#Loads and starts the game scene
		var _game_scene = ResourceLoader.load("res://scenes/game.tscn").instantiate()
		
		# End the start screen scene scene
		_game_mode_screen.queue_free()
		
		# Change to the game scene
		get_tree().root.add_child(_game_scene)
