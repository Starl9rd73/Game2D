extends Node

var enemy_scene = preload("res://Scenes/Enemy.tscn")

# Bắt cả 2 tên hàm phòng trường hợp bạn nối dây tín hiệu bằng tên nào đi nữa
func _on_enemy_spawner_timeout():
	spawn_enemy()

func _on_timeout():
	spawn_enemy()

func spawn_enemy():
	var enemy = enemy_scene.instantiate()
	get_tree().current_scene.add_child(enemy)
	
	# ÉP QUÁI LUÔN XUẤT HIỆN NGAY TRƯỚC MẶT PLAYER 800 PIXEL
	var player = get_tree().current_scene.get_node_or_null("Player")
	if player != null:
		# Rớt cách người chơi 800px về phía bên phải
		enemy.global_position.x = player.global_position.x + 800
		# Rớt ngẫu nhiên trên không trung (cao hơn người chơi 100-400px)
		enemy.global_position.y = player.global_position.y - randf_range(100, 400)
