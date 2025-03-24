class_name ItemInfo
extends Control

# --- Variables --- #
var item_data: ItemDataChunk

@export var icon_rect: TextureRect
@export var count_label: RichTextLabel

@export var center_count := false

# --- Functions --- #
func _ready() -> void:
	mouse_entered.connect(show_tooltip)
	mouse_exited.connect(hide_tooltip)

func set_item(item) -> void:
	visible = not not item
	
	if not visible:
		return
	
	if item is InventoryItem:
		item_data = DataManager.get_item(item.item_key) as ItemDataChunk
	else:
		item_data = item
	
	if not (item and item_data):
		return
	
	# set icon
	icon_rect.texture = item_data.icon
	
	# set count
	if center_count:
		count_label.text = "[center]"
	else:
		count_label.text = " "
	
	count_label.text += str(item.quantity)

func set_item_target(new_item, target: int) -> void:
	set_item(new_item)
	count_label.append_text("/" + str(target))

func show_tooltip() -> void:
	if not item_data:
		return
	
	#Tooltip.set_title_text(item_data.name)
	#Tooltip.set_body_text(item_data.description)
	#Tooltip.show_tooltip()

func hide_tooltip() -> void:
	return
	#Tooltip.hide_tooltip()
