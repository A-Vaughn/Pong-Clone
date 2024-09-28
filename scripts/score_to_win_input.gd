extends LineEdit
@onready var _enter: AudioStreamPlayer2D = $"../../SFX/Enter"
@onready var _back_button: Button = $"../../BackButton"


# Called when the node enters the scene tree for the first time.
func _ready():
	
	# Stop players from changing the score if game already started and is currently paused
	if get_tree().paused == true:
		self.editable = false
		
	# Set score_to_win text to the current score to win
	self.text = str(GameData.score_to_win)


# Called when the user submits the text in the LineEdit
func _on_text_submitted(new_text):
	
	# If the new text is not empty, update the score_to_win and play the enter sfx
	if  not new_text == "":
		GameData.score_to_win = int(new_text)
		_enter.play()
		_back_button.grab_focus()
		
	# If the text is empty, set it to 3 (default value) and play the enter sfx
	else:
		self.text = str(3)
		GameData.score_to_win = int(text)
		_enter.play()
		_back_button.grab_focus()


# Called when the text in the LineEdit changes
func _on_text_changed(new_text):
	
	# If the new text is a valid integer
	if  new_text.is_valid_int():
		
		# If the entered score is less than 0, reset to 1
		if int(new_text) <= 0 :
			self.text = str(1)
			
	# If the text is not a valid integer, clear the text
	else:
		self.text = ""
