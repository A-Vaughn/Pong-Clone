extends LineEdit
@onready var _enter = $"../../SFX/Enter"
@onready var _back_button = $"../../BackButton"


# Called when the node enters the scene tree for the first time.
func _ready():
	if get_tree().paused == true:
		editable = false
	text = str(GameData.score_to_win)


func _on_text_submitted(new_text):
	if  not new_text == "":
		GameData.score_to_win = int(new_text)
		_enter.play()
		_back_button.grab_focus()
	else:
		text = str(3)
		GameData.score_to_win = int(text)
		_enter.play()
		_back_button.grab_focus()


func _on_text_changed(new_text):
	if  new_text.is_valid_int():
		if int(new_text) <= 0 :
			text = str(1)
	else:
		text = ""
