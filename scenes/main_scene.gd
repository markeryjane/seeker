extends Node2D
const GAME_OVER_SCREEN = preload("res://scenes/game_over_screen.tscn")
const CARD_BASE = preload("res://card_base.tscn")
const EXTRA_TURN_INDICATOR = preload("res://scenes/extra_turn_indicator.tscn")
const PARTICLES = preload("res://particles.tscn")
@onready var character_jump_animator: AnimationPlayer = %CharacterJumpAnimator

var deck = []
var play_area = []
var hand = []
@onready var hand_node: Node2D = %Hand
@onready var play_area_node: Node2D = %PlayArea
@onready var discard_label: Label = %DiscardLabel
@onready var play_label: Label = %PlayLabel
@onready var points_label: Label = %PointsLabel
@onready var multiplier_label: Label = %MultiplierLabel
@onready var combo_display_animation_player: AnimationPlayer = %ComboDisplayAnimationPlayer
@onready var score_value_label: Label = %ScoreValueLabel
@onready var year_ui: Control = %YearUI
@onready var turns_left_container: CenterContainer = %TurnsLeftContainer
@onready var turns_left_value_label: Label = %TurnsLeftValueLabel
@onready var play_discard_center_container: CenterContainer = %PlayDiscardCenterContainer

@onready var move_cursor_sfx: AudioStreamPlayer = %MoveCursorSfx
@onready var select_card_sfx: AudioStreamPlayer = %SelectCardSfx
@onready var deselect_card_sfx: AudioStreamPlayer = %DeselectCardSfx
@onready var invalid_hand_sfx: AudioStreamPlayer = %InvalidHandSfx
@onready var play_hand_sfx: AudioStreamPlayer = %PlayHandSfx
@onready var discard_sfx: AudioStreamPlayer = %DiscardSfx
@onready var score_tick_sfx: AudioStreamPlayer = %ScoreTickSfx
@onready var pressed_play_or_discard_sfx: AudioStreamPlayer = %PressedPlayOrDiscardSfx
@onready var extra_turn_sfx: AudioStreamPlayer = %ExtraTurnSfx
@onready var discard_sfx_another: AudioStreamPlayer = %DiscardSfxAnother

@onready var play_hand_3: AudioStreamPlayer = %PlayHand3
@onready var play_hand_4: AudioStreamPlayer = %PlayHand4
@onready var play_hand_5: AudioStreamPlayer = %PlayHand5
@onready var play_hand_6: AudioStreamPlayer = %PlayHand6
@onready var play_hand_7: AudioStreamPlayer = %PlayHand7
@onready var tutorial: Node2D = %Tutorial
@onready var alien: Node2D = %alien
@onready var rat: Node2D = %rat
@onready var bear: Node2D = %bear
@onready var paper_sfx: AudioStreamPlayer = %PaperSfx


var selection_index = 0

var horizontal_selection_index = 1

var max_hand_size = 7
var max_turns = 5
var turns_left = max_turns

var scoring_numbers = []

var score:int = 0
var score_display_value:int = 0
var combo_display_value:int = 0

var game_is_over = false

var input_is_disabled = false

func setup_deck():
	for i in 12:
		for j in 4:
			var card_instance = CARD_BASE.instantiate()
			card_instance.month = i+1
			
			var _is_none_type = randi_range(0,2)
			
			
			
			
			var _type = randi_range(0,2)
			if _is_none_type != 0:
				_type = 0
			#if _type == 1: #add turn
				#_type = 2 #change it to add points
			
			
			card_instance.effect_amount = 0
			
			if _type != 0:
				#var _positive = randi_range(0,3)
				var amount = 0
				amount = randi_range(1,2)
				#if _positive == 0:
					#amount = randi_range(-1,-2)
				#else:
					#amount = randi_range(1,2)
				
				if _type == 2: #points
					if SignalBus.character_selected == 1:
						amount *= 1.5
						amount = round(amount)
					amount *= 50
				else: #turns
					if card_instance.month == 12:
						_type = 0
				card_instance.card_effect = _type
				card_instance.effect_amount = amount
			deck.append(card_instance)
			
	deck.shuffle()

func populate_hand():
	#adds cards until you have as many as max hand size
	if hand.size() < max_hand_size:
		for i in max_hand_size - hand.size():
			if deck.is_empty():
				setup_deck()
			
			var _card = deck.pop_front()
			hand.append(_card)
			hand_node.add_child(_card)

func spend_turn():
	turns_left -= 1
	if turns_left == 0:
		game_over()

