extends Control

var months_played = [false, false, false, false, false, false, false, false, false, false, false, false]
@onready var month_container: HBoxContainer = %MonthContainer

var month_colors = ["#0091de", "#ff8ec0", "#ff7a69", "#61f2ce", "#f5d67d", "#ff0a37", "#3284ff", "#a88246", "#7d4f4e", "#d06900", "#b63900", "#2a4fff"]

var spring_bonus_active = false
var summer_bonus_active = false
var autumn_bonus_active = false
var winter_bonus_active = false
var year_bonus_active = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var _index = 0
	for label in month_container.get_children():
		if months_played[_index]:
			label.modulate =Color.html(month_colors[_index])
		else:
			label.modulate = Color.html("#ffffff14")
		_index += 1

func activate_month(month:int) -> void:
	months_played[month-1] = true
	
	if months_played[11] and months_played[0] and months_played[1]:
		winter_bonus_active = true
	if months_played[2] and months_played[3] and months_played[4]:
		spring_bonus_active = true
	if months_played[6] and months_played[7] and months_played[5]:
		summer_bonus_active = true
	if months_played[8] and months_played[9] and months_played[10]:
		autumn_bonus_active = true
	if winter_bonus_active and spring_bonus_active and summer_bonus_active and autumn_bonus_active:
		year_bonus_active = true
