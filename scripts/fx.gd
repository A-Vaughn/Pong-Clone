extends Node

@onready var _gpu_particles_2d: GPUParticles2D = $GPUParticles2D

# Removes particles and stores them in memory
func detach_particles():
	
	FX.remove_child(_gpu_particles_2d)


# Adds particles to the scene from memory and does fade in effect
func reattach_particles():
	
	FX.add_child(_gpu_particles_2d)
	SceneTransition.fade_in()
