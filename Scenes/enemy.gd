extends CharacterBody2D

var speed = 150.0
var chase_speed = 220.0 # Tốc độ khi lao vào rượt đuổi player
var direction = -1 
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var hp = 100 
var is_dead = false # Khóa trạng thái chống rớt vàng 2 lần
var gold_scene = preload("res://Scenes/GoldDrop.tscn") # Đã thêm file vàng

# 2 biến khóa để xử lý chuẩn logic "Mỗi lần đi vào"
var is_in_zone = false
var is_playing_warning = false 

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	# --- BAREM: CẢNH BÁO & AI RƯỢT ĐUỔI MỖI LẦN VÀO VÙNG CẤM ---
	var player = get_parent().get_node_or_null("Player")
	if player != null:
		var distance = global_position.distance_to(player.global_position)
		
		# KHI PLAYER BƯỚC VÀO VÙNG CẤM (< 300px)
		if distance < 300:
			# 1. Kích hoạt cảnh báo (nếu chưa vào vùng trước đó)
			if not is_in_zone:
				is_in_zone = true
				if not is_playing_warning:
					play_warning_sound()
			
			# 2. HÀNH VI THÔNG MINH: Đuổi theo Player!
			var move_dir = global_position.direction_to(player.global_position)
			velocity.x = move_dir.x * chase_speed
			
			# Quay đầu sprite theo hướng rượt đuổi
			if move_dir.x < 0:
				$AnimatedSprite2D.flip_h = false # Hoặc chỉnh theo animation hiện tại của bạn
				$AnimatedSprite2D.play("Running_west")
			else:
				$AnimatedSprite2D.flip_h = true
				$AnimatedSprite2D.play("Running_west") # Hoặc tạo animation hướng ngược lại
				
		# KHI PLAYER Ở XÃ (>= 300px) -> Quay về tuần tra bình thường
		else:
			is_in_zone = false 
			velocity.x = direction * speed
			$AnimatedSprite2D.play("Running_west")

	move_and_slide()

# Hàm báo động ngẫu nhiên 3 đến 6 lần
func play_warning_sound():
	is_playing_warning = true # Khóa lại để chống bị kêu đè lên nhau
	var loops = randi_range(3, 6) # Tự động bốc ngẫu nhiên số lần lặp từ 3 đến 6
	
	for i in range(loops): 
		if has_node("WarningSound"):
			$WarningSound.play()
		await get_tree().create_timer(0.5).timeout # Cách nhau 0.5 giây
		
	is_playing_warning = false # Kêu đủ số lần thì mở khóa
	
# XỬ LÝ SÁT THƯƠNG KHI CHẠM PLAYER
func _on_damage_zone_body_entered(body):
	if body.name == "Player":
		if body.has_method("take_damage"):
			body.take_damage(1)

# --- HÀM NHẬN SÁT THƯƠNG TỪ ĐẠN CỦA PLAYER ---
func take_damage(amount):
	if is_dead: return 
	
	hp -= amount
	show_damage_text(amount) 
	
	if hp <= 0:
		is_dead = true 
		
		# --- HỆ THỐNG RỚT VÀNG ---
		if gold_scene != null: 
			var dropped_gold = gold_scene.instantiate()
			get_tree().current_scene.call_deferred("add_child", dropped_gold)
			dropped_gold.global_position = global_position 
		
		# --- DỌN DẸP XÁC QUÁI TỐI GIẢN & AN TOÀN NHẤT ---
		visible = false 
		queue_free()
		return 
		
	$AnimatedSprite2D.modulate = Color.RED
	var tween = create_tween()
	if tween:
		tween.tween_property($AnimatedSprite2D, "modulate", Color.WHITE, 0.1)

# --- HIỆU ỨNG CHỮ NỔI SÁT THƯƠNG ---
func show_damage_text(damage_amount):
	var label = Label.new()
	label.text = "-" + str(damage_amount)
	
	label.modulate = Color.RED
	label.add_theme_font_size_override("font_size", 24)
	label.add_theme_color_override("font_outline_color", Color.BLACK)
	label.add_theme_constant_override("outline_size", 4)
	
	get_tree().current_scene.add_child(label)
	
	var random_offset = Vector2(randf_range(-20, 20), -40)
	label.global_position = global_position + random_offset
	
	var tween = label.create_tween()
	tween.tween_property(label, "global_position", label.global_position + Vector2(0, -50), 0.6)
	tween.parallel().tween_property(label, "modulate", Color(1, 0, 0, 0), 0.6)
	tween.tween_callback(label.queue_free)
