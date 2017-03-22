class "Ezreal"

require('DamageLib')

local _shadow = myHero.pos

function Ezreal:__init()
    if myHero.charName ~= "Ezreal" then return end
    self:LoadSpells()
    self:LoadMenu()
    Callback.Add("Tick", function() self:Tick() end)
    Callback.Add("Draw", function() self:Draw() end)
end

function Ezreal:LoadSpells()
Q = {Delay = 0.25, Radius = 60, Range = 1150, Speed = 2000, Collision = true}
W = {Delay = 0.25, Radius = 80, Range = 1000, Speed = 2000, Collision = false}
E = {Delay = 0.25, Range = 475, Speed = math.max, width = 1}
R = {Delay = 1, Radius = 160, Range = 3000, Speed = 2000, Collision = false}
end

function Ezreal:LoadMenu()
    self.Menu = MenuElement({type = MENU, id = "Ezreal", name = "Ezreal - The Prodigal Explorer", leftIcon="http://pt.seaicons.com/wp-content/uploads/2015/07/Ezreal-Pulsefire-icon.png"})

    --[[Combo]]
    self.Menu:MenuElement({type = MENU, id = "Combo", name = "Combo Settings"})
    self.Menu.Combo:MenuElement({id = "ComboQ", name = "Use Q", value = true})
    self.Menu.Combo:MenuElement({id = "ComboW", name = "Use W", value = true})
    self.Menu.Combo:MenuElement({id = "ComboE", name = "Use E offensively (AP EZ)", value = false})
    self.Menu.Combo:MenuElement({id = "ComboR", name = "Use R", value = true})
    --[[Harass]]
    self.Menu:MenuElement({type = MENU, id = "Harass", name = "Harass Settings"})
    self.Menu.Harass:MenuElement({id = "HarassQ", name = "Use Q", value = true})
    self.Menu.Harass:MenuElement({id = "HarassW", name = "Use W", value = true})
    self.Menu.Harass:MenuElement({id = "HarassMana", name = "Min. Mana", value = 40, min = 0, max = 100})

    --[[Farm]]
    self.Menu:MenuElement({type = MENU, id = "Farm", name = "Farm Settings"})
    self.Menu.Farm:MenuElement({id = "FarmQ", name = "Use Q", value = true})
    self.Menu.Farm:MenuElement({id = "FarmMana", name = "Min. Mana", value = 40, min = 0, max = 100})

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

function Ezreal:Tick()

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

function Ezreal:Combo()
local qtarget = self:GetTarget(Q.range)
if qtarget and self.Menu.Combo.ComboQ:Value() and self:CanCast(_Q)then
if qtarget:GetCollision(Q.Radius, Q.Speed, Q.Delay) == 0 then
local castPos = qtarget:GetPrediction(Q.Speed, Q.Delay)
self:CastQ(castPos)
end
end

local wtarget = self:GetTarget(W.range)
if wtarget and self.Menu.Combo.ComboW:Value() and self:CanCast(_W)then
if wtarget:GetCollision(W.Radius, W.Speed, W.Delay) == 0 then
local castPos = wtarget:GetPrediction(R.Speed, R.Delay)
self:CastW(castPos)
end
end

local etarget = self:GetTarget(E.range)
if etarget and self.Menu.Combo.ComboE:Value() and self:CanCast(_E) and etarget.distance <= Q.range then
local castPos = etarget:GetPrediction(E.Speed, E.Delay)
self:CastE(castPos)
end


local rtarget = self:GetTarget(R.range)
if rtarget and self.Menu.Combo.ComboR:Value() and self:CanCast(_R)then
if rtarget:GetCollision(R.Radius, R.Speed, R.Delay) == 0 then
local castPos = rtarget:GetPrediction(R.Speed, R.Delay)
self:CastR(castPos)
end
end
end



function Ezreal:Harass()
    -- HARASS LOGIC HERE
end

function Ezreal:Farm()
    -- FARM LOGIC HERE
end

function Ezreal:LastHit()
    -- LASTHIT LOGIC HERE
end

function Ezreal:CastQ(position)
    if position then
	    Control.SetCursorPos(position)
        Control.CastSpell(HK_Q, position)
    end
end

function Ezreal:CastW(position)
    if position then
		    Control.SetCursorPos(position)

        Control.CastSpell(HK_W, position)
    end
end

function Ezreal:CastE(position)
    if position then
		    Control.SetCursorPos(position)

        Control.CastSpell(HK_E, position)
    end
end

function Ezreal:CastR(target)
    if target then
		    Control.SetCursorPos(position)

        Control.CastSpell(HK_R, target)
    end
end

function Ezreal:Draw()
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

function Ezreal:Mode()
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

function Ezreal:GetTarget(range)
    local target
    for i = 1,Game.HeroCount() do
        local hero = Game.Hero(i)
        if hero.isTargetable and hero.team ~= myHero.team then
            target = hero
            break
        end
    end
    return target
end

function Ezreal:GetFarmTarget(range)
    local target
    for j = 1,Game.MinionCount() do
        local minion = Game.Minion(j)
        if minion.isTargetable and minion.distance <= Q.range and minion.team ~= myHero.team then
            target = minion
            break
        end
    end
    return target
end

function Ezreal:GetPercentHP(unit)
    return 100 * unit.health / unit.maxHealth
end

function Ezreal:GetPercentMP(unit)
    return 100 * unit.mana / unit.maxMana
end

function Ezreal:HasBuff(unit, buffname)
    for K, Buff in pairs(self:GetBuffs(unit)) do
        if Buff.name:lower() == buffname:lower() then
            return true
        end
    end
    return false
end

function Ezreal:GetBuffs(unit)
    self.T = {}
    for i = 0, unit.buffCount do
        local Buff = unit:GetBuff(i)
        if Buff.count > 0 then
            table.insert(self.T, Buff)
        end
    end
    return self.T
end

function Ezreal:IsReady(spellSlot)
    return myHero:GetSpellData(spellSlot).currentCd == 0 and myHero:GetSpellData(spellSlot).level > 0
end

function Ezreal:CheckMana(spellSlot)
    return myHero:GetSpellData(spellSlot).mana < myHero.mana
end

function Ezreal:CanCast(spellSlot)
    return self:IsReady(spellSlot) and self:CheckMana(spellSlot)
end




function OnLoad()
    Ezreal()
end