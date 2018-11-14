local E, L, V, P, G = unpack(ElvUI);
local ENB = E:GetModule("NutsAndBolts");
local mod = E:NewModule('NB_ObjectiveTracker', 'AceEvent-3.0');

local GetInstanceInfo = GetInstanceInfo
local IsInInstance = IsInInstance
local GetNumTrackedAchievements = GetNumTrackedAchievements
local UnitOnTaxi = UnitOnTaxi

function mod:UpdateLocation()
	if (UnitOnTaxi("player")) then return end

	local db = E.db.NutsAndBolts.ObjectiveTracker
	local _, _, difficulty = GetInstanceInfo();

	if db.allInstances and IsInInstance() and (db.achievement == false or GetNumTrackedAchievements() == 0) and (db.mythic == false or (difficulty ~= 8)) then
		ObjectiveTrackerFrame:Hide()
	else
		ObjectiveTrackerFrame:Show()
	end
end

function mod:Initialize()
    self:RegisterEvent("CHALLENGE_MODE_RESET", mod.UpdateLocation)
    self:RegisterEvent("CHALLENGE_MODE_START", mod.UpdateLocation)
	self:RegisterEvent("PLAYER_ENTERING_WORLD", mod.UpdateLocation)
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA", mod.UpdateLocation)
	self.initialized = true
end

local function InitializeCallback()
	if E.db.NutsAndBolts.ObjectiveTracker.enable ~= true then return end
	mod:Initialize()
end

E:RegisterModule(mod:GetName(), InitializeCallback)