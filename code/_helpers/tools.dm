/// True when this atom can be used as a wrench.
/atom/proc/IsWrench()
	return FALSE

/// Defines the base wrench as useable as a wrench.
/obj/item/wrench/IsWrench()
	return TRUE

/// True when A exists and can be used as a wrench.
#define isWrench(A) (A?.IsWrench())


/// True when this atom can be used as a Welder.
/atom/proc/IsWelder()
	return FALSE

/// Defines the base welder as useable as a welder.
/obj/item/weldingtool/IsWelder()
	return TRUE

/// True when A exists and can be used as a welder.
#define isWelder(A) (A?.IsWelder())


/// True when this atom can be used as a cable coil.
/atom/proc/IsCoil()
	return FALSE

/// Defines the base coil as useable as a cable coil.
/obj/item/stack/cable_coil/IsCoil()
	return TRUE

/// True when A exists and can be used as a cable coil.
#define isCoil(A) (A?.IsCoil())


/// True when this atom can be used as a wirecutter.
/atom/proc/IsWirecutter()
	return FALSE

/// Defines the base wirecutter as useable as a wirecutter.
/obj/item/wirecutters/IsWirecutter()
	return TRUE

/// True when A exists and can be used as a wirecutter.
#define isWirecutter(A) (A?.IsWirecutter())


/// True when this atom can be used as a screwdriver.
/atom/proc/IsScrewdriver()
	return FALSE

/// Defines the base screwdriver as useable as a screwdriver.
/obj/item/screwdriver/IsScrewdriver()
	return TRUE

/// True when A exists and can be used as a screwdriver.
#define isScrewdriver(A) (A?.IsScrewdriver())

#define isShovel(A) (A?.IsShovel())


/// True when this atom can be used as a multitool.
/atom/proc/IsMultitool()
	return FALSE

/// Defines the base multitool as useable as a multitool.
/obj/item/device/multitool/IsMultitool()
	return TRUE

/// True when A exists and can be used as a multitool.
#define isMultitool(A) (A?.IsMultitool())


/// True when this atom can be used as a crowbar.
/atom/proc/IsCrowbar()
	return FALSE

/// Defines the base crowbar as useable as a crowbar.
/obj/item/crowbar/IsCrowbar()
	return TRUE

/// True when A exists and can be used as a crowbar.
#define isCrowbar(A) (A?.IsCrowbar())


/// True when this atom can be used as a hatchet.
/atom/proc/IsHatchet()
	return FALSE

/atom/proc/isshovel()
	return FALSE

/// Defines the base hatchet as useable as a hatchet.
/obj/item/material/hatchet/IsHatchet()
	return TRUE

/obj/item/weapon/weldingtool/iswelder()
	return TRUE

/obj/item/stack/cable_coil/iscoil()
	return TRUE

/obj/item/weapon/wirecutters/iswirecutter()
	return TRUE

/obj/item/weapon/screwdriver/isscrewdriver()
	return TRUE

/obj/item/device/multitool/ismultitool()
	return TRUE

/obj/item/weapon/crowbar/iscrowbar()
	return TRUE

/obj/item/weapon/material/hatchet/ishatchet()
	return TRUE

/obj/item/weapon/shovel/isshovel()
	return TRUE
