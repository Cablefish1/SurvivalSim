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
@onready var sleep_label = $SleepPopup/SleepLabel


#GAME CONFIG:
@export var tutorial : bool = true






# Called when the node enters the scene tree for the first time.
func _ready():
	Storyteller.tell_player("THE GLOBAL SCENE WORKS!")

	display_text("A new day dawns")
	update_health_bar()
	if tutorial:
		display_text("HINTS:")
		display_text("- In order to survive you need food and sleep.")
		display_text("- Don't work more than 8 hours or risk fatigue")
		display_text("- Remember to cut wood and build a fire")
		display_text("- Unless at full health everything will be harder")




		


func sleep_popup():
	$SleepPopup.show()
	sleep_label.clear()
	#calculate popup vars
	var fatigue = time_keeper.hour - 8 #Translate overextended work to fatigue
	if(fatigue < 0): fatigue = 0 #Fatigue can't be negative
	var negative_sleep_factors = fatigue
	
	sleep_label.set_text("Negative sleep factors:\n")
	if(fatigue > 0):
		sleep_label.add_text(var_to_str(fatigue)+": overextended work hour(s)\n")
	
	if(home_cabin.roof_thatched == false):
		sleep_label.add_text("1: Unthatched hole in the roof\n")
		negative_sleep_factors = negative_sleep_factors + 1
	
	if(home_cabin.fire_built == false):
		sleep_label.add_text("1: Fire not built\n")
		negative_sleep_factors = negative_sleep_factors + 1
	
	if(home_cabin.bed_fixed == false):
		sleep_label.add_text("1: No real bed\n \n") #note the linespace here
		negative_sleep_factors = negative_sleep_factors + 1
		
	if(negative_sleep_factors >= 1):
		sleep_label.add_text(var_to_str(negative_sleep_factors)+" Total negative factors\n \n")
	else:
		sleep_label.add_text("No negative sleep factors!\n \n")
		
	if (player.food_eaten_today == false):
		sleep_label.add_text("You have not eaten any food today!\nYou will loose health and cannot heal during sleep!\n")
		sleep_label.add_text("If sleep quality is negative you'll lose even more health!\n \n")
	else:
		sleep_label.add_text("If sleep quality is positive you'll gain 2 health\n")
		sleep_label.add_text("If if negative you'll loose the amount of health\n")
	sleep_label.add_text("Roll for quality of your sleep (1d6 - negative factors)?\n")
	
	
	
	

	
	


		
		
		
		
	

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
	





func _on_sleep_wait_pressed():
	$SleepPopup.hide()

func game_over():
	print("Game Over thing happens")
	queue_free()
