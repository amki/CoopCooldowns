--version 0.0.1

local Users = {}
local CooldownSpells = {
	-- Mage
	-- Arcane
	[62] = {},
	-- Fire
	[63] = {},
	-- Frost
	[64] = {},

	-- Paladin
	-- Holy
	[65] = {},
	-- Protection
	[66] = {},
	-- Retribution
	[70] = {},

	-- Warrior
	-- Arms
	[71] = {},
	-- Fury
	[72] = {},
	-- Protection
	[73] = {},

	-- Druid
	-- Balance
	[102] = {},
	-- Feral
	[103] = {},
	-- Guardian
	[104] = {},
	-- Restoration
	[105] = {
		[48438] = true,
		[22812] = true,
		[18562] = true
	},

	-- Death Knight
	-- Blood
	[250] = {},
	-- Frost
	[251] = {},
	-- Unholy
	[252] = {},

	-- Hunter
	-- Beast Mastery
	[253] = {},
	-- Marksmanship
	[254] = {},
	-- Survival
	[255] = {},

	-- Priest
	-- Discipline
	[256] = {},
	-- Holy
	[257] = {},
	-- Shadow
	[258] = {},

	-- Rogue
	-- Assasination
	[259] = {},
	-- Outlaw
	[260] = {},
	-- Sublety
	[261] = {},

	-- Shaman
	-- Elemental
	[262] = {},
	-- Enhancement
	[263] = {},
	-- Restoration
	[264] = {},

	-- Warlock
	-- Affliction
	[265] = {},
	-- Demonology
	[266] = {},
	-- Destruction
	[267] = {},

	-- Monk
	-- Brewmaster
	[268] = {},
	-- Windwalker
	[269] = {},
	-- Mistweaver
	[270] = {},

	-- Demon Hunter
	-- Havoc
	[577] = {},
	-- Vengeance
	[581] = {}
}
local playerUser = GetUnitName("player",true).."-"..GetRealmName()
local iconSize = 32

local CoopFrame = CreateFrame("Frame", "CoopFrame", UIParent)
CoopFrame:RegisterEvent("SPELL_UPDATE_COOLDOWN")
CoopFrame:RegisterEvent("SPELL_UPDATE_USABLE")
local MSG_PREFIX = "CoopHelper"
local success = RegisterAddonMessagePrefix(MSG_PREFIX)
CoopFrame:RegisterEvent("CHAT_MSG_ADDON")
CoopFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
CoopFrame:RegisterEvent("PLAYER_ENTERING_WORLD")

CoopFrame:ClearAllPoints()
CoopFrame:SetPoint("CENTER")
CoopFrame:SetSize(iconSize, iconSize)
CoopFrame.text = CoopFrame:CreateFontString(nil, "BACKGROUND", "PVPInfoTextFont")
CoopFrame.text:SetAllPoints()
CoopFrame.text:SetTextHeight(12)
CoopFrame:SetAlpha(1)
CoopFrame:SetMovable(true)
CoopFrame:EnableMouse(true)
CoopFrame:RegisterForDrag("LeftButton")
CoopFrame:SetScript("OnDragStart", CoopFrame.StartMoving)
CoopFrame:SetScript("OnDragStop", CoopFrame.StopMovingOrSizing)

function table.pack(...)
  return { n = select("#", ...), ... }
end

function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

CoopFrame:SetScript("OnEvent", function(self, event_name, ...)
	if self[event_name] then
		return self[event_name](self, event_name, ...)
	end
end)

function CoopFrame:PLAYER_ENTERING_WORLD(event)
	CoopFrame:RebuildTable()
end

function CoopFrame:GROUP_ROSTER_UPDATE(event,...)
	CoopFrame:RebuildTable()
end

function CoopFrame:RebuildTable()
	Users = {}
	-- print("Reset Addon Users table")
	if IsInGroup() or IsInRaid() or IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
		local playerSpecId, _, _, _, _, _ = GetSpecializationInfo(GetSpecialization())
		SendAddonMessage(MSG_PREFIX,"INIT;"..playerSpecId,RAID)
	end
end

function CoopFrame:CHAT_MSG_ADDON(event,...)
	local prefix, message, channel, sender = select(1,...)
	if prefix ~= MSG_PREFIX then
		return
	end
	print("Message ("..sender.."): "..message)
	if message:match("^INIT") then
		local msg, specId = message:match("([^;]+);([^;]+)")
		Users[sender] = {specId = specId, cdIcons = {}}
		print("User "..sender.." has specId "..Users[sender].specId)
		CoopFrame:CreateIcons()
	elseif message:match("^SUP") then
		local msg, loctime, spellId, start, duration, enabled = message:match("([^;]+);([^;]+);([^;]+);([^;]+);([^;]+);([^;]+)")
		local offset = loctime - GetTime()
		print("Spellupdate: "..spellId.." s: "..start.." d: "..duration)
		if Users[sender] == nil then
			print("ERROR: Got SUP from someone who was not initiated.")
			return
		end
		local f = Users[sender]["cdIcons"][tonumber(spellId)]
		if f ~= nil then
			f:SetCooldown(start-offset,duration)
		else
			print("ERROR: Update for non-existing spell icon")
		end
	end
end

function CoopFrame:CreateIcons()
	local lastFrame = nil
	for name,obj in pairs(Users) do
		print("User "..name.." has spec "..obj.specId)
		local cdspells = CooldownSpells[tonumber(obj.specId)]
		for spellId,val in pairs(cdspells) do
			print("spellId "..spellId)
			local spellName, rank, icon, castTime, minRange, maxRange = GetSpellInfo(spellId)
			print("spellName "..spellName)
			local spellCooldown = CreateFrame("Cooldown", nil, CoopFrame, "CooldownFrameTemplate")
			local tex = CoopFrame:CreateTexture()
			tex:SetTexture(icon)
			if lastFrame == nil then
				spellCooldown:SetPoint("TOPLEFT",CoopFrame,"TOPLEFT",0,0)
				spellCooldown:SetSize(iconSize,iconSize)
				tex:SetPoint("TOPLEFT",CoopFrame,"TOPLEFT",0,0)
				tex:SetSize(iconSize,iconSize)
			else
				spellCooldown:ClearAllPoints()
				spellCooldown:SetPoint("TOPLEFT",lastFrame,"BOTTOMLEFT",0,-5)
				spellCooldown:SetSize(iconSize,iconSize)
				tex:ClearAllPoints()
				tex:SetPoint("TOPLEFT",lastFrame,"BOTTOMLEFT",0,-5)
				tex:SetSize(iconSize,iconSize)
			end
			lastFrame = spellCooldown
			
			Users[name]["cdIcons"][spellId] = spellCooldown
		end
	end
end

function CoopFrame:SPELL_UPDATE_COOLDOWN(event,...)
	print("SPELL_UPDATE_COOLDOWN")
	local playerSpecId, _, _, _, _, _ = GetSpecializationInfo(GetSpecialization())
	print("Player has spec: "..playerSpecId)
	for spellId,val in pairs(CooldownSpells[playerSpecId]) do
		local start, duration, enabled = GetSpellCooldown(spellId);
		SendAddonMessage(MSG_PREFIX,"SUP;"..GetTime()..";"..spellId..";"..start..";"..duration..";"..enabled,RAID)
	end
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