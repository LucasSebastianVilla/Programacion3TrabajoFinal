extends CanvasLayer

onready var soundOfGame = $SoundsOfGame
onready var fxLabel = $SoundsOfGame/FxLabel
onready var musicLabel = $SoundsOfGame/MusicLabel

onready var buttons = $Buttons

func _ready():
	set_visible(false) #inicio en false para que no aparezca el menu pausado
	
func _input(event):
	if event.is_action_pressed("ui_cancel"): #boton de escape por defecto
		set_visible(!get_tree().paused) #si no esta en pausa lo oculto
		get_tree().paused = !get_tree().paused #cambia de estado

func _on_Continue_pressed(): #si se presiona el boton continuar el juego reanuda
	get_tree().paused = false
	set_visible(false)

func set_visible(is_visible): #configura la visibilidad de los nodos
	for node in get_children():
		node.visible = is_visible
		
	soundOfGame.visible = false

func _on_Fullscreen_pressed(): #permito que se pueda pasar a pantalla completa desde el menu pausa
	OS.window_fullscreen = !OS.window_fullscreen

func _on_Restart_pressed():
	get_tree().change_scene("res://scenes/Level1.tscn")

func _on_Back3_pressed():
	buttons.visible = true
	soundOfGame.visible = false
	
func _on_MusicButton_pressed():
	Global.music = !Global.music
	if Global.music:
		musicLabel.text = "ON"
	else:
		musicLabel.text = "OFF"

func _on_Sounds_pressed():
	buttons.visible = false
	soundOfGame.visible = true

func _on_FxButton_pressed():
	Global.fx = !Global.fx
	if Global.fx:
		fxLabel.text = "ON"
	else:
		fxLabel.text = "OFF"

