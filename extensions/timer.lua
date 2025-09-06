local addon_name = "HodorReflexes"
local addon = _G[addon_name]

local extension = {
    name = "timer",
    version = "1.0.0",
}
local extension_name = extension.name
local extension_version = extension.version
addon[extension_name] = extension

local strmatch = string.match
local strformat = string.format
local EM = GetEventManager()

local timer = ZO_Object:Subclass()

local ON_START = "OnStart"
local ON_TICK = "OnTick"
local ON_STOP = "OnStop"
extension.ON_START = ON_START
extension.ON_TICK = ON_TICK
extension.ON_STOP = ON_STOP

function extension.New()
    return timer:New()
end

function timer:New()
    local obj = ZO_Object.New(self)
    obj.running = false
    obj.durationMS = 0
    obj.startTime = 0
    obj.tickInterval = 100 -- milliseconds
    obj._eventId = "Timer_" .. strmatch(tostring(obj), "0%x+")
    obj._cm = ZO_CallbackObject:New()
    return obj
end

function timer:SetTickInterval(tickInterval)
    self.tickInterval = tickInterval
end

function timer:SetHandler(handlerName, callback)
    self._cm:RegisterCallback(handlerName, callback)
end

function timer:StartCountdown(durationMS)
    self.running = true
    self.durationMS = durationMS
    self.startTime = GetGameTimeMilliseconds()
    self._cm:FireCallbacks(ON_START, ON_START, self.startTime, self.startTime + self.durationMS, self.durationMS, self.durationMS)

    EM:UnregisterForUpdate(self._eventId)
    EM:RegisterForUpdate(self._eventId, self.tickInterval, function()
        self._cm:FireCallbacks(ON_TICK, ON_TICK, self.startTime, self.startTime + self.durationMS, self.durationMS, self:GetRemainingMS())
        -- always stop AFTER firing the last tick
        if self:GetRemainingMS() <= 0 then
            self:Stop()
            return
        end
    end)

end

function timer:GetRemainingMS()
    -- duration - (now - start)
    return zo_max(0, self.durationMS - (GetGameTimeMilliseconds() - self.startTime))
end

function timer:IsRunning()
    return self.running
end

function timer:Stop()
    EM:UnregisterForUpdate(self._eventId)
    self.running = false
    self._cm:FireCallbacks(ON_STOP, ON_STOP, self.startTime, self.startTime + self.durationMS, self.durationMS, 0)
end

function timer:Reset()
    self.running = false
    self.remainingMS = 0
    self.startTime = 0
end