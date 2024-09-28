extends HSlider

@onready var _music_slider: HSlider = $"."
@export var _bus_name: String
var _bus_index: int


# Called when the node enters the scene tree for the first time.
func _ready():
	
	# Get the current value of the background music volume and apply it to the music slider
	_bus_index = AudioServer.get_bus_index(_bus_name)
	_music_slider.value = db_to_linear(AudioServer.get_bus_volume_db(_bus_index))


func _on_value_changed(_value):
	
	# Set the volume of the background music based on the music slider
	AudioServer.set_bus_volume_db(_bus_index, linear_to_db(_value))
