class_name AttackMenu
extends Control

# --- Variables --- #

# --- References --- #
var attack_grid: Control
var rows: Array[Node]

@onready var select_panel := $"attack_info/select_panel" as Control
@onready var attack_name_label := $"attack_info/title/label" as RichTextLabel
@onready var attack_power_label := $"attack_info/power/label" as RichTextLabel
@onready var attack_description_label := $"attack_info/description/label" as RichTextLabel

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
	
	attack_name_label.text = attack.name
	attack_power_label.text = "O" + str(attack.power)
	attack_description_label.text = attack.description
