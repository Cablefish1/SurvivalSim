extends Button

@onready var dicebag = Dicebag.new()
@onready var popup = $CloseWildernessPopupMenu
@onready var storyteller = $"../../../StorytellerPanel/Storyteller"
@onready var player = $"../../../PlayerDataObject"
@onready var main_game_object = $"../../.."


@export var explored : bool  = false
@export var resource_count : int = 0
@export var max_resource_count : int = 0
@export var resource_type : String = ""



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_pressed():
	popup.show()

func explore():
	if (explored == true): #should be redundant but nice debug to have
		storyteller.add_text("ERROR: TRYING TO EXPLORE AN ALREADY EXPLORED TILE")
		return
	explored = true
	storyteller.add_text("You succesfully search the area")
	storyteller.newline()
	randomize()
	player.unexplored_close_tiles.shuffle()
	print(player.unexplored_close_tiles.back())
	resource_type = player.unexplored_close_tiles.back() #roll to figure out ressource type (if any) on explored tile
	player.unexplored_close_tiles.pop_back()
	if(resource_type == "nothing"):
		storyteller.add_text("unfortunately there's nothing to be found")
		storyteller.newline()
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
			storyteller.add_text("You found "+var_to_str(resource_count)+" spots with wild game")
			storyteller.newline()
			popup.clear()
			popup.add_item("Hunting: Hunt for game (1 hour)")
			
		"berries":
			storyteller.add_text("You found "+var_to_str(resource_count)+" berry patches to pick")
			storyteller.newline()
			popup.clear()
			popup.add_item("Foraging: Pick berries (1 hour)")
		
		"fish":
			storyteller.add_text("You found a stream with "+var_to_str(resource_count)+" spots to fish")
			storyteller.newline()
			popup.clear()
			popup.add_item("Fishing: Go fish (1 hour)")	


func food_gain():
	storyteller.add_text("You gain food enough for a day")
	storyteller.newline()
	player.inventory["Unpreserved food"] = player.inventory["Unpreserved food"] + 1
	resource_count = resource_count - 1
	set_text(var_to_str(resource_count)+"\n"+str(resource_type))
	if(resource_count == 0):
		popup.remove_item(0)
		popup.add_item("Resource depleted")




func _on_close_wilderness_popup_menu_id_pressed(id):
	if(explored == false):
		main_game_object.advance_time(1) #If exploring advance time 1 hour
		if(player.skill_roll("Pathfinding", 12) == true):
			explore()
		else: 
			storyteller.add_text("You fail to find anything useful to your survival")
			storyteller.newline()
	else:
		#another if/then nightmare
		print("popup id: "+str(id)) #debug
		main_game_object.advance_time(1) #Whether succesfull or not advance time 1 hour.
		if(resource_type == "fish" && resource_count >= 1):
			if(player.skill_roll("Fishing", 12) == true):
				food_gain()
			else:
				storyteller.add_text("You fail to catch any fish")
				storyteller.newline()
		
		if(resource_type == "game" && resource_count >= 1):
			if(player.skill_roll("Hunting", 12) == true):
				food_gain()
			else:
				storyteller.add_text("You fail to kill any game")
				storyteller.newline()
		
		if(resource_type == "berries" && resource_count >= 1):
			if(player.skill_roll("Foraging", 12) == true):
				food_gain()
			else:
				storyteller.add_text("You fail to find any edible berries")
				storyteller.newline()

