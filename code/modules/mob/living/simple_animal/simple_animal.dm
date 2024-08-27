/mob/living/simple_animal
	name = "animal"
	icon = 'icons/mob/simple_animal/animal.dmi'
	health = 20
	maxHealth = 20
	universal_speak = FALSE
	pronouns = null

	mob_bump_flag = SIMPLE_ANIMAL
	mob_swap_flags = MONKEY|SLIME|SIMPLE_ANIMAL
	mob_push_flags = MONKEY|SLIME|SIMPLE_ANIMAL

	meat_type = /obj/item/reagent_containers/food/snacks/meat
	meat_amount = 3
	bone_material = MATERIAL_BONE_GENERIC
	bone_amount = 5
	skin_material = MATERIAL_SKIN_GENERIC
	skin_amount = 5

	var/show_stat_health = 1	//does the percentage health show in the stat panel for the mob

	var/icon_living = ""
	var/icon_dead = ""
	var/icon_gib = null	//We only try to show a gibbing animation if this exists.
	var/icon_rest = null			// The iconstate for resting, optional

	var/turns_per_move = 1
	var/turns_since_move = 0
	//Interaction
	var/response_help   = "tries to help"
	var/response_disarm = "tries to disarm"
	var/response_harm   = "tries to hurt"
	var/can_escape = FALSE // 'smart' simple animals such as human enemies, or things small, big, sharp or strong enough to power out of a net

	//Temperature effect
	var/minbodytemp = 250
	var/maxbodytemp = 350
	var/heat_damage_per_tick = 3	//amount of damage applied if animal's body temperature is higher than maxbodytemp
	var/cold_damage_per_tick = 2	//same as heat_damage_per_tick, only if the bodytemperature it's lower than minbodytemp
	var/fire_alert = 0

	var/min_oxy = 5					// Oxygen in moles, minimum, 0 is 'no minimum'
	var/max_oxy = 0					// Oxygen in moles, maximum, 0 is 'no maximum'
	var/min_tox = 0					// Phoron min
	var/max_tox = 1					// Phoron max
	var/min_co2 = 0					// CO2 min
	var/max_co2 = 5					// CO2 max
	var/min_n2 = 0					// N2 min
	var/max_n2 = 0					// N2 max
	var/unsuitable_atoms_damage = 2	// This damage is taken when atmos doesn't fit all the requirements above

	//Attack ranged settings
	var/projectiletype				// The projectiles I shoot
	var/projectilesound				// The sound I make when I do it
	var/projectile_accuracy = 0		// Accuracy modifier to add onto the bullet when its fired.
	var/projectile_dispersion = 0	// How many degrees to vary when I do it.
	var/casingtype

	// Reloading settings, part of ranged code
	var/needs_reload = FALSE							// If TRUE, mob needs to reload occasionally
	var/reload_max = 1									// How many shots the mob gets before it has to reload, will not be used if needs_reload is FALSE
	var/reload_count = 0								// A counter to keep track of how many shots the mob has fired so far. Reloads when it hits reload_max.
	var/reload_time = 4 SECONDS							// How long it takes for a mob to reload. This is to buy a player a bit of time to run or fight.
	var/reload_sound = 'sound/weapons/flipblade.ogg'	// What sound gets played when the mob successfully reloads. Defaults to the same sound as reloading guns. Can be null.

	//Hostility settings
	var/taser_kill = 1				// Is the mob weak to tasers

	//Mob melee settings
	var/list/attacktext = list("attacked") // "You are [attacktext] by the mob!"
	var/attack_sound = null				// Sound to play when I attack
	var/attack_armor_pen = 0			// How much armor pen this attack has.

	var/melee_attack_delay = 4			// If set, the mob will do a windup animation and can miss if the target moves out of the way.
	var/ranged_attack_delay = null
	var/special_attack_delay = null

	//Mob interaction
	var/list/friends = list()		// Mobs on this list wont get attacked regardless of faction status.
	var/harm_intent_damage = 3		// How much an unarmed harm click does to this mob.
	var/list/loot_list = list()		// The list of lootable objects to drop, with "/path = prob%" structure
	var/obj/item/card/id/myid// An ID card if they have one to give them access to stuff.

	//Movement things.
	var/movement_cooldown = 3			// Lower is faster.
	var/movement_sound = null			// If set, will play this sound when it moves on its own will.
	var/turn_sound = null				// If set, plays the sound when the mob's dir changes in most cases.
	var/movement_shake_radius = 0		// If set, moving will shake the camera of all living mobs within this radius slightly.
	var/aquatic_movement = 0			// If set, the mob will move through fluids with no hinderance.

	//Atmos effect - Yes, you can make creatures that require phoron or co2 to survive. N2O is a trace gas and handled separately, hence why it isn't here. It'd be hard to add it. Hard and me don't mix (Yes, yes make all the dick jokes you want with that.) - Errorage
	var/list/min_gas = list(GAS_OXYGEN = 5)
	var/list/max_gas = list(GAS_PHORON = 1, GAS_CO2 = 5)

	var/unsuitable_atmos_damage = 2	//This damage is taken when atmos doesn't fit all the requirements above
	var/speed = 0 //LETS SEE IF I CAN SET SPEEDS FOR SIMPLE MOBS WITHOUT DESTROYING EVERYTHING. Higher speed is slower, negative speed is faster


	//LETTING SIMPLE ANIMALS ATTACK? WHAT COULD GO WRONG. Defaults to zero so Ian can still be cuddly
	var/obj/item/natural_weapon/natural_weapon
	var/friendly = "nuzzles"
	var/environment_smash = 0
	var/resistance		  = 0	// Damage reduction
	var/armor_type = /datum/extension/armor
	var/list/natural_armor //what armor animal has
	var/flash_vulnerability = 1 // whether or not the mob can be flashed; 0 = no, 1 = yes, 2 = very yes

	var/can_pry = TRUE
	var/pry_time = 7 SECONDS //time it takes for mob to pry open a door
	var/pry_desc = "prying" //"X begins pry_desc the door!"

	//Special attacks
	var/special_attack_min_range = null		// The minimum distance required for an attempt to be made.
	var/special_attack_max_range = null		// The maximum for an attempt.
	var/special_attack_charges = null		// If set, special attacks will work off of a charge system, and won't be usable if all charges are expended. Good for grenades.
	var/special_attack_cooldown = null		// If set, special attacks will have a cooldown between uses.
	var/last_special_attack = null			// world.time when a special attack occured last, for cooldown calculations.

	//Damage resistances
	var/grab_resist = 0				// Chance for a grab attempt to fail. Note that this is not a true resist and is just a prob() of failure.
	var/list/armor = list(			// Values for normal getarmor() checks
				"melee" = 0,
				"bullet" = 0,
				"laser" = 0,
				"energy" = 0,
				"bomb" = 0,
				"bio" = 100,
				"rad" = 100
				)

	// Protection against heat/cold/electric/water effects.
	// 0 is no protection, 1 is total protection. Negative numbers increase vulnerability.
	var/heat_resist = 0.0
	var/cold_resist = 0.0
	var/shock_resist = 0.0
	var/water_resist = 1.0
	var/poison_resist = 0.0
	var/thick_armor = FALSE // Stops injections and "injections".
	var/purge = 0					// Cult stuff.
	var/supernatural = FALSE		// Ditto.

	var/bleed_ticks = 0
	var/bleed_colour = COLOR_BLOOD_HUMAN
	var/can_bleed = TRUE

	// contained in a cage
	var/in_stasis = 0

	//for simple animals with abilities, mostly megafauna
	var/ability_cooldown
	var/time_last_used_ability

	//for simple animals that reflect damage when attacked in melee
	var/return_damage_min
	var/return_damage_max

