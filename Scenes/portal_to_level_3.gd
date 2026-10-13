extends Area2D

func _ready() -> void:
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	# Kiểm tra xem người chơi có bước vào cổng không
	if body.name == "Player":
		# 1. Lưu lại toàn bộ chỉ số hiện tại lên "Đám mây" Global
		if Global:
			Global.player_hp = body.current_hp
			Global.player_gold = body.gold
			Global.current_level = 3 # Đánh dấu sang màn 3
			print("Đã lưu trạng thái -> Chuyển sang Level 3. Máu: ", Global.player_hp, " | Vàng: ", Global.player_gold)
		
		# 2. Chuyển cảnh sang file Level3.tscn
		var err = get_tree().change_scene_to_file("res://Scenes/Level3.tscn")
		
		if err != OK:
			print("LỖI: Không tìm thấy file Level3.tscn! Hãy kiểm tra lại đường dẫn.")
