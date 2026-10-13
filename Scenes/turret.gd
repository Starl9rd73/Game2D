extends StaticBody2D

# Gọi file Đạn (Bullet) dành riêng cho trụ súng
var bullet_scene = preload("res://Bullet.tscn")
var player_target = null

func _physics_process(_delta):
	if player_target != null:
		# Nếu Player đứng bên trái súng
		if player_target.global_position.x < global_position.x:
			$AnimatedSprite2D.flip_h = false
			# Kéo nòng súng (Muzzle) sang bên trái cho khớp ảnh
			$Muzzle.position.x = -abs($Muzzle.position.x)
		# Nếu Player đứng bên phải súng
		else:
			$AnimatedSprite2D.flip_h = true
			# Trả nòng súng (Muzzle) về bên phải
			$Muzzle.position.x = abs($Muzzle.position.x)

# Khi Player vào tầm ngắm
func _on_detection_zone_body_entered(body):
	if body.name == "Player":
		player_target = body
		$AnimatedSprite2D.play("alert")
		$FireTimer.start() # Bắt đầu nhịp đếm giờ bắn

# Khi Player chạy khỏi tầm ngắm
func _on_detection_zone_body_exited(body):
	if body.name == "Player":
		player_target = null
		$AnimatedSprite2D.play("idle")
		$FireTimer.stop() # Ngừng bắn

# Mỗi khi Timer đếm ngược xong (1 giây 1 lần)
func _on_fire_timer_timeout():
	if player_target != null:
		shoot()

func shoot():
	$AnimatedSprite2D.play("fire") # Bật animation giật nòng súng
	
	var bullet = bullet_scene.instantiate()
	
	# 1. BẮT BUỘC: Thêm đạn vào màn chơi TRƯỚC để đồng bộ hệ tọa độ
	get_tree().current_scene.add_child(bullet)
	
	# 2. Đặt viên đạn đúng vị trí nòng súng SAU KHI đã thêm vào màn
	bullet.global_position = $Muzzle.global_position
	
	# 3. TỰ ĐỘNG CHỈA THẲNG ĐẦU ĐẠN VÀO PLAYER
	bullet.look_at(player_target.global_position)
	
	# 4. PHÁT ÂM THANH BẮN ĐẠN (Thêm theo yêu cầu)
	if has_node("SoundShoot"):
		$SoundShoot.play()
