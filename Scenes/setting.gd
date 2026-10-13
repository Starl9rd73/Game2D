extends Control

# Lấy ID của các kênh âm thanh từ hệ thống Godot
var music_bus = AudioServer.get_bus_index("Music")
var sfx_bus = AudioServer.get_bus_index("SFX")

func _ready():
	# Mở khóa hệ thống (Phòng trường hợp bạn vào Settings khi đang Pause game)
	get_tree().paused = false 
	
	# Khi vừa mở bảng Setting, ép thanh trượt chạy tới đúng vị trí âm lượng hiện tại
	if has_node("VBoxContainer/SliderMusic"):
		$VBoxContainer/SliderMusic.value = db_to_linear(AudioServer.get_bus_volume_db(music_bus))
	
	if has_node("VBoxContainer/SliderSFX"):
		$VBoxContainer/SliderSFX.value = db_to_linear(AudioServer.get_bus_volume_db(sfx_bus))

# Kéo thanh trượt NHẠC NỀN
func _on_slider_music_value_changed(value):
	# Dùng linear_to_db để chuyển dải số 0.0->1.0 thành chuẩn Decibel của Godot (-80dB tới 0dB)
	AudioServer.set_bus_volume_db(music_bus, linear_to_db(value))

# Kéo thanh trượt HIỆU ỨNG (SFX/VFX)
func _on_slider_sfx_value_changed(value):
	AudioServer.set_bus_volume_db(sfx_bus, linear_to_db(value))

# Nút QUAY LẠI
func _on_btn_back_pressed():
	# Chuyển về lại màn hình Main Menu (Hoặc Game Over tùy ý bạn)
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
