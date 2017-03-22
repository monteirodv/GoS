if myHero.charName ~= "Ezreal" then return end
require "DamageLib"

Config = MenuElement({type = MENU, id = "Ezreal", name = "Ezreal - The Prodigal Explorer", lefticon="http://pt.seaicons.com/wp-content/uploads/2015/07/Ezreal-Pulsefire-icon.png"})
Config:MenuElement({type = MENU, id = "HotKeys", name = "HotKeys"})
Config.Key:MenuElement({id = "Combo", name = "Combo", key = 32})
Config.Key:MenuElement({id = "Harass", name = "Harass", key = 67})
Config.Key:MenuElement({id = "LaneClear", name = "Farm", key = 86})
Config.Key:MenuElement({id = "LastHit", name = "Last Hit", key = 88})

Config:MenuElement({type = MENU, id = "Combo", name = "Combo"})
Config.Combo:MenuElement({id = "ComboQ", name = "Use Q", value = true})
Config.Combo:MenuElement({id = "ComboW", name = "Use W", value = true})
Config.Combo:MenuElement({id = "ComboE", name = "Use E for Damage(Ap Ezreal)", value = False})
Config.Combo:MenuElement({id = "ComboR", name = "Use R", value = true})

Config:MenuElement({type = MENU, id = "Harass", name = "Harass"})
Config.Harass:MenuElement({id = "HarassQ", name = "Use Q", value = true})
Config.Harass:MenuElement({id = "HarassW", name = "Use W", value = true})
Config.Harass:MenuElement({id = "HarassMana", name = "Min. Mana", value = 70, min = 0, max = 100})

Config:MenuElement({type = MENU, id = "LaneClear", name = "Lane Clear"})
Config.Farm:MenuElement({id = "FarmEnable", name = "Farm using spells", value = true})
Config.Farm:MenuElement({id = "QClear", name = "Use Q to clear", value = true})
Config.Farm:MenuElement({id = "FarmMana", name = "Min. Mana", value = 60, min = 0, max = 100})

Config:MenuElement({type = MENU, id = "LastHit", name = "Last Hit"})
Config.LastHit:MenuElement({id = "LastHitQ", name = "Use Q", value = true})
Config.LastHit:MenuElement({id = "LastHitMana", name = "Min. Mana", value = 60, min = 0, max = 100})

Config:MenuElement({type = MENU, id = "Draw", name = "Drawing Settings"})
Config.Draw:MenuElement({id = "DrawQ", name = "Draw Q", value = true})
Config.Draw:MenuElement({id = "DrawW", name = "Draw W", value = true})
Config.Draw:MenuElement({id = "DrawE", name = "Draw E", value = true})

Config:MenuElement({type = MENU, id = "KillSteal", name = "KillSteal"})

Config.Draw:MenuElement({id = "KSQ", name = "KS Q", value = true})
Config.Draw:MenuElement({id = "KSW", name = "KS W", value = true})
Config.Draw:MenuElement({id = "KSE", name = "KS E", value = false})
Config.Draw:MenuElement({id = "KSR", name = "KS R", value = false})

Q = {Delay = 0.25, Radius = 60, Range = 1150, Speed = 2000, Collision = true}
W = {Delay = 0.25, Radius = 80, Range = 1000, Speed = 2000, Collision = false}
E = {Delay = 0.25, Range = 475, Speed = math.max, width = 1}
R = {Delay = 1, Radius = 160, Range = 3000, Speed = 2000, Collision = false}
function IsValidTarget(obj, spellRange)
	return obj ~= nil and obj.valid and obj.visible and not obj.dead and obj.isTargetable and obj.distance <= spellRange
end
function GetTarget(range)
	local result = nil
	local N = 0
	for i = 1,Game.HeroCount()  do
		local hero = Game.Hero(i)	
		if ValidTarget(hero,range) and hero.team ~= myHero.team then
			local dmgtohero = CalcMagicalDamage(myHero,hero,100)
			local tokill = hero.health/dmgtohero
			if tokill > N or result == nil then
				result = hero
			end
		end
	end
	return result
end
function ValidTarget(unit,range,from)
	from = from or myHero.pos
	range = range or math.huge
	return unit and unit.valid and not unit.dead and unit.visible and unit.isTargetable and GetDistanceSqr(unit.pos,from) <= range*range
end
function isReady(slot)
	return Game.CanUseSpell(slot) == READY
end
function GetFarmTarget(minionRange)
	local getFarmTarget
	for j = 1,Game.MinionCount()	do
		local minion = Game.Minion(j)
		if isValidTarget(minion, minionRange) and minion.team ~= myHero.team then
      		getFarmTarget = minion
      		break
		end
	end
	return getFarmTarget
end

function CanCast(spellSlot)
	return self:IsReady(spellSlot) and self:CheckMana(spellSlot)
end
function Combo()
	local qtarget = GetTarget(Q.Range)	
	if qtarget and Game.CanUseSpell(_Q) == READY then
		CastQ(qtarget)
	end

end
function OnTick()

	if Config.Key.Combo:Value()  then
     Combo()
	 end
end

