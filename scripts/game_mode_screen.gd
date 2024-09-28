extends ColorRect
@onready var _game_mode_screen = $"."

@onready var _select: AudioStreamPlayer2D = $SFX/Select
@onready var _enter: AudioStreamPlayer2D = $SFX/Enter

@onready var _single_player_button: Button = $SinglePlayerButton
@onready var _two_player_button: Button = $TwoPlayerButton
@onready var _back_button: Button = $BackButton

@onready var _p1_label: Label = $P1Label
@onready var _p1_controls: Label = $P1Controls

@onready var _p2_label: Label = $P2Label
@onready var _p2_controls: Label = $P2Controls

@onready var _choose_label: Label = $ChooseLabel
@onready var _pause_lable: Label = $PauseLable

var _back_to_start: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	_single_player_button.grab_focus()


func _on_single_player_button_pressed():
	
	# Play the enter sfx
	_enter.play()
	
	# Play the fade out animation
	SceneTransition.fade_out()
	
	GameData.single_player_mode = true


func _on_single_player_button_focus_exited():
	
	# Play the select sfx
	_select.play()


func _on_single_player_button_mouse_entered():
	_single_player_button.grab_focus()


func _on_two_player_button_pressed():
	
	# Play the enter sfx
	_enter.play()
	
	# Play the fade out animation
	SceneTransition.fade_out()
	
	GameData.single_player_mode = false

func _on_two_player_button_focus_exited():
	
	# Play the select sfx
	_select.play()


func _on_two_player_button_mouse_entered():
	_two_player_button.grab_focus()


func _on_back_button_pressed():
	
	# Play the enter sfx
	_enter.play()
	_back_to_start = true

func _on_back_button_focus_exited():
	
	# Play the select sfx
	_select.play()


func _on_back_button_mouse_entered():
	_back_button.grab_focus()


func _on_single_player_button_focus_entered():
	
	# Show game instructions for single player mode
	_p1_label.visible = true
	_p1_controls.visible = true
	_p2_label.visible = false
	_p2_controls.visible = false
	_choose_label.visible = false
	_pause_lable.visible = true


func _on_two_player_button_focus_entered():
	
	# Show game instructions for two player mode
	_p1_label.visible = true
	_p1_controls.visible = true
	_p2_label.visible = true
	_p2_controls.visible = true
	_choose_label.visible = false
	_pause_lable.visible = true


func _on_back_button_focus_entered():
	
	# Hide instructions
	_choose_label.visible = true
	_p1_label.visible = false
	_p1_controls.visible = false
	_p2_label.visible = false
	_p2_controls.visible = false
	_pause_lable.visible = false


func _on_enter_finished():
	
	if _back_to_start == true:
		
		# Loads and starts the start screen scene
		var _start_screen_scene: ColorRect = ResourceLoader.load("res://scenes/start_screen.tscn").instantiate()
		
		# End the settings screen scene
		_game_mode_screen.queue_free()
		
		# Change to the start screen scene
		get_tree().root.add_child(_start_screen_scene)
	else:
		
		#Loads and starts the game scene
		var _game_scene: Node2D = ResourceLoader.load("res://scenes/game.tscn").instantiate()
		
		# End the start screen scene scene
		_game_mode_screen.queue_free()
		
		# Change to the game scene
		get_tree().root.add_child(_game_scene)
