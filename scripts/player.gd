extends StaticBody2D

var _win_height
var _player_height

const SPEED = 600
@onready var _color_rect = $ColorRect

# Called when the node enters the scene tree for the first time.
func _ready():
	# Centers the player
	center_player()

func _process(delta):
	# Handle movement
	if Input.is_action_pressed("move_up"):
		position.y -= SPEED * delta 
	elif Input.is_action_pressed("move_down"):
		position.y += SPEED * delta

	# Calculate the top and bottom limits for the paddle's movement
	var _top_limit = 0
	var _bottom_limit = _win_height - _player_height

	# Clamp the paddle's position within the calculated limits
	position.y = clamp(position.y, _top_limit, _bottom_limit)

# Centers the player along the y axis
func center_player():
	# Get window height and paddle height
	_win_height = get_viewport().get_visible_rect().size.y
	_player_height = _color_rect.get_size().y
	
	# Set the player paddle position to the center
	position.y = _win_height/2 - _player_height/2
