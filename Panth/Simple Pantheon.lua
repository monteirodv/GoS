class "Pantheon"

require('DamageLib')

local _shadow = myHero.pos

function Pantheon:__init()
    if myHero.charName ~= "Pantheon" then return end
    self:LoadSpells()
    self:LoadMenu()
    Callback.Add("Tick", function() self:Tick() end)
    Callback.Add("Draw", function() self:Draw() end)
end

function Pantheon:LoadSpells()
Q = {Delay = 0.25, Range = 600}
W = {Delay = 0.25, Range = 600} 
E = {Delay = 0.25, Range = 600}
end

function Pantheon:LoadMenu()
    self.Menu = MenuElement({type = MENU, id = "Pantheon", name = "Pantheon - The artisan of war", leftIcon="http://images1.wikia.nocookie.net/__cb20100121071638/leagueoflegends/images/9/9b/PantheonSquare.png"})

    --[[Combo]]
    self.Menu:MenuElement({type = MENU, id = "Combo", name = "Combo Settings"})
    self.Menu.Combo:MenuElement({id = "ComboQ", name = "Use Q", value = true})
    self.Menu.Combo:MenuElement({id = "ComboW", name = "Use W", value = true})
    self.Menu.Combo:MenuElement({id = "ComboE", name = "Use E", value = true})
    --[[Harass]]
    self.Menu:MenuElement({type = MENU, id = "Harass", name = "Harass Settings"})
    self.Menu.Harass:MenuElement({id = "HarassQ", name = "Use Q", value = true})
	self.Menu.Harass:MenuElement({id = "HarassE", name = "Use Q", value = true})
    self.Menu.Harass:MenuElement({id = "HarassMana", name = "Min. Mana", value = 40, min = 0, max = 100})


    --[[Misc]]
    --self.Menu:MenuElement({type = MENU, id = "Misc", name = "Misc Settings"})

    --[[Draw]]
    self.Menu:MenuElement({type = MENU, id = "Draw", name = "Drawing Settings"})
    self.Menu.Draw:MenuElement({id = "DrawReady", name = "Draw Only Ready Spells [?]", value = true, tooltip = "Only draws spells when they're ready"})
    self.Menu.Draw:MenuElement({id = "DrawQ", name = "Draw Q Range", value = true})
    self.Menu.Draw:MenuElement({id = "DrawW", name = "Draw W Range", value = true})
    self.Menu.Draw:MenuElement({id = "DrawE", name = "Draw E Range", value = true})
    self.Menu.Draw:MenuElement({id = "DrawTarget", name = "Draw Target [?]", value = true, tooltip = "Draws current target"})

end

function Pantheon:Tick()

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

function Pantheon:Combo()
local qtarget = self:GetTarget(Q.range)

if qtarget and self.Menu.Combo.ComboQ:Value() and self:CanCast(_Q)then
local castPos = qtarget
self:CastQ(castPos)
end


local wtarget = self:GetTarget(W.range)

if wtarget and self.Menu.Combo.ComboW:Value() and self:CanCast(_W)then
local castPos = wtarget
self:CastW(castPos)
end


local etarget = self:GetTarget(E.range)
if etarget and self.Menu.Combo.ComboE:Value() and not self:CanCast(_W) and self:CanCast(_E)then
local castPos = etarget
self:CastE(castPos)
end

end



function Pantheon:Harass()
	if(myHero.mana/myHero.maxMana >= self.Menu.Harass.HarassMana:Value()/100) then
	local qtarget = self:GetTarget(Q.range)
if qtarget and self.Menu.Harass.HarassQ:Value() and  qtarget.distance <= Q.Range and self:CanCast(_Q)then
local castPos = qtarget
self:CastQ(castPos)
end
end


end





function Pantheon:LastHit()
    -- LASTHIT LOGIC HERE
end

function Pantheon:CastQ(position)
    if position then
	    Control.SetCursorPos(position)
        Control.CastSpell(HK_Q, position)
    end
end

function Pantheon:CastW(position)
    if position then
		    Control.SetCursorPos(position)

        Control.CastSpell(HK_W, position)
    end
end

function Pantheon:CastE(position)
    if position then
		    Control.SetCursorPos(position)

        Control.CastSpell(HK_E, position)
    end
end

function Pantheon:CastR(target)
    if target then
		    Control.SetCursorPos(position)

        Control.CastSpell(HK_R, target)
    end
end

function Pantheon:Draw()
    if myHero.dead then return end

    if self.Menu.Draw.DrawReady:Value() then
        if self:IsReady(_Q) and self.Menu.Draw.DrawQ:Value() then
            Draw.Circle(myHero.pos, Q.Range, 1, Draw.Color(255, 255, 255, 255))
        end
        if self:IsReady(_W) and self.Menu.Draw.DrawW:Value() then
            Draw.Circle(myHero.pos, W.Range, 1, Draw.Color(255, 255, 255, 255))
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

function Pantheon:Mode()
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

function Pantheon:GetTarget(range)
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



function Pantheon:GetPercentHP(unit)
    return 100 * unit.health / unit.maxHealth
end

function Pantheon:GetPercentMP(unit)
    return 100 * unit.mana / unit.maxMana
end

function Pantheon:HasBuff(unit, buffname)
    for K, Buff in pairs(self:GetBuffs(unit)) do
        if Buff.name:lower() == buffname:lower() then
            return true
        end
    end
    return false
end

function Pantheon:GetBuffs(unit)
    self.T = {}
    for i = 0, unit.buffCount do
        local Buff = unit:GetBuff(i)
        if Buff.count > 0 then
            table.insert(self.T, Buff)
        end
    end
    return self.T
end

function Pantheon:IsReady(spellSlot)
    return myHero:GetSpellData(spellSlot).currentCd == 0 and myHero:GetSpellData(spellSlot).level > 0
end

function Pantheon:CheckMana(spellSlot)
    return myHero:GetSpellData(spellSlot).mana < myHero.mana
end

function Pantheon:CanCast(spellSlot)
    return self:IsReady(spellSlot) and self:CheckMana(spellSlot)
end




function OnLoad()
    Pantheon()
end