extends Button

export var path:String

func _ready():
	connect("focus_entered",get_parent().get_parent(),"focus_on_selected_game",[get_parent()])
