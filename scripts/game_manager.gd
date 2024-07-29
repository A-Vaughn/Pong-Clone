extends Node

var _player_score = 0
var _cpu_score = 0
var last_scorer = null
#var _score_to_win = 3
var _ball_movement_timer

@onready var _ball = %Ball
@onready var _player_score_text = $PlayerScore
@onready var _cpu_score_text = $CPUscore
@onready var _game = $".."
@onready var _timer_label = $TimerLabel
@onready var _player = %Player
@onready var _cpu = %CPU
@onready var _game_speed_timer = $GameSpeedTimer
@onready var pause_screen = $PauseScreen

@onready var _ball_explosion_camera = $BallExplosionCamera
@onready var ball_explosion_sound = $BallExplosionSound

# Camera stuff
var _random_strength: float = 30.0
var shake_fade: float = 5.0
var _rng = RandomNumberGenerator.new()
var _shake_strength: float = 0.0


# Called when the node enters the scene tree for the first time.
func _ready():
	
	# Get the ball movement timer
	_ball_movement_timer = _ball.get_node("BallMovementTimer")

# Checks for any inputs
func _input(event):
	
	# Check if the input was the pause key
	if event.is_action_pressed("pause"):
		
		# Create a filter effect for the background song
		var _effect = AudioEffectFilter.new()
		
		# Add the filter effect to the background song, this makes the song sound muffled
		AudioServer.add_bus_effect(1, _effect, 0)
		
		# Make the pause screen visible
		pause_screen.visible = true
		
		# Pause the game
		get_tree().paused = true


func _process(delta):
	
	# Check if the ball movement timer is running 
	if _ball_movement_timer.is_stopped() == false:
		
		# Displays the time when the time until the ball moves
		_timer_label.text = str(int(_ball_movement_timer.time_left)+1)
	
	# Camera shake stuff
	if _shake_strength>0:
		_shake_strength = lerpf(_shake_strength, 0, shake_fade * delta)
		_ball_explosion_camera.offset = _random_offset()


# Handles score updates and vfx when the ball goes behind the player
func _on_behind_player_body_entered(body):
	
	# Sets the last scorer to cpu
	last_scorer = "CPU"
	
	# Updates the score based on the last_scorer
	_update_score(last_scorer)
	
	# Handles vfx based on the ball position and the number entered
	# -1 tells the function to emit the particles to the right
	_explode_ball(body.position, -1)
	
	# Start the timer that determines when the game will go back to its original speed
	_game_speed_timer.start()


# Handles score updates and vfx when the ball goes behind the XPU
func _on_behind_cpu_body_entered(body):
	
	# Sets the last scorer to player
	last_scorer = "Player"
	
	# Updates the score based on the last_scorer
	_update_score(last_scorer)
	
	# Handles vfx based on the ball position and the number entered
	# 1 tells the function to emit the particles to the left
	_explode_ball(body.position, 1)
	
	# Start the timer that determines when the game will go back to its original speed
	_game_speed_timer.start()


# Emits particles at the position of the ball when a point is scored and in a direction depending on where the ball was
func _explode_ball(ball_position, direction):
	
	# Play the ball explosion sfx
	ball_explosion_sound.play()
	
	# Get the particle node
	var _ball_explosion = self.get_node("BallExplosion")
	
	# Slow down the game by half its current speed
	Engine.time_scale = 0.5
	
	# Set the particle node position to the ball's position
	_ball_explosion.global_position = ball_position
	
	# Set the direction of the particles to a direction depending on where the ball was
	_ball_explosion.direction.x = direction
	
	# Start emitting the particles
	_ball_explosion.emitting = true
	
	# Camera stuff
	_apply_shake()


# Update the score and display on screen depending on who scored
func _update_score(current_last_scorer):
	
	# Increment the player score by one if the player last scored
	if current_last_scorer == "Player":
		
		#increment the _player_score by one
		_player_score+=1
		
		# Update the player score text on screen
		_player_score_text.text = str(_player_score) 
		
	# Increment the cpu score by one if the cpu last scored
	elif current_last_scorer == "CPU":
		
		#increment the _cpu_score by one
		_cpu_score+=1
		
		# Update the cpu score text on screen
		_cpu_score_text.text = str(_cpu_score) 


# Checks if either the player or cpu has won and changes the scene if true
func _end_game(current_last_scorer):
	
	# Checks if the cpu last scored
	if current_last_scorer == "CPU":
		
		# Checks if the _cpu_score is the same as the _score_to_win
		#if _cpu_score == _score_to_win:
		if _cpu_score == GameData.score_to_win:
			
			# Changes to the game over scene
			_change_to_game_over_screen_scene()
	
	# Checks if the player last scored
	elif current_last_scorer == "Player":
		
		# Checks if the _player_score is the same as the _score_to_win
		#if _player_score == _score_to_win:
		if _player_score == GameData.score_to_win:
			# Changes to the game over scene
			_change_to_game_over_screen_scene()


# Resets the games speed, resets the ball,play and cpu positions and checks to see if the game is over
func _on_game_speed_timer_timeout():
	
	#  Resets the games speed
	Engine.time_scale = 1
	
	# Handles what happens if the game is over
	_end_game(last_scorer)
	
	# Reset the ball, player and cpu positions for the next round
	_ball.start_ball()
	_player.center_player()
	_cpu.center_cpu()
	


# Handles changing the scene to the game over scene
func _change_to_game_over_screen_scene():
	
	# Stores the last_scorer as the winner in the winner variable in the GameData script
	GameData.winner = last_scorer
	
	# Load and start the game over scene
	var _game_over_screen_scene = ResourceLoader.load("res://scenes/game_over_screen.tscn").instantiate()
	
	# End the game scene
	_game.queue_free()
	
	# Change to the game over scene
	get_tree().root.add_child(_game_over_screen_scene)


# Camera stuff
func _apply_shake():
	_shake_strength = _random_strength	


# Camera stuff
func _random_offset() -> Vector2:
	return Vector2(_rng.randf_range(-_shake_strength, _shake_strength), _rng.randf_range(-_shake_strength, _shake_strength))