func game_over():
	if game_is_over: return
	
	remove_child(hand_node)
	remove_child(play_discard_center_container)
	
	game_is_over = true
	
	await get_tree().create_timer(1.5).timeout
	
	if tutorial:
		tutorial.visible = false
	if turns_left_container:
		turns_left_container.visible = false
	
	var inst = GAME_OVER_SCREEN.instantiate()
	inst.final_score = score
	inst.gameover_winter_bonus_active = year_ui.winter_bonus_active
	inst.gameover_spring_bonus_active = year_ui.spring_bonus_active
	inst.gameover_autumn_bonus_active = year_ui.autumn_bonus_active
	inst.gameover_summer_bonus_active = year_ui.summer_bonus_active
	inst.gameover_year_bonus_active = year_ui.year_bonus_active
	add_child(inst)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if SignalBus.character_selected == 2:
		turns_left = 7
	if SignalBus.character_selected == 0:
		max_hand_size = 7
	else:
		max_hand_size = 6
		hand_node.position.x += 50
		
	
	match(SignalBus.character_selected):
		0:
			alien.visible = true
		1:
			rat.visible = true
		2:
			bear.visible = true
	
	
	setup_deck()
	populate_hand()
	reposition_cards_in_hand()
	pop_up_selected_card()
	
	play_label.modulate = Color.WHITE
	discard_label.modulate = Color.DIM_GRAY
	
	
	
	#AudioManager.start_bgm()
	#$BGM.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if score_value_label.text != str(score):
		score_value_label.text = str(score)
		score_tick_sfx.play()
	
	if turns_left <= 1:
		turns_left_container.modulate = Color.RED
	else:
		turns_left_container.modulate = Color.WHITE
		
	if game_is_over: return
	if input_is_disabled: return
	
	if turns_left_value_label.text != str(turns_left):
		turns_left_value_label.text = str(turns_left)
	
	if horizontal_selection_index == 1:
		pop_up_selected_card()
		
		if Input.is_action_just_pressed("ui_left"):
			#selection_index = max(0, selection_index-1)
			selection_index -= 1
			if selection_index < 0:
				selection_index = max_hand_size
			pop_up_selected_card()
			move_cursor_sfx.play()
			
		if Input.is_action_just_pressed("ui_right"):
			#selection_index = min(hand.size()-1, selection_index+1)
			selection_index += 1
			if selection_index > hand.size()-1:
				selection_index = 0
			pop_up_selected_card()
			move_cursor_sfx.play()
		
		if Input.is_action_just_pressed("ui_accept"):
			select_card()
	else:
		unpop_all_cards()
	
	if horizontal_selection_index == 0:
		play_label.modulate = Color.WHITE
		discard_label.modulate = Color.DIM_GRAY
		
		if Input.is_action_just_pressed("ui_accept"):
			play_hand()
		
	elif horizontal_selection_index == 1:
		play_label.modulate = Color.DIM_GRAY
		discard_label.modulate = Color.DIM_GRAY
	elif horizontal_selection_index == 2:
		play_label.modulate = Color.DIM_GRAY
		discard_label.modulate = Color.WHITE
		
		if Input.is_action_just_pressed("ui_accept"):
			discard()
	
	if Input.is_action_just_pressed("ui_up"):
		horizontal_selection_index = max(0, horizontal_selection_index-1)
		move_cursor_sfx.play()
	
	if Input.is_action_just_pressed("ui_down"):
		horizontal_selection_index = min(2, horizontal_selection_index+1)
		move_cursor_sfx.play()
	
	#if horizontal_selection_index == 1:
		#pop_up_selected_card()
	
	
	
	#if Input.is_action_just_pressed("play_hand"):
		#
	
	if Input.is_action_just_pressed("discard"):
		discard()
	
	if selection_index < 0:
		selection_index = 0
	if selection_index > hand.size()-1:
		selection_index = hand.size()-1
		
	if deck.size() == 0:
		setup_deck()
	
	


func select_card():
	hand[selection_index].selected = !hand[selection_index].selected
	
	if hand[selection_index].selected:
		select_card_sfx.play()
	else:
		deselect_card_sfx.play()

func is_valid_hand() -> bool:
	var december_skip_used = true
	var december_skip_available = scoring_numbers.has(1) and scoring_numbers.has(12)
	if december_skip_available:
		december_skip_used = false
	
	var _selected_count = 0
	for card in hand:
		if card.selected:
			_selected_count += 1
	if _selected_count >= 3:
		var _index = scoring_numbers.size()-1
		for i in scoring_numbers.size():
			#printt('ind',_index)
			if _index > 0:
				if scoring_numbers[_index]-1 != scoring_numbers[_index-1] and scoring_numbers[_index] != scoring_numbers[_index-1]:
					if december_skip_available and !december_skip_used:
						december_skip_used = true
						_index -= 1
						continue
					else:
						return false
			_index -= 1
		#print("RETURN TRUE")
		return true
	return false

