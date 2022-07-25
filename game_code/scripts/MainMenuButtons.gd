extends Control

onready var vBoxButtons = $VBoxButtons
onready var narrative = $Narrative
onready var itemsOfGame = $ItemsOfGame

func _on_Exit_pressed():
	get_tree().quit()

func _on_Play_pressed():
	get_tree().change_scene("res://scenes/Level1.tscn")

func _on_History_pressed():
	Global.parallaxScroll = false
	vBoxButtons.visible = false
	narrative.visible = true

func _on_Back_pressed():
	Global.parallaxScroll = true
	vBoxButtons.visible = true
	narrative.visible = false


func _on_Back2_pressed():
	Global.parallaxScroll = true
	vBoxButtons.visible = true
	itemsOfGame.visible = false

func _on_Items_pressed():
	Global.parallaxScroll = false
	vBoxButtons.visible = false
	itemsOfGame.visible = true
