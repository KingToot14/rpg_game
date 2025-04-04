extends CanvasLayer

# --- Variables --- #
## The action to use for advancing the dialogue
@export var next_action: StringName = &"ui_accept"

## The action to use to skip typing the dialogue
@export var skip_action: StringName = &"ui_cancel"

@export var custom_tags: Dictionary

@export_group("Animation")
@export var tween_duration := 0.25

# --- References --- #
@onready var balloon := %balloon as Control
@onready var dialogue_label := %dialogue_label as DialogueLabel

@onready var audio_player := %'audio_player' as SfxPlayer

var resource: DialogueResource
var npc_info: NpcInformation

var temporary_game_states: Array = []
var is_waiting_for_input: bool = false
var will_hide_balloon: bool = false

## The current line
var dialogue_line: DialogueLine:
	set(next_dialogue_line):
		is_waiting_for_input = false
		balloon.focus_mode = Control.FOCUS_ALL
		balloon.grab_focus()

		# The dialogue has finished so close the balloon
		if not next_dialogue_line:
			close()
			return

		# If the node isn't ready yet then none of the labels will be ready yet either
		if not is_node_ready():
			await ready
		
		# add spacing for outlines
		next_dialogue_line.text = "\n" + next_dialogue_line.text
		
		# parse custom tags
		for tag in custom_tags:
			var pattern = RegEx.new()
			pattern.compile(r'\[' + tag + r'\]')
			next_dialogue_line.text = pattern.sub(next_dialogue_line.text, r'[color=' + custom_tags[tag].to_html() + r']', true)
			
			pattern = RegEx.new()
			pattern.compile(r'\[/' + tag + r'\]')
			next_dialogue_line.text = pattern.sub(next_dialogue_line.text, r'[/color]', true)
		
		dialogue_line = next_dialogue_line
		
		var from_character = not dialogue_line.character.is_empty()
		
		# set character
		%"character_panel".visible = from_character
		%"character_label".text = tr(dialogue_line.character, "dialogue")
		
		%"character_label".get_parent().size.x = %"character_label".get_content_width() + 7
		
		%"portrait".texture = npc_info.portrait_texture
		
		# set dialogue
		dialogue_label.hide()
		dialogue_label.dialogue_line = dialogue_line
		
		# show response menu
		var responses_menu = %'response_menu'
		var quest_container = %'quest_container'
		
		responses_menu.hide()
		responses_menu.set_responses(dialogue_line.responses)
		
		# display quest
		var quest = dialogue_line.get_tag_value('quest')
		
		if not quest.is_empty():
			quest_container.visible = true
			quest_container.load_items(quest)
		else:
			quest_container.visible = false
		
		# Show our balloon
		balloon.show()
		will_hide_balloon = false

		dialogue_label.show()
		if not dialogue_line.text.is_empty():
			dialogue_label.type_out()
			await dialogue_label.finished_typing

		# Wait for input
		if dialogue_line.responses.size() > 0:
			balloon.focus_mode = Control.FOCUS_NONE
			responses_menu.show_responses()
		elif dialogue_line.time != "":
			var time = dialogue_line.text.length() * 0.02 if dialogue_line.time == "auto" else dialogue_line.time.to_float()
			await get_tree().create_timer(time).timeout
			next(dialogue_line.next_id)
		else:
			is_waiting_for_input = true
			balloon.focus_mode = Control.FOCUS_ALL
			balloon.grab_focus()
	get:
		return dialogue_line

# --- Functions --- #
func _ready() -> void:
	print("Ready")
	
	Globals.curr_dialogue = self
	
	if Globals.overworld_manager:
		Globals.overworld_manager.player.set_state('dialogue')
	
	balloon.hide()
	Engine.get_singleton("DialogueManager").mutated.connect(_on_mutated)
	
	# If the responses menu doesn't have a next action set, use this one
	var responses_menu = %'response_menu'
	if responses_menu.next_action.is_empty():
		responses_menu.next_action = next_action

func _unhandled_input(_event: InputEvent) -> void:
	# Only the balloon is allowed to handle input while it's showing
	get_viewport().set_input_as_handled()

func _notification(what: int) -> void:
	if not is_node_ready():
		return
	
	# Detect a change of locale and update the current dialogue line to show the new language
	if what == NOTIFICATION_TRANSLATION_CHANGED:
		var visible_ratio = dialogue_label.visible_ratio
		self.dialogue_line = await resource.get_next_dialogue_line(dialogue_line.id)
		if visible_ratio < 1:
			dialogue_label.skip_typing()

## Start some dialogue
func start(dialogue_resource: DialogueResource, title: String, npc: NpcInformation = null, extra_game_states: Array = []) -> void:
	# set dialogue
	npc_info = npc
	
	temporary_game_states = [self] + extra_game_states
	is_waiting_for_input = false
	resource = dialogue_resource
	
	self.dialogue_line = await resource.get_next_dialogue_line(title, temporary_game_states)
	
	# show panel
	open()
	
	# setup sfx signals
	if npc_info and npc_info.dialogue_sfx:
		dialogue_label.spoke.connect(_on_dialogue_spoke)

func open() -> void:
	var tween = create_tween().set_parallel()
	
	tween.tween_property(balloon, ^'position:y', balloon.position.y, tween_duration).from(balloon.position.y + 16).set_trans(Tween.TRANS_BACK)
	tween.tween_property(balloon, ^'modulate:a', 1.0, tween_duration).from(0.0)

func close() -> void:
	var tween = create_tween().set_parallel()
	
	tween.tween_property(balloon, ^'position:y', balloon.position.y + 16, tween_duration)
	tween.tween_property(balloon, ^'modulate:a', 0.0, tween_duration)
	
	tween.finished.connect(queue_free)

## Go to the next line
func next(next_id: String) -> void:
	self.dialogue_line = await resource.get_next_dialogue_line(next_id, temporary_game_states)

#region Signals
func _on_mutated(_mutation: Dictionary) -> void:
	is_waiting_for_input = false
	will_hide_balloon = true
	get_tree().create_timer(0.1).timeout.connect(func():
		if will_hide_balloon:
			will_hide_balloon = false
			balloon.hide()
	)

func _on_balloon_gui_input(event: InputEvent) -> void:
	# See if we need to skip typing of the dialogue
	if dialogue_label.is_typing:
		var mouse_was_clicked: bool = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed()
		var skip_button_was_pressed: bool = event.is_action_pressed(skip_action)
		if mouse_was_clicked or skip_button_was_pressed:
			get_viewport().set_input_as_handled()
			dialogue_label.skip_typing()
			return

	if not is_waiting_for_input: return
	if dialogue_line.responses.size() > 0: return

	# When there are no response options the balloon itself is the clickable thing
	get_viewport().set_input_as_handled()

	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		next(dialogue_line.next_id)
	elif event.is_action_pressed(next_action) and get_viewport().gui_get_focus_owner() == balloon:
		next(dialogue_line.next_id)

func _on_responses_menu_response_selected(response: DialogueResponse) -> void:
	next(response.next_id)

func _on_dialogue_spoke(_letter: String, _letter_index: int, _speed: float) -> void:
	audio_player.play_sfx(npc_info.dialogue_sfx)
#endregion
