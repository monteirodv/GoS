class "Teemo"

require('DamageLib')

local _shadow = myHero.pos

function Teemo:__init()
    if myHero.charName ~= "Teemo" then return end
    self:LoadSpells()
    self:LoadMenu()
    Callback.Add("Tick", function() self:Tick() end)
    Callback.Add("Draw", function() self:Draw() end)
end

function Teemo:LoadSpells()
Q = {Delay = 0.25, Range = 580}
W = {Delay = 0.25}
E = {Delay = 0.25}
R = {Delay = 0.25 ,Range = 650}
end

function Teemo:LoadMenu()
    self.Menu = MenuElement({type = MENU, id = "Teemo", name = "Teemo - The Swift Scout", leftIcon="http://orig10.deviantart.net/0a20/f/2013/075/3/9/teemo___classic_by_tanaka89-d5y84or.png"})

    --[[Combo]]
    self.Menu:MenuElement({type = MENU, id = "Combo", name = "Combo Settings"})
    self.Menu.Combo:MenuElement({id = "ComboQ", name = "Use Q", value = true})
    self.Menu.Combo:MenuElement({id = "ComboW", name = "Use W", value = false})
    self.Menu.Combo:MenuElement({id = "ComboR", name = "Use R", value = false})
    --[[Harass]]
    self.Menu:MenuElement({type = MENU, id = "Harass", name = "Harass Settings"})
    self.Menu.Harass:MenuElement({id = "HarassQ", name = "Use Q", value = true})
    self.Menu.Harass:MenuElement({id = "HarassMana", name = "Min. Mana", value = 40, min = 0, max = 100})

    --[[Farm]]
    self.Menu:MenuElement({type = MENU, id = "Farm", name = "Farm Settings"})
    self.Menu.Farm:MenuElement({id = "FarmQ", name = "Use Q to clear", value = true})
    self.Menu.Farm:MenuElement({id = "FarmMana", name = "Min. Mana", value = 40, min = 0, max = 100})

    --[[Misc]]
    --self.Menu:MenuElement({type = MENU, id = "Misc", name = "Misc Settings"})

    --[[Draw]]
    self.Menu:MenuElement({type = MENU, id = "Draw", name = "Drawing Settings"})
    self.Menu.Draw:MenuElement({id = "DrawReady", name = "Draw Only Ready Spells [?]", value = true, tooltip = "Only draws spells when they're ready"})
    self.Menu.Draw:MenuElement({id = "DrawQ", name = "Draw Q Range", value = true})
    self.Menu.Draw:MenuElement({id = "DrawE", name = "Draw E Range", value = true})
	    self.Menu.Draw:MenuElement({id = "DrawR", name = "Draw E Range", value = true})
    self.Menu.Draw:MenuElement({id = "DrawTarget", name = "Draw Target [?]", value = true, tooltip = "Draws current target"})

end

function Teemo:Tick()

    -- Put everything you want to update every time the game ticks here (don't put too many calculations here or you'll drop FPS)

    if self:Mode() == "Combo" then
        self:Combo()
    elseif self:Mode() == "Harass" then
        self:Harass()
    elseif self:Mode() == "Farm" then
        self:Farm()
    elseif self:Mode() == "LastHit" then
        self:LastHit()
    end
end

function Teemo:Combo()
local qtarget = self:GetTarget(Q.range)

if qtarget and self.Menu.Combo.ComboQ:Value() and self:CanCast(_Q)then
local castPos = qtarget
self:CastQ(castPos)
end



if self.Menu.Combo.ComboW:Value() and self:CanCast(_W)then
local qtarget = self:GetTarget(Q.range)
if qtaget.distance <= Q.Range + 150
Control.CastSpell(HK_W, position)
end
end

local rtarget = self:GetTarget(r.range)

if rtarget and self.Menu.Combo.ComboR:Value() and self:CanCast(_R)then
local castPos = rtarget
self:CastR(castPos)
end



end



function Teemo:Harass()
local qtarget = self:GetTarget(Q.range)

