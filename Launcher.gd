extends Node2D

enum MenuStates { #Used to identify which button is opened in the menu
	MenuClosed,
	MenuOpen,
	Options,
	Cassettes,
	Navigation,
}

export var TracksGroup:ButtonGroup #Group of all soundtrack buttons. Used to identify the playing track
export var GamesGroup:ButtonGroup #Group of all game buttons

var menu_state = MenuStates.MenuClosed

var open_game = true #If true, the selected_game launches on exit().If false, the launcher closes

var selected_game #The focused game
var selected_menu_button #The last pressed menu button
var selected_track #The playing track

var path #Path to a game scene
var old_positions = {} #Polygon texture offset when a game is not focused anymore
var old_scales = {} #Polygon scale when a game is not focused anymore

onready var games = GamesGroup.get_buttons()

onready var loading_screen = $OpeningCamera/AnimationPlayer
onready var menu_animations = $Menu/AnimationPlayer

onready var mgs3 = $MGS3/Button
onready var mgspw = $MGSPW/Button
onready var mgsv = $MGSV/Button
onready var mgsgz = $MGSGZ/Button
onready var mgs2 = $MGS2/Button
onready var mg = $MG/Button
onready var mgs4 = $MGS4/Button
onready var mgs1 = $MGS1/Button

onready var game_effects = $GameEffects
onready var menu_effects = $MenuEffects
onready var vignette = $Vignette
onready var sway = $Sway
onready var blur = $Blur

onready var camera_anchor_point_1 = $CameraAnchorPoint1
onready var camera_anchor_point_2 = $CameraAnchorPoint2
onready var main_camera = $MainCamera

onready var menu = $Menu
onready var menu_button_outline = $Menu/Control/Node2D
onready var options_button = $Menu/Control/VBoxContainer/OptionsButton
onready var options = $Menu/Control/Panel/TextureRect3/Options
onready var cassettes_button = $Menu/Control/VBoxContainer/CassettesButton
onready var cassette_tapes = $Menu/Control/Panel/TextureRect3/CassetteTapes
onready var navigation_button = $Menu/Control/VBoxContainer/NavigationButton
onready var navigation = $Menu/Control/Panel/TextureRect3/Navigation
onready var exit_button = $Menu/Control/VBoxContainer/ExitButton



func start(): #Play random music and set selected_game
	Music.fade_music(0)
	Music.music_state = Music.MusicStates.Random
	Music.play_music(1)
	
	selected_game = mgs3.get_parent()
	mgs3.grab_focus()

func focus_on_selected_game(game): #Sets selected_game when focused
	selected_game = game
	sway.game = selected_game

func _ready(): #Set the selected menu, track buttons and old positions and scales
	sway.set_physics_process(false)
	randomize()
	
	for game in games:
		old_positions[game.get_parent().name] = game.get_parent().texture_offset
		old_scales[game.get_parent().name] = game.get_parent().texture_scale

	selected_menu_button = options_button
	selected_track = cassette_tapes.get_node("Panel/HBoxContainer/Panel/ScrollContainer/VBoxContainer/MGS3")
	
func _on_game_focus_entered(): #Plays animations for the focused game and starts sway timer
	for node in get_tree().get_nodes_in_group("EffectTimers"):
		node.queue_free()
	var game_focus_effect = Timer.new()
	game_focus_effect.add_to_group("EffectTimers")
	game_focus_effect.wait_time = 2.5
	game_focus_effect.connect("timeout",self,"focus_effect")
	game_focus_effect.connect("timeout",game_focus_effect,"queue_free")
	game_focus_effect.autostart = true
	add_child(game_focus_effect)
	
	main_camera.current = true
	Music.create_sound(1,-20)
	
	game_effects.interpolate_property(vignette,"modulate",null,selected_game.get_node("Polygon").color,0.6,Tween.TRANS_EXPO,Tween.EASE_OUT)
	game_effects.interpolate_property(main_camera,"global_position",null,selected_game.get_node("Position2D").global_position,0.5,Tween.TRANS_EXPO,Tween.EASE_OUT)
	game_effects.interpolate_property(main_camera,"zoom",null,Vector2(0.8,0.8),0.5,Tween.TRANS_EXPO,Tween.EASE_OUT)
	game_effects.interpolate_property(selected_game,"texture_scale",null,Vector2(selected_game.texture_scale.x / 1.1,selected_game.texture_scale.y /1.1),0.6,Tween.TRANS_EXPO,Tween.EASE_OUT)
	game_effects.interpolate_property(selected_game,"self_modulate",null,Color(1,1,1,1),0.6,Tween.TRANS_EXPO,Tween.EASE_OUT)
	game_effects.interpolate_property(selected_game.get_node("Polygon"),"modulate",null,Color(1,1,1,1),0.6,Tween.TRANS_EXPO,Tween.EASE_OUT)
	game_effects.start()
	
	selected_game.z_index = 1
	selected_game.get_node("Polygon").z_index = 4
	selected_game.get_node("Title/AnimationPlayer").play("SLIDE")

