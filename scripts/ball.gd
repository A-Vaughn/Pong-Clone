extends CharacterBody2D

var _direction = 0
var _speed
var _last_collider

# Handles when the speedIncrease animation will play
var _play_speed_increase

@onready var _game_manager = %GameManager
@onready var _color_rect = $ColorRect
@onready var _ball_movement_timer = $BallMovementTimer
@onready var _timer_label = %TimerLabel
@onready var _animation_player = $AnimationPlayer
@onready var _paddle_hit_effect = $PaddleHitEffect
@onready var _ball_hit_effect = $BallHitEffect
@onready var _speed_effect = $SpeedEffect

func _ready():
	# Handles various tasks to get the ball ready for moving and then moves the ball
	start_ball()
	
	
func _process(delta):
	# Handles the speed increase visual effects
	_play_speed_increase_vfx()
	# Move ball
	var _collision = move_and_collide(_direction * _speed * delta)
	# Check if the ball collided with something
	if _collision:
		#Get what the ball collided with
		var _collider = _collision.get_collider()
		
		# Check if the ball collided with the boundaries
		if _collider.get_name() == "UpBoundary" or _collider.name == "DownBoundary":
			# Bounce the ball off the boundary
			_direction = _direction.bounce(_collision.get_normal())
			
		# If the ball didn't collide with the boundaries then it collided with a paddle
		else:
			# play the hit animation when the ball is over a certain speed
			if _speed > 800:
				_animation_player.play("hit")
				
			# Give the ball a random direction based on who hit it
			_direction = _direction_after_paddle(_collider)

			# Increase the speed until a certain speed is reached
			if _speed < 1500:
				#Set acceleration to 50
				var _acceleration = 50
				# Increase speed when player or cpu hits ball
				_speed += _acceleration



# Handles starting the ball at the start of the game and restarting the ball when someone scores a point 
func start_ball():
	# Start the timer that determines when the ball will move (after 3 seconds)
	_ball_movement_timer.start()
	# Set the ball to invisible so that the timer label can be properly seen
	_color_rect.set_visible(false)
	# Set the timer label to visible so that it can be seen
	_timer_label.set_visible(true)
	
	# Set the speed to 0 which stops the ball from moving
	_speed = 0
	
	# This animation resets the ball size and ball collision size
	_animation_player.play("RESET")
	
	#Set to true so the speed increase vfx can  play
	_play_speed_increase = true
	
	# Get window length and height
	var _win_length = get_viewport().get_visible_rect().size.x
	var _win_height = get_viewport().get_visible_rect().size.y
	
	# Center ball along the x axis
	position.x = (_win_length / 2) - (_color_rect.size.x / 2.0)
	
	# Set ball along the y axis randomly
	position.y = randi_range(_color_rect.size.y/2.0, _win_height - _color_rect.size.y/2.0)
	
	# Choose a random direction for the ball to go in
	_direction = _random_direction(_game_manager.last_scorer)

# Returns a random direction depending on who scored last
func _random_direction(_last_scorer):
	# Make new vector for storing new direction
	var _new_direction = Vector2()
	# If there was no last scorer, i.e the game just started choose a completely random direction to start
	if _last_scorer == null:
		# Choose a direction for the x axis above 0.5 and below -0.5 so that the ball doesnt start to vertical
		_new_direction.x = [randf_range(-1, -0.5),randf_range(0.5, 1)].pick_random()
		
		#Choose a random value for the direction y axis
		_new_direction.y = randf_range(-1, 1)
		
		# Normalize the new direction before returning it
		_new_direction = _new_direction.normalized()
		return _new_direction
		# If the last scorer was the player, choose a random direction aimed at the cpu
	elif _last_scorer == "Player":
		# Set the direction of the ball to the left(direction of the CPU paddle)
		_new_direction.x = -1
		
		#Choose a random value for the direction y axis
		_new_direction.y = randf_range(-1, 1)
		
		# Normalize the new direction before returning it
		_new_direction = _new_direction.normalized()
		return _new_direction
		# If the last scorer was the player, choose a random direction aimed at the player
	elif _last_scorer == "CPU":
		# Set the direction of the ball to the right(direction of the Player paddle)
		_new_direction.x = 1
		
		#Choose a random value for the direction y axis
		_new_direction.y = randf_range(-1, 1)
		
		# Normalize the new direction before returning it
		_new_direction = _new_direction.normalized()
		return _new_direction
		
		



