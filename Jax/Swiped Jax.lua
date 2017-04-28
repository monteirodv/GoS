class "Jax"

require('DamageLib')

local _shadow = myHero.pos

function Jax:__init()
    if myHero.charName ~= "Jax" then return end
    self:LoadSpells()
    self:LoadMenu()
    Callback.Add("Tick", function() self:Tick() end)
    Callback.Add("Draw", function() self:Draw() end)
end

function Jax:LoadSpells()
Q = {Delay = 0.25, Range = 700}
W = {Delay = 0.25, Range = 90}
E = {Delay = 0.25, Range = 187}
R = {Delay = 0.25, Range = 90}
end

function Jax:LoadMenu()
    self.Menu = MenuElement({type = MENU, id = "Jax", name = ""})
    self.Menu:MenuElement({type = MENU, id = "Keys", name = "Key Settings"})
    self.Menu.Key:MenuElement({id = "Combo", name = "Combo", key = string.byte(" ")})
    self.Menu.Key:MenuElement({id = "Harass", name = "Harass", key = string.byte("S")})
    self.Menu.Key:MenuElement({id = "Farm", name = "Farm", key = string.byte("V")})
    --[[Combo]]
    self.Menu:MenuElement({type = MENU, id = "Combo", name = "Combo Settings"})
    self.Menu.Combo:MenuElement({id = "ComboQ", name = "Use Q", value = true})
    self.Menu.Combo:MenuElement({id = "ComboW", name = "Use W", value = true})
    self.Menu.Combo:MenuElement({id = "ComboE", name = "Use E", value = true})
	self.Menu.Combo:MenuElement({id = "ComboR", name = "Use R", value = true})
    --[[Harass]]
    self.Menu:MenuElement({type = MENU, id = "Harass", name = "Harass Settings"})
    self.Menu.Harass:MenuElement({id = "HarassQ", name = "Use Q", value = true})
    self.Menu.Harass:MenuElement({id = "HarassW", name = "Use W", value = true})
	    self.Menu.Harass:MenuElement({id = "HarassE", name = "Use W", value = true})
    self.Menu.Harass:MenuElement({id = "HarassMana", name = "Min. Mana", value = 40, min = 0, max = 100})

    --[[Farm]]
    self.Menu:MenuElement({type = MENU, id = "Farm", name = "Farm Settings"})
    self.Menu.Farm:MenuElement({id = "FarmE", name = "Use E", value = true})
    self.Menu.Farm:MenuElement({id = "FarmMana", name = "Min. Mana", value = 40, min = 0, max = 100})

    --[[Misc]]
    --self.Menu:MenuElement({type = MENU, id = "Misc", name = "Misc Settings"})

    --[[Draw]]
    self.Menu:MenuElement({type = MENU, id = "Draw", name = "Drawing Settings"})
    self.Menu.Draw:MenuElement({id = "DrawReady", name = "Draw Only Ready Spells [?]", value = true, tooltip = "Only draws spells when they're ready"})
    self.Menu.Draw:MenuElement({id = "DrawQ", name = "Draw Q Range", value = true})
    self.Menu.Draw:MenuElement({id = "DrawE", name = "Draw E Range", value = true})
    self.Menu.Draw:MenuElement({id = "DrawTarget", name = "Draw Target [?]", value = true, tooltip = "Draws current target"})

end

function Jax:Tick()

    -- Put everything you want to update every time the game ticks here (don't put too many calculations here or you'll drop FPS)

if GOS:GetMode() == "Combo" then 
        self:Combo()
elseif GOS:GetMode() == "Harass" then 
        self:Harass()
elseif GOS:GetMode() == "Farm" then 
        self:Farm()
elseif GOS:GetMode() == "LastHit" then 
        self:LastHit()
    end
end

function Jax:Combo()
local qtarget = self:GetTarget(Q.range)

if qtarget and self.Menu.Combo.ComboQ:Value()and qtarget.distance <= Q.Range and self:CanCast(_Q)then
local castPos = qtarget
self:CastQ(castPos)
end


local wtarget = self:GetTarget(100)

if wtarget and self.Menu.Combo.ComboW:Value() and qtarget.distance <= Q.Range and self:CanCast(_W)then
        Control.CastSpell(HK_W)
end


local etarget = self:GetTarget(Q.range)
if etarget and self.Menu.Combo.ComboE:Value() and qtarget.distance <= Q.Range and self:CanCast(_E) and self:CanCast(_Q) then
        Control.CastSpell(HK_E)
		else
		etarget = self:GetTarget(E.range)
		if etarget and self.Menu.Combo.ComboE:Value() and self:CanCast(_E) then
		        Control.CastSpell(HK_E)
local rtarget = self:GetTarget(100)

if rtarget and self.Menu.Combo.ComboR:Value() and qtarget.distance <= Q.Range and self:CanCast(_R)then
        Control.CastSpell(HK_R)
