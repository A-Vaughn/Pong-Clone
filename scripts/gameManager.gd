extends Node

var playerScore
var cpuScore
var lastScorer
var scoreToWin
var timer

@onready var behind_player = $BehindPlayer
@onready var behind_cpu = $BehindCPU
@onready var ball = %Ball
@onready var player_score_text = $PlayerScore
@onready var cpu_score_text = $CPUscore
@onready var game = $".."
@onready var timer_label = $TimerLabel
@onready var player = %Player
@onready var game_speed_timer = $GameSpeedTimer

@onready var ball_explosion_camera = $BallExplosionCamera

var deltaTime
var randomStrength: float = 30.0
var shakeFade: float = 5.0
 
var rng = RandomNumberGenerator.new()
var shake_strength: float = 0.0

var doShake


# Called when the node enters the scene tree for the first time.
func _ready():
	#Engine.time_scale = 0.5
	playerScore = 0
	cpuScore = 0
	lastScorer = null
	scoreToWin = 3
	
	timer = ball.get_node("Timer")


func _process(delta):
	#deltaTime = delta
	timer_label.text = str(int(timer.time_left)+1)
	
	#if doShake == true:
		#applyShake()
	if shake_strength>0:
		shake_strength = lerpf(shake_strength, 0, shakeFade * delta)
		ball_explosion_camera.offset = randomOffset()
	


func explodeBall(ballPosition, direction):
	
	
	var ballExplosion = self.get_node("BallExplosion")
	#print(self)
	#print(ballExplosion)
	#testParticle.gravity = -980
	ballExplosion.global_position = ballPosition
	#ballExplosion.global_position.x += 
	ballExplosion.direction.x = direction
	ballExplosion.emitting = true
	doShake = true

	applyShake()
	#if shake_strength>0:
		#shake_strength = lerpf(shake_strength, 0, shakeFade * deltaTime)
		#ball_explosion_camera.offset = randomOffset()
	

func _on_behind_player_body_entered(body):
		lastScorer = "CPU"
		updateScore(lastScorer, ball)
		explodeBall(body.position, -1)
		Engine.time_scale = 0.5
		game_speed_timer.start()
	
	#game_speed_timer.start()
	#lastScorer = "CPU"
	#Engine.time_scale = 0.5
	#updateScore(lastScorer, body)
	
	##Engine.time_scale = 0.5
	#explodeBall(body.position)
	#lastScorer = "CPU"
	#cpuScore+=1
	#cpu_score_text.text = str(cpuScore) 
	#if cpuScore == scoreToWin:
		#GameData.winner = lastScorer
		#
		#var gameOverScene = ResourceLoader.load("res://scenes/gameOver.tscn").instantiate()
		#game.queue_free()
		#get_tree().root.add_child(gameOverScene)
	#else:
		##explodeBall(body.position)
		#body.startBall()
		#player.centerPlayer()


func _on_behind_cpu_body_entered(body):
		lastScorer = "Player"
		explodeBall(body.position, 1)
		updateScore(lastScorer, ball)
		Engine.time_scale = 0.5
		game_speed_timer.start()
	
	
	#game_speed_timer.start()
	#lastScorer = "Player"
	#Engine.time_scale = 0.5
	#updateScore(lastScorer, body)
	
	#lastScorer = "Player"
	#playerScore+=1
	#player_score_text.text = str(playerScore) 
	#if playerScore == scoreToWin:
		#GameData.winner = lastScorer
		#var gameOverScene = ResourceLoader.load("res://scenes/gameOver.tscn").instantiate()
		#game.queue_free()
		#get_tree().root.add_child(gameOverScene)
	#else:
		#body.startBall()
		#player.centerPlayer()
		
func _on_game_speed_timer_timeout():
	endGame(lastScorer)
	Engine.time_scale = 1
	ball.startBall()
	player.centerPlayer()
	#updateScore(lastScorer, ball)
	#doShake = false
	#ball_explosion_camera.offset = Vector2(0.0,0.0)
	
	
	
	
func updateScore(lastScorer, ball):
	if lastScorer == "Player":
		playerScore+=1
		player_score_text.text = str(playerScore) 
		#if playerScore == scoreToWin:
			#GameData.winner = lastScorer
			#var gameOverScene = ResourceLoader.load("res://scenes/gameOver.tscn").instantiate()
			#game.queue_free()
			#get_tree().root.add_child(gameOverScene)
		#else:
			#ball.startBall()
			#player.centerPlayer()
	elif lastScorer == "CPU":
		cpuScore+=1
		cpu_score_text.text = str(cpuScore) 
		#if cpuScore == scoreToWin:
			#GameData.winner = lastScorer
			#var gameOverScene = ResourceLoader.load("res://scenes/gameOver.tscn").instantiate()
			#game.queue_free()
			#get_tree().root.add_child(gameOverScene)
		#else:
			#ball.startBall()
			#player.centerPlayer()
			
			
			
func endGame(lastScorery):
	if lastScorer == "CPU":
		if cpuScore == scoreToWin:
			GameData.winner = lastScorer
			var gameOverScene = ResourceLoader.load("res://scenes/gameOver.tscn").instantiate()
			game.queue_free()
			get_tree().root.add_child(gameOverScene)
	elif lastScorer == "Player":
		if playerScore == scoreToWin:
			GameData.winner = lastScorer
			var gameOverScene = ResourceLoader.load("res://scenes/gameOver.tscn").instantiate()
			game.queue_free()
			get_tree().root.add_child(gameOverScene)
	
func applyShake():
	shake_strength = randomStrength
	
func randomOffset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))


