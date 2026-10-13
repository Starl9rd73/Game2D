extends Area2D

var gold_value = 10 # Trị giá mỗi cục vàng rớt ra

func _ready():
	# CHỈ ANIMATE CÁI ẢNH (Sprite2D), giữ nguyên gốc Area2D ở mặt đất
	if has_node("Sprite2D"):
		var tween = create_tween().set_loops()
		# Ảnh bay lên 15 pixel
		tween.tween_property($Sprite2D, "position:y", -15.0, 0.6).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		# Ảnh rớt về lại vị trí gốc 0
		tween.tween_property($Sprite2D, "position:y", 0.0, 0.6).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func _on_body_entered(body):
	if body.name == "Player":
		if body.has_method("collect_gold"):
			body.collect_gold(gold_value)
			queue_free() # Nhặt xong thì biến mất
