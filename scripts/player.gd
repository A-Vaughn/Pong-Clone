extends StaticBody2D

var _win_height: float
var _player_height: float

const SPEED: int = 600
@onready var _color_rect: ColorRect = $ColorRect

var up: String
var down: String

# Called when the node enters the scene tree for the first time.
func _ready():
	
	# Centers the player
	center_player()
	
	# Changes move keys based on game mode
	if GameData.single_player_mode == true:
		up = "single_player_move_up"
		down = "single_player_move_down"
	else:
		up = "p1_move_up"
		down = "p1_move_down"


func _process(delta):
	
	# Handle movement
	if Input.is_action_pressed(up):
		position.y -= SPEED * delta 
		
	elif Input.is_action_pressed(down):
		position.y += SPEED * delta

	# Calculate the top and bottom limits for the paddle's movement
	var _top_limit: float = 0.0
	var _bottom_limit: float = _win_height - _player_height

	# Clamp the paddle's position within the calculated limits
	position.y = clamp(position.y, _top_limit, _bottom_limit)


# Centers the player along the y axis
func center_player():
	
	# Get window height and paddle height
	_win_height = get_viewport().get_visible_rect().size.y
	_player_height = _color_rect.get_size().y
	
	# Set the player paddle position to the center
	position.y = _win_height/2 - _player_height/2