/mob/living/simple_animal/Initialize()
	. = ..()
	if(LAZYLEN(natural_armor))
		set_extension(src, armor_type, natural_armor)
	if(!icon_living)
		icon_living = initial(icon_state)

/mob/living/simple_animal/Destroy()
	if(istype(natural_weapon))
		QDEL_NULL(natural_weapon)

	. = ..()
	if(!.)
		return FALSE
	if(!living_observers_present(GetConnectedZlevels(z)))
		return
	//Health
	if(stat == DEAD)
		if(health > 0)
			icon_state = icon_living
			switch_from_dead_to_living_mob_list()
			set_stat(CONSCIOUS)
			set_density(1)
		return 0

	handle_atmos()

	if(health <= 0)
		death()
		return

	if(health > maxHealth)
		health = maxHealth

	handle_stunned()
	handle_weakened()
	handle_paralysed()
	handle_confused()
	handle_supernatural()
	handle_impaired_vision()

	if(can_bleed && bleed_ticks > 0)
		handle_bleeding()

	if(!AI_inactive)
		if(buckled && can_escape)
			if(istype(buckled, /obj/effect/energy_net))
				var/obj/effect/energy_net/Net = buckled
				Net.escape_net(src)
			else if(prob(50))
				escape(src, buckled)
			else if(prob(50))
				visible_message("<span class='warning'>\The [src] struggles against \the [buckled]!</span>")

		//Movement
		if(!client && !stop_automated_movement && wander && !anchored)
			if(isturf(src.loc) && !resting)		//This is so it only moves if it's not inside a closet, gentics machine, etc.
				turns_since_move++
				if(turns_since_move >= turns_per_move)
					if(!(stop_automated_movement_when_pulled && pulledby)) //Some animals don't move when pulled
						SelfMove(pick(GLOB.cardinal))
						turns_since_move = 0

		//Speaking
		if(!client && speak_chance)
			if(rand(0,200) < speak_chance)
				var/action = pick(
					speak.len;      "speak",
					emote_hear.len; "emote_hear",
					emote_see.len;  "emote_see"
					)

				switch(action)
					if("speak")
						say(pick(speak))
					if("emote_hear")
						audible_emote("[pick(emote_hear)].")
					if("emote_see")
						visible_emote("[pick(emote_see)].")
	return 1

