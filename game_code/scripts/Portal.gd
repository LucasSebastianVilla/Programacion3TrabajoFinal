tool
#El cambio de escena se hace gracias a este tutorial
#https://www.youtube.com/watch?v=tp1OiUEq3Pk

extends Area2D

export(String, FILE) var next_scene_path = ""
export(Vector2) var player_spawn_location = Vector2.ZERO
export(int) var player_direction


func _get_configuration_warning() -> String:
	if next_scene_path == "":
		return "Advertencia: next_scene_path debe estar configurada para que funcione el portal"
	else:
		return ""

func _on_Portal_body_entered(body):
	Global.player_initial_map_position = player_spawn_location
	Global.player_facing_direction = player_direction
	if get_tree().change_scene(next_scene_path) != OK:
		print ("Error: La escena no se pudo cargar")
