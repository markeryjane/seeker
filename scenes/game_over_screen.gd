extends Node2D

var final_score:int = 0
var gameover_spring_bonus_active = false
var gameover_summer_bonus_active = false
var gameover_autumn_bonus_active = false
var gameover_winter_bonus_active = false
var gameover_year_bonus_active = false
@onready var winter_bonus_text: Label = %WinterBonusText
@onready var spring_bonus_text: Label = %SpringBonusText
@onready var summer_bonus_text: Label = %SummerBonusText
@onready var autumn_bonus_text: Label = %AutumnBonusText

@onready var score_text: Label = %ScoreText

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	score_text.text = str(final_score)
	if gameover_spring_bonus_active:
		spring_bonus_text.text = "Spring bonus: x3"
	else:
		spring_bonus_text.modulate = Color.html("#ffffff32")
	if gameover_summer_bonus_active:
		summer_bonus_text.text = "Summer bonus: x3"
	else:
		summer_bonus_text.modulate = Color.html("#ffffff32")
	if gameover_autumn_bonus_active:
		autumn_bonus_text.text = "Autumn bonus: x3"
	else:
		autumn_bonus_text.modulate = Color.html("#ffffff32")
	if gameover_winter_bonus_active:
		winter_bonus_text.text = "Winter bonus: x3"
	else:
		winter_bonus_text.modulate = Color.html("#ffffff32")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		SceneTransition.goToScene(load("res://scenes/title_screen.tscn"))
