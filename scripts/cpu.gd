extends StaticBody2D

var win_height
var cpu_height
var speed = 600.0

#const SPEED = 600.0
@onready var color_rect = $ColorRect
@onready var ball = %Ball

@onready var ball_timer = ball.get_node("Timer")

# Called when the node enters the scene tree for the first time.
func _ready():
	# Get window height and paddle height
	win_height = get_viewport().get_visible_rect().size.y
	cpu_height = color_rect.get_size().y
	
	# Positions paddle in the center based on the width of the screen
	position.y = win_height/2 - cpu_height/2

func _process(delta):
	if ball_timer.time_left>0:
		position.y = win_height/2 - cpu_height/2
	else:
		#var SPEED = randi_range(100,600)
		# Calculate position to move to
		var target = ball.position.y - (cpu_height/2)
		# Handle movement
		position.y = move_toward(position.y, target, speed * delta) 

		# Calculate the top and bottom limits for the paddle's movement
		var top_limit = 0
		var bottom_limit = win_height - cpu_height

		# Clamp the paddle's position within the calculated limits
		position.y = clamp(position.y, top_limit, bottom_limit)


func _on_timer_timeout():
	speed = randi_range(200,600)
