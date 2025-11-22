extends Button

@onready var dicebag = Dicebag.new()
@onready var popup = $CloseWildernessPopupMenu
@onready var player = $"../../../PlayerDataObject"
@onready var main_game_object = $"../../.."
@onready var time_keeper = $"../../../TimeKeeper"


@export var explored : bool  = false
@export var resource_count : int = 0
@export var max_resource_count : int = 0
@export var resource_type : String = ""

signal storyteller_tell_player

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func emit_to_storyteller(text_to_tell : String):
	emit_signal("storyteller_tell_player" , text_to_tell)

func _on_pressed():
	popup.show()
	popup.position.y = get_global_mouse_position().y
	popup.position.x = get_global_mouse_position().x

func explore():
	if (explored == true): #should be redundant but nice debug to have
		emit_to_storyteller("ERROR: TRYING TO EXPLORE AN ALREADY EXPLORED TILE")
		return
	explored = true
	emit_to_storyteller("You succesfully search the area")
	randomize()
	player.unexplored_close_tiles.shuffle()
	print(player.unexplored_close_tiles.back())
	resource_type = player.unexplored_close_tiles.back() #roll to figure out ressource type (if any) on explored tile
	player.unexplored_close_tiles.pop_back()
	if(resource_type == "nothing"):
		emit_to_storyteller("unfortunately there's nothing to be found")
		set_text("barren \nwilderness")
		popup.clear()
		return
	resource_count = dicebag.roll_dice(1, 3, 3) #resource amount = 1d3 + 3
	max_resource_count = resource_count
	set_text(var_to_str(resource_count)+"\n"+str(resource_type))
	populate_popup()
	
func populate_popup(): #populates the popup menu once resources are found
	popup.clear() #pave the way for new buttons
	#populate the popup with new buttons with an if/then nightmare.
	#It's really bad practize but it can work with a manegable amount of resource types
	match resource_type:
		"game":
			emit_to_storyteller("You found "+var_to_str(resource_count)+" spots with wild game")
			popup.clear()
			popup.add_item("Hunting: Hunt for game (1 hour)")
			
		"berries":
			emit_to_storyteller("You found "+var_to_str(resource_count)+" berry patches to pick")
			popup.clear()
			popup.add_item("Foraging: Pick berries (1 hour)")
		
		"fish":
			emit_to_storyteller("You found a stream with "+var_to_str(resource_count)+" spots to fish")
			popup.clear()
			popup.add_item("Fishing: Go fish (1 hour)")	


func food_gain():
	emit_to_storyteller("You gain food enough for a day")
	player.inventory["Unpreserved food"] = player.inventory["Unpreserved food"] + 1
	resource_count = resource_count - 1
	set_text(var_to_str(resource_count)+"\n"+str(resource_type))
	if(resource_count == 0):
		popup.remove_item(0)
		popup.add_item("Resource depleted")




func _on_close_wilderness_popup_menu_id_pressed(_id):
	if(explored == false):
		time_keeper.advance_time(1) #If exploring advance time 1 hour
		if(player.skill_roll("Pathfinding", 12) == true):
			explore()
		else: 
			emit_to_storyteller("You fail to find anything useful to your survival")

	else:
		#another if/then nightmare
		time_keeper.advance_time(1) #Whether succesfull or not advance time 1 hour.
		match(resource_type):
			"fish":
				if resource_count >= 1:
					if(player.skill_roll("Fishing", 12) == true):
						food_gain()
					else:
						emit_to_storyteller("You fail to catch any fish")

		
			"game":
				if resource_count >= 1:
					if(player.skill_roll("Hunting", 12) == true):
						food_gain()
					else:
						emit_to_storyteller("You fail to kill any game")

		
			"berries":
				if resource_count >= 1:
					if(player.skill_roll("Foraging", 12) == true):
						food_gain()
					else:
						emit_to_storyteller("You fail to find any edible berries")
