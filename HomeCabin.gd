extends Button

@onready var popup = $HomeCabinPopup
@onready var player = $"../../../PlayerDataObject"
@onready var storyteller = $"../../../StorytellerPanel/Storyteller"

signal advance_time(hours)
signal sleep_popup()

var roof_thatched : bool = false
var bed_fixed : bool = false
var fire_built : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.




func _on_pressed():
	popup.show()
	popup.clear()
	popup.add_item("Cut firewood using woodcraft (1 hour)", 1)
	if(fire_built == false && player.inventory["Firewood"] >= 1):
		popup.add_item("Build Fire using 1 firewood (instant)", 2)
	if(player.inventory["Unpreserved food"] + player.inventory["Preserved food"] > 0 && player.food_eaten_today == false):
		popup.add_item("Eat 1 food", 3)
	
	popup.add_item("Go to sleep", 10)




func _on_home_cabin_popup_id_pressed(id):
	match(id):
		1:
			print("cut firewood pressed")
			advance_time.emit(1)
			if (player.skill_roll("Woodcraft", 12) == true):
				player.inventory["Firewood"] = player.inventory["Firewood"] + 1
				storyteller.add_text("You succesfully gain firewood enough to last one night")
				storyteller.newline()
				return
			storyteller.add_text("you fail to get any useable firewood")
			storyteller.newline()
			
		2:
			if(player.inventory["Firewood"] >= 1):
				player.inventory["Firewood"] = player.inventory["Firewood"] -1
				fire_built = true
				storyteller.add_text("You build a fire that should keep you warm for the night.")
				storyteller.newline()
				return
			storyteller.add_text("You have no firewood.")
			storyteller.newline()
		3: 
			player.eat_food()
		10:
			sleep_popup.emit()
		
	
