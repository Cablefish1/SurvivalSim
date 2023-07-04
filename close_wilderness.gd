extends Button

@onready var dicebag = Dicebag.new()
@onready var popup = $CloseWildernessPopupMenu
@onready var storyteller = $"../../../StorytellerPanel/Storyteller"
@onready var player = $"../../../PlayerDataObject"


@export var explored : bool  = false
@export var resource_count : int = 0
@export var resource_type : String = ""



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	popup.show()

func explore():
	if (explored == true): #should be redundant but nice debug to have
		storyteller.add_text("ERROR: TRYING TO EXPLORE AN ALREADY EXPLORED TILE")
		return
	explored = true
	popup.clear() #pave the way for new buttons
	var exploration_roll = dicebag.roll_dice(1, player.unexplored_close_tiles.size(), 0)
	print("exploration_roll: "+str(exploration_roll))
	print("resource found: "+str(player.unexplored_close_tiles[exploration_roll])) #roll to figure out ressource type (if any) on explored tile
	resource_type = player.unexplored_close_tiles[exploration_roll]
	print(resource_type)
	if(resource_type == "nothing"):
		storyteller.add_text("You succesfully search the area \nunfortunately there's nothing to be found")
		set_text("barren \nwilderness")
		return
	resource_count = dicebag.roll_dice(1, 3, 3) #resource amount = 1d3 + 3
	


	
	



func _on_close_wilderness_popup_menu_id_pressed(id):
	if(explored):
		#do explored logic
		pass
	else:
		if(player.skill_roll("Pathfinding", 12) == true):
			explore()
		else: 
			storyteller.add_text("You fail to find anything useful to your survival")
			storyteller.newline()
	
	
	
