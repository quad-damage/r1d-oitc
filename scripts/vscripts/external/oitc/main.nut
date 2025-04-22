function main() {
	AddDamageCallback("player", on_player_damage)
	AddCallback_OnPlayerRespawned(on_player_respawn)
	
	RegisterSignal("EndGiveLoadouts")
}

function on_player_damage(ent, damageInfo) {
	local inflictor = damageInfo.GetInflictor()
	if(inflictor == null || !inflictor.IsPlayer())
		return
	
	local weapon = inflictor.GetActiveWeapon()
	if(weapon == null)
		return
	
	if(damageInfo.GetDamageSourceIdentifier() == eDamageSourceId.human_melee) {
		weapon.SetWeaponPrimaryAmmoCount(0)
		weapon.SetWeaponPrimaryClipCount(1)
	} else {
		if(weapon.GetClassname() != "mp_weapon_wingman") {
			give_oitc_weapons(inflictor)
			damageInfo.SetDamage(0)
			return
		}

		damageInfo.SetDamage(99999)
		weapon.SetWeaponPrimaryAmmoCount(0)
		weapon.SetWeaponPrimaryClipCount(2)
	}
}

function on_player_respawn(player) {
	give_oitc_weapons(player)
	thread on_player_respawn_thread(player)
}

function on_player_respawn_thread(player) {
	player.WaitSignal("EndGiveLoadouts")

	while(IsValid(player.isSpawning)) {
		wait 1
	}

	give_oitc_weapons(player)
}


function give_oitc_weapons(player) {
	TakeAllWeapons(player)
	player.GiveWeapon("mp_weapon_wingman")
	
	local weapon = player.GetActiveWeapon()
	if(weapon == null)
		return
	
	weapon.SetWeaponPrimaryAmmoCount(0)
	weapon.SetWeaponPrimaryClipCount(1)
}