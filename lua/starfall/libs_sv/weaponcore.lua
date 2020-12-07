
SF.Permissions.registerPrivilege("entities.giveAmmo","Give ammo","Allows the user to give ammo to the player", { entities = {} }) -- I have no clue if this is correct
SF.Permissions.registerPrivilege("entities.giveWeapon","Give weapon","Allows the user to give weapons to the player", { entities = {} })


local function main(instance)
	local ply = instance.Types.Player.Methods
	local checkluatype = SF.CheckLuaType
	local checktype = instance.CheckType
	local checkpermission = instance.player ~= NULL and SF.Permissions.check or function() end
	local getply = instance.Types.Player.GetPlayer
	local entunwrap = instance.Types.Entity.Unwrap
	

	
	local ammotypes = {}
	for k,v in pairs(game.GetAmmoTypes()) do
		ammotypes[v] = k
	end


	--- Gives player ammo
	-- @param string typ
	-- @param number ammt
	function ply:giveAmmo(typ,ammt)
		local plyr = getply(self)
		checkpermission(instance,plyr,"entities.giveAmmo")
		checkluatype(typ,TYPE_STRING)
		checkluatype(ammt,TYPE_NUMBER)
		if not ammotypes[typ] then return end -- I don't want to thrown an error here, so people can reuse their scripts with different addons installed
		plyr:GiveAmmo(ammt,typ)
	end

	local validweps = {}
	for k,v in pairs(list.Get("Weapon")) do
		validweps[k] = {}
		if v.AdminOnly then
			validweps[v.ClassName].Admin = true
		end
		validweps[v.ClassName].Spawnable = v.Spawnable
	end

	-- Gives player weapon
	-- @param string weapon
	function ply:giveWeapon(weapon)
		local plyr = getply(self)
		checkpermission(instance,plyr,"entities.giveWeapon")
		print("passed perm check")
		checkluatype(weapon,TYPE_STRING)
		print("passed luatype check")
		if not validweps[weapon] then return end -- I don't want to thrown an error here, so people can reuse their scripts with different addons installed
		local wep = validweps[weapon]
		if (wep.Admin and not plyr:IsAdmin()) or (not wep.Spawnable and not plyr:IsAdmin()) then return end
		plyr:Give(weapon)
	end

end

return main
