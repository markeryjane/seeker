extends Node2D

const CARD_BASE = preload("res://card_base.tscn")
var base_deck = []

var deck = []
var play_area = []
var hand = []
@onready var hand_node: Node2D = %Hand
@onready var play_area_node: Node2D = %PlayArea
@onready var discard_label: Label = %DiscardLabel
@onready var play_label: Label = %PlayLabel

var selection_index = 0

var horizontal_selection_index = 1

var max_hand_size = 7


func setup_deck():
	for i in 12:
		for j in 4:
			var card_instance = CARD_BASE.instantiate()
			card_instance.month = i+1
			
			var _is_none_type = randi_range(0,4)
			var _type = randi_range(0,2)
			if _is_none_type == 0:
				_type = 0
			
			card_instance.card_effect = _type
			card_instance.effect_amount = 0
			
			if _type != 0:
				var _positive = randi_range(0,3)
				var amount = 0
				if _positive == 0:
					amount = randi_range(-1,-2)
				else:
					amount = randi_range(1,2)
				
				if _type == 2: #points
					amount *= 25
				
				card_instance.effect_amount = amount
			base_deck.append(card_instance)
			
	deck = base_deck.duplicate()
	deck.shuffle()

func repopulate_deck():
	deck = base_deck.duplicate()
	deck.shuffle()

func populate_hand():
	if deck.is_empty():
		repopulate_deck()
	#adds cards until you have as many as max hand size
	if hand.size() < max_hand_size:
		for i in max_hand_size - hand.size():
			var _card = deck.pop_front()
			hand.append(_card)
			hand_node.add_child(_card)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_deck()
	populate_hand()
	reposition_cards_in_hand()
	pop_up_selected_card()
	
	play_label.modulate = Color.WHITE
	discard_label.modulate = Color.DIM_GRAY

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if horizontal_selection_index == 1:
		pop_up_selected_card()
		
		if Input.is_action_just_pressed("ui_left"):
			selection_index = max(0, selection_index-1)
			pop_up_selected_card()
			
		if Input.is_action_just_pressed("ui_right"):
			selection_index = min(hand.size()-1, selection_index+1)
			pop_up_selected_card()
		
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
	
	if Input.is_action_just_pressed("ui_down"):
		horizontal_selection_index = min(2, horizontal_selection_index+1)
	
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
	
	#reposition_cards_in_hand()

func select_card():
	hand[selection_index].selected = !hand[selection_index].selected

func play_hand():
	#calculate score here
	var scoring_numbers = []
	for card in hand:
		if card.selected:
			scoring_numbers.append(card.month)
	print(scoring_numbers)
	#if scoring_numbers.size()*(scoring_numbers.size()+1)/2
	
	for i in 200: #idk why but this works
		for card in hand:
			if card.selected:
				card.queue_free()
				hand.pop_at(hand.find(card))
				hand_node.remove_child(card)
				reposition_cards_in_hand()
	
	
	if deck.is_empty():
		repopulate_deck()
	
	populate_hand()
	reposition_cards_in_hand()

func discard():
	for i in 200: #idk why but this works
		for card in hand:
			if card.selected:
				card.queue_free()
				hand.pop_at(hand.find(card))
				hand_node.remove_child(card)
				reposition_cards_in_hand()
	
	if deck.is_empty():
		repopulate_deck()
	populate_hand()
	
	reposition_cards_in_hand()

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