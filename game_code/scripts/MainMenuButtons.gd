extends Control

onready var vBoxButtons = $VBoxButtons
onready var narrative = $Narrative
onready var itemsOfGame = $ItemsOfGame
onready var soundOfGame = $SoundsOfGame
onready var fxLabel = $SoundsOfGame/FxLabel
onready var musicLabel = $SoundsOfGame/MusicLabel

func _on_Exit_pressed():
	get_tree().quit()

func _on_Play_pressed():
	get_tree().change_scene("res://scenes/Level1.tscn")

func _on_History_pressed():
	Global.parallaxScroll = false
	vBoxButtons.visible = false
	narrative.visible = true

func _on_Items_pressed():
	Global.parallaxScroll = false
	vBoxButtons.visible = false
	itemsOfGame.visible = true

func _on_Sounds_pressed():
	Global.parallaxScroll = false
	vBoxButtons.visible = false
	soundOfGame.visible = true

func _on_Back_pressed():
	Global.parallaxScroll = true
	vBoxButtons.visible = true
	narrative.visible = false
	
func _on_Back2_pressed():
	Global.parallaxScroll = true
	vBoxButtons.visible = true
	itemsOfGame.visible = false
	
func _on_Back3_pressed():
	Global.parallaxScroll = true
	vBoxButtons.visible = true
	soundOfGame.visible = false

func _on_MusicButton_pressed():
	Global.music = !Global.music
	if Global.music:
		musicLabel.text = "ON"
	else:
		musicLabel.text = "OFF"

func _on_FxButton_pressed():
	Global.fx = !Global.fx
	if Global.fx:
		fxLabel.text = "ON"
	else:
		fxLabel.text = "OFF"