func play_hand():
	SignalBus.played_hand.emit()
	
	input_is_disabled = true
	
	for card in hand:
		if card.selected:
			scoring_numbers.append(card.month)
			
	if !is_valid_hand():
		invalid_hand_sfx.play()
		scoring_numbers.clear()
		input_is_disabled = false
		return
		
	character_jump_animator.play("jump")
	pressed_play_or_discard_sfx.play()
	paper_sfx.play()
	match scoring_numbers.size():
		3:
			play_hand_3.play()
		4:
			play_hand_4.play()
		5:
			play_hand_5.play()
		6:
			play_hand_6.play()
		7:
			play_hand_7.play()
		_:
			play_hand_sfx.play()
	
	await get_tree().create_timer(.3).timeout
	
	calculate_score()
	
	for card in hand:
		if card.selected:
			print("particle")
			var _part = PARTICLES.instantiate()
			_part.modulate = card.modulate
			_part.position = card.global_position
			_part.type = card.month
			add_child(_part)
			
	
	for i in 200: #idk why but this works
		for card in hand:
			if card.selected:
				card.queue_free()
				#card.destroy()
				hand.pop_at(hand.find(card))
				hand_node.remove_child(card)
				reposition_cards_in_hand()
	
	#printt("PLAYING A HAND: ", deck)
	#if deck.size() == 0:
		#repopulate_deck()
	
	populate_hand()
	reposition_cards_in_hand()
	spend_turn()
	scoring_numbers.clear()
	
	input_is_disabled = false
	
	

func discard():
	var _num_selected = 0
	for card in hand:
		if card.selected:
			_num_selected += 1
	if _num_selected == 0:
		invalid_hand_sfx.play()
		return
	
	for i in 200: #idk why but this works
		for card in hand:
			if card.selected:
				card.queue_free()
				hand.pop_at(hand.find(card))
				hand_node.remove_child(card)
				reposition_cards_in_hand()
	populate_hand()
	
	reposition_cards_in_hand()
	spend_turn()
	
	pressed_play_or_discard_sfx.play()
	discard_sfx.play()
	discard_sfx_another.play()

func calculate_score():
	var _points_to_add = 0
	for i in scoring_numbers:
		_points_to_add += 10
	for card in hand:
		if card.selected:
			if card.card_effect == 2: #add points
				_points_to_add += card.effect_amount
			elif card.card_effect == 1: #add turns
				turns_left += card.effect_amount
				extra_turn_sfx.play()
				var _inst = EXTRA_TURN_INDICATOR.instantiate()
				_inst.position = Vector2(990,655)
				add_child(_inst)
			year_ui.activate_month(card.month)
			
	score_display_value = _points_to_add
	points_label.text = str(score_display_value)
	
	var _all_cards_multiplier = 0
	if scoring_numbers.size() == max_hand_size:
		_all_cards_multiplier = 3
	_points_to_add *= scoring_numbers.size() + _all_cards_multiplier
	
	#score += _points_to_add
	var tween = get_tree().create_tween()
	tween.tween_property(self, "score", score+_points_to_add, 0.9)
	
	combo_display_value = scoring_numbers.size() + _all_cards_multiplier
	multiplier_label.text = str(combo_display_value)
	
	combo_display_animation_player.play("animate_combo_display")
	
	#check december game over
	for i in scoring_numbers:
		if i == 12:
			turns_left_value_label.text = "December!"
			$TurnsLeftContainer/VBoxContainer/TurnsLeftTextLabel.visible = false
			game_over()
	
	#printt("POINTS",_points_to_add)
	#print(scoring_numbers)

func pop_up_selected_card():
	var _index = 0
	for card in hand:
		if _index == selection_index:
			card.pop_up()
		else:
			card.reset_pop()
		_index += 1

func unpop_all_cards():
	if hand.is_empty():
		return
	for card in hand:
		card.reset_pop()

func sort_by_month(a, b):
	if a.month < b.month:
		return true
	return false

	
func reposition_cards_in_hand() -> void:
	if hand.is_empty():
		return
		
	hand.sort_custom(sort_by_month)
	
	var _index = 0
	var _separation = 200
	for card in hand:
		card.position.x = hand_node.position.x + _separation * _index
		_index += 1
