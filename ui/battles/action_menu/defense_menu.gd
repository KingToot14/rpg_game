class_name DefendMenu
extends ActionMenu

# --- Variables --- #

# --- References --- #
var defense_grid: Control

@onready var backing := $"grid_backing" as Control

var info_panel: Control
var info_panel_pos: float

@onready var name_label := $"defense_info/info/name" as RichTextLabel
@onready var icon_rect := $"defense_info/info/icon_frame/icon" as TextureRect
@onready var power_label := $"defense_info/info/defend_power/label" as RichTextLabel
@onready var description_label := $"defense_info/description/label" as RichTextLabel

# --- Functions --- #
#f8jc duke duke :3
func _ready() -> void:
	super()
	
	# set references
	defense_grid = $"defense_grid" as Control
	info_panel = $"defense_info" as Control
	
	info_panel_pos = info_panel.position.y
	
	info_panel.visible = false
	info_panel.position.y += 8
	
	# setup signals
	for child in defense_grid.get_children():
		child.mouse_entered.connect(item_hovered.bind(child))
		child.mouse_exited.connect(item_hovered.bind(null))

func tween_info_panel(value: bool) -> void:
	var tween = create_tween().set_parallel()
	
	if value:
		info_panel.show()
		
		tween.tween_property(info_panel, 'position:y', info_panel_pos, 0.15)
		tween.tween_property(info_panel, 'modulate:a', 1.0, 0.15)
	else:
		tween.tween_property(info_panel, 'position:y', info_panel_pos + 8.0, 0.15)
		tween.tween_property(info_panel, 'modulate:a', 0.0, 0.15)

func item_hovered(item: ActionMenuItem) -> void:
	tween_info_panel(not not item)
	
	if not (item and item.item is Defense):
		return
	
	var defense = item.item as Defense
	
	name_label.text = defense.name
	icon_rect.texture = defense.icon
	power_label.text = str(int(defense.defense_value * 100))
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
