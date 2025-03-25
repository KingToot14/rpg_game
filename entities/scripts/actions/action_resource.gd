class_name ActionResource
extends Resource

# --- Enums --- #
enum TargetSide {
	PLAYER = 1,
	ENEMY = 2,
	BOTH = PLAYER | ENEMY
}
enum TargetingMode {
	SINGLE = 1,
	AOE = 2,
	ALL = 4,
	SINGLE_OR_ALL = SINGLE | ALL,
	RANDOM = 8,
	CASTER = 16,
	NOT_CASTER = 32
}

# --- Variables --- #
@export var name: String
@export var animation_name: StringName
@export var icon: Texture2D

@export_multiline var description: String

@export var side: TargetSide = TargetSide.PLAYER
@export var targeting: TargetingMode = TargetingMode.SINGLE

@export var cooldown: int
var remaining_cooldown: int

# --- Functions --- #
func perform_action(_target: Entity) -> void:
	return

func can_target(target: Entity) -> bool:
	return (side & TargetSide.ENEMY != 0 and not target.is_player()) or (side & TargetSide.PLAYER != 0 and target.is_player())

func highlight_targets(caster: Entity = null) -> void:
	var targets = TargetingHelper.get_entities(get_side_string())
	
	match targeting:
		TargetingMode.ALL:
			if side & TargetSide.PLAYER:
				TargetingHelper.show_all_targeting(&'player_all')
			if side & TargetSide.ENEMY:
				TargetingHelper.show_all_targeting(&'enemy_all')
		TargetingMode.CASTER:
			for target in targets:
				target.targeting.set_targetable(target == caster)
		TargetingMode.NOT_CASTER:
			for target in targets:
				target.targeting.set_targetable(target != caster)
		TargetingMode.SINGLE_OR_ALL:
			for target in targets:
				target.targeting.set_targetable(true)
		_:
			for target in targets:
				target.targeting.set_targetable(true)

func get_side_string() -> StringName:
	if side & TargetSide.PLAYER and side & TargetSide.ENEMY:
		return &'entity'
	elif side & TargetSide.ENEMY:
		return &'enemy'
	else:
		return &'player'

#region Cooldown
func start_cooldown(val: int = -1) -> void:
	if val < 0:
		if cooldown > 0:
			val = cooldown + 1
		else:
			val = 0
	
	remaining_cooldown = val

func decrement_cooldown() -> void:
	remaining_cooldown = max(remaining_cooldown - 1, 0)
#endregion
