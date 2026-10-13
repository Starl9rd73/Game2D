extends Control

func _ready():
	# ĐÁP ỨNG BAREM: Phát hiệu ứng âm thanh xxx khi hiển thị
	if has_node("SoundGameOver"):
		$SoundGameOver.play()
	
	# Đảm bảo khi Game Over, thời gian game không bị đóng băng nếu trước đó bạn dùng pause
	get_tree().paused = false 

# --- ĐÁP ỨNG BAREM: 3 NÚT ĐIỀU HƯỚNG CÓ ĐẦY ĐỦ CHỨC NĂNG ---

# Nút 1: Chơi lại (Replay)
func _on_btn_replay_pressed():
	# Nếu bạn đã tạo file Global Autoload thì gọi hàm reset chỉ số máu/vàng ở đây
	if Engine.has_singleton("Global"):
		Global.reset_stats()
	
	# Tải lại màn chơi hiện tại hoặc màn Level 1
	get_tree().change_scene_to_file("res://Scenes/Gameplay.tscn") # Đổi tên Gameplay.tscn cho đúng với file map của bạn

# Nút 2: Về Màn hình chính (Home Screen)
func _on_btn_home_pressed():
	# Chuyển hướng về Main Menu
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn") 

func _on_btn_setting_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Setting.tscn")
