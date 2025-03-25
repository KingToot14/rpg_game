class_name ActionMenu
extends Control

# --- Variables --- #
@export var tween_duration := 0.15
var origin: float

var tween: Tween

# --- Functions --- #
func _ready() -> void:
	origin = position.y
	
	reload_items()
	hide_menu()

func reload_items() -> void:
	var item_count = 0
	
	for row in $'grid'.get_children():
		for child: ActionMenuItem in row.get_children():
			child.set_menu_item(child.item)
			if child.visible:
				item_count += 1
	
	$'backing'.size.y = 24 * (floor(item_count / 5.0) + 1) + 4
	$'backing'.position.y = 100 - $'backing'.size.y

func load_items(items) -> void:
	var index = 0
	var item_count = len(items)
	
	for row in $'grid'.get_children():
		var children = row.get_children()
		row.visible = index < item_count
		
		for child: ActionMenuItem in children:
			if index < item_count:
				child.set_menu_item(items[index])
			else:
				child.set_menu_item(null)
			
			index += 1
	
	$'backing'.size.y = 24 * (floor(item_count / 5.0) + 1) + 4
	$'backing'.position.y = 100 - $'backing'.size.y

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
