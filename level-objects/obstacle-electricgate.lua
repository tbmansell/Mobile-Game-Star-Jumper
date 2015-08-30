local soundEngine = require("core.sound-engine")


-- @class ElectricGate class
local electricgate = {
	
	isElectricGate = true,

	-- Methods:
	-----------
	-- setPhysics()
	-- canGrab()
	-- trigger()
	-- toggleDeadlyState()
	-- killWithElectricity()
}


function electricgate:setPhysics(s)
    if not globalIgnorePhysicsEngine then
        -- divide default image size by length to get scale
        local w, h  = 40*s, 300*s
        local shape = {-w,-h, w,-h, w,h/1.5, -w,h/1.5}
        physics.addBody(self.image, "static", {density=0, friction=0, bounce=0, isSensor=true, shape=shape})
    end
end


function electricgate:canGrab()
    return false
end


function electricgate:trigger()
    timer.cancel(self.timerAnimationHandle)
    self.deadly = false
    self:loop("Standard")
end


function electricgate:toggleDeadlyState()
    if self.deadly then
        self.deadly = false
        self:loop("Standard")
        self.timerAnimationHandle = timer.performWithDelay(self.timerOff, function() self:toggleDeadlyState(self) end, 1)
    else
        self.deadly = true
        
        if self.isElectricGate then
            soundEngine:playManaged(sounds.ledgeElectricActivated, self, self.timerOn)
            self:loop("Activated")
        end
        self.timerAnimationHandle = timer.performWithDelay(self.timerOn, function() self:toggleDeadlyState(self) end, 1)
    end
end


function electricgate:killWithElectricity(target)
    if (target.shielded ~= true or self.antishield) and target.mode ~= playerKilled then
        soundEngine:playManaged(sounds.playerDeathElectric, self, 2000)

        if target.shielded then
            target:shieldExpired()
        end

        if target.isPlayer then
            target:murder(self)
            if target.main then 
            	hud:displayMessageDied("electric-ledge") 
            end
        else
            target:destroy()
        end
    end
end


return electricgate