func focus_effect(): #Uses blur shader and sway at timer timeout
	sway.set_physics_process(true)
	sway.apply_noise_sway(0.2,20)
	game_effects.interpolate_property(blur.get_material(),"shader_param/lod",null,1.6,0.4,Tween.TRANS_EXPO,Tween.EASE_OUT)
	game_effects.start()

func _on_game_focus_exited(): #Reverts the focused animation
	sway.set_physics_process(false)
	game_effects.interpolate_property(selected_game,"texture_offset",null,old_positions[selected_game.name],0.6,Tween.TRANS_BACK,Tween.EASE_OUT)
	game_effects.interpolate_property(selected_game,"self_modulate",null,Color(0.5,0.5,0.5,1),0.6,Tween.TRANS_EXPO,Tween.EASE_OUT)
	game_effects.interpolate_property(selected_game,"texture_scale",null,old_scales[selected_game.name],0.6,Tween.TRANS_BACK,Tween.EASE_OUT)
	game_effects.interpolate_property(selected_game.get_node("Polygon"),"modulate",null,Color(0,0,0,1),0.6,Tween.TRANS_EXPO,Tween.EASE_OUT)
	game_effects.interpolate_property(blur.get_material(),"shader_param/lod",null,0.7,0.6,Tween.TRANS_EXPO,Tween.EASE_OUT)
	game_effects.start()
	
	selected_game.z_index = 0
	selected_game.get_node("Polygon").z_index = 0
	selected_game.get_node("Title/AnimationPlayer").play_backwards("SLIDE")

func _on_game_selected(): #Plays the closing animation
	path = selected_game.get_node("Button").path
	open_game = true
	loading_screen.play("CLOSE")
	Music.fade_music(-30)

func exit(): #Opens the selected_game. Called at the end of closing animation
	if open_game == true:
		get_tree().change_scene(path)
		queue_free()
	else:
		get_tree().quit()

func _input(event):
	if Input.is_action_just_pressed("Mute"): #Mutes sound
		Music.mute()

	if Input.is_action_just_pressed("Quit"): #Quits game
		open_game = false
		loading_screen.play("CLOSE")

	if Input.is_action_just_pressed("ChangeMusic"): #Plays a random track or the next selected track
		if Music.music_state == Music.MusicStates.Random:
			Music.play_music(1)
		else:
			TracksGroup.get_pressed_button().get_node(TracksGroup.get_pressed_button().focus_neighbour_bottom).pressed = true
			TracksGroup.get_pressed_button().emit_signal("pressed")
	
	if Input.is_action_just_pressed("Options"): #Handles the menu states
		use_menu()

func use_menu(): #Either opens the menu, closes it, or return from a menu option
	var centres = [camera_anchor_point_1,camera_anchor_point_2]
	var closest_centre = 1000.0
	var camera_position = camera_anchor_point_1.global_position
	for point in centres:
		var distance_from_point = main_camera.global_position.distance_to(point.global_position)
		if closest_centre > distance_from_point:
			closest_centre = distance_from_point
			camera_position = point

	if menu_state == MenuStates.MenuClosed:
		Music.create_sound(3,-10)
		menu_effects.interpolate_property(main_camera,"global_position",null,camera_position.global_position,0.3,Tween.TRANS_CUBIC,Tween.EASE_OUT)
		
		if camera_position == camera_anchor_point_1:
			menu.global_position = Vector2(0,0)
		else:
			menu.global_position = Vector2(650,0)
			
	elif menu_state == MenuStates.MenuOpen:
		Music.create_sound(4,5)
		menu_animations.play("MenuClose")
		menu_effects.interpolate_property(main_camera,"zoom",null,Vector2(0.8,0.8),0.3,Tween.TRANS_CUBIC,Tween.EASE_IN)
	else:
		menu_animations.play_backwards("MenuChangeBackwards")
		Music.create_sound(4,5)
		return
	menu_effects.connect("tween_completed",self,"menu_zoom_finished",[],4)
	menu_effects.start()


