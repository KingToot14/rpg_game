class_name PlayerInfoManager
extends Node

# --- Variables --- #
var curr_player: PlayerDataChunk
var curr_tab: Control

@export var weak_color := Color.WHITE
@export var weak_outline := Color.WHITE
@export var normal_color := Color.WHITE
@export var normal_outline := Color.WHITE
@export var resist_color := Color.WHITE
@export var resist_outline := Color.WHITE
@export var heal_color := Color.WHITE
@export var heal_outline := Color.WHITE

# --- Functions --- #
func _ready() -> void:
	# setup tab signals
	for tab: Control in %'role_tabs'.get_children():
		tab.get_node(^'icon_button').pressed.connect(_on_tab_button_pressed.bind(tab))
		tab.get_node(^'left_button').pressed.connect(_on_tab_button_moved.bind(tab, true))
		tab.get_node(^'right_button').pressed.connect(_on_tab_button_moved.bind(tab, false))
		
		tab.hide()
	
	# setup tabs
	for player in DataManager.players:
		if not player:
			continue
		if player.role == PlayerDataChunk.PlayerRole.MELEE:
			%'role_tabs'.get_node(^'melee_tab').show()
		elif player.role == PlayerDataChunk.PlayerRole.MONK:
			%'role_tabs'.get_node(^'monk_tab').show()
		elif player.role == PlayerDataChunk.PlayerRole.RANGED:
			%'role_tabs'.get_node(^'ranged_tab').show()
		elif player.role == PlayerDataChunk.PlayerRole.MAGIC:
			%'role_tabs'.get_node(^'magic_tab').show()
	
	curr_tab = %'role_tabs'.get_child(0)
	
	load_player(DataManager.players[0])
	update_tabs()

#region Stats
func reload_panel() -> void:
	load_player(curr_player)

func load_player(player: PlayerDataChunk) -> void:
	if not player:
		return
	
	curr_player = player
	
	# load stats
	update_stat(%'player_hp', player.get_max_hp())
	update_stat(%'player_p_attack', player.get_p_attack())
	update_stat(%'player_m_attack', player.get_m_attack())
	update_stat(%'player_p_defense', player.get_p_defense())
	update_stat(%'player_m_defense', player.get_m_defense())
	update_stat(%'player_accuracy', player.get_accuracy())
	update_stat(%'player_evasion', player.get_evasion())
	
	# load xp
	%'player_level'.text = "Level %d" % player.level
	
	%'curr_xp'.text = "[right]%d[/right]" % player.curr_xp
	%'target_xp'.text = "%d" % player.xp_to_next
	
	set_fill_size(%'xp_fill', 1.0 * player.curr_xp / player.xp_to_next)
	
	# load hp
	%'curr_hp'.text = "[right]%d[/right]" % player.curr_hp
	%'max_hp'.text = "%d" % player.get_max_hp()
	set_fill_size(%'hp_fill', 1.0 * player.curr_hp / player.get_max_hp())
	
	%'sp_label'.text = "[right]%d[/right]" % player.curr_special + "%"
	set_fill_size(%'sp_fill', player.curr_special)
	
	# load element resistances
	var entity: Entity = null
	if curr_player.role == PlayerDataChunk.PlayerRole.MELEE:
		entity = %'melee_dummy' as Entity
	
	%'fire_value'.text = get_element_resistance(entity, Attack.Element.FIRE)
	%'electric_value'.text = get_element_resistance(entity, Attack.Element.ELECTRIC)
	%'nature_value'.text = get_element_resistance(entity, Attack.Element.NATURE)
	%'water_value'.text = get_element_resistance(entity, Attack.Element.WATER)
	%'ice_value'.text = get_element_resistance(entity, Attack.Element.ICE)
	%'flying_value'.text = get_element_resistance(entity, Attack.Element.FLYING)
	%'earth_value'.text = get_element_resistance(entity, Attack.Element.EARTH)
	%'light_value'.text = get_element_resistance(entity, Attack.Element.LIGHT)
	%'dark_value'.text = get_element_resistance(entity, Attack.Element.DARK)
	
	# load status resistances
	%'harass_value'.text = get_status_resistance(entity, Globals.StatusType.HARASS)
	%'hinder_value'.text = get_status_resistance(entity, Globals.StatusType.HINDER)
	%'life_value'.text = get_status_resistance(entity, Globals.StatusType.LIFE)
	%'death_value'.text = get_status_resistance(entity, Globals.StatusType.DEATH)
	%'body_value'.text = get_status_resistance(entity, Globals.StatusType.BODY)
	%'environment_value'.text = get_status_resistance(entity, Globals.StatusType.ENVIRONMENT)
	
	# load gear icons
	%'weapon_icon'.texture = player.weapon.equip_texture
	%'primary_icon'.texture = player.outfit_primary.equip_texture
	%'secondary_icon'.texture = player.outfit_secondary.equip_texture
	
	# load trinket icons
	if player.trinket1:
		%'trinket1_icon'.texture = player.trinket1.texture
	if player.trinket2:
		%'trinket2_icon'.texture = player.trinket2.texture
	if player.trinket3:
		%'trinket3_icon'.texture = player.trinket3.texture

