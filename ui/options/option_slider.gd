class_name OptionSlider
extends ThemeSetter

# --- Variables --- #
@export var value_label: RichTextLabel
@export var suffix: String

@export var slider: HSlider

# --- Functions --- #
func _ready() -> void:
	super()
	set_value_text(int(slider.value))
	slider.value_changed.connect(set_value_text)

func set_value_text(val: int) -> void:
	value_label.text = str(val) + suffix
