extends CharacterBody2D
var win_length
var win_height

var direction = 0

var speed
var acceleration = 50
var lastCollider
@onready var game_manager = %GameManager
@onready var color_rect = $ColorRect
@onready var timer = $Timer
@onready var timer_label = %TimerLabel
@onready var animation_player = $AnimationPlayer
@onready var paddle_hit_effect = $PaddleHitEffect
@onready var ball_hit_effect = $BallHitEffect
@onready var speed_effect = $SpeedEffect


var play = true


func _ready():
	startBall()
	
	
func _process(delta):
	if speed > 800 && play == true:
		animation_player.play("speedIncrease")
		#speed_effect.visible = true
		if lastCollider == "Player":
			speed_effect.position.x = 15 #15 #51
			speed_effect.gravity.x = -980
			speed_effect.emitting = true
		if lastCollider == "CPU":
			speed_effect.position.x =5#5 #51
			speed_effect.gravity.x = 980
			speed_effect.emitting = true
		play = false
		
	# Move ball
	var collision = move_and_collide(direction * speed * delta)
	# Check if the ball collided with something
	if collision:
		
		#Get the name of what the ball collided with
		var collider = collision.get_collider()
		
		# Check f the ball collided with the boundaries
		if collider.get_name() == "UpBoundary" or collider.name == "DownBoundary":
			# Bounce the ball off the boundary
			direction = direction.bounce(collision.get_normal())
			
		# Check if the ball collided with the player or cpu
		else:
			if speed > 800:
				animation_player.play("hit")
			# Give the ball a random direction based on who hit it
			direction = directionAfterPaddle(collider)

			# Set max speed of ball
			if speed < 1500:
				# Increase speed when player or cpu hits ball
				speed += acceleration




func startBall():
	# Start the timer that determines when the ball will move
	timer.start()
	# Set the ball to invisible so that the timer label can be properly seen
	color_rect.set_visible(false)
	# Set the timer label to visible so that it can be seen
	timer_label.set_visible(true)
	
	speed = 0
	
	animation_player.play("RESET")
	play = true
	
	# Get window length and height
	win_length = get_viewport().get_visible_rect().size.x
	win_height = get_viewport().get_visible_rect().size.y
	
	# Center ball
	position.x = (win_length / 2) - (color_rect.size.x / 2.0)
	#position.y = (win_height/2) - (color_rect.size.y/2.0)
	position.y = randi_range(color_rect.size.y/2.0, win_height-color_rect.size.y/2.0)
	# Choose a random direction for the ball to go in
	direction = randomDirection(game_manager.lastScorer)

# Returns a random direction depending on who scored last
func randomDirection(lastScorer):
	# If there was no last scorer, i.e the game just started choose a completely random direction to start
	if lastScorer == null:
		var newDirection = Vector2()
		# Choose a direction for the x axis above 0.5 and below -0.5 so that the ball doesnt start to vertical
		newDirection.x = [randf_range(-1, -0.5),randf_range(0.5, 1)].pick_random()
		
		#Choose a random value for the direction y axis
		newDirection.y = randf_range(-1, 1)
		
		newDirection = newDirection.normalized()
		return newDirection
		# If the last scorer was the player, choose a random direction aimed at the cpu
	elif lastScorer == "Player":
		var newDirection = Vector2()
		newDirection.x = -1
		newDirection.y = randf_range(-1, 1)
		newDirection = newDirection.normalized()
			
		return newDirection
		# If the last scorer was the player, choose a random direction aimed at the player
	elif lastScorer == "CPU":
		var newDirection = Vector2()
		newDirection.x = 1
		newDirection.y = randf_range(-1, 1)
		newDirection = newDirection.normalized()
		return newDirection
		
		



# Returns a random direction with respect to the last paddle that was hit
func directionAfterPaddle(collider):
	# Get paddle center and distance between ball and paddle center
	var paddle = collider.get_node("ColorRect")
	var paddleCenter = paddle.get_size().y/2
	var distanceFromCenter = position.y - (paddleCenter + paddle.global_position.y)
	
	# Make a direction for the ball to go in
	var newDirection = Vector2()
	
	# Calculate the normalized vertical distance from the center of the paddle.
	# This adjusts the bounce direction based on how far the ball is from the center
	# of the paddle along the y-axis, relative to half the paddle's height.
	newDirection.y =distanceFromCenter/paddleCenter
	
	if collider.get_name() == "Player":
		lastCollider = "Player"
		# Sends ball to the left
		newDirection.x = -1
		if speed > 800:
			ball_hit_effect.position.x = 38 #15
			ball_hit_effect.gravity.x = -980
			ball_hit_effect.emitting = true
			
			paddle_hit_effect.position.x = 23
			paddle_hit_effect.gravity.x = -980
			paddle_hit_effect.emitting = true
			
			speed_effect.position.x = 15
			speed_effect.gravity.x = -980
	else:
		lastCollider = "CPU"
		#Sends ball to the left
		newDirection.x = 1
		
		if speed > 800:
			ball_hit_effect.position.x =-20 #-7 #5
			ball_hit_effect.gravity.x = 980
			ball_hit_effect.emitting = true
			
			paddle_hit_effect.position.x = -3
			paddle_hit_effect.gravity.x = 980
			paddle_hit_effect.emitting = true
			
			speed_effect.position.x =5 
			speed_effect.gravity.x = 980

	newDirection = newDirection.normalized()
	# Creates a small offset to prevent the ball from getting stuck to a paddle when moving in the same direction
	position += newDirection * 5
	
	return newDirection


# When 3 seconds have passed:
# Give the ball speed which allows it to move
# Make the ball visible and make the timer label invisible
func _on_timer_timeout():
	timer_label.set_visible(false)
	color_rect.set_visible(true)
	speed = 600
	
	
	
