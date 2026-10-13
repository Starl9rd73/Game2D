extends CanvasLayer

func _ready() -> void:
	pass 

# Khi bấm nút -> toggled_on là true -> Mute kênh Music
func _on_btn_music_toggled(toggled_on: bool) -> void:
	var bus_idx = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_mute(bus_idx, toggled_on)

# Khi bấm nút -> toggled_on là true -> Mute kênh SFX
func _on_btn_sound_toggled(toggled_on: bool) -> void:
	var bus_idx = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_mute(bus_idx, toggled_on)
