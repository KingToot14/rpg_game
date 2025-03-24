class_name EquipmentButton
extends BaseButton

# --- Variables --- #
@export var is_main := false
var equipment: Equipment

# --- Functions --- #
func _ready() -> void:
	load_equipment(null)
	
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered() -> void:
	if not is_main and not equipment:
		return
	
	$'backing'.update_theme(ThemePreset.ColorValue.LIGHT)

func _on_mouse_exited() -> void:
	if not is_main and not equipment:
		return
	
	$'backing'.update_theme(ThemePreset.ColorValue.SHADED)

#region Equipment
func load_equipment(new_equip: Equipment) -> void:
	equipment = new_equip
	
	if not equipment:
		$'equip_icon'.texture = null
		return
	
	# load icon
	$'equip_icon'.texture = equipment.equip_texture

#endregion

#region Button Actions
func show_gear_select(key: StringName) -> void:
	if %'equip_select'.showing_id(key):
		%'equip_select'.hide_tooltip()
	else:
		var player = %'stat_loader'.curr_player
		
		%'equip_select'.load_equipment(player, key)
		%'equip_select'.point_to(global_position + size / 2)

func equip_current() -> void:
	if not equipment:
		return
	
	# equip
	if %'equip_select'.curr_id == &'weapon':
		%'stat_loader'.curr_player.weapon = equipment
	elif %'equip_select'.curr_id == &'primary':
		%'stat_loader'.curr_player.outfit_primary = equipment
	elif %'equip_select'.curr_id == &'secondary':
		%'stat_loader'.curr_player.outfit_secondary = equipment
	elif %'equip_select'.curr_id == &'trinket1':
		%'stat_loader'.curr_player.trinket1 = equipment
	elif %'equip_select'.curr_id == &'trinket2':
		%'stat_loader'.curr_player.trinket2 = equipment
	elif %'equip_select'.curr_id == &'trinket3':
		%'stat_loader'.curr_player.trinket3 = equipment
	
	%'stat_loader'.reload_panel()
	%'melee_dummy'.reload_equips()
	
	# hide tooltip
	%'equip_select'.hide_tooltip()

#endregion
