class_name ItemInfo
extends Control

# --- Variables --- #
var item

@export var icon_rect: TextureRect
@export var count_label: RichTextLabel

@export var center_count := false

# --- Functions --- #
func _ready() -> void:
	mouse_entered.connect(show_tooltip)
	mouse_exited.connect(hide_tooltip)

func set_item(new_item) -> void:
	visible = not not new_item
	
	if not visible:
		return
	
	item = new_item
	if item is InventoryItem:
		item = DataManager.get_item(item.item_key) as ItemDataChunk
	
	if not item:
		return
	
	# set icon
	icon_rect.texture = item.icon
	
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
	if not item:
		return
	
	Tooltip.set_title_text(item.name)
	Tooltip.set_body_text(item.description)
	Tooltip.show_tooltip()

func hide_tooltip() -> void:
	Tooltip.hide_tooltip()
