extends Node2D
@onready var back_group: Node2D = %BackGroup
@onready var month_label: Label = %MonthLabel
@onready var month_label_number: Label = %MonthLabelNumber
@onready var effect_label_amount: Label = %EffectLabelAmount
@onready var effect_label_type: Label = %EffectLabelType
@onready var selected_icon: Node2D = %SelectedIcon
@onready var outline: ColorRect = %Outline



enum effect_type {NONE, ADD_TURN, ADD_POINTS}
var effect_amount = -5
var month = 5
var card_effect = effect_type.NONE

var selected = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var _index = 1
	for background in back_group.get_children():
		if _index == month:
			background.visible = true
		else:
			background.visible = false
		_index += 1
		
	month_label_number.text = "("+str(month)+") "
	
	match(month):
		1:
			month_label.text = "January"
		2:
			month_label.text = "February"
		3:
			month_label.text = "March"
		4:
			month_label.text = "April"
		5:
			month_label.text = "May"
		6:
			month_label.text = "June"
		7:
			month_label.text = "July"
		8:
			month_label.text = "August"
		9:
			month_label.text = "September"
		10:
			month_label.text = "October"
		11:
			month_label.text = "November"
		12:
			month_label.text = "December"
	
	
	match(card_effect):
		effect_type.NONE:
			effect_label_amount.text = ""
			effect_label_type.text = ""
		effect_type.ADD_POINTS:
			if effect_amount > 0:
				effect_label_amount.text = "+"+str(effect_amount)
			else:
				effect_label_amount.text = str(effect_amount)
			effect_label_type.text = " points"
		effect_type.ADD_TURN:
			if effect_amount > 0:
				effect_label_amount.text = "+"+str(effect_amount)
			else:
				effect_label_amount.text = str(effect_amount)
			effect_label_type.text = " turns"
	reset_pop()
	
	
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(0,0), .001)
	tween.tween_property(self, "scale", Vector2(.8,.8), .3)
	
	#$Node2D/CPUParticles2D.emitting = true
	#var month_colors = ["#0091de", "#ff8ec0", "#ff7a69", "#61f2ce", "#f5d67d", "#ff0a37", "#3284ff", "#a88246", "#7d4f4e", "#d06900", "#b63900", "#2a4fff"]
	#$Node2D/CPUParticles2D.color = month_colors[month-1]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	selected_icon.visible = selected

func destroy():
	#$Node2D/CPUParticles2D.emitting = true
	#var month_colors = ["#0091de", "#ff8ec0", "#ff7a69", "#61f2ce", "#f5d67d", "#ff0a37", "#3284ff", "#a88246", "#7d4f4e", "#d06900", "#b63900", "#2a4fff"]
	#$Node2D/CPUParticles2D.color = month_colors[month-1]
	var tween = get_tree().create_tween()
	#tween.tween_property(self, "scale", Vector2(0,0), .001)
	tween.tween_property(self, "scale", Vector2(0,0), .3)
	await get_tree().create_timer(1.0).timeout
	queue_free()

func pop_up():
	scale = Vector2(1,1)
	z_index = 100
	outline.visible = true

func reset_pop():
	scale = Vector2(.7,.7)
	z_index = 0
	outline.visible = false
