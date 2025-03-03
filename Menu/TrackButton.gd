extends Button

export var Song:int #Music id

onready var menu_effects = $"../../../../../../../../../../../../MenuEffects"
onready var focus_outline = $"../../../../../Node2D"
onready var node_2d = $"../../../../../../../../../../../.."


func _ready(): #Connects signals
	focus_neighbour_left = "."
	focus_neighbour_right = "."
	connect("pressed",self,"play_track")
	connect("focus_entered",self,"focus_entered",[],1)

func focus_entered(): #Playes animation
	Music.create_sound(2,-5)
	menu_effects.interpolate_property(focus_outline,"global_position",null,get_parent().get_parent().get_parent().get_parent().get_parent().get_focus_owner().rect_global_position,0.2,Tween.TRANS_CUBIC,Tween.EASE_OUT)
	menu_effects.start()

func play_track(): #Play track when pressed. If tracks is playing already, play random music
	node_2d.selected_track = self
	if Music.music_state == Music.MusicStates.Selected and Music.music_player.stream == load(Music.MusicPaths[Song]):
		Music.music_state = Music.MusicStates.Random
		Music.play_music(1)
		pressed = false
	else:
		Music.music_state = Music.MusicStates.Selected
		Music.play_music(self)
