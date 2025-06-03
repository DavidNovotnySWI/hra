extends Pickups
class_name Gold
 
@export var gold : int = 5
 
func activate():
	super.activate()
	#prints("+" + str(gold) + "gold")
	player_reference.gain_gold(gold)
