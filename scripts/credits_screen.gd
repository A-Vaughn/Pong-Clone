extends ColorRect

@onready var _music_by = $MusicBy
@onready var _back_button = $BackButton
@onready var _select = $SFX/Select
@onready var _enter = $SFX/Enter
@onready var _credits_screen_scene = $"."

var _back_to_start: bool


# Called when the node enters the scene tree for the first time.
func _ready():
	_back_button.grab_focus()
	#pass

func _on_back_button_pressed():
	_enter.play()
	_back_to_start = true


func _on_back_button_focus_exited():
	_select.play()
	
	
func _on_music_by_meta_clicked(meta):
	_enter.play()
	_back_to_start = false


func _on_music_by_meta_hover_ended(meta):
	_music_by.text = _music_by.text.replace("[color=red]https://onemansymphony.bandcamp.com[/color]", "https://onemansymphony.bandcamp.com")


func _on_music_by_meta_hover_started(meta):
		_music_by.text = _music_by.text.replace("https://onemansymphony.bandcamp.com", "[color=red]https://onemansymphony.bandcamp.com[/color]")

func _on_enter_finished():
	if _back_to_start == true:
		# Loads and starts the start screen scene
		var _start_screen_scene = ResourceLoader.load("res://scenes/start_screen.tscn").instantiate()
		
		# End the settings screen scene
		_credits_screen_scene.queue_free()
		
		# Change to the start screen scene
		get_tree().root.add_child(_start_screen_scene)
	else:
		OS.shell_open("https://onemansymphony.bandcamp.com")



