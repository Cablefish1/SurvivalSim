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
		


func sleep_popup():
	$SleepPopup.show()
	sleep_label.clear()
	#calculate popup vars
	var fatigue = hour - 8 #Translate overextended work to fatigue
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
	
	
	
	

	
	


func advance_day():
	$SleepPopup.hide()
	var fatigue = hour - 8 #Translate overextended work to fatigue
	
	#reset hours and set a new day
	hour = 0
	day = day + 1
	time_keeper.set_text("Day: "+var_to_str(day)+"\nHour: "+var_to_str(hour))
	
	#PLAYER STUFF HAPPENS
	#Should probably go to a function in the PlayerObject
	var negative_sleep_factors : int = 0
	if(fatigue < 0): fatigue = 0 #Fatigue can't be positive. We want the player to expend all 8 hours
	negative_sleep_factors = fatigue #translate overextended work hours to fatigue
	
	if(home_cabin.roof_thatched == false):
		negative_sleep_factors = negative_sleep_factors + 1
	
	if(home_cabin.fire_built == false):
		negative_sleep_factors = negative_sleep_factors + 1
	
	if(home_cabin.bed_fixed == false):
		negative_sleep_factors = negative_sleep_factors + 1
	
	var sleep_roll = dicebag.roll_dice(1, 6, - negative_sleep_factors)
		
	if(sleep_roll < 0):
		display_text("The quality of your sleep was unable to counter the negative sleep factors.")
		display_text("You take damage from lack of decent rest.")
		player.modify_health(sleep_roll)
		
	else:
		if(player.health < 10 && player.food_eaten_today == true):
			display_text("You slept well regaining some much needed health!")
			player.modify_health(2)
		if(player.starvation > 0):
			display_text("No amount of sleep can heal when you're starving")
		if(player.health >= 10):
			display_text("You slept well")
		
	#WORLD STUFF HAPPENS
	home_cabin.fire_built = false
	player.food_eaten_today = false
	#respawning ressources should go here
		
		
		
		
	

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
