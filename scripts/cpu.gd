extends StaticBody2D

var _win_height
var _cpu_height
var _speed = 600

@onready var _color_rect = $ColorRect
@onready var _ball = %Ball
@onready var _ball_movement_timer = _ball.get_node("BallMovementTimer")

# Called when the node enters the scene tree for the first time.
func _ready():
	
	# Centers the CPU
	center_cpu()


func _process(delta):
	
	# If the timer has ended allow the CPU paddle to move
	# The timer gives the player 3 seconds before the ball starts moving
	if _ball_movement_timer.time_left == 0:
		
		# Calculate position to move to
		var _target = _ball.position.y - (_cpu_height/2)
		
		# Handle movement
		position.y = move_toward(position.y, _target, _speed * delta) 
		
		# Calculate the top and bottom limits for the paddle's movement
		var _top_limit = 0
		var _bottom_limit = _win_height - _cpu_height
		
		# Clamp the paddle's position within the calculated limits
		position.y = clamp(position.y, _top_limit, _bottom_limit)


# This function centers the CPU paddle along the y axis
func center_cpu():
	
	# Get window height and paddle height
	_win_height = get_viewport().get_visible_rect().size.y
	_cpu_height = _color_rect.get_size().y
	
	# Set the CPU paddle position to the center
	position.y = _win_height/2 - _cpu_height/2	


# This function changes the sspeed of the CPU paddle between 200 and 600 when the speed change timer runs out
# The speed change timer runs every second for 1 second so every second the speed of the CPU paddle is changed
func _on_timer_timeout():
	
	#Chooses a random number between 200 and 600 for the speed of the CPU paddle
	_speed = randi_range(200,600)
