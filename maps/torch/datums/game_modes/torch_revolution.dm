/datum/game_mode/revolution
	name = "Mutiny"
	round_description = "Morale is shattered, and a mutiny is brewing! Use the 'Check Round Info' verb for more information!"
	extended_round_description = "Time in space, away from home and loved ones, takes its toll on even the most grizzled space travellers. To make matters worse, the planned return trip to Sol \
								for refitting, repairs and relaxation has been cancelled by the brass; instead, the CEV Zerzura is to, for the first time, enter a hibernative state. All crew will enter cryogenic stasis, \
								and the shipbound AI system will complete a series of jumps that will take the ship lightyears further away from home. Outrage from friends and family of crew back \
								on Mars, Luna and other various worlds has spawned primetime scandals that dominate the 24/7 news cycle. Videolink interviews with Zerzura crew reveal morale is at an \
								all time low. Rumors are spreading of an impending mutiny."
	config_tag = "mutiny"
	required_enemies = 4
	required_players = 10

/datum/antagonist/revolutionary
	role_text = "Head Mutineer"
	role_text_plural = "Mutineers"

	faction_welcome = "That's it; you're done taking this crap. Obey all instructions from the leaders of the mutiny, and ensure the mutiny succeeds."
	welcome_text = "You've been out here for what feels like an eternity. The time spent in space has worn away at your conscience, and \
					you won't let yourself be canned up like a sardine for even one more jump. Take control of your situation and use the Torch for your own ends, or \
					even just to return home."

	victory_text = "The heads of staff were relieved of their posts. The Zerzura is finally heading home."
	loss_text = "The heads of staff managed to quash the mutiny. The mission will continue as ordered."

	//Inround revs.
	faction_role_text = "Mutineer"
	faction_descriptor = "Mutiny"

	faction = "mutiny"


/datum/antagonist/loyalists


	victory_text = "The heads of staff remained at their posts; the mission will continue as ordered."
	loss_text = "The heads of staff could not contain the mutiny, and the Zerzura is now heading home."


/datum/antagonist/loyalists/Initialize()
	..()
	welcome_text = "The CEV Zerzura, the most ambitious and prestigious human research project ever established, is now under threat from her very crew as a result of the Expeditionary Corps' brass decision \
					to enter 'hibernation mode' (with crew in cryosleep, and the AI piloting the ship) instead of making the scheduled return to Sol. Crew morale is dangerously low. What the Zerzura needs now \
					is a steady hand to guide her through what will likely be the greatest trial she will face."
	faction_welcome = "Obey all instructions, follow the chain of command, and ensure the mission continues as ordered."
	faction_descriptor = "[GLOB.using_map.company_name]"
