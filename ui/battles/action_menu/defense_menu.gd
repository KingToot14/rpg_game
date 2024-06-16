class_name DefendMenu
extends Control

# --- Variables --- #

# --- References --- #
var defense_grid: Control

@onready var backing := $"grid_backing" as Control

@onready var select_panel := $"defense_info/select_panel" as Control

@onready var name_label := $"defense_info/title/label" as RichTextLabel
@onready var icon_rect := $"defense_info/info/icon_frame/icon" as TextureRect
@onready var power_label := $"defense_info/info/defend_power/label" as RichTextLabel
@onready var description_label := $"defense_info/description/label" as RichTextLabel

# --- Functions --- #
#f8jc duke duke :3
func _ready() -> void:
	# set references
	defense_grid = $"defense_grid" as Control
	
	# setup signals
	for child in defense_grid.get_children():
		child.mouse_entered.connect(item_hovered.bind(child))
		child.mouse_exited.connect(item_hovered.bind(null))

func item_hovered(item: ActionMenuItem) -> void:
	select_panel.visible = not item
	
	if not (item and item.item is Defense):
		return
	
	var defense = item.item as Defense
	
	name_label.text = defense.name
	icon_rect.texture = defense.icon
	power_label.text = "O" + str(int(defense.defense_value * 100))
	description_label.text = defense.description

func load_items(items) -> void:
	var index = 0
	var item_count = len(items)
	
	for child in defense_grid.get_children():
		if index < item_count:
			child.set_menu_item(items[index])
		else:
			child.set_menu_item(null)
		
		index += 1
