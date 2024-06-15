class_name AttackMenu
extends Control

# --- Variables --- #

# --- References --- #
var attack_grid: Control
var rows: Array[Node]

@onready var backing := $"grid_backing" as Control

@onready var select_panel := $"attack_info/select_panel" as Control

@onready var name_label := $"attack_info/title/label" as RichTextLabel
@onready var icon_rect := $"attack_info/power/icon_frame/icon" as TextureRect
@onready var power_label := $"attack_info/power/label" as RichTextLabel
@onready var description_label := $"attack_info/description/label" as RichTextLabel

# --- Functions --- #
#f8jc duke duke :3
func _ready() -> void:
	# set references
	attack_grid = $"attack_grid" as Control
	
	# find rows
	rows = attack_grid.get_children()
	rows.reverse()
	
	# setup signals
	for row in rows:
		for child in row.get_children():
			child.mouse_entered.connect(item_hovered.bind(child))
			child.mouse_exited.connect(item_hovered.bind(null))

func item_hovered(item: ActionMenuItem) -> void:
	select_panel.visible = not item
	
	if not item:
		return
	
	var attack = item.item as Attack
	
	name_label.text = attack.name
	icon_rect.texture = attack.icon
	power_label.text = "O" + str(attack.power)
	description_label.text = attack.description

func load_items(items) -> void:
	var index = 0
	var item_count = len(items)
	
	for row in rows:
		var children = row.get_children()
		for child in children:
			if index < item_count:
				child.set_menu_item(items[index])
			else:
				child.set_menu_item(null)
			
			index += 1
	
	backing.size.y = 24 * (floor(item_count / 5.0) + 1) + 4
	backing.position.y = 94 - backing.size.y + 6
