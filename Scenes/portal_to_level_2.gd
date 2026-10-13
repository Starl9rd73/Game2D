extends Area2D # (Nếu bạn gắn script vào thẳng Portal)

func _on_body_entered(body):
	# Kiểm tra xem đối tượng chạm vào cửa có phải là nhân vật chính không
	if body.name == "Player":
		
		# 1. Lưu lại các chỉ số hiện tại lên "Đám mây" Global
		if Global:
			Global.player_hp = body.current_hp
			Global.player_gold = body.gold
			Global.current_level = 2 # Đánh dấu đã sang màn 2
			print("Đã lưu sang Global -> Máu: ", Global.player_hp, " | Vàng: ", Global.player_gold)
		# 2. Phát âm thanh chuyển màn (Nếu có)
		# $PortalSound.play()
		
		# 3. Ra lệnh chuyển sang Level 2 (Nhớ ĐỔI ĐƯỜNG DẪN cho đúng file Level2 của bạn)
		var err = get_tree().change_scene_to_file("res://Scenes/Level2.tscn")
		
		if err != OK:
			print("LỖI CHUYỂN CẢNH! Không tìm thấy file Level 2.")
