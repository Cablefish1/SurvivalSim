extends Node

@onready var dicebag = Dicebag.new()

@onready var storyteller = $"../StorytellerPanel/Storyteller"


@export var skills : Dictionary = {
	"Pathfinding" : 0,
	"Fishing" : 0,
	"Foraging" : 0,
	"Hunting" : 0,
	"Farming" : 0,
	"Animal husbandry" : 0,
	"Food preservation" : 0,
	"Woodworking" : 0,
	"Leatherworking" : 0,
	"Toolmaking" : 0,
	"Social insight" : 0
} 

@export var inventory : Dictionary = {
	"Unpreserved food" : 0,
	"Preserved food" : 0,
	"Firewood" : 0,

} 

@export var unexplored_close_tiles : Dictionary = {
	1 : "fish",
	2 : "fish",
	3 : "game",
	4 : "game",
	5 : "berries",
	6 : "berries",
	7 : "nothing",
	8 : "nothing"
}


@export var health : int = 10

@export var hour : int = 0
@export var day : int = 0



func skill_roll(skill_name, target_dc):
	randomize()
	if(skills.has(skill_name)):
		storyteller.add_text("you attempt "+str(skill_name))
		storyteller.newline()
		var attempt = dicebag.roll_dice(1, 20)
		attempt = attempt + skills[skill_name]
		storyteller.add_text("Your rank in "+str(skill_name)+" is "+str(skills[skill_name]))
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

