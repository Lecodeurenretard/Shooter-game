extends CanvasLayer

signal continuing()

func unpause() -> void:
	continuing.emit()

func quit() -> void:
	get_tree().quit()
