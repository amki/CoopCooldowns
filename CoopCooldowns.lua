--version 0.0.1

local Users = {}
local playerUser = GetUnitName("player",true).."-"..GetRealmName()

local CoopFrame = CreateFrame("Frame", "CoopFrame", UIParent)
CoopFrame:RegisterEvent("SPELL_UPDATE_COOLDOWN")
CoopFrame:RegisterEvent("SPELL_UPDATE_USABLE")
local MSG_PREFIX = "CoopHelper"
local success = RegisterAddonMessagePrefix(MSG_PREFIX)
CoopFrame:RegisterEvent("CHAT_MSG_ADDON")
CoopFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
CoopFrame:RegisterEvent("ADDON_LOADED")

CoopFrame:ClearAllPoints()
CoopFrame:SetPoint("CENTER")
CoopFrame:SetSize(80, 80)
CoopFrame.text = CoopFrame:CreateFontString(nil, "BACKGROUND", "PVPInfoTextFont")
CoopFrame.text:SetAllPoints()
CoopFrame.text:SetTextHeight(13)
CoopFrame:SetAlpha(1)
CoopFrame:SetMovable(true)
CoopFrame:EnableMouse(true)
CoopFrame:RegisterForDrag("LeftButton")
CoopFrame:SetScript("OnDragStart", CoopFrame.StartMoving)
CoopFrame:SetScript("OnDragStop", CoopFrame.StopMovingOrSizing)

local abilityTexture = CoopFrame:CreateTexture()
abilityTexture:SetAllPoints()
abilityTexture:SetTexture("Interface\\Icons\\Ability_Druid_Flourish")
local myCooldown = CreateFrame("Cooldown", "myCooldown", CoopFrame, "CooldownFrameTemplate")
myCooldown:SetAllPoints()

function table.pack(...)
  return { n = select("#", ...), ... }
end

CoopFrame:SetScript("OnEvent", function(self, event_name, ...)
	if self[event_name] then
		return self[event_name](self, event_name, ...)
	end
end)

function CoopFrame:ADDON_LOADED(event,addon)
	if addon == "CoopHelper" then
		CoopFrame:RebuildTable()
	end
end

function CoopFrame:GROUP_ROSTER_UPDATE(event,...)
	CoopFrame:RebuildTable()
end

function CoopFrame:RebuildTable()
	Users = {}
	-- print("Reset Addon Users table")
	if IsInGroup() or IsInRaid() or IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
		local _,_,cIdx = UnitClass("player")
		SendAddonMessage(MSG_PREFIX,"INIT;"..cIdx..";"..GetSpecialization(),RAID)
	end
end

function CoopFrame:CHAT_MSG_ADDON(event,...)
	local prefix, message, channel, sender = select(1,...)
	if prefix ~= MSG_PREFIX then
		return
	end
	if message:match("^INIT") then
		local msg, class, spec = message:match("([^;]+);([^;]+);([^;]+)")
		print("Sender "..sender.." sent "..message)
		Users[sender] = {classId = class, specId = spec}
		print("User "..sender.." has specId "..Users[sender].specId.." and "..Users[sender].classId)
	end
end

function CoopFrame:SPELL_UPDATE_COOLDOWN(event,...)
	-- print("SPELL_UPDATE_COOLDOWN")
	local start, duration = GetSpellCooldown(48438)
	myCooldown:SetCooldown(start, duration)
end

function CoopFrame:SPELL_UPDATE_USABLE(event,...)
	-- print("SPELL_UPDATE_USABLE")
end

SlashCmdList["COOPCOOLDOWNS"] = function(msg,editBox)
	if msg == "activeuser" then
		print("activeUser is "..activeUser)
	elseif msg == "resync" then
		CoopFrame:RebuildTable()
	elseif msg == "test" then
		local test = "5;4"
		local class, spec = test:match("([^;]+);([^;]+)")
		print(class.." ;;;;; "..spec)
	end
end

SLASH_COOPCOOLDOWNS1 = "/coop"