func set_fill_size(fill: Control, value: float) -> void:
	var max_width = fill.get_parent().size.x - 4
	
	fill.custom_minimum_size.x = floori(max_width * value)

func update_stat(label: RichTextLabel, value: float) -> void:
	if value < 100:
		label.text = "%.2f" % value
	else:
		label.text = "%d" % value

func get_element_resistance(entity: Entity, element: Attack.Element) -> String:
	if not entity:
		return "[center][outline_size=3]0[/outline_size][/center]"
	
	var chunk = {
		&'damage': 0,
		&'element': element,
		&'element_mod': 1.0
	}
	
	entity.took_damage.emit(chunk)
	
	var mod = roundi((1.0 - chunk[&'element_mod']) * 100)
	
	var out = "[center][outline_size=3]"
	
	if mod < 0:
		out += "[outline_color=#%s][color=#%s]%d" % [weak_outline.to_html(false), weak_color.to_html(false), -mod]
	elif mod == 0:
		out += "[outline_color=#%s][color=#%s]%d" % [normal_outline.to_html(false), normal_color.to_html(false), mod]
	elif mod <= 100:
		out += "[outline_color=#%s][color=#%s]%d" % [resist_outline.to_html(false), resist_color.to_html(false), mod]
	else:
		out += "[outline_color=#%s][color=#%s]%d" % [heal_outline.to_html(false), heal_color.to_html(false), mod]
	
	return out + "[/color][/outline_color][/outline_size][/center]"

func get_status_resistance(entity: Entity, type: Globals.StatusType) -> String:
	if not entity:
		return "[center][outline_size=3]0[/outline_size][/center]"
	
	var chunk = {
		&'status_type': type,
		&'stacks_odds': 0.0
	}
	
	entity.received_status.emit(chunk)
	
	var out := "[center][outline_size=3]"
	var mod = roundi(chunk[&'stacks_odds'] * 100)
	
	if mod < 0:
		out += "[outline_color=#%s][color=#%s]%d" % [weak_outline.to_html(false), weak_color.to_html(false), -mod]
	elif mod == 0:
		out += "[outline_color=#%s][color=#%s]%d" % [normal_outline.to_html(false), normal_color.to_html(false), mod]
	elif mod <= 100:
		out += "[outline_color=#%s][color=#%s]%d" % [resist_outline.to_html(false), resist_color.to_html(false), mod]
	else:
		out += "[outline_color=#%s][color=#%s]%d" % [heal_outline.to_html(false), heal_color.to_html(false), mod]
	
	return out

#endregion

#region Player Selection
func update_tabs() -> void:
	var shown = 0
	for tab: Control in %'role_tabs'.get_children():
		if tab.visible:
			shown += 1
	
	for tab: Control in %'role_tabs'.get_children():
		var index = tab.get_index()
		
		if tab == curr_tab:
			tab.get_node(^'backing').update_theme(ThemePreset.ColorValue.SHADED)
			tab.get_node(^'icon_button/backing').update_theme(ThemePreset.ColorValue.NORMAL)
		else:
			tab.get_node(^'backing').update_theme(ThemePreset.ColorValue.DARK)
			tab.get_node(^'icon_button/backing').update_theme(ThemePreset.ColorValue.SHADED)
		
		tab.get_node(^'left_button').visible = index != 0
		tab.get_node(^'right_button').visible = index != shown - 1

func _on_tab_button_pressed(tab: Control) -> void:
	curr_tab = tab
	
	load_player(DataManager.players[tab.get_index()])
	
	update_tabs()

func _on_tab_button_moved(tab: Control, is_left: bool) -> void:
	var index = tab.get_index()
	
	if index <= 0 and is_left:
		return
	
	if is_left:
		%'role_tabs'.move_child(tab, index - 1)
		DataManager.swap_players(index, index - 1)
	else:
		%'role_tabs'.move_child(tab, index + 1)
		DataManager.swap_players(index, index + 1)
	
	update_tabs()

#endregion
