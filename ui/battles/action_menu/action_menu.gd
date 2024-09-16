class_name ActionMenu
extends Control

# --- Variables --- #
@export var tween_duration := 0.15
var origin: float

var tween: Tween

# --- Functions --- #
func _ready() -> void:
	origin = position.y
	
	hide_menu()

func toggle_menu() -> void:
	if mouse_filter == Control.MOUSE_FILTER_IGNORE:
		show_menu(true)
	else:
		hide_menu(true)

func show_menu(update_group := false) -> void:
	if update_group:
		for menu in get_tree().get_nodes_in_group(&'action_menu'):
			if menu != self:
				menu.hide_menu()
	
	if tween:
		tween.kill()
	tween = create_tween().set_parallel()
	
	mouse_filter = Control.MOUSE_FILTER_STOP
	show()
	tween.tween_property(self, 'modulate:a', 1.0, tween_duration)
	tween.tween_property(self, 'position:y', origin, tween_duration).from(origin + 8)

func hide_menu(update_group := false) -> void:
	if update_group:
		for menu in get_tree().get_nodes_in_group(&'action_menu'):
			if menu != self:
				menu.hide_menu()
	
	if tween:
		tween.kill()
	tween = create_tween().set_parallel()
	
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	tween.tween_property(self, 'modulate:a', 0.0, tween_duration)
	tween.tween_property(self, 'position:y', origin + 8, tween_duration)
	tween.finished.connect(hide)
