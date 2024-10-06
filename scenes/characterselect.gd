extends Node2D

@onready var char_3: Node2D = %char3
@onready var char_2: Node2D = %char2
@onready var char_1: Node2D = %char1
@onready var marker: Node2D = %Marker
@onready var description_text: Label = %DescriptionText
@onready var move_cursor_sfx: AudioStreamPlayer = %MoveCursorSfx
@onready var select_sfx: AudioStreamPlayer = %SelectSfx

var selected = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_right"):
		selected += 1
		move_cursor_sfx.play()
	if Input.is_action_just_pressed("ui_left"):
		selected -= 1
		move_cursor_sfx.play()
	
	if selected > 2:
		selected = 0
	if selected < 0:
		selected = 2
	
	if selected == 0:
		marker.position = char_1.global_position
		description_text.text = "Hold 7 cards"
	elif selected == 1:
		marker.position = char_2.global_position
		description_text.text = "Bonus cards are worth more"
	elif selected == 2:
		marker.position = char_3.global_position
		description_text.text = "Start with 7 turns"
	
	if Input.is_action_just_pressed("ui_accept"):
		select_sfx.play()
		SignalBus.character_selected = selected
		SceneTransition.goToScene(preload("res://scenes/main_scene.tscn"))
