extends Node

@onready var dicebag = Dicebag.new()

@onready var storyteller = $"../StorytellerPanel/Storyteller"
@onready var MainGameObject = $".."

@export var food_eaten_today : bool = false
@export var health : int = 10
@export var starvation : int = 0
@export var penalty : int = 0



@export var skills : Dictionary = {
	"Pathfinding" : 0,
	"Fishing" : 0,
	"Foraging" : 0,
	"Hunting" : 0,
	"Farming" : 0,
	"Animal husbandry" : 0,
	"Food preservation" : 0,
	"Woodcraft" : 0,
	"Leatherworking" : 0,
	"Toolmaking" : 0,
	"Social insight" : 0
} 

@export var inventory : Dictionary = {
	"Unpreserved food" : 0,
	"Preserved food" : 0,
	"Firewood" : 0,

} 

@export var unexplored_close_tiles = [
	"fish", 
	"fish", 
	"game", 
	"game", 
	"berries", 
	"berries", 
	"nothing", 
	"nothing"
]


func starve():
	starvation = starvation + 1
	storyteller.add_text("You've been starving for "+var_to_str(starvation)+" day(s)")
	storyteller.newline()
	storyteller.add_text("You take "+var_to_str(starvation)+" health damage")
	storyteller.newline()
	modify_health(- starvation)

func eat_food():
	if(inventory["Unpreserved food"] >= 1 && food_eaten_today == false):
		inventory["Unpreserved food"] = inventory["Unpreserved food"] - 1
		storyteller.add_text("Prioritizing food that might go bad overnight,")
		storyteller.newline()
		storyteller.add_text("you eat 1 ration of unpreserved food")
		storyteller.newline()
		starvation = 0
		food_eaten_today = true
		return
	elif(inventory["Preserved food"] >= 1):
		inventory["Preserved food"] = inventory["Preserved food"] - 1
		storyteller.add_text("You eat 1 ration of preserved food")
		storyteller.newline()
		starvation = 0
		food_eaten_today = true
		return
	else:
		storyteller.add_text("ERROR: NO FOOD FOUND!")
	
		
	
	

func modify_health(amount):
	health = health + amount
	if (health <=0):
		MainGameObject.game_over()
	if (health >=10):
		health = 10
	MainGameObject.update_health_bar()
	


func calculate_penalty():
	var health_penalty = health - 10
	penalty = health_penalty #modify if anything else needs to add penalties.
	



func skill_roll(skill_name, target_dc):
	randomize()
	if(skills.has(skill_name)):
		calculate_penalty()
		storyteller.add_text("you attempt "+str(skill_name))
		storyteller.newline()
		var attempt = dicebag.roll_dice(1, 20, penalty)
		attempt = attempt + skills[skill_name]
		storyteller.add_text("Your rank in "+str(skill_name)+" is "+str(skills[skill_name]))
		storyteller.newline()
		if(penalty < 0):
			storyteller.add_text("Penalty due to lack of health: "+var_to_str(penalty))
			storyteller.newline()
		storyteller.add_text("You hit a "+str(attempt)+" versus a target of "+str(target_dc)) #inform the player how close the were
		storyteller.newline()
		
		#if the player hits within 2 above or below their target DC they challanged themselves enough to learn something
		if(attempt >= target_dc - 2 && attempt <= target_dc + 2): 
			storyteller.add_text("Challanging yourself you learned a lot") #output to the player
			storyteller.newline()
			skills[skill_name] = skills[skill_name] + 1 #Adds one to the skill rank
			storyteller.add_text("Your skill is now "+str(skills[skill_name]))
			storyteller.newline()
		
		#return whether the skill roll was succesfull or not
		if(attempt >= target_dc):
			return true
		else:
			return false
			
		
	print("nonexisting skill")
