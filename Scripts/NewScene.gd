extends Node2D

export (bool) var is_top_down := true

onready var player := get_node("Characters/%s" % global.current_player_name)
onready var UI := player.get_node("Camera2D/UI")

# Set up the scene
func _ready() -> void:
	# Reset the reference to camera for the MSG_Parser 
	MSG.camera = get_node('Characters/%s/Camera2D' % global.current_player_name)
	
	# Set global reference variables
	global.set_current_scene(self.name)
	
	# Disable the tint momentarily
	#$BG/Map/CanvasModulate/AnimationPlayer.play_backwards("set_tint")
	
	# Fade in the scene
	$Transition.visible = true
	$Transition.fade_out()
	
	# Start emitting particles
	if $Effects.has_node("Particles"): 
		$Effects/Particles.emit_all()
	
	# Play the level's theme
	#GlobalMusicPlayer.set_music("res://assets/music/slow_low.ogg")
	
	# SAVE DATA HANDLING HERE
	# Usually will set up story stuff based on the save data
	var save_data = global.get_save_data()
	if save_data.has(self.name):
		print("Loading from save")
		
		if save_data[self.name].has("dialogue_finished"):
			if save_data[self.name]["dialogue_finished"]:
				global.set_can_talk(true)
		else:
			global.set_can_talk(true)
	
		# Set the position of the player according to the last time 
		# the player was in this scene
		if save_data[self.name].has("exit_point"):
			# Set x and y separately because Vector2 is a Godot thing, not a JSON thing
			player.global_position.x = save_data[self.name]["exit_point"]["position_x"]
			player.global_position.y = save_data[self.name]["exit_point"]["position_y"]
			# Disable the exit node the player used previously
			get_node(save_data[self.name]["exit_point"]["exit_node"]).monitoring = false
			yield(get_tree().create_timer(2.5), "timeout")
			get_node(save_data[self.name]["exit_point"]["exit_node"]).monitoring = true
	else: 
		print("Creating new save entry for this level")
		# Update save data and autosave
		UI.popup_element("SaveIndicator", 3)
		global.set_save_data("global", {
			"current_scene": self.filename
		})
		# Create the save entry for the level
		global.set_save_data(self.name, {})
		# Stuff to do
		global.set_can_talk(true)
		if player.interaction_script:
			player.talk()

# Method for other nodes to use
# Fade to black and freeze player input and movement
func change_scene(scene: String, time:=1.5, delay_between_scenes:=1.0) -> void:
	global.set_can_talk(false)
	$Transition.fade_in(time)
	yield(get_tree().create_timer(time+delay_between_scenes), "timeout")
	get_tree().change_scene(scene)
