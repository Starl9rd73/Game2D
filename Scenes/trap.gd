extends Area2D

# Lượng máu sẽ bị trừ khi dẫm phải bẫy
var damage_amount = 20

func _on_body_entered(body: Node2D) -> void:
	# Kiểm tra xem vật thể chạm vào bẫy có chính xác là "Player" không
	if body.name == "Player":
		# Kiểm tra an toàn xem Player có hàm take_damage không để tránh báo lỗi
		if body.has_method("take_damage"):
			body.take_damage(damage_amount)
			
			# In ra bảng Output bên dưới để lúc báo cáo dễ kiểm tra (Debug)
			print("Đạp trúng bẫy! Lượng máu hiện tại: ", body.current_hp)
