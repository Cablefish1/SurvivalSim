extends RichTextLabel


func _ready() -> void:
	connect("storyteller_tell_player", Callable(self, "tell_player"))

func tell_player(text_to_tell : String):
	add_text(text_to_tell)
	newline()
