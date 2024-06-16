class_name AttackMenu
extends Control

# --- Variables --- #

# --- References --- #
var attack_grid: Control
var rows: Array[Node]

@onready var backing := $"grid_backing" as Control

@onready var select_panel := $"attack_info/select_panel" as Control

@onready var name_label := $"attack_info/title/label" as RichTextLabel
@onready var icon_rect := $"attack_info/info/icon_frame/icon" as TextureRect

@onready var power_icon := $"attack_info/info/power_holder/icon" as TextureRect
@onready var power_label := $"attack_info/info/power_holder/label" as RichTextLabel

@onready var element_holder := $"attack_info/info/element_holder" as Control
@onready var element_icon := $"attack_info/info/element_holder/icon" as TextureRect
@onready var element_label := $"attack_info/info/element_holder/label" as RichTextLabel

@onready var accuracy_label := $"attack_info/info/accuracy_holder/label" as RichTextLabel
@onready var crit_label := $"attack_info/info/crit_rate/label" as RichTextLabel


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
	
	# power
	power_label.text = str(attack.power)
	
	# element
	element_holder.visible = attack.element != Attack.Element.NONE and attack.element != Attack.Element.USE_WEAPON
	if element_holder.visible:
		# calculate texture
		var column: int = (attack.element - 2) % 3
		var row: int = (attack.element - 2) / 3
		
		element_icon.texture.region = Rect2(column * 10, row * 10, 10, 10)
		
		# percent
		element_label.text = str(int(attack.element_percent * 100))
		
	
	# accuracy
	accuracy_label.text = str(int(attack.accuracy * 100))
	
	# crit rate
	crit_label.text = str(int(attack.crit_rate * 100))
	
	# description
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
