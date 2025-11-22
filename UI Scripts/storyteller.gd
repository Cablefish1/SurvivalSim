extends RichTextLabel



func _ready() -> void:
	tell_player("Storyteller online")

func tell_player(text_to_tell : String):
	add_text(text_to_tell)
	newline()
