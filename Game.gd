extends Node2D



export var Song:int #Music id
export var SwayWaitTime:float = 4.0 #Time before Moveableobject sways
export var GamePath:String #Path to game shortcut
export var MoveableObject:NodePath #Object to sway

var start_game = true #If true opens game, if false returns to game selection

onready var moveable_object = get_node(MoveableObject)
onready var animation = $AnimationPlayer
onready var loading_screen = $OpeningCamera/AnimationPlayer
onready var sway = $Sway


func _input(event):
	if Input.is_action_just_pressed("Back") or Input.is_action_just_pressed("ui_focus_prev"): #Returns to game selection
		Music.fade_music(-30)
		loading_screen.play("CLOSE")
		start_game = false
	
	if Input.is_action_just_pressed("ui_accept"): #Plays closing animation to open game
		Music.fade_music(-30)
		loading_screen.play("CLOSE")
	
	if Input.is_action_just_pressed("Mute"):
		Music.mute()

func _ready(): #If there is an object to sway, starts a timer
	if MoveableObject!= null:
		var sway_timer = Timer.new()
		sway_timer.wait_time = SwayWaitTime
		sway_timer.autostart = true
		sway_timer.connect("timeout",self,"sway_timer_timeout")
		sway_timer.connect("timeout",sway_timer,"queue_free")
		add_child(sway_timer)
		
		sway.target = moveable_object
		sway.set_physics_process(false)
		
func start(): #Plays music. If the music state in the game selection was Selected, now it is random
	Music.music_state = Music.MusicStates.GameBased
	Music.fade_music(0)
	Music.play_music(Song)
	animation.play("OPEN")

func exit(): #Either opens game or returns to game selection
	if start_game == true:
		OS.execute("CMD.exe",["/C", GamePath],false)
		get_tree().quit()
	else:
		get_tree().change_scene("res://Launcher.tscn")

func sway_timer_timeout(): #Moves moveable object
	if MoveableObject!=null:
		sway.target_initial_pos = sway.target.global_position
		sway.set_physics_process(true)
		sway.apply_noise_sway()


func mgv_shine(): #Only used by MgsvGame to shine title
	get_node("AnimationPlayer2").play("SHINE")

func ground_zeroes_lightning(): #Only used by MgsGz for lightning
	animation.play("LIGHTNING")
	get_node("LightningTimer").wait_time = rand_range(5.0,10.0)
	get_node("LightningTimer").start()
