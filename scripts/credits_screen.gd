extends ColorRect

@onready var _music_by: RichTextLabel = $MusicBy
@onready var _back_button: Button = $BackButton
@onready var _select: AudioStreamPlayer2D = $SFX/Select
@onready var _enter: AudioStreamPlayer2D = $SFX/Enter
@onready var _credits_screen_scene: ColorRect = $"."

var _back_to_start: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	
	_back_button.grab_focus()


func _on_back_button_pressed():
	
	# Play enter sfx
	_enter.play()
	_back_to_start = true


func _on_back_button_focus_exited():
	
	# Play select sfx
	_select.play()
	
	
# When the link for the music creator is clicked
func _on_music_by_meta_clicked(_meta):
	
	# Play enter sfx
	_enter.play()
	_back_to_start = false

# When the link for the music creator is no longer hovered
func _on_music_by_meta_hover_ended(_meta):
	
	# Turn link text to white
	_music_by.text = _music_by.text.replace("[color=red]https://onemansymphony.bandcamp.com[/color]", "https://onemansymphony.bandcamp.com")

# When the link for the music creator is hovered
func _on_music_by_meta_hover_started(_meta):
	
	# Turn link text to red
	_music_by.text = _music_by.text.replace("https://onemansymphony.bandcamp.com", "[color=red]https://onemansymphony.bandcamp.com[/color]")

func _on_enter_finished():

	if _back_to_start == true:
		
		# Loads and starts the start screen scene
		var _start_screen_scene: ColorRect = ResourceLoader.load("res://scenes/start_screen.tscn").instantiate()
		
		# End the settings screen scene
		_credits_screen_scene.queue_free()
		
		# Change to the start screen scene
		get_tree().root.add_child(_start_screen_scene)
		
	else:
		
		# Open the link in browser
		OS.shell_open("https://onemansymphony.bandcamp.com")
