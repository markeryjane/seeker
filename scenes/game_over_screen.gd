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
@onready var year_bonus_text: Label = %YearBonusText

@onready var score_text: Label = %ScoreText
@onready var score_tick_sfx: AudioStreamPlayer = %ScoreTickSfx

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$GameOverSfx.play()
	
	var bonus_multiplier = 0
	
	if gameover_spring_bonus_active:
		#final_score *= 3
		bonus_multiplier += 3
		spring_bonus_text.text = "Spring bonus: x3"
	else:
		spring_bonus_text.modulate = Color.html("#ffffff32")
	if gameover_summer_bonus_active:
		#final_score *= 3
		bonus_multiplier += 3
		summer_bonus_text.text = "Summer bonus: x3"
	else:
		summer_bonus_text.modulate = Color.html("#ffffff32")
	if gameover_autumn_bonus_active:
		#final_score *= 3
		bonus_multiplier += 3
		autumn_bonus_text.text = "Autumn bonus: x3"
	else:
		autumn_bonus_text.modulate = Color.html("#ffffff32")
	if gameover_winter_bonus_active:
		#final_score *= 3
		bonus_multiplier += 3
		winter_bonus_text.text = "Winter bonus: x3"
	else:
		winter_bonus_text.modulate = Color.html("#ffffff32")
	if gameover_year_bonus_active:
		#final_score *= 5
		bonus_multiplier += 5
		year_bonus_text.text = "Year bonus: x5"
	else:
		year_bonus_text.modulate = Color.html("#ffffff32")
	
	final_score *= max(1,bonus_multiplier)
	var final_score_to_show = final_score
	final_score = 0
	
	await get_tree().create_timer(.9).timeout
	
	var tween = get_tree().create_tween()
	tween.tween_property(self, "final_score", final_score_to_show, .4)
	
	#score_text.text = str(final_score)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		SceneTransition.goToScene(load("res://scenes/title_screen.tscn"))
	
	if score_text.text != str(final_score):
		score_text.text = str(final_score)
		score_tick_sfx.play()
