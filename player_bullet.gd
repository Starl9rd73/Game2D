extends Area2D

var speed = 800.0
var damage = 100 

func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * speed * delta

func _on_body_entered(body):
	# Bỏ qua người chơi và các viên đạn khác
	if body.name == "Player" or "Bullet" in body.name:
		return
		
	if body.has_method("take_damage"):
		# Chỉ nổ và trừ máu khi con quái thực sự CÒN SỐNG (hp > 0)
		if body.get("hp") != null and body.get("hp") > 0:
			body.take_damage(damage)
			queue_free() # Trúng mục tiêu hợp lệ -> Hủy đạn
	else:
		# Trúng tường/sàn -> Hủy đạn
		queue_free()
