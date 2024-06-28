extends ColorRect

@onready var start_screen = $"."
@onready var start_button = $StartButton
@onready var exit_button = $ExitButton

# Called when the node enters the scene tree for the first time.
func _ready():
	start_button.grab_focus()





func _on_start_button_pressed():
	var gameScene = ResourceLoader.load("res://scenes/game.tscn").instantiate()
	start_screen.queue_free()
	get_tree().root.add_child(gameScene)


func _on_exit_button_pressed():
	get_tree().quit()





func _on_exit_button_mouse_entered():
	exit_button.grab_focus()


func _on_start_button_mouse_entered():
	start_button.grab_focus()
