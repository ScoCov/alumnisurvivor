class_name Tags
extends Resource

enum Group {
	NONE,
	ATHLETE, 
	ARTIST, 
	ACADEMIC, 
	MUSICAL, 
	INFLUENCER,
	NERD, 
	OUTCAST
	}

enum Enemy {
	NONE,
	ELITE,
	BOSS,
	NORMAL,
	WEAK,
	STRONG,
	RANGED,
	SPAWN,
	DEATH_SPAWN,
	CHARGER,
	PASSIVE,
	ARMORED
}

enum Attack_Type {
	None,
	Thrust,
	Swing,
	Slam,
	Wave,
	Beam,
	Chain,
	Projectile,
	Retaliation,
	Status_Effect,
	Pool
}

enum Damage_Type {
	None,
	Blunt,
	Sharp,
	Ego,
	Sound,
	Explosion,
	Toxic,
	Heat,
	Chill,
	Shock,
	Typless
}

enum Range_Type {
	None,
	Melee,
	Ranged,
	Area,
	Contact,
	Direct
}

enum Ability {
	None,
	Attack,
	Defense,
	Support,
	Other,
	Enemy
}

enum Rarity {
	Common,
	Uncommon,
	Rare,
	Legendary
}

enum Timeline {
	NONE,
	PAST,
	PRESENT
}

enum Difficulty {
	Normal, 
	Challenge,
	Hard,
	Legendary,
	Impossible
}
