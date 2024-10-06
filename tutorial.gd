extends Node2D
@onready var play_label: Label = %PlayLabel

var level = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.connect("played_hand", just_played_hand)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func just_played_hand():
	print("played hand")
	level += 1
	
	if level == 1:
		play_label.text = "The more months, the more you score. \nCollect a season for a bonus."
	if level == 2:
		play_label.text = "The game ends when December is played, \nor you run out of turns."
	if level == 3:
		play_label.text = ""
		visible = false
