extends Node2D

# --- Variables --- #
@export var title_label: RichTextLabel
@export var body_label: RichTextLabel

# --- Functions --- #
func _ready() -> void:
	hide()

func _process(_delta: float) -> void:
	position = get_viewport().get_mouse_position()

func set_title_text(text: String) -> void:
	title_label.text = text

func set_body_text(text: String) -> void:
	body_label.text = text

func show_tooltip() -> void:
	show()

func hide_tooltip() -> void:
	hide()
