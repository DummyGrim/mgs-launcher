extends Button

export var TrackGroup:NodePath #Reference of tracks from this group

var selecting = false #Determines if a track is playing already

onready var track_group = get_node(TrackGroup)
onready var menu_effects = $"../../../../../../../../../../../MenuEffects"
onready var focus_outline = $"../../../../Node2D"

func _ready(): #Connects signals
	connect("focus_entered",self,"focus_entered",[],1)
	connect("focus_exited",self,"focus_exited",[],1)
	connect("button_down",self,"button_pressed")

func button_pressed(): #Uses tracks reference to grab focus
	track_group.grab_focus()
	selecting = true
func focus_entered(): #Plays animation and shows the tracks
	Music.create_sound(2,-5)
	menu_effects.interpolate_property(focus_outline,"global_position",null,get_parent().get_parent().get_parent().get_parent().get_parent().get_focus_owner().rect_global_position,0.2,Tween.TRANS_CUBIC,Tween.EASE_OUT)
	menu_effects.start()
	track_group.get_parent().get_parent().get_parent().show()
	
func focus_exited(): #Hides tracks, unless pressed
	if not track_group.get_parent().get_parent().get_parent().get_parent().get_focus_owner() == track_group:
		track_group.get_parent().get_parent().get_parent().hide()