func menu_zoom_finished(object, key): #Starts opening animation after the camera unzooms
	if menu_state == MenuStates.MenuClosed:
		menu_state = MenuStates.MenuOpen
		menu_animations.play("Menu")
		menu_effects.interpolate_property(main_camera,"zoom",null,Vector2(1,1),0.8,Tween.TRANS_CUBIC)
	elif menu_state == MenuStates.MenuOpen:
		menu_state = MenuStates.MenuClosed
		selected_game.get_node("Button").grab_focus()
		menu_effects.interpolate_property(main_camera,"global_position",null,selected_game.get_node("Position2D").global_position,0.3,Tween.TRANS_CUBIC)
	else:
		return
	menu_effects.start()

func on_menu_animation_finished(): #Opens menu
	match menu_state:
		MenuStates.Cassettes:
			cassette_tapes.hide()
		MenuStates.Navigation:
			navigation.hide()
		MenuStates.Options:
			options.hide()
	menu_state = MenuStates.MenuOpen
	selected_menu_button.grab_focus()

func menu_button_focus_entered(): #Plays animation for focused menu button
	selected_menu_button = menu.get_node("Control/VBoxContainer").get_focus_owner()
	Music.create_sound(2,-5)
	menu_effects.interpolate_property(selected_menu_button,"rect_size:x",200,250,0.3,Tween.TRANS_CUBIC,Tween.EASE_OUT)
	menu_effects.interpolate_property(menu_button_outline,"global_position",null,selected_menu_button.rect_global_position,0.2,Tween.TRANS_CUBIC,Tween.EASE_OUT)
	menu_effects.start()

func menu_button_focus_exited(): #Reverts animation for unfocused menu button
	menu_effects.interpolate_property(selected_menu_button,"rect_size:x",250,200,0.3,Tween.TRANS_CUBIC,Tween.EASE_OUT)
	menu_effects.start()

func  menu_close(): #Called when the menu close animation playes
	menu_effects.interpolate_property(menu_button_outline,"global_position:x",null,-250,0.2,Tween.TRANS_CUBIC,Tween.EASE_OUT)
	menu_effects.start()


func exit_button_pressed(): #Starts a timer to close the launcher when button is pressed
	Music.create_sound(1,-20)
	Music.fade_music(-30)
	open_game = false
	menu_animations.play("MenuClose")
	exit_button.get_node("ExitTimer").start()

func exit_timer_timeout(): #Closes the launcher
	loading_screen.play("CLOSE")

func navigation_button_pressed(): #Opens the navigation menu
	Music.create_sound(1,-20)
	menu_state = MenuStates.Navigation
	navigation.show()
	menu_animations.play("MenuChange")
	navigation.get_node("Panel/Button").grab_focus() 

func options_button_pressed(): #Opens the options
	Music.create_sound(1,-20)
	menu_state = MenuStates.Options
	options.show()
	menu_animations.play("MenuChange")
	var slider = options.get_node("Panel/Control/HBoxContainer/VBoxContainer/Buttons/ScrollContainer/VBoxContainer/Volume/Button3/VSlider")
	slider.grab_focus()

func options_sliders_focus_entered(): #Plays animation for sliders when focused
	var options_buttons_outline = $Menu/Control/Panel/TextureRect3/Options/Panel/Control/HBoxContainer/VBoxContainer/Buttons/ScrollContainer/VBoxContainer/Node2D
	menu_effects.interpolate_property(options_buttons_outline,"global_position",null,options.get_focus_owner().get_parent().rect_global_position,0.2,Tween.TRANS_CUBIC,Tween.EASE_OUT)
	menu_effects.start()
	Music.create_sound(2,-5)

func produce_slider_sound(value_changed): 
	Music.create_sound(2,-5)

func cassettes_button_pressed(): #Opens the cassetes menu
	Music.create_sound(1,-20)
	menu_state = MenuStates.Cassettes
	cassette_tapes.show()
	selected_track.grab_focus()
	menu_animations.play("MenuChange")
	cassette_tapes.get_node("Panel/HBoxContainer/Panel/ScrollContainer").ensure_control_visible(cassette_tapes.get_node("Panel/HBoxContainer/Panel/ScrollContainer/VBoxContainer/MGS3"))