/mob/living/simple_animal/proc/handle_atmos(var/atmos_suitable = 1)
	//Atmos

	if(!loc)
		return

	var/datum/gas_mixture/environment = loc.return_air()
	if(!(MUTATION_SPACERES in mutations) && environment)

		if(abs(environment.temperature - bodytemperature) > 40 )
			bodytemperature += ((environment.temperature - bodytemperature) / 5)

		 // don't bother checking it twice if we got a supplied 0 val.
		if(atmos_suitable)
			if(LAZYLEN(min_gas))
				for(var/gas in min_gas)
					if(environment.gas[gas] < min_gas[gas])
						atmos_suitable = FALSE
						break
			if(atmos_suitable && LAZYLEN(max_gas))
				for(var/gas in max_gas)
					if(environment.gas[gas] > max_gas[gas])
						atmos_suitable = FALSE
						break

	//Atmos effect
	if(bodytemperature < minbodytemp)
		fire_alert = 2
		adjustBruteLoss(cold_damage_per_tick)
	else if(bodytemperature > maxbodytemp)
		fire_alert = 1
		adjustBruteLoss(heat_damage_per_tick)
	else
		fire_alert = 0

	if(!atmos_suitable)
		adjustBruteLoss(unsuitable_atmos_damage)

/mob/living/simple_animal/proc/escape(mob/living/M, obj/O)
	O.unbuckle_mob(M)
	visible_message("<span class='danger'>\The [M] escapes from \the [O]!</span>")

/mob/living/simple_animal/proc/handle_supernatural()
	if(purge)
		purge -= 1

/mob/living/simple_animal/gib()
	..(icon_gib,1)

/mob/living/simple_animal/proc/visible_emote(var/act_desc)
	custom_emote(1, act_desc)

/mob/living/simple_animal/proc/audible_emote(var/act_desc)
	custom_emote(2, act_desc)