# Returns a random direction with respect to the last paddle that was hit
func _direction_after_paddle(_current_collider):
	# Get paddle center and distance between ball and paddle center
	var _paddle = _current_collider.get_node("ColorRect")
	var _paddle_center = _paddle.get_size().y/2
	var _distance_from_center = position.y - (_paddle_center + _paddle.global_position.y)
	
	# Make a direction for the ball to go in
	var _new_direction = Vector2()
	
	# Calculate the normalized vertical distance from the center of the paddle.
	# This adjusts the bounce direction based on how far the ball is from the center
	# of the paddle along the y-axis, relative to half the paddle's height.
	_new_direction.y = _distance_from_center/_paddle_center
	
	# Handle directions for f the ball collided with the Player paddle
	if _current_collider.get_name() == "Player":
		# Update the last_collider to Player
		_last_collider = "Player"
		
		# Sends ball to the left
		_new_direction.x = -1
		
		# Handle particles when speed is greater than 800
		_handle_collision_effects()
		
	# Handle directions for if the ball collided with the CPU paddle
	else:
		# Update the last_collider to CPU
		_last_collider = "CPU"
		
		#Sends ball to the left
		_new_direction.x = 1
		
		# Handle particles when speed is greater than 800
		_handle_collision_effects()
		
	# Normalize the new direction before returning it
	_new_direction = _new_direction.normalized()
	# Creates a small offset to prevent the ball from getting stuck to a paddle when moving in the same direction
	position += _new_direction * 5
	
	return _new_direction
	
	
	
	
	# Determines which direction to play collision effects and plays them
func _handle_collision_effects():
	#Plays effects when speed is greater than 800
	if _speed > 800:
		#Determines the direction to emit particles when the ball was hit by the player
		if _last_collider == "Player":
			# Set the particles effect to the right side of the ball
			_ball_hit_effect.position.x = 38
			# Set the particles to emit to the right
			_ball_hit_effect.gravity.x = -980
			# Emit the particles
			_ball_hit_effect.emitting = true
			
			# Set the particles effect to the right side of the ball
			_paddle_hit_effect.position.x = 23
			# Set the particles to emit to the right
			_paddle_hit_effect.gravity.x = -980
			# Emit the particles
			_paddle_hit_effect.emitting = true
			
			# Set the particles effect to the right side of the ball
			_speed_effect.position.x = 15
			# Set the particles to emit to the right
			_speed_effect.gravity.x = -980
		else:
			# Set the particles effect to the left side of the ball
			_ball_hit_effect.position.x =-20
			# Set the particles to emit to the left
			_ball_hit_effect.gravity.x = 980
			# Emit the particles
			_ball_hit_effect.emitting = true
			
			# Set the particles effect to the left side of the ball
			_paddle_hit_effect.position.x = -3
			# Set the particles to emit to the left
			_paddle_hit_effect.gravity.x = 980
			# Emit the particles
			_paddle_hit_effect.emitting = true
			
			# Set the particles effect to the right side of the ball
			_speed_effect.position.x =5 
			# Set the particles to emit to the left
			_speed_effect.gravity.x = 980
	
	
# Determines which direction to emit the speed effect particle based on who last hit the ball
func _start_speed_effect():
		if _last_collider == "Player":
			# Set the particles effect to the right side of the ball
			_speed_effect.position.x = 15
			# Set the particles to emit to the right
			_speed_effect.gravity.x = -980
			# Emit the particles
			_speed_effect.emitting = true
		if _last_collider == "CPU":
			# Set the particles effect to the left side of the ball
			_speed_effect.position.x =5
			# Set the particles to emit to the left
			_speed_effect.gravity.x = 980
			# Emit the particles
			_speed_effect.emitting = true

# Plays the speedIncrease animation and effectwhen the speed of the ball is over 800 and _play_speed_increase is true
func _play_speed_increase_vfx():
	if _speed > 800 && _play_speed_increase == true:
		#Plays the speedIncrease animation
		_animation_player.play("speedIncrease")
		# Handles the speedEffect particles
		_start_speed_effect()
		# Sets the _play_speed_increase to false so the animation only plays once and doesn't keep looping
		_play_speed_increase = false

# When 3 seconds have passed:
# Give the ball speed which allows it to move
# Make the ball visible and make the timer label invisible
func _on_timer_timeout():
	_timer_label.set_visible(false)
	_color_rect.set_visible(true)
	_speed = 600
	
	
	
