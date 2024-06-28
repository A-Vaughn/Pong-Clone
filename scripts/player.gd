extends StaticBody2D

var win_height
var p_height

const SPEED = 600.0
@onready var color_rect = $ColorRect

# Called when the node enters the scene tree for the first time.
func _ready():
	centerPlayer()

func _process(delta):
	# Handle movement
	if Input.is_action_pressed("move_up"):
		position.y -= SPEED * delta 
	elif Input.is_action_pressed("move_down"):
		position.y += SPEED * delta

	# Calculate the top and bottom limits for the paddle's movement
	var top_limit = 0
	var bottom_limit = win_height - p_height

	# Clamp the paddle's position within the calculated limits
	position.y = clamp(position.y, top_limit, bottom_limit)
	#move_and_slide()
	
func centerPlayer():
	# Get window height and paddle height
	win_height = get_viewport().get_visible_rect().size.y
	p_height = color_rect.get_size().y
	position.y = win_height/2 - p_height/2
