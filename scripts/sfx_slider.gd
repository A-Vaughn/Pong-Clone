extends HSlider

@onready var _sfx_slider: HSlider = $"."
@export var _bus_name: String
var _bus_index: int


# Called when the node enters the scene tree for the first time.
func _ready():
	
	# Get the current value of the sfx volume and apply it to the sfx slider
	_bus_index = AudioServer.get_bus_index(_bus_name)
	_sfx_slider.value =  db_to_linear(AudioServer.get_bus_volume_db(_bus_index))

func _on_value_changed(_value):
	
	# Set the volume of the sfx based on the sfx slider
	AudioServer.set_bus_volume_db(_bus_index, linear_to_db(_value))
