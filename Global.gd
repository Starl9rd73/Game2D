extends Node

# --- CÁC BIẾN LƯU TRỮ TOÀN CỤC ---
var player_hp = 100
var player_max_hp = 100
var player_gold = 0
var current_level = 1
var player_has_shield = false

# --- HÀM KHÔI PHỤC CHỈ SỐ VỀ MẶC ĐỊNH ---
# Dùng khi bấm nút "Chơi lại" ở màn hình Game Over
func reset_stats():
	player_hp = player_max_hp
	player_gold = 0
	current_level = 1
	player_has_shield = false

# (Tùy chọn) Hàm cập nhật thông tin trước khi chuyển qua Level mới
func save_player_state(hp, gold, shield):
	player_hp = hp
	player_gold = gold
	player_has_shield = shield