/mob/living/simple_animal/bullet_act(var/obj/item/projectile/Proj)
	if(!Proj || Proj.nodamage)
		return

	var/damage = Proj.damage
	if(Proj.damtype == STUN)
		damage = Proj.damage / 6
	if(Proj.damtype == BRUTE)
		damage = Proj.damage / 2
	if(Proj.damtype == BURN)
		damage = Proj.damage / 1.5
	if(Proj.agony)
		damage += Proj.agony / 6
		if(health < Proj.agony * 3)
			Paralyse(Proj.agony / 20)
			visible_message("<span class='warning'>[src] is stunned momentarily!</span>")

	bullet_impact_visuals(Proj)
	adjustBruteLoss(damage)
	Proj.on_hit(src)
	return 0

/mob/living/simple_animal/attack_hand(mob/living/carbon/human/M as mob)
	..()

	switch(M.a_intent)

		if(I_HELP)
			if (health > 0)
				M.visible_message("<span class='notice'>[M] [response_help] \the [src].</span>")
				M.update_personal_goal(/datum/goal/achievement/specific_object/pet, type)

		if(I_DISARM)
			M.visible_message("<span class='notice'>[M] [response_disarm] \the [src].</span>")
			M.do_attack_animation(src)
			//TODO: Push the mob away or something

		if(I_HURT)
			var/dealt_damage = harm_intent_damage
			var/harm_verb = response_harm
			if(ishuman(M) && M.species)
				var/datum/unarmed_attack/attack = M.get_unarmed_attack(src)
				dealt_damage = attack.damage <= dealt_damage ? dealt_damage : attack.damage
				harm_verb = pick(attack.attack_verb)
				if(attack.sharp || attack.edge)
					adjustBleedTicks(dealt_damage)

			adjustBruteLoss(dealt_damage)
			M.visible_message("<span class='warning'>[M] [harm_verb] \the [src]!</span>")
			M.do_attack_animation(src)

	return

/mob/living/simple_animal/attackby(var/obj/item/O, var/mob/user)
	if(istype(O, /obj/item/stack/medical))
		if(stat != DEAD)
			var/obj/item/stack/medical/MED = O
			if(!MED.animal_heal)
				to_chat(user, "<span class='notice'>That [MED] won't help \the [src] at all!</span>")
				return
			if(health < maxHealth)
				if(MED.can_use(1))
					adjustBruteLoss(-MED.animal_heal)
					visible_message("<span class='notice'>[user] applies the [MED] on [src].</span>")
					MED.use(1)
		else
			to_chat(user, "<span class='notice'>\The [src] is dead, medical items won't bring \him back to life.</span>")
		return

	if(istype(O, /obj/item/device/flash))
		if(stat != DEAD)
			O.attack(src, user, user.zone_sel.selecting)
			return

	if(meat_type && (stat == DEAD) && meat_amount)
		if(istype(O, /obj/item/weapon/material/knife/kitchen/cleaver))
			var/victim_turf = get_turf(src)
			if(!locate(/obj/structure/table, victim_turf))
				to_chat(user, SPAN_NOTICE("You need to place \the [src] on a table to butcher it."))
				return
			var/time_to_butcher = (mob_size)
			to_chat(user, SPAN_NOTICE("You begin harvesting \the [src]."))
			if(do_after(user, time_to_butcher, src, do_flags = DO_DEFAULT & ~DO_BOTH_CAN_TURN))
				if(prob(user.skill_fail_chance(SKILL_COOKING, 60, SKILL_ADEPT)))
					to_chat(user, SPAN_NOTICE("You botch harvesting \the [src], and ruin some of the meat in the process."))
					subtract_meat(user)
					return
				else
					harvest(user, user.get_skill_value(SKILL_COOKING))
					return
			else
				to_chat(user, SPAN_NOTICE("Your hand slips with your movement, and some of the meat is ruined."))
				subtract_meat(user)
				return

	else
		if(!O.force)
			visible_message("<span class='notice'>[user] gently taps [src] with \the [O].</span>")
		else
			O.attack(src, user, user.zone_sel.selecting)

