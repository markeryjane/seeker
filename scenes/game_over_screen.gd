extends Node2D

var final_score:int = 0
@onready var score_text: Label = %ScoreText

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	score_text.text = str(final_score)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		SceneTransition.goToScene(load("res://scenes/title_screen.tscn"))
