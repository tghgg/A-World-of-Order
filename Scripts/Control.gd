extends CanvasLayer

onready var settings := $Settings

func _ready() -> void:
	# Setup the menu buttons automatically
	#settings.get_node("Popup/NinePatchRect/VBoxContainer/Guide").connect("pressed", self, "_on_Quit_pressed")
	settings.get_node("Popup/NinePatchRect/VBoxContainer/Quit").connect("pressed", self, "_on_Quit_pressed")

func popup_element(menu: String, time_until_hidden:= 0) -> void:
	get_node("%s/Popup" % menu).popup()
	if time_until_hidden != 0:
		yield(get_tree().create_timer(time_until_hidden), "timeout")
		get_node("%s/Popup" % menu).hide()

func hide_element(menu: String) -> void:
	get_node("%s/Popup" % menu).hide()

# Hide the settings menu and unfreeze player movement
# Quit to Title
func _on_Quit_pressed() -> void:
	settings.get_node("Popup").hide()
	global.set_can_talk(false)
	get_node("../../../../Transition").fade_in(1.0)
	yield(get_tree().create_timer(1.0), "timeout")
	get_tree().change_scene("res://src/Scenes/Jam/Day1/Title.tscn")
