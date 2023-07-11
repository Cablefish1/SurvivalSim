extends Control


#i didn't settle on a convention hence why some vars are capitalised and others aren't
#should all be lowercase

@onready var dicebag = Dicebag.new()
@onready var storyteller = $StorytellerPanel/Storyteller
@onready var player = $PlayerDataObject
@onready var time_keeper = $TimeKeeper
@onready var Healthbar = $Healthbar
@onready var HealthbarLabel = $Healthbar/HealthbarLabel
@onready var home_cabin = $SectorMapPanel/GridContainer/HomeCabin



@export var hour = 0
@export var day = 0



# Called when the node enters the scene tree for the first time.
func _ready():
	display_text("Game initiated")
	time_keeper.set_text("Day: "+var_to_str(day)+"\nHour: "+var_to_str(hour))
	update_health_bar()

func advance_time(hours):
	hour = hour + hours
	time_keeper.set_text("Day: "+var_to_str(day)+"\nHour: "+var_to_str(hour))
	if(hour == 8):
		display_text("You've reached the maximum productive hours today.")
		display_text("You should go to bed or risk fatigue.")
	elif(hour >= 9 && hour <= 10):
		display_text("You're very tired!")
		display_text("You should consider going to bed or risk fatigue.")
	elif(hour >= 11):
		display_text("You are too tired to keep working.")
		display_text("You barely manege to stumble into bed before passing out!")
		hour = 0
		day = day + 1
		advance_day()
		

func advance_day():
	var fatigue = hour - 8
	var negative_sleep_factors : int = 0
	if(fatigue < 0): fatigue = 0
	display_text("Negative sleep factors:")
	if(fatigue > 0):
		display_text(var_to_str(fatigue)+"overextended productive hour(s)")
		negative_sleep_factors = fatigue
	if(home_cabin.roof_thatched == false):
		display_text("Unthatched hole in the roof")
		negative_sleep_factors = negative_sleep_factors + 1
	if(home_cabin.fire_buildt == false):
		display_text("Fire not buildt")
		negative_sleep_factors = negative_sleep_factors + 1
	if(home_cabin.bed_fixed == false):
		display_text("No real bed")
		negative_sleep_factors = negative_sleep_factors + 1
	display_text("total negative factors: "+var_to_str(negative_sleep_factors))
	dicebag.roll_dice(1, 6, - negative_sleep_factors)
		
		
	

func update_health_bar():
	Healthbar.value = player.health
	HealthbarLabel.set_text("Health "+var_to_str(player.health)+"/10")




func display_text(text : String):
	storyteller.add_text(text)
	storyteller.newline()


func display_skills():
	for skill in player.skills:
		var value = player.skills[skill]
		storyteller.add_text(str(value)+str(" "))
		storyteller.add_text(str(skill))
		storyteller.newline()
		

func display_inventory():
	for item in player.inventory:
		var value = player.inventory[item]
		storyteller.add_text(str(item)+str(" "))
		storyteller.add_text(str(value))
		storyteller.newline()

func _on_display_sheet_pressed():
	display_skills()


func _on_display_inventory_pressed():
	display_inventory()
	
func game_over():
	print("Game Over thing happens")
	queue_free()

