extends HSlider

export var bus_name:String

var bus_index:int

func _ready(): 
	bus_index = AudioServer.get_bus_index(bus_name)

func _on_VSlider_value_changed(value):
	AudioServer.set_bus_volume_db(bus_index,linear2db(value))
