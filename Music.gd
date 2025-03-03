extends Node

enum MusicStates { #Determines if the music is selected or random
	Random
	Selected
	GameBased
}

var music_state = MusicStates.Random

var looping = false

var SFXPaths = { #Sound paths
	1:"res://SFX/Menu Sounds/Untitled song.mp3",
	2:"res://SFX/Menu Sounds/Audio Track-2.wav",
	3:"res://SFX/Menu Sounds/Audio Track-4.mp3",
	4:"res://SFX/Menu Sounds/Audio Track-5.wav",
}

var RandomPaths = { #Random tracks
	1:"res://Music/MGS3/MGS3 OST_ Surfing Guitar - Metal Gear Solid 3_ Snake Eater [ ezmp3.cc ].mp3",
	2:"res://Music/MGS3/mgs3-ost-cqc-metal-gear-solid-3-snake-eater.mp3",
	3:"res://Music/MGS3/mgs3-ost-on-the-ground-metal-gear-solid-3-sn.mp3",
	4:"res://Music/MGS3/Ocelot Youth.mp3",
	5:"res://Music/MGS3/Old Metal Gear.mp3",
	6:"res://Music/MGSPW/Metal Gear Solid Peace Walker OST (Mother Base Version 2) [ ezmp3.cc ].mp3",
	7:"res://Music/MGSPW/Metal Gear Solid_ Peace Walker OST Music - Entry Gate [ ezmp3.cc ].mp3",
	8:"res://Music/MGSPW/Metal Gear Solid_ Peace Walker OST Music - Clients [ ezmp3.cc ].mp3",
	9:"res://Music/MGS2/Metal Gear Solid 2 [Sons of Liberty] - Complete Soundtrack - 106 - Starboard [ ezmp3.cc ].mp3",
	10:"res://Music/MGS2/Metal Gear Solid 2 [Sons of Liberty] - Complete Soundtrack - 204 - Infiltration [ ezmp3.cc ].mp3",
	11:"res://Music/MGS2/Metal Gear Solid 2 [Sons of Liberty] - Complete Soundtrack - 314 - Prelude to the Denouement [ ezmp3.cc ].mp3",
	12:"res://Music/MGS2/metal-gear-solid-2-sons-of-liberty-complete.mp3",
	13:"res://Music/MGS/03-discovery.mp3",
	14:"res://Music/MGS/04 - Cavern [ ezmp3.cc ].mp3",
	15:"res://Music/MG/Zanzibar Breeze Integral.mp3",
}