if qtarget and self.Menu.Combo.ComboQ:Value() and self:CanCast(_Q)then
local castPos = qtarget
self:CastQ(castPos)
end
end

function Teemo:Farm()
if (myHero.mana/myHero.maxMana >= self.Menu.Farm.FarmMana:Value()/100) then
local qMinion
		if self:CanCast(_Q) then
			for j = 1,Game.MinionCount() do
        local minion = Game.Minion(j)
        if minion.isTargetable and not minion.dead and minion.distance <= Q.Range and minion.team ~= myHero.team then
            qMinion = minion
            break
        end
    end
			if qMinion then
					    Control.SetCursorPos(qMinion)
				Control.CastSpell(HK_Q, qMinion)
			end
		end
	end
end

function Teemo:LastHit()
    -- LASTHIT LOGIC HERE
end

function Teemo:CastQ(position)
    if position then
	    Control.SetCursorPos(position)
        Control.CastSpell(HK_Q, position)
    end
end

function Teemo:CastW(position)
    if position then
		    Control.SetCursorPos(position)

        Control.CastSpell(HK_W, position)
    end
end

function Teemo:CastE(position)
    if position then
		    Control.SetCursorPos(position)

        Control.CastSpell(HK_E, position)
    end
end

function Teemo:CastR(target)
    if target then
		    Control.SetCursorPos(position)

        Control.CastSpell(HK_R, target)
    end
end

function Teemo:Draw()
    if myHero.dead then return end

    if self.Menu.Draw.DrawReady:Value() then
        if self:IsReady(_Q) and self.Menu.Draw.DrawQ:Value() then
            Draw.Circle(myHero.pos, Q.Range, 1, Draw.Color(255, 255, 255, 255))
        end
        if self:IsReady(_W) and self.Menu.Draw.DrawW:Value() then
            Draw.Circle(myHero.pos, W.Range, 1, Draw.Color(255, 255, 255, 255))
        end
        if self:IsReady(_R) and self.Menu.Draw.DrawR:Value() then
            Draw.Circle(myHero.pos, E.Range, 1, Draw.Color(255, 255, 255, 255))
        end

    else
        if self.Menu.Draw.DrawQ:Value() then
            Draw.Circle(myHero.pos, Q.Range, 1, Draw.Color(255, 255, 255, 255))
        end
        if self.Menu.Draw.DrawW:Value() then
            Draw.Circle(myHero.pos, W.Range, 1, Draw.Color(255, 255, 255, 255))
        end
        if self.Menu.Draw.DrawR:Value() then
            Draw.Circle(myHero.pos, R.Range, 1, Draw.Color(255, 255, 255, 255))
        end

    end


    if self.Menu.Draw.DrawTarget:Value() then
        local drawTarget = self:GetTarget(Q.Range)
        if drawTarget then
            Draw.Circle(drawTarget.pos,80,3,Draw.Color(255, 255, 0, 0))
        end
    end
end

function Teemo:Mode()
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

function Teemo:GetTarget(range)
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



function Teemo:GetPercentHP(unit)
    return 100 * unit.health / unit.maxHealth
end

function Teemo:GetPercentMP(unit)
    return 100 * unit.mana / unit.maxMana
end

function Teemo:HasBuff(unit, buffname)
    for K, Buff in pairs(self:GetBuffs(unit)) do
        if Buff.name:lower() == buffname:lower() then
            return true
        end
    end
    return false
end

function Teemo:GetBuffs(unit)
    self.T = {}
    for i = 0, unit.buffCount do
        local Buff = unit:GetBuff(i)
        if Buff.count > 0 then
            table.insert(self.T, Buff)
        end
    end
    return self.T
end

function Teemo:IsReady(spellSlot)
    return myHero:GetSpellData(spellSlot).currentCd == 0 and myHero:GetSpellData(spellSlot).level > 0
end

function Teemo:CheckMana(spellSlot)
    return myHero:GetSpellData(spellSlot).mana < myHero.mana
end

function Teemo:CanCast(spellSlot)
    return self:IsReady(spellSlot) and self:CheckMana(spellSlot)
end




function OnLoad()
    Teemo()
end