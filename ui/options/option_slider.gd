class_name OptionSlider
extends HSlider

# --- Variables --- #
@export var value_label: RichTextLabel
@export var suffix: String

# --- Functions --- #
func _ready() -> void:
	set_value_text(value)
	value_changed.connect(set_value_text)

func set_value_text(val: int) -> void:
	value_label.text = str(val) + suffix
