extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
signal fade_out_finished_signal

# Plays the fade in animation
func fade_in() -> void:
	animation_player.play("fade_in")

# Plays the fade out animation
func fade_out() -> void:
	animation_player.play("fade_out")

# Handle what to do after an animation is finished
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	
	# If the animation that just finished was the fade_out animation emit a signal
	if anim_name == "fade_out":
		emit_signal("fade_out_finished_signal")
