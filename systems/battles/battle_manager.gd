class_name BattleManager
extends Node2D

# --- Variables --- #
@export var encounter_path_label: Label

var encounter: Encounter

# --- Functions --- #
func _ready():
	AsyncLoader.new(Globals.encounter_resource, setup_encounter)

func setup_encounter(loaded_encounter: Encounter):
	encounter = loaded_encounter
	encounter_path_label.text = encounter.resource_name

func load_overworld():
	SceneManager.load_scene(Globals.OVERWORLD_SCENE)
