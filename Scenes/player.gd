extends CharacterBody2D

# --- BIẾN EXPORT CHỐNG HARDCODE CƠ CHẾ DI CHUYỂN ---
@export var normal_speed: float = 300.0
@export var dash_speed: float = 1200.0
@export var buff_speed: float = 600.0
@export var trap_speed: float = 100.0
@export var jump_velocity: float = -400.0

# --- BIẾN EXPORT CHỐNG HARDCODE SÁT THƯƠNG ---
@export var normal_dmg: int = 35
@export var heavy_dmg: int = 100
@export var skill_dmg: int = 10

var current_speed: float = normal_speed
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var facing_direction = "east"

# --- HUD ---
@onready var health_bar = get_node_or_null("UI/HealthBar")
@onready var lbl_gold = get_node_or_null("UI/LbGold")
@onready var lbl_shield = get_node_or_null("UI/LbShield")

@export var max_hp: int = 100
var current_hp: int = 100
var is_dead = false
var gold = 0
var has_shield = false

var bullet_scene = preload("res://PlayerBullet.tscn")

func _ready():
	# Nạp lại dữ liệu từ Global nếu có chuyển màn chơi để không bị reset chỉ số
	if Global:
		current_hp = Global.player_hp
		gold = Global.player_gold
	else:
		current_hp = max_hp
		
	if health_bar != null:
		health_bar.max_value = max_hp
		health_bar.value = current_hp
	update_hud()

func update_hud():
	if lbl_gold != null:
		lbl_gold.text = "Vàng: " + str(gold)
	if lbl_shield != null:
		if has_shield:
			lbl_shield.text = "Khiên: ĐANG BẬT"
			lbl_shield.modulate = Color.CYAN # Về sau nên thay bằng Animation thật
		else:
			lbl_shield.text = "Khiên: TẮT"
			lbl_shield.modulate = Color.WHITE

func _input(event):
	if is_dead: return
	
	# [TẤN CÔNG 1] Dùng Input Map "shoot" thay cho MOUSE_BUTTON_LEFT
	if Input.is_action_just_pressed("shoot"):
		shoot_skill(1.0, Color.WHITE, normal_dmg)
		
	# [TẤN CÔNG 2] Dùng Input Map "heavy_shoot" thay cho MOUSE_BUTTON_RIGHT
	if Input.is_action_just_pressed("heavy_shoot"):
		shoot_skill(2.5, Color.RED, heavy_dmg)
		
	# [TẤN CÔNG 3] Dùng Input Map "skill_shoot" (Bắn liên thanh dùng is_action_pressed)
	if Input.is_action_pressed("skill_shoot"):
		shoot_skill(0.5, Color.YELLOW, skill_dmg)

	# [PHÒNG THỦ 1] Bật khiên
	if Input.is_action_just_pressed("shield") and not has_shield:
		activate_shield()

	# [PHÒNG THỦ 2] Lướt (Dash)
	if Input.is_action_just_pressed("dash"):
		dash()

func activate_shield():
	has_shield = true
	update_hud()
	$AnimatedSprite2D.modulate = Color.CYAN 
	await get_tree().create_timer(3.0).timeout 
	has_shield = false
	update_hud()
	$AnimatedSprite2D.modulate = Color.WHITE

func dash():
	current_speed = dash_speed 
	await get_tree().create_timer(0.2).timeout
	current_speed = normal_speed

func shoot_skill(size_scale, bullet_color, damage_amount):
	var bullet = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = global_position
	bullet.look_at(get_global_mouse_position())
	
	bullet.scale = Vector2(size_scale, size_scale)
	bullet.modulate = bullet_color
	bullet.set("damage", damage_amount) 
	
	if has_node("SoundShoot"):
		$SoundShoot.play()

func _physics_process(delta):
	if is_dead: return
	
	if not is_on_floor(): velocity.y += gravity * delta
	if Input.is_action_just_pressed("ui_accept") and is_on_floor(): velocity.y = jump_velocity

	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * current_speed
		facing_direction = "east" if direction > 0 else "west"
		$AnimatedSprite2D.play("run_" + facing_direction)
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		if Input.is_action_pressed("ui_up"): facing_direction = "north"
		elif Input.is_action_pressed("ui_down"): facing_direction = "south"
		if is_on_floor(): $AnimatedSprite2D.play("idle_" + facing_direction)
			
	move_and_slide()

func take_damage(damage):
	if is_dead: return
	
	if has_shield:
		has_shield = false 
		update_hud()
		$AnimatedSprite2D.modulate = Color.WHITE
		return 
		
	current_hp -= damage 
	if health_bar != null:
		health_bar.value = current_hp
	
	$AnimatedSprite2D.modulate = Color.RED 
	var tween = create_tween()
	tween.tween_property($AnimatedSprite2D, "modulate", Color.WHITE, 0.2)
	
	if current_hp <= 0:
		is_dead = true
		get_tree().call_deferred("change_scene_to_file", "res://Scenes/GameOver.tscn")

func collect_buff():
	gold += 50 
	update_hud() # Cập nhật UI ngay lập tức khi nhận buff tăng vàng
	current_speed = buff_speed # Dùng biến export thay vì số cứng 600
	await get_tree().create_timer(3.0).timeout
	current_speed = normal_speed

func step_on_trap():
	current_speed = trap_speed # Dùng biến export thay vì số cứng 100
	$AnimatedSprite2D.modulate = Color.GREEN 
	await get_tree().create_timer(2.0).timeout
	current_speed = normal_speed
	$AnimatedSprite2D.modulate = Color.WHITE
	
# --- HIỆU ỨNG CHỮ NỔI SÁT THƯƠNG ---
func show_damage_text(damage_amount):
	var label = Label.new()
	label.text = "-" + str(damage_amount)
	
	# Chỉnh form chữ: Màu đỏ, có viền đen cho dễ nhìn, size to
	label.modulate = Color.RED
	label.add_theme_font_size_override("font_size", 24)
	label.add_theme_color_override("font_outline_color", Color.BLACK)
	label.add_theme_constant_override("outline_size", 4)
	
	# Thêm chữ vào thẳng map (để chữ không bị lật ngược nếu quái quay đầu)
	get_tree().current_scene.add_child(label)
	
	# Đặt vị trí chữ xuất hiện ở ngay trên đầu quái vật (Thêm chút ngẫu nhiên để chữ không đè lên nhau)
	var random_offset = Vector2(randf_range(-20, 20), -40)
	label.global_position = global_position + random_offset
	
	# Tạo hiệu ứng Animation (Tween): Chữ bay lên trên và mờ dần trong 0.6 giây
	var tween = create_tween()
	tween.tween_property(label, "global_position", label.global_position + Vector2(0, -50), 0.6)
	tween.parallel().tween_property(label, "modulate:a", 0.0, 0.6) # Giảm độ trong suốt (alpha) về 0
	tween.tween_callback(label.queue_free) # Bay xong thì tự xóa để nhẹ máy
	
func collect_gold(amount):
	gold += amount 
	update_hud() # Gọi hàm cập nhật UI chữ LbGold ngay lập tức