var MusicPaths = { #Selected tracks
	1:"res://Music/MGS3/metal-gear-solid-3-snake-eater-theme-flac (1).mp3",
	2: "res://Music/MGS3/22 The World Needs Only One Big Boss.mp3",
	3: "res://Music/MGS3/24 Metal Gear Saga.mp3",
	4: "res://Music/MGS3/mgs3-ost-cqc-metal-gear-solid-3-snake-eater.mp3",
	5: "res://Music/MGS3/Ocelot Youth.mp3",
	6: "res://Music/MGS3/mgs3-ost-on-the-ground-metal-gear-solid-3-sn.mp3",
	7: "res://Music/MGS3/Virtuous Mission.mp3",
	8: "res://Music/MGS3/MGS3 OST_ Battle in the Base - Metal Gear Solid 3_ Snake Eater [ ezmp3.cc ].mp3",
	9: "res://Music/MGS3/21 Taking On The Shagohod.mp3",
	10: "res://Music/MGS3/MGS3 OST_ Last Showdown - Metal Gear Solid 3_ Snake Eater [ ezmp3.cc ].mp3",
	11:"res://Music/MGS3/Old Metal Gear.mp3",
	12:"res://Music/MGS3/MGS3 OST_ Surfing Guitar - Metal Gear Solid 3_ Snake Eater [ ezmp3.cc ].mp3",
	13:"res://Music/MGS3/35  Debriefing.mp3",
	14:"res://Music/MGS3/34 Ending theme.mp3",
	
	15:"res://Music/MGSPW/metal-gear-solid-peace-walker-main-theme-metal (1).mp3",
	16:"res://Music/MGSPW/25 Zero Allies!.mp3",
	17:"res://Music/MGSPW/Metal Gear Solid_ Peace Walker OST Music - Outer Heaven [ ezmp3.cc ].mp3",
	18:"res://Music/MGSPW/Metal Gear Solid Peace Walker OST (Mother Base Version 2) [ ezmp3.cc ].mp3",
	19:"res://Music/MGSPW/Metal Gear Solid_ Peace Walker OST Music - Clients [ ezmp3.cc ].mp3",
	20:"res://Music/MGSPW/Metal Gear Solid_ Peace Walker OST Music - Entry Gate [ ezmp3.cc ].mp3",
	21:"res://Music/MGSPW/2 Show Time.mp3",
	22:"res://Music/MGSPW/3 Confession.mp3",
	23:"res://Music/MGSPW/22 Koi no Yokushiryoku.mp3",
	24:"res://Music/MGSPW/31 Calling To The Night.mp3",
	25:"res://Music/MGSPW/Metal Gear Solid_ Peace Walker OST Music - HEAVENS DIVIDE [ ezmp3.cc ].mp3",
	
	26:"res://Music/MGSGZ/Ground Zeroes Theme.mp3",
	27:"res://Music/MGSGZ/Tactical Espionage Operations - Metal Gear Solid V_ Ground Zeroes [OST] [ ezmp3.cc ].mp3",
	
	28:"res://Music/MGSV/metal-gear-solid-v-t.p.p.midge-ure-the-ma (1).mp3",
	
	29:"res://Music/MG/Zanzibar Breeze Integral.mp3",
	30:"res://Music/MG/1 Zanzibar Breeze.mp3",
	31:"res://Music/MG/11 Level 1 Warning.mp3",
	32:"res://Music/MG/Advance Immediately - Metal Gear 2 (MSX) [ ezmp3.cc ].mp3",
	33:"res://Music/MG/Frequency 140.85 - Metal Gear 2 - (MSX) [ ezmp3.cc ].mp3",
	34:"res://Music/MG/The Front Line - Metal Gear 2 (MSX) [ ezmp3.cc ].mp3",
	35:"res://Music/MG/0 Theme Of Solid Snake.mp3",
	36:"res://Music/MG/Wavelet - Metal Gear 2 (MSX) [ ezmp3.cc ].mp3",
	37:"res://Music/MG/33 Tears.mp3",
	38:"res://Music/MG/Red Sun - Metal Gear 2 (MSX) [ ezmp3.cc ].mp3",
	
	39:"res://Music/MGS/01-metal-gear-solid-main-theme (1).mp3",
	40:"res://Music/MGS/02-introduction.mp3",
	41:"res://Music/MGS/03-discovery.mp3",
	42:"res://Music/MGS/04 - Cavern [ ezmp3.cc ].mp3",
	43:"res://Music/MGS/08 - Warhead Storage [ ezmp3.cc ].mp3",
	44:"res://Music/MGS/15 - Colosseo [ ezmp3.cc ].mp3",
	45:"res://Music/MGS/2 Duel.mp3",
	46:"res://Music/MGS/17 - Escape [ ezmp3.cc ].mp3",
	47:"res://Music/MGS/32 The Best Is Yet To Come.mp3",
	
	48:"res://Music/MGS2/metal-gear-solid-4-final-boss-second-phase-bgm (1).mp3",
	49:"res://Music/MGS2/metal-gear-solid-2-sons-of-liberty-complete.mp3",
	50:"res://Music/MGS2/Metal Gear Solid 2 [Sons of Liberty] - Complete Soundtrack - 204 - Infiltration [ ezmp3.cc ].mp3",
	51:"res://Music/MGS2/Metal Gear Solid 2 [Sons of Liberty] - Complete Soundtrack - 106 - Starboard [ ezmp3.cc ].mp3",
	52:"res://Music/MGS2/Metal Gear Solid 2 [Sons of Liberty] - Complete Soundtrack - 314 - Prelude to the Denouement [ ezmp3.cc ].mp3",
	53:"res://Music/MGS2/metal-gear-solid-2-sons-of-liberty-complete (1).mp3",
	54:"res://Music/MGS2/Metal Gear Solid 2 [Sons of Liberty] - Complete Soundtrack - 222 - Yell \'Dead Cell\' [ ezmp3.cc ].mp3",
	55:"res://Music/MGS2/23Metal Gear Solid Main Theme.mp3",
	
	56:"res://Music/MGS4/2 Encounter.mp3",
	
	57:"res://Music/MG/VR Training.mp3"
	
}

onready var random_track_cooldown = $RandomTrackCooldown
onready var music_player = $MusicPlayer
onready var music_effects = $MusicEffects

func _ready():
	randomize()

func mute():
	if AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")) == 0:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"),linear2db(0.001))
	else:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"),linear2db(1))

func play_music(track): #Either uses track to match a path or plays random music
	random_track_cooldown.stop()
	if music_player.is_connected("finished",self,"request_next"):
		music_player.disconnect("finished",self,"request_next")

	if music_state == MusicStates.Random:
		music_player.stream = load(RandomPaths[randi() % RandomPaths.size() + 1])
	elif music_state == MusicStates.Selected:
		music_player.stream = load(MusicPaths[track.Song])
	else:
		music_player.stream = load(MusicPaths[track])
	music_player.connect("finished",self,"request_next",[track])
	music_player.play()

func request_next(track): #Plays next or a random music
	if music_state == MusicStates.Random:
		random_track_cooldown.start()
	else:
		if music_state == MusicStates.Selected:
			play_music(track.get_node(track.focus_neighbour_bottom))
			track.get_node(track.focus_neighbour_bottom).pressed = true
		else:
			play_music(track + 1)

func create_sound(sound_number,volume):
	var new_sound = AudioStreamPlayer.new()
	new_sound.stream = load(SFXPaths[sound_number])
	new_sound.volume_db = volume
	add_child(new_sound)
	new_sound.connect("finished",new_sound,"queue_free")
	new_sound.play()
	new_sound.bus = "Sounds"

func fade_music(value):
	music_effects.interpolate_property(music_player,"volume_db",null,value,0.5,Tween.TRANS_LINEAR)
	music_effects.start()