/mob/living/simple_animal/hit_with_weapon(obj/item/O, mob/living/user, var/effective_force, var/hit_zone)

	visible_message("<span class='danger'>\The [src] has been attacked with \the [O] by [user]!</span>")

	if(O.force <= resistance)
		to_chat(user, "<span class='danger'>This weapon is ineffective; it does no damage.</span>")
		return 0

	var/damage = O.force
	if (O.damtype == PAIN)
		damage = 0
	if (O.damtype == STUN)
		damage = (O.force / 8)
	if(supernatural && istype(O,/obj/item/weapon/nullrod))
		damage *= 2
		purge = 3
	adjustBruteLoss(damage)
	if(O.edge || O.sharp)
		adjustBleedTicks(damage)

	return 1

/mob/living/simple_animal/movement_delay()
	var/tally = ..() //Incase I need to add stuff other than "speed" later

	tally += speed
	if(purge)//Purged creatures will move more slowly. The more time before their purge stops, the slower they'll move.
		if(tally <= 0)
			tally = 1
		tally *= purge

	return tally

/mob/living/simple_animal/Stat()
	. = ..()

	if(statpanel("Status") && show_stat_health)
		stat(null, "Health: [round((health / maxHealth) * 100)]%")

/mob/living/simple_animal/death(gibbed, deathmessage = "dies!", show_dead_message)
	icon_state = icon_dead
	update_icon()
	density = FALSE
	adjustBruteLoss(maxHealth) //Make sure dey dead.
	walk_to(src,0)
	return ..(gibbed,deathmessage,show_dead_message)

/mob/living/simple_animal/ex_act(severity)
	if (status_flags & GODMODE)
		return
	if(!blinded)
		flash_eyes()

	var/damage
	switch (severity)
		if (EX_ACT_DEVASTATING)
			damage = 500

		if (EX_ACT_HEAVY)
			damage = 120

		if(EX_ACT_LIGHT)
			damage = 30

	apply_damage(damage, DAMAGE_BRUTE, damage_flags = DAMAGE_FLAG_EXPLODE)

/mob/living/simple_animal/adjustBruteLoss(damage)
	..()
	updatehealth()

/mob/living/simple_animal/adjustFireLoss(damage)
	..()
	updatehealth()

/mob/living/simple_animal/adjustToxLoss(damage)
	..()
	updatehealth()

/mob/living/simple_animal/adjustOxyLoss(damage)
	..()
	updatehealth()

/mob/living/simple_animal/say(message)
	var/verb = "says"
	if(length(speak_emote))
		verb = pick(speak_emote)

	message = sanitize(message)

	..(message, null, verb)

/mob/living/simple_animal/get_speech_ending(verb, ending)
	return verb

/mob/living/simple_animal/put_in_hands(obj/item/W) // No hands.
	W.forceMove(get_turf(src))
	return 1

// Harvest an animal's delicious byproducts
/mob/living/simple_animal/proc/harvest(mob/user, skill_level)
	var/actual_meat_amount = round(max(1,(meat_amount / 2) + skill_level / 2))
	user.visible_message(SPAN_DANGER("\The [user] chops up \the [src]!"))
	if(meat_type && actual_meat_amount > 0 && (stat == DEAD))
		for(var/i=0;i<actual_meat_amount;i++)
			var/obj/item/meat = new meat_type(get_turf(src))
			meat.SetName("[src.name] [meat.name]")
			if(can_bleed)
				var/obj/decal/cleanable/blood/splatter/splat = new(get_turf(src))
				splat.basecolor = bleed_colour
				splat.update_icon()
			qdel(src)

/mob/living/simple_animal/proc/subtract_meat(mob/user)
	meat_amount--
	if(meat_amount <= 0)
		to_chat(user, SPAN_NOTICE("\The [src] carcass is ruined beyond use."))

/mob/living/simple_animal/bullet_impact_visuals(obj/item/projectile/P, def_zone)
	..()
	switch(get_bullet_impact_effect_type(def_zone))
		if(BULLET_IMPACT_MEAT)
			if (P.damtype == DAMAGE_BRUTE)
				var/hit_dir = get_dir(P.starting, src)
				var/obj/decal/cleanable/blood/B = blood_splatter(get_step(src, hit_dir), src, 1, hit_dir)
				B.icon_state = pick("dir_splatter_1","dir_splatter_2")
				B.basecolor = bleed_colour
				B.SetTransform(scale = min(1, round(mob_size / MOB_MEDIUM, 0.1)))
				B.update_icon()