end

end

end
end


function Jax:Harass()
	if(myHero.mana/myHero.maxMana >= self.Menu.Harass.HarassMana:Value()/100) then
local qtarget = self:GetTarget(Q.range)

if qtarget and self.Menu.Harass.HarassQ:Value() and qtarget.distance <= Q.Range and self:CanCast(_Q)then
local castPos = qtarget
self:CastQ(castPos)
end


local wtarget = self:GetTarget(100)

if wtarget and self.Menu.Harass.HarassW:Value() and qtarget.distance <= Q.Range and self:CanCast(_W)then
        Control.CastSpell(HK_W)
end
end
end


function Jax:Farm()
if (myHero.mana/myHero.maxMana >= self.Menu.Farm.FarmMana:Value()/100) then
local qMinion
		if self:CanCast(_Q) then
			for j = 1,Game.MinionCount() do
        local minion = Game.Minion(j)
        if minion.isTargetable and not minion.dead and minion.distance <= E.Range and minion.team ~= myHero.team then
            qMinion = minion
            break
        end
    end
			if qMinion then
        Control.CastSpell(HK_E)

			end
		end
	end
end


function Jax:LastHit()
    -- LASTHIT LOGIC HERE
end

function Jax:CastQ(position)
    if position then
	    Control.SetCursorPos(position)
        Control.CastSpell(HK_Q, position)
    end
end

function Jax:CastW(position)
    if position then
		    Control.SetCursorPos(position)

        Control.CastSpell(HK_W, position)
    end
end

function Jax:CastE(position)
    if position then
		    Control.SetCursorPos(position)

        Control.CastSpell(HK_E, position)
    end
end

function Jax:CastR(target)
    if target then
		    Control.SetCursorPos(position)

        Control.CastSpell(HK_R, target)
    end
end

function Jax:Draw()
    if myHero.dead then return end

    if self.Menu.Draw.DrawReady:Value() then
        if self:IsReady(_Q) and self.Menu.Draw.DrawQ:Value() then
            Draw.Circle(myHero.pos, Q.Range, 1, Draw.Color(255, 255, 255, 255))
        end
        
        if self:IsReady(_E) and self.Menu.Draw.DrawE:Value() then
            Draw.Circle(myHero.pos, E.Range, 1, Draw.Color(255, 255, 255, 255))
        end

    else
        if self.Menu.Draw.DrawQ:Value() then
            Draw.Circle(myHero.pos, Q.Range, 1, Draw.Color(255, 255, 255, 255))
        end
        if self.Menu.Draw.DrawW:Value() then
            Draw.Circle(myHero.pos, W.Range, 1, Draw.Color(255, 255, 255, 255))
        end
        if self.Menu.Draw.DrawE:Value() then
            Draw.Circle(myHero.pos, E.Range, 1, Draw.Color(255, 255, 255, 255))
        end

    end


    if self.Menu.Draw.DrawTarget:Value() then
        local drawTarget = self:GetTarget(Q.Range)
        if drawTarget then
            Draw.Circle(drawTarget.pos,80,3,Draw.Color(255, 255, 0, 0))
        end
    end
end

function Jax:Mode()
    if Orbwalker["Combo"].__active then
        return "Combo"
    elseif Orbwalker["Harass"].__active then
        return "Harass"
    elseif Orbwalker["Farm"].__active then
        return "Farm"
    elseif Orbwalker["LastHit"].__active then
        return "LastHit"
    end
    return ""
end

function Jax:GetTarget(range)
    local target
    for i = 1,Game.HeroCount() do
        local hero = Game.Hero(i)
        if hero.isTargetable and not hero.dead and hero.team ~= myHero.team then
            target = hero
            break
        end
    end
    return target
end



function Jax:GetPercentHP(unit)
    return 100 * unit.health / unit.maxHealth
end

function Jax:GetPercentMP(unit)
    return 100 * unit.mana / unit.maxMana
end

function Jax:HasBuff(unit, buffname)
    for K, Buff in pairs(self:GetBuffs(unit)) do
        if Buff.name:lower() == buffname:lower() then
            return true
        end
    end
    return false
end

function Jax:GetBuffs(unit)
    self.T = {}
    for i = 0, unit.buffCount do
        local Buff = unit:GetBuff(i)
        if Buff.count > 0 then
            table.insert(self.T, Buff)
        end
    end
    return self.T
end

function Jax:IsReady(spellSlot)
    return myHero:GetSpellData(spellSlot).currentCd == 0 and myHero:GetSpellData(spellSlot).level > 0
end

function Jax:CheckMana(spellSlot)
    return myHero:GetSpellData(spellSlot).mana < myHero.mana
end

function Jax:CanCast(spellSlot)
    return self:IsReady(spellSlot) and self:CheckMana(spellSlot)
end




function OnLoad()
    Jax()
end
