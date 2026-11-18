extends CanvasLayer


@export var game: Node = null

@onready var money_label: Label = $StatsPanel/MarginContainer/VBoxContainer/MoneyLabel
@onready var time_label: Label = $StatsPanel/MarginContainer/VBoxContainer/TimeLabel
@onready var stats_panel: PanelContainer = $StatsPanel
@onready var game_over_panel: PanelContainer = $GameOverPanel
@onready var game_over_money_label: Label = $GameOverPanel/MarginContainer/VBoxContainer/MoneyEarned
@onready var game_over_time_label: Label = $GameOverPanel/MarginContainer/VBoxContainer/FinalTime


func _process(_delta: float) -> void:
	var is_day_running: bool = bool(game.get("day_running"))
	stats_panel.visible = is_day_running
	game_over_panel.visible = not is_day_running

	var current_money := int(game.get("money"))
	var seconds_left := ceili(float(game.get("day_time_left")))
	var minutes := int(seconds_left / 60)
	var seconds := seconds_left % 60

	money_label.text = "Money: $%d" % current_money
	time_label.text = "Time Left: %02d:%02d" % [minutes, seconds]

	if not is_day_running:
		game_over_time_label.text = "Time: 00:00"
		game_over_money_label.text = "Money Earned: $%d" % current_money
