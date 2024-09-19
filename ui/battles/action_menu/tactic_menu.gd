class_name TacticMenu
extends ActionMenu

# --- Variables --- #
@export var tactics: Array[Tactic] = []

# --- References --- #
var tactic_grid: Control

@onready var backing := $"grid_backing" as Control

var info_panel: Control
var info_panel_pos: float

@onready var name_label := $"tactic_info/info/name" as RichTextLabel
@onready var description_label := $"tactic_info/info/description" as RichTextLabel

# --- Functions --- #
#f8jc duke duke :3
func _ready() -> void:
	super()
	
	# set references
	tactic_grid = $"tactic_grid" as Control
	info_panel = $"tactic_info" as Control
	
	info_panel_pos = info_panel.position.y
	
	info_panel.visible = false
	info_panel.position.y += 8
	
	# setup signals
	for child in tactic_grid.get_children():
		child.mouse_entered.connect(item_hovered.bind(child))
		child.mouse_exited.connect(item_hovered.bind(null))
	
	load_items(tactics)

func tween_info_panel(value: bool) -> void:
	var info_panel_tween = create_tween().set_parallel()
	
	if value:
		info_panel.show()
		
		info_panel_tween.tween_property(info_panel, 'position:y', info_panel_pos, 0.15)
		info_panel_tween.tween_property(info_panel, 'modulate:a', 1.0, 0.15)
	else:
		info_panel_tween.tween_property(info_panel, 'position:y', info_panel_pos + 8.0, 0.15)
		info_panel_tween.tween_property(info_panel, 'modulate:a', 0.0, 0.15)

func item_hovered(item: ActionMenuItem) -> void:
	tween_info_panel(not not item)
	
	if not (item and item.item is Tactic):
		return
	
	var tactic = item.item as Tactic
	
	name_label.text = tactic.name
	description_label.text = tactic.description

func load_items(items) -> void:
	var index = 0
	var item_count = len(items)
	
	for child in tactic_grid.get_children():
		if index < item_count:
			child.set_menu_item(items[index])
		else:
			child.set_menu_item(null)
		
		index += 1

