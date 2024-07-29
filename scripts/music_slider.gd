extends HSlider

@onready var _music_slider = $"."
@export var _bus_name: String
var _bus_index: int


# Called when the node enters the scene tree for the first time.
func _ready():
	_bus_index = AudioServer.get_bus_index(_bus_name)
	_music_slider.value =  db_to_linear(AudioServer.get_bus_volume_db(_bus_index))


func _on_value_changed(value):
	AudioServer.set_bus_volume_db(_bus_index, linear_to_db(value))
