extends ColorRect

@onready var _settings_screen_scene = $"."
@onready var _back_button = $BackButton
@onready var _music_slider = $MusicOption/MusicSlider
@onready var _sfx_slider = $SFXOption/SFXSlider
@onready var _score_to_win_input = $ScoreToWinOption/ScoreToWinInput

@onready var _select = $SFX/Select
@onready var _enter = $SFX/Enter

var _back : bool


# Called when the node enters the scene tree for the first time.
func _ready():
	_back_button.grab_focus()
	#_score_to_win_input.text = str(GameData.score_to_win)

func _on_back_button_pressed():
	_back = true
	_enter.play()


func _on_back_button_focus_exited():
	_select.play()


func _on_back_button_mouse_entered():
	_back_button.grab_focus()


func _on_enter_finished():
	if _back == true:
		
		if get_tree().paused == true:
			
			get_tree().root.get_node("Game/GameManager/PauseScreen").visible = true
			
			# End the settings screen scene
			_settings_screen_scene.queue_free()
		else:
			# Loads and starts the start screen scene
			var _start_screen_scene = ResourceLoader.load("res://scenes/start_screen.tscn").instantiate()
			
			# End the settings screen scene
			_settings_screen_scene.queue_free()
			
			# Change to the start screen scene
			get_tree().root.add_child(_start_screen_scene)


func _on_music_slider_focus_exited():
	_select.play()


func _on_sfx_slider_focus_exited():
	_select.play()
	

func _on_score_to_win_input_focus_exited():
	_select.play()


func _on_music_label_mouse_entered():
	pass # Replace with function body.


func _on_music_slider_mouse_entered():
	_music_slider.grab_focus()


func _on_sfx_slider_mouse_entered():
	_sfx_slider.grab_focus()


func _on_score_to_win_input_mouse_entered():
	_score_to_win_input.grab_focus()
