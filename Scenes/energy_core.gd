extends Area2D

func _ready() -> void:
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	# Kiểm tra xem người nhặt có phải là Player không
	if body.name == "Player":
		print("Đã nhặt thành công Lõi Năng Lượng! Kích hoạt chiến thắng!")
		
		# (Tùy chọn) Cộng thêm vàng hoặc điểm thưởng nếu thích
		if "gold" in body:
			body.gold += 100
			if body.has_method("update_hud"):
				body.update_hud()
		
		# Phát âm thanh chiến thắng (nếu có)
		# $WinSound.play()
		
		# Chuyển thẳng sang Màn hình Win (WinScreen)
		get_tree().change_scene_to_file("res://Scenes/WinScreen.tscn")
