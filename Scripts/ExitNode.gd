extends Area2D

export (String, FILE) var exit_scene

export (String, FILE) var interaction_script

# Connect signals 
func _ready() -> void:
	self.connect("body_entered", self, "_on_body_entered")

# Dialogue handler
func talk() -> void:
#	print("talking to " + self.name)
	if interaction_script:
		global.set_can_talk(false)
		MSG.start_dialogue(interaction_script, self)
	else:
		print("No dialogue found for the player")

# Exit function
func _on_body_entered(body: PhysicsBody2D) -> void:
	if body as KinematicBody2D and body.name == global.current_player_name:
		var current_root := body.get_parent().get_parent()
		# Track the exit points in the save file
		global.append_save_data(current_root.name, "exit_point", {
			"position_x": body.position.x,
			"position_y": body.position.y,
			"exit_node": self.get_path()
		})
		# Start an exit dialogue if specified
		if interaction_script:
			talk()
			yield(global, "dialogue_finished")
		current_root.change_scene(exit_scene)
