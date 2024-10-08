extends Node

var _player_score: int = 0
var _cpu_score:int = 0
var last_scorer: String
var _ball_movement_timer: Timer

@onready var _ball: CharacterBody2D = %Ball
@onready var _player_score_text: Label = $PlayerScore
@onready var _cpu_score_text: Label = $CPUScore
@onready var _game: Node2D = $".."
@onready var _timer_label: Label = $TimerLabel
@onready var _player: StaticBody2D = %Player
@onready var _cpu: StaticBody2D = %CPU
@onready var _game_speed_timer: Timer = $GameSpeedTimer
@onready var pause_screen: ColorRect = $PauseScreen

@onready var _ball_explosion_camera: Camera2D = $BallExplosionCamera

@onready var _ball_explosion_sound: AudioStreamPlayer2D = $BallExplosionSound

# Camera stuff
var _random_strength: float = 30.0
var shake_fade: float = 5.0
var _rng = RandomNumberGenerator.new()
var _shake_strength: float = 0.0


# Called when the node enters the scene tree for the first time.
func _ready():
	
	# Removes particles effect decoration from game scene
	FX.detach_particles()
	
	# Get the ball movement timer
	_ball_movement_timer = _ball.get_node("BallMovementTimer")
	
	# Loads scripts based on game mode for second paddle
	if GameData.single_player_mode == true:
		
		_cpu.set_script(load("res://scripts/cpu.gd"))
	else:
		
		_cpu.set_script(load("res://scripts/player2.gd"))


# Checks for any inputs
func _input(event):
	
	# Check if the input was the pause key
	if event.is_action_pressed("pause"):
		
		# Create a filter effect for the background song
		var _effect: AudioEffect = AudioEffectFilter.new()
		
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
	_explode_ball(body.position, 1)
	
	# Start the timer that determines when the game will go back to its original speed
	_game_speed_timer.start()


func _on_behind_cpu_body_entered(body):
	
	# Sets the last scorer to player
	last_scorer = "Player"
	
	# Updates the score based on the last_scorer
	_update_score(last_scorer)
	
	# Handles vfx based on the ball position and the number entered
	# -1 tells the function to emit the particles to the right
	_explode_ball(body.position, -1)
	
	# Start the timer that determines when the game will go back to its original speed
	_game_speed_timer.start()


# Emits particles at the position of the ball when a point is scored and in a direction depending on where the ball was
func _explode_ball(ball_position, direction):
	
	# Play the ball explosion sfx
	_ball_explosion_sound.play()
	
	# Get the particle node
	var _ball_explosion: CPUParticles2D = self.get_node("BallExplosion")
	
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
	
	if current_last_scorer == "CPU" and _cpu_score == GameData.score_to_win:
		
		# Play the fade out animation
		SceneTransition.fade_out()
		
		# Connects the fade_out_finished_signal from the singleton SceneTransition to _on_fade_out_finished
		# This allows me to know when the fade out scene transition is over
		SceneTransition.connect("fade_out_finished_signal", Callable(self, "_on_fade_out_finished"))
		
		# Game is over
		return true 
		
	elif current_last_scorer == "Player" and _player_score == GameData.score_to_win:
		
		# Play the fade out animation
		SceneTransition.fade_out()
		
		# Connects the fade_out_finished_signal from the singleton SceneTransition to _on_fade_out_finished
		# This allows me to know when the fade out scene transition is over
		SceneTransition.connect("fade_out_finished_signal", Callable(self, "_on_fade_out_finished"))
		
		 # Game is over
		return true
		
	# Game is not over, continue with the next round
	return false 


# Resets the games speed, resets the ball,play and cpu positions and checks to see if the game is over
func _on_game_speed_timer_timeout():
	
	#  Resets the games speed
	Engine.time_scale = 1
	
	# Handles what happens if the game is not over
	if _end_game(last_scorer) == false:
		# Reset the ball, player and cpu positions for the next round
		_ball.start_ball()
		_player.center_player()
		_cpu.center_player()
	


# Handles changing the scene to the game over scene
func _change_to_game_over_screen_scene():
	
	# Stores the last_scorer as the winner in the winner variable in the GameData script
	GameData.winner = last_scorer
	
	# Load and start the game over scene
	var _game_over_screen_scene: ColorRect = ResourceLoader.load("res://scenes/game_over_screen.tscn").instantiate()
	
	# End the game scene
	_game.queue_free()
	
	# Add back decoration particles
	FX.reattach_particles()
	
	# Change to the game over scene
	get_tree().root.add_child(_game_over_screen_scene)


# Camera stuff
func _apply_shake():
	_shake_strength = _random_strength	


# Camera stuff
func _random_offset() -> Vector2:
	return Vector2(_rng.randf_range(-_shake_strength, _shake_strength), _rng.randf_range(-_shake_strength, _shake_strength))


func _on_fade_out_finished():
	
	# Change to the game over scene after fade out animation
	_change_to_game_over_screen_scene()
