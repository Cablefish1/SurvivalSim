extends Control

@onready var storyteller = $Panel/Storyteller
@onready var player = $PlayerDataObject



# Called when the node enters the scene tree for the first time.
func _ready():
	display_text("Game initiated")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func display_text(text):
	storyteller.add_text(text)
	storyteller.newline()


func display_skills():
	for skill in player.skills:
		var value = player.skills[skill]
		storyteller.add_text(str(skill))
		storyteller.add_text(str(value))
		storyteller.newline()
		

func _on_display_sheet_pressed():
	display_skills()
