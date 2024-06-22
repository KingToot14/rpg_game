class_name ItemInfo
extends Control

# --- Variables --- #
@export var icon_rect: TextureRect
@export var count_label: RichTextLabel

@export var tooltip_rect: Control
@export var tooltip_label: RichTextLabel

# --- Functions --- #
func _ready() -> void:
	tooltip_rect.modulate.a = 0.0

func set_item(item) -> void:
	visible = not not item
	
	if not visible:
		return
	
	var inventory_item = item
	if item is InventoryItem:
		inventory_item = DataManager.get_item(item.item_key) as ItemDataChunk
	
	if not inventory_item:
		return
	
	# set icon
	icon_rect.texture = inventory_item.icon
	
	# set count
	count_label.text = " " + str(item.quantity)
	
	# set tooltip
	tooltip_label.text = "[center]" + inventory_item.name

func set_item_target(item: InventoryItem, target: int) -> void:
	set_item(item)
	count_label.append_text("/" + str(target))

func show_tooltip() -> void:
	var tween = create_tween()
	
	tween.tween_property(tooltip_rect, 'modulate:a', 1.0, 0.15)

func hide_tooltip() -> void:
	var tween = create_tween()
	
	tween.tween_property(tooltip_rect, 'modulate:a', 0.0, 0.15)
