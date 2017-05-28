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
	[104] = {
		[61336] = true,
		[22812] = true,
		[200851] = true,
	},
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
	for name,obj in pairs(Users) do
		local cdspells = CooldownSpells[tonumber(obj.specId)]
		for spellId,val in pairs(cdspells) do
			local f = Users[name]["cdIcons"][spellId].cd
			local tex = Users[name]["cdIcons"][spellId].tex
			if f ~= nil then
				f:Hide()
			end
			if tex ~= nil then
				tex:Hide()
			end
		end
	end
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
		if Users[sender] == nil then
			print("Creating entry for "..sender)
			Users[sender] = {specId = specId, cdIcons = {}}
		else
			local cdspells = CooldownSpells[tonumber(Users[sender].specId)]
			for spellId,val in pairs(cdspells) do
				local f = Users[sender]["cdIcons"][spellId].cd
				local tex = Users[sender]["cdIcons"][spellId].tex
				if f ~= nil then
					f:Hide()
				end
				if tex ~= nil then
					tex:Hide()
				end
			end
			Users[sender].specId = specId
		end
		CoopFrame:CreateIcons(sender)
	elseif message:match("^SUP") then
		local msg, loctime, spellId, start, duration, enabled = message:match("([^;]+);([^;]+);([^;]+);([^;]+);([^;]+);([^;]+)")
		local offset = loctime - GetTime()
		if Users[sender] == nil then
			print("ERROR: Got SUP from someone who was not initiated.")
			return
		end
		local f = Users[sender]["cdIcons"][tonumber(spellId)].cd
		if f ~= nil then
			f:SetCooldown(start-offset,duration)
		else
			print("ERROR: Update for non-existing spell icon")
		end
	end
end

function CoopFrame:CreateIcons(name)
	local obj = Users[name]
	print("CreateIcons for "..name)
	local userFrame = nil
	if Users[name].userFrame == nil then
		userFrame = CreateFrame("Frame", nil, CoopFrame)
		userFrame:SetPoint("TOPLEFT",CoopFrame,"TOPLEFT",0,0)
		userFrame:SetSize(iconSize,iconSize)
		userFrame:SetMovable(true)
		userFrame:EnableMouse(true)
		userFrame:RegisterForDrag("LeftButton")
		userFrame:SetScript("OnDragStart", userFrame.StartMoving)
		userFrame:SetScript("OnDragStop", userFrame.StopMovingOrSizing)
		local nameFS = userFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		nameFS:SetPoint("TOPLEFT")
		nameFS:SetText(name)
		Users[name].userFrame = userFrame
		Users[name].lastFrame = nameFS
	else
		userFrame = Users[name].userFrame
		userFrame:Show()
	end
	local cdspells = CooldownSpells[tonumber(obj.specId)]
	for spellId,val in pairs(cdspells) do
		-- If this frame already exists do nothing
		if Users[name]["cdIcons"][spellId] ~= nil then
			print("User: "..name.."Frame for spell "..spellId.." exists.")
			local f = Users[name]["cdIcons"][spellId].cd
			local tex = Users[name]["cdIcons"][spellId].tex
			f:Show()
			tex:Show()
		else
			print("User: "..name.." Creating Frame for spellId "..spellId)
			local spellName, rank, icon, castTime, minRange, maxRange = GetSpellInfo(spellId)
			local spellCooldown = CreateFrame("Cooldown", nil, userFrame, "CooldownFrameTemplate")
			local tex = userFrame:CreateTexture()
			tex:SetTexture(icon)
			if Users[name].lastFrame == nil then
				spellCooldown:SetPoint("TOPLEFT",userFrame,"TOPLEFT",0,0)
				spellCooldown:SetSize(iconSize,iconSize)
				tex:SetPoint("TOPLEFT",userFrame,"TOPLEFT",0,0)
				tex:SetSize(iconSize,iconSize)
			else
				lastFrame = Users[name].lastFrame
				spellCooldown:ClearAllPoints()
				spellCooldown:SetPoint("TOPLEFT",lastFrame,"BOTTOMLEFT",0,-5)
				spellCooldown:SetSize(iconSize,iconSize)
				tex:ClearAllPoints()
				tex:SetPoint("TOPLEFT",lastFrame,"BOTTOMLEFT",0,-5)
				tex:SetSize(iconSize,iconSize)
			end
			Users[name].lastFrame = spellCooldown
			
			Users[name]["cdIcons"][spellId] = {userFrame = userFrame, cd = spellCooldown, tex = tex}
		end
	end
end

function CoopFrame:SPELL_UPDATE_COOLDOWN(event,...)
	print("SPELL_UPDATE_COOLDOWN")
	local playerSpecId, _, _, _, _, _ = GetSpecializationInfo(GetSpecialization())
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