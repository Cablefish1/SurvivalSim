extends Button

@onready var dicebag = Dicebag.new()

@export var hour = 0
@export var day = 0

signal storyteller_tell_player

func update_time():
	set_text("Day: "+var_to_str(day)+"\nHour: "+var_to_str(hour))


func advance_time(hours):
	hour = hour + hours
	set_text("Day: "+var_to_str(day)+"\nHour: "+var_to_str(hour))
	if(hour == 8):
		emit_to_storyteller("You've reached the maximum productive hours today.")
		emit_to_storyteller("You should go to bed or risk fatigue.")
	elif(hour >= 9 && hour <= 10):
		emit_to_storyteller("You're very tired!")
		emit_to_storyteller("You should consider going to bed or risk fatigue.")
	elif(hour >= 11):
		emit_to_storyteller("You are too tired to keep working.")
		emit_to_storyteller("You barely manege to stumble into bed before passing out!")
		hour = 0
		day = day + 1
		advance_day()


func emit_to_storyteller(text_to_tell : String):
	emit_signal("storyteller_tell_player" , text_to_tell)
	
	

func advance_day():
	var root_scene = get_tree().current_scene
	var home_cabin = root_scene.find_node("HomeCabin")
	var player = root_scene.find_node("PlayerDataObject")
	print(home_cabin)
	$SleepPopup.hide()
	var fatigue = hour - 8 #Translate overextended work to fatigue
	
	#reset hours and set a new day
	hour = 0
	day = day + 1
	set_text("Day: "+var_to_str(day)+"\nHour: "+var_to_str(hour))
	
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
		emit_to_storyteller("The quality of your sleep was unable to counter the negative sleep factors.")
		emit_to_storyteller("You take damage from lack of decent rest.")
		player.modify_health(sleep_roll)
		
	else:
		if(player.health < 10 && player.food_eaten_today == true):
			emit_to_storyteller("You slept well regaining some much needed health!")
			player.modify_health(2)
		if(player.starvation > 0):
			emit_to_storyteller("No amount of sleep can heal when you're starving")
		if(player.health >= 10):
			emit_to_storyteller("You slept well")
		
	#WORLD STUFF HAPPENS
	home_cabin.fire_built = false
	player.food_eaten_today = false
	#respawning ressources should go here