/mob/living/simple_animal/handle_fire()
	. = ..()

	var/burn_temperature = fire_burn_temperature()
	var/thermal_protection = get_heat_protection(burn_temperature)

	if (thermal_protection < 1 && bodytemperature < burn_temperature)
		bodytemperature += round(BODYTEMP_HEATING_MAX*(1-thermal_protection), 1)

	burn_temperature -= maxbodytemp

	if(burn_temperature < 1)
		return

	adjustBruteLoss(log(10, (burn_temperature + 10)))

/mob/living/simple_animal/update_fire()
	. = ..()
	CutOverlays(image("icon"='icons/mob/OnFire.dmi', "icon_state"="Generic_mob_burning"))
	if(on_fire)
		AddOverlays(image("icon"='icons/mob/OnFire.dmi', "icon_state"="Generic_mob_burning"))

/mob/living/simple_animal/is_burnable()
	return heat_damage_per_tick

/mob/living/simple_animal/proc/adjustBleedTicks(amount)
	if(!can_bleed)
		return

	if(amount > 0)
		bleed_ticks = max(bleed_ticks, amount)
	else
		bleed_ticks = max(bleed_ticks + amount, 0)

	bleed_ticks = round(bleed_ticks)

/mob/living/simple_animal/proc/handle_bleeding()
	bleed_ticks--
	adjustBruteLoss(1)

	var/obj/decal/cleanable/blood/drip/drip = new(get_turf(src))
	drip.basecolor = bleed_colour
	drip.update_icon()

/mob/living/simple_animal/get_digestion_product()
	return /datum/reagent/nutriment

/mob/living/simple_animal/eyecheck()
	switch(flash_vulnerability)
		if(2 to INFINITY)
			return FLASH_PROTECTION_REDUCED
		if(1)
			return FLASH_PROTECTION_NONE
		if(0)
			return FLASH_PROTECTION_MAJOR
		else
			return FLASH_PROTECTION_MAJOR

/mob/living/simple_animal/SelfMove(turf/n, direct, movetime)
	var/turf/old_turf = get_turf(src)
	var/old_dir = dir
	. = ..()
	if(. && movement_shake_radius)
		for(var/mob/living/L in range(movement_shake_radius, src))
			shake_camera(L, 1, 1)
	if(turn_sound && dir != old_dir)
		playsound(src, turn_sound, 50, 1)
	else if(movement_sound && old_turf != get_turf(src)) // Playing both sounds at the same time generally sounds bad.
		playsound(src, movement_sound, 50, 1)

/mob/living/simple_animal/movement_delay(singleton/move_intent/using_intent = move_intent)
	. = movement_cooldown

	// Turf related slowdown
	var/turf/T = get_turf(src)
	if(T && T.movement_delay && !is_floating) // Flying mobs ignore turf-based slowdown. Aquatic mobs ignore water slowdown, and can gain bonus speed in it.
		. += T.movement_delay

	if(purge)//Purged creatures will move more slowly. The more time before their purge stops, the slower they'll move.
		if(. <= 0)
			. = 1
		. *= purge

	if(a_intent == "walk")
		. *= 1.5

	 . += ..()

/mob/living/simple_animal/get_inventory_slot(obj/item/I)
	return -1

/mob/living/simple_animal/proc/pry_door(mob/user, delay, obj/machinery/door/pesky_door)
	set waitfor = FALSE
	visible_message(SPAN_WARNING("\The [user] begins [pry_desc] at \the [pesky_door]!"))
	set_AI_busy(TRUE)
	if(do_after(user, delay, pesky_door, DO_DEFAULT | DO_PUBLIC_PROGRESS))
		pesky_door.open(1)
		ai_holder.prying = FALSE
		set_AI_busy(FALSE)
	else
		visible_message(SPAN_NOTICE("\The [user] is interrupted."))
		set_AI_busy(FALSE)

/mob/living/simple_animal/rejuvenate()
	..()
	icon_state = icon_living
	update_icon()
	bleed_ticks = 0
	ai_holder?.handle_stance_tactical()
