extends Control

func _ready() -> void:
	# Hiện chuột khi vào màn hình UI để người chơi dễ bấm nút
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

# 1. Nút REPLAY: Chơi lại từ đầu (Reset Level 1)
func _on_btn_replay_pressed() -> void:
	Global.player_hp = 100 # Reset máu gốc
	Global.player_gold = 0 # Reset vàng
	Global.current_level = 1
	get_tree().change_scene_to_file("res://Scenes/Level1.tscn") # Đổi đường dẫn nếu file Level 1 của bạn khác

# 2. Nút HOME SCREEN: Quay về màn hình chính (Menu)
func _on_btn_home_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn") # Đổi đường dẫn tới Main Menu của bạn

# 3. Nút HIGH ACHIEVEMENTS: Xem thành tích cao / Bảng vinh danh
func _on_btn_achievements_pressed() -> void:
	# Nếu bạn chưa làm scene Achievement riêng, có thể tạm thời in ra console hoặc hiện Popup thông báo
	print("Hiển thị bảng Thành tích cao: Điểm số của bạn đã được ghi nhận!")
	
	# Hoặc nếu muốn tạo một Label thông báo tạm thời trên màn hình khi bấm nút:
	$BtnAchievements.text = "Vàng tích lũy: " + str(Global.player_gold) + " - Xuất sắc!"


func _on_btn_setting_pressed() -> void:
	pass # Replace with function body.
