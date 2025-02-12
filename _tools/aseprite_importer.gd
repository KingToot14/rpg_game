@tool
class_name AsepriteImporter
extends Resource

# --- Variables --- #
@export var role: PlayerDataChunk.PlayerRole
# @@buttons("Reimport", _reimport())
@export var sprites: Array[String] = []

var reimported_files: Array[String]

# --- References --- #
const PLAYER_SAVE_DIR := "C:/Users/armor/OneDrive/Art/Aseprite/RPG/entities/player"
const ASEPRITE_BIN_PATH := "C:/Programs/Aseprite/build/bin/aseprite.exe"

# --- Functions --- #
func _reimport() -> void:
	# file the directory name for each role
	var role_str = ""
	if role == PlayerDataChunk.PlayerRole.MELEE: role_str = "melee"
	if role == PlayerDataChunk.PlayerRole.RANGED: role_str = "ranged"
	if role == PlayerDataChunk.PlayerRole.MONK: role_str = "monk"
	if role == PlayerDataChunk.PlayerRole.MAGIC: role_str = "magic"
	
	var player_dir := PLAYER_SAVE_DIR.path_join(role_str)
	var player_dir_res := "res://entities/player".path_join(role_str)
	
	reimported_files = []
	
	# import the body (same for all roles)
	import_aseprite_file(
		player_dir.path_join("battle.aseprite"),
		player_dir_res.path_join("battle.png"),
		['arm-front', 'head', 'leg-front', 'body', 'arm-back', 'leg-back'],
		true
	)
	
	# load straps
	if role == PlayerDataChunk.PlayerRole.MELEE:
		import_aseprite_file(
			player_dir.path_join("battle.aseprite"),
			player_dir_res.path_join("weapons/strap.png"),
			['weapons/strap']
		)
	
	# for each component, reimport based on the role and type
	for sprite_str in sprites:
		var type := sprite_str.split("|")[0]
		var sprite := sprite_str.split("|")[1]
		
		if role == PlayerDataChunk.PlayerRole.MELEE:
			# load swords
			if type == "w":
				import_aseprite_file(
					player_dir.path_join("battle.aseprite"),
					player_dir_res.path_join("weapons").path_join(sprite).path_join("sword.png"),
					['weapons/' + sprite]
				)
			
			# load shields
			if type == "w":
				import_aseprite_file(
					player_dir.path_join("battle.aseprite"),
					player_dir_res.path_join("weapons").path_join(sprite).path_join("shield.png"),
					['shields/' + sprite]
				)
			
			# load outfits
			if type == "o":
				pass
			
		if role == PlayerDataChunk.PlayerRole.RANGED:
			pass
		if role == PlayerDataChunk.PlayerRole.MONK:
			pass
		if role == PlayerDataChunk.PlayerRole.MAGIC:
			pass
	
	# reimport files
	EditorInterface.get_resource_filesystem().reimport_files(reimported_files)

func import_aseprite_file(aseprite_path: String, target_path: String, layers: Array[String], merge := false) -> void:
	# load the arguments
	var args: Array[String] = ["-b", "--sheet=" + ProjectSettings.globalize_path(target_path), 
		"--sheet-columns=6"]
	
	# add each layer arg
	for layer in layers:
		args.append("--layer=" + layer)
	
	args.append(aseprite_path)
	
	# optionally merge duplicates
	if merge:
		args.append('--merge-duplicates')
	
	# reimport new png
	var out = []
	var code = OS.execute(ASEPRITE_BIN_PATH, args, out)
	reimported_files.append(target_path)
	
	#print("Code: ", code)
	#print("Target: ", '"' + ProjectSettings.globalize_path(target_path) + '"')
	#print("Output: ", out[0])
	#print("Command:")
	#print(ASEPRITE_BIN_PATH, " ", " ".join(args))
