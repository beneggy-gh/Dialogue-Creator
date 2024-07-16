@tool
extends EditorPlugin

const main = preload("res://addons/dialogue_creator/main.tscn")
var main_instance

const PLUGIN_ICON_PATH := "res://addons/dialogue_creator/icon.svg"

func _enter_tree():
	main_instance = main.instantiate()
	EditorInterface.get_editor_main_screen().add_child(main_instance)
	_make_visible(true)


func _exit_tree():
	if main_instance:
		main_instance.queue_free()


func _has_main_screen():
	return true


func _make_visible(visible):
	if main_instance:
		main_instance.visible = visible


func _get_plugin_name():
	return "Dialogue Creator"


func _get_plugin_icon():
	return load(PLUGIN_ICON_PATH)
