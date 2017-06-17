--version 0.0.1

local Users = {}
local CooldownSpells = {
	-- Mage
	-- Arcane
	[62] = {
		[2139] = true,			-- Counterspell
		[45438] = true,			-- Ice Block
	},
	-- Fire
	[63] = {
		[2139] = true,			-- Counterspell
		[45438] = true,			-- Ice Block
	},
	-- Frost
	[64] = {
		[2139] = true,			-- Counterspell
		[45438] = true,			-- Ice Block
	},

	-- Paladin
	-- Holy
	[65] = {
		[96231] = true,			-- Rebuke
		[1022] = true,			-- Blessing of Protection
		[31821] = true,			-- Aura Mastery
		[6940] = true,			-- Blessing of Sacrifice
		[642] = true,			-- Divine Shield
		[31842] = true,			-- Avenging Wrath
		[633] = true,			-- Lay on Hands
	},
	-- Protection
	[66] = {
		[96231] = true,			-- Rebuke
		[1022] = true,			-- Blessing of Protection
		[6940] = true,			-- Blessing of Sacrifice
		[642] = true,			-- Divine Shield
		[633] = true,			-- Lay on Hands
	},
	-- Retribution
	[70] = {
		[96231] = true,			-- Rebuke
		[1022] = true,			-- Blessing of Protection
		[642] = true,			-- Divine Shield
		[633] = true,			-- Lay on Hands
	},

	-- Warrior
	-- Arms
	[71] = {
		[132168] = true,		-- Shockwave
		[6552] = true,			-- Pummel
		[97462] = true,			-- Commanding Shout
	},
	-- Fury
	[72] = {
		[132168] = true,		-- Shockwave
		[6552] = true,			-- Pummel
		[97462] = true,			-- Commanding Shout
	},
	-- Protection
	[73] = {
		[132168] = true,		-- Shockwave
		[6552] = true,			-- Pummel
	},

	-- Druid
	-- Balance
	[102] = {
		[132469] = true,		-- Typhoon
		[78675] = true,			-- Solar Beam
		[20484] = true,			-- Rebirth
		[29166] = true,			-- Innervate
	},
	-- Feral
	[103] = {
		[132469] = true,		-- Typhoon
		[106839] = true,		-- Skull Bash
		[20484] = true,			-- Rebirth
		[77764] = true,			-- Stampeding Roar
	},
	-- Guardian
	[104] = {
		[61336] = true,			-- Survival Instincts
		[22812] = true,			-- Barkskin
		[200851] = true,		-- Rage of the Sleeper
		[132469] = true,		-- Typhoon
		[106839] = true,		-- Skull Bash
		[20484] = true,			-- Rebirth
		[77761] = true,			-- Stampeding Roar
		[99] = true,			-- Incapacitating Roar
	},
	-- Restoration
	[105] = {
		[102793] = true,		-- Ursol's Vortex
		[132469] = true,		-- Typhoon
		[20484] = true,			-- Rebirth
		[740] = true,			-- Tranquility
		[102342] = true,		-- Ironbark
		[208253] = true,		-- Essence of G'Hanir
	},

	-- Death Knight
	-- Blood
	[250] = {
		[48707] = true,			-- Anti-Magic Shell
		[205223] = true,		-- Consumption
		[108199] = true,		-- Gorefiend's Grasp
		[49028] = true,			-- Dancing Rune Weapon
		[55233] = true,			-- Vampiric Blood
		[47528] = true,			-- Mind Freeze
		[61999] = true,			-- Raise Ally
	},
	-- Frost
	[251] = {
		[47528] = true,			-- Mind Freeze
		[48792] = true,			-- Icebound Fortitude
		[61999] = true,			-- Raise Ally
	},
	-- Unholy
	[252] = {
		[47528] = true,			-- Mind Freeze
		[48792] = true,			-- Icebound Fortitude
		[42650] = true,			-- Army of the Dead
		[61999] = true,			-- Raise Ally
	},

	-- Hunter
	-- Beast Mastery
	[253] = {
		[109248] = true,		-- Binding Shot
		[147362] = true,		-- Counter Shot
		[34477] = true,			-- Misdirection
		[186265] = true,		-- Aspect of the Turtle
	},
	-- Marksmanship
	[254] = {
		[109248] = true,		-- Binding Shot
		[147362] = true,		-- Counter Shot
		[34477] = true,			-- Misdirection
		[186265] = true,		-- Aspect of the Turtle
	},
	-- Survival
	[255] = {
		[109248] = true,		-- Binding Shot
		[187707] = true,		-- Muzzle
		[186265] = true,		-- Aspect of the Turtle
	},

	-- Priest
	-- Discipline
	[256] = {
		[62618] = true,			-- Power Word: Barrier
		[33206] = true,			-- Pain Suppression
		[204263] = true,		-- Shining Force
	},
	-- Holy
	[257] = {
		[64843] = true,			-- Divine Hymn
		[47788] = true,			-- Guardian Spirit
		[200183] = true,         -- Apotheosis
	},
	-- Shadow
	[258] = {
		[15487] = true,			-- Silence
		[15286] = true,			-- Vampiric Embrace
		[205369] = true,		-- Mind Bomb
	},

	-- Rogue
	-- Assasination
	[259] = {
		[1766] = true,			-- Kick
		[31224] = true,			-- Cloak of Shadows
	},
	-- Outlaw
	[260] = {
		[1766] = true,			-- Kick
		[31224] = true,			-- Cloak of Shadows
	},
	-- Sublety
	[261] = {
		[1766] = true,			-- Kick
		[31224] = true,			-- Cloak of Shadows
	},

	-- Shaman
	-- Elemental
	[262] = {
		[192058] = true, 		-- Lightning Surge Totem
		[57994] = true,			-- Wind Shear
		[108281] = true,		-- Ancestral Guidance
		[20608] = true,			-- Ankh
	},
	-- Enhancement
	[263] = {
		[192058] = true, 		-- Lightning Surge Totem
		[57994] = true,			-- Wind Shear
		[20608] = true,			-- Ankh
	},
	-- Restoration
	[264] = {
		[192058] = true, 		-- Lightning Surge Totem
		[57994] = true,			-- Wind Shear
		[108281] = true,		-- Ancestral Guidance
		[108280] = true,		-- Healing Tide Totem
		[98008] = true,			-- Spirit Link Totem
		[20608] = true,			-- Ankh
	},

	-- Warlock
	-- Affliction
	[265] = {
		[171140] = true,		-- Shadow Lock
		[20707] = true,			-- Soulstone
	},
	-- Demonology
	[266] = {
		[171140] = true,		-- Shadow Lock
		[20707] = true,			-- Soulstone
		[30283] = true,			-- Shadowfury
	},
	-- Destruction
	[267] = {
		[171140] = true,		-- Shadow Lock
		[20707] = true,			-- Soulstone
		[30283] = true,			-- Shadowfury
	},

	-- Monk
	-- Brewmaster
	[268] = {
		[119381] = true,		-- Leg Sweep
		[116705] = true,		-- Spear Hand Strike
	},
	-- Windwalker
	[269] = {
		[119381] = true,		-- Leg Sweep
		[116705] = true,		-- Spear Hand Strike
	},
	-- Mistweaver
	[270] = {
		[119381] = true,		-- Leg Sweep
		[116705] = true,		-- Spear Hand Strike
		[115310] = true,		-- Revival
		[116849] = true,		-- Life Cocoon
	},

	-- Demon Hunter
	-- Havoc
	[577] = {
		[179057] = true,		-- Chaos Nova
		[183752] = true,		-- Consume Magic
		[196718] = true,		-- Darkness
		[196555] = true,		-- Netherwalk
	},
	-- Vengeance
	[581] = {
		[183752] = true,		-- Consume Magic
		[202138] = true,		-- Sigil of Chains
	}
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
CoopFrame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
CoopFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
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
	maybeSendAddonMessage(MSG_PREFIX,"REQINIT",RAID)
end

function CoopFrame:GROUP_ROSTER_UPDATE(event,...)
	CoopFrame:RebuildTable()
end

function CoopFrame:ACTIVE_TALENT_GROUP_CHANGED(event,...)
	CoopFrame:RebuildTable()
end

function CoopFrame:ZONE_CHANGED_NEW_AREA(event,...)
	CoopFrame:RebuildTable()
end

function maybeSendAddonMessage(prefix, message, channel)
	if IsInGroup(LE_PARTY_CATEGORY_HOME) or IsInRaid(LE_PARTY_CATEGORY_HOME) or IsInGroup(LE_PARTY_CATEGORY_INSTANCE) or IsInRaid(LE_PARTY_CATEGORY_INSTANCE) then
		SendAddonMessage(prefix,message,channel)
	end
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
		Users[name].userFrame:Hide()
	end
	local InInstance, InstanceType = IsInInstance()
	local playerSpecId, _, _, _, _, _ = GetSpecializationInfo(GetSpecialization())
	maybeSendAddonMessage(MSG_PREFIX,"INIT;"..playerSpecId,RAID)
end

function CoopFrame:CHAT_MSG_ADDON(event,...)
	local prefix, message, channel, sender = select(1,...)
	if prefix ~= MSG_PREFIX then
		return
	end
	-- print("Message ("..sender.."): "..message)
	if message:match("^INIT") then
		local msg, specId = message:match("([^;]+);([^;]+)")
		if Users[sender] == nil then
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
	elseif message:match("^REQINIT") then
		local playerSpecId, _, _, _, _, _ = GetSpecializationInfo(GetSpecialization())
		maybeSendAddonMessage(MSG_PREFIX,"INIT;"..playerSpecId,RAID)
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
			local f = Users[name]["cdIcons"][spellId].cd
			local tex = Users[name]["cdIcons"][spellId].tex
			f:Show()
			tex:Show()
		else
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
	local playerSpecId, _, _, _, _, _ = GetSpecializationInfo(GetSpecialization())
	for spellId,val in pairs(CooldownSpells[playerSpecId]) do
		local start, duration, enabled = GetSpellCooldown(spellId);
		if duration > 5 then
			maybeSendAddonMessage(MSG_PREFIX,"SUP;"..GetTime()..";"..spellId..";"..start..";"..duration..";"..enabled,RAID)
		end
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