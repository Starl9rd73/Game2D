extends Area2D

@export var speed: float = 140.0         # Tốc độ bay đuổi theo
@export var escape_speed: float = 250.0  # Tốc độ bay vút lên trời khi hoàn thành nhiệm vụ
@export var heal_distance: float = 40.0  # Khoảng cách tối thiểu để tiến hành bơm máu
@onready var sprite: Sprite2D = $Sprite2D

var target: Node2D = null                # Mục tiêu (Player)
var has_healed: bool = false             # Đánh dấu đã hồi máu chưa (chỉ 1 lần)

func _ready() -> void:
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	if not has_healed:
		# TRẠNG THÁI 1: Chưa hồi máu -> Bay đuổi theo Player
		if target != null:
			var distance = global_position.distance_to(target.global_position)
			
			# Kiểm tra xem đã bay đến sát người chơi chưa
			if distance > heal_distance:
				# Vẫn đang ở xa -> Tiếp tục bay lại gần
				var direction = global_position.direction_to(target.global_position)
				global_position += direction * speed * delta
				
				# Quay đầu trái/phải theo hướng bay
				if direction.x < 0:
					sprite.flip_h = true
				elif direction.x > 0:
					sprite.flip_h = false
			else:
				# Đã bay đến sát người chơi -> Tiến hành HỒI MÁU
				perform_heal(target)
	else:
		# TRẠNG THÁI 2: Đã hồi máu xong -> Bay thẳng vút lên trên trời và biến mất
		global_position.y -= escape_speed * delta 
		
		# Hiệu ứng mờ dần (Fade out)
		modulate.a -= delta * 2.0 
		if modulate.a <= 0:
			call_deferred("queue_free")

# Khi Player bước vào vùng phát hiện rộng của Drone
func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" and not has_healed:
		target = body # Gán mục tiêu để chuẩn bị bay đến

# Hàm thực hiện hồi máu khi đã tiếp cận sát người chơi
func perform_heal(player: Node2D) -> void:
	if "current_hp" in player and "max_hp" in player:
		if player.current_hp < player.max_hp:
			player.current_hp = min(player.current_hp + 50, player.max_hp)
			
			# Nếu Player có hàm update_hud hoặc health_bar, gọi nó để thanh máu cập nhật ngay lập tức
			if player.has_method("update_hud"):
				player.update_hud()
			if player.has_node("UI/HealthBar"):
				player.get_node("UI/HealthBar").value = player.current_hp
				
			has_healed = true # Khóa lại, kích hoạt trạng thái bay vụt lên trời
			print("Medic Bot đã áp sát, bơm 50 máu thành công và cất cánh bay đi!")
