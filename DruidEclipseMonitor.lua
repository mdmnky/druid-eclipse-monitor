local has_superwow = SetAutoloot and true or false

DruidEclipseMonitor = CreateFrame("Frame", "DruidEclipseMonitor", UIParent);

DruidEclipseMonitor:RegisterEvent("ADDON_LOADED")
DruidEclipseMonitor:RegisterEvent("PLAYER_AURAS_CHANGED")
DruidEclipseMonitor:RegisterEvent("PLAYER_DEAD")
DruidEclipseMonitor:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE")
DruidEclipseMonitor:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS")
DruidEclipseMonitor:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE")
DruidEclipseMonitor:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF")

DruidEclipseMonitor_frames = {}

DruidEclipseMonitor_default_x = 0
DruidEclipseMonitor_default_y = 0
DruidEclipseMonitor_default_width = 220
DruidEclipseMonitor_default_height = 200
DruidEclipseMonitor_default_sound = true
DruidEclipseMonitor_default_invertCooldown = false

DruidEclipseMonitor_demo = false
DruidEclipseMonitor_debug = false

DruidEclipseMonitor_color = {
	nature = { r = .584, g = 1, b = .306 },
	arcane = { r = .243, g = .812, b = 1 },
	text_dark = { r = 0, g = 0, b = 0 },
	debug = { r = 1, g = .1, b = .1 },
	debug_alt = { r = .1, g = .1, b = 1 },
}

DruidEclipseMonitorAuras = {
	["Nature Eclipse"] = {
		enabled = true,
		position = "LEFT",
		offset = { x = 0, y = 0 },
		icon = {
			size = { width = 100, height = 200 },
			texture = "Interface\\Addons\\DruidEclipseMonitor\\textures\\eclipse-arc.tga",
			textureCoord = { 0, .5, 0, 1 },
			color = DruidEclipseMonitor_color.nature,
			alpha = 1,
		},
		timer = {
			size = 26,
			offset = { x = 8, y = 0 }
		},
		buff = {
			id = 51042,
			texture = "Interface\\Icons\\Spell_Nature_AbolishMagic",
			type = "buff",
		},
		duration = 15,
		log = {
			start = "You are afflicted by Arcane Solstice", -- Track debuff start
			stop = "Nature Eclipse fades from you", -- Track buff end
		},
		sound = {
			start = "Interface\\Addons\\DruidEclipseMonitor\\sounds\\eclipse-nature.ogg",
			stop = nil,
		},
	},
	["Arcane Eclipse"] = {
		enabled = true,
		position = "RIGHT",
		offset = { x = 0, y = 0 },
		icon = {
			size = { width = 100, height = 200 },
			texture = "Interface\\Addons\\DruidEclipseMonitor\\textures\\eclipse-arc.tga",
			textureCoord = { .5, 1, 0, 1 },
			color = DruidEclipseMonitor_color.arcane,
			alpha = 1,
		},
		timer = {
			size = 26,
			offset = { x = -8, y = 0 }
		},
		buff = {
			id = 51443,
			texture = "Interface\\Icons\\Spell_Nature_WispSplode",
			type = "buff",
		},
		duration = 15,
		log = {
			start = "You are afflicted by Natural Solstice", -- Track debuff start
			stop = "Arcane Eclipse fades from you", -- Track buff end
		},
		sound = {
			start = "Interface\\Addons\\DruidEclipseMonitor\\sounds\\eclipse-arcane.ogg",
			stop = nil,
		},
	},
	["Natural Boon"] = {
		enabled = true,
		position = "LEFT",
		strata = "HIGH",
		offset = { x = -22, y = 0 },
		icon = {
			size = 46,
			texture = "Interface\\Addons\\DruidEclipseMonitor\\textures\\boon-pip-1.tga",
			color = DruidEclipseMonitor_color.nature,
			alpha = 1,
		},
		timer = {
			size = 14,
			offset = { x = 6, y = 0 },
			color = DruidEclipseMonitor_color.text_dark,
		},
		buff = {
			id = 51671,
			texture = "Interface\\Icons\\Spell_Nature_AbolishMagic",
			type = "buff",
		},
		duration = 60,
		log = {
			start = "You gain Natural Boon",
			update = "damage from your Moonfire.",
			stop = "Natural Boon fades from you",
		},
		sound = nil,
	},
	["Astral Boon"] = {
		enabled = true,
		position = "RIGHT",
		strata = "HIGH",
		offset = { x = 22, y = 0 },
		icon = {
			size = 46,
			texture = "Interface\\Addons\\DruidEclipseMonitor\\textures\\boon-pip-1.tga",
			color = DruidEclipseMonitor_color.arcane,
			alpha = 1,
		},
		timer = {
			size = 14,
			offset = { x = -6, y = 0 },
			color = DruidEclipseMonitor_color.text_dark,
		},
		buff = {
			id = 51432,
			texture = "Interface\\Icons\\Spell_Arcane_StarFire",
			type = "buff",
		},
		duration = 60,
		log = {
			start = "You gain Astral Boon",
			update = "damage from your Insect Swarm.",
			stop = "Astral Boon fades from you",
		},
		sound = nil,
	},
	["Natural Solstice"] = {
		enabled = true,
		position = "RIGHT",
		offset = { x = -42, y = -32 },
		icon = {
			size = 30,
			texture = "Interface\\Addons\\DruidEclipseMonitor\\textures\\circle-shade.tga",
			alpha = .3,
		},
		timer = {
			size = 14,
			color = DruidEclipseMonitor_color.arcane,
		},
		buff = {
			id = 53213,
			texture = "Interface\\Icons\\Spell_Nature_AbolishMagic",
			type = "debuff",
		},
		duration = 30,
		log = {
			start = "You are afflicted by Natural Solstice",
			stop = "Natural Solstice fades from you",
		},
		sound = nil,
	},
	["Arcane Solstice"] = {
		enabled = true,
		position = "LEFT",
		offset = { x = 42, y = -32 },
		icon = {
			size = 30,
			texture = "Interface\\Addons\\DruidEclipseMonitor\\textures\\circle-shade.tga",
			alpha = .3,
		},
		timer = {
			size = 14,
			color = DruidEclipseMonitor_color.nature,
		},
		buff = {
			id = 53212,
			texture = "Interface\\Icons\\Spell_Arcane_StarFire",
			type = "debuff",
		},
		duration = 30,
		log = {
			start = "You are afflicted by Arcane Solstice",
			stop = "Arcane Solstice fades from you",
		},
		sound = nil,
	},
	["Natural Solstice Invert"] = {
		enabled = false,
		position = "LEFT",
		offset = { x = 42, y = -32 },
		icon = {
			size = 30,
			texture = "Interface\\Addons\\DruidEclipseMonitor\\textures\\circle-shade.tga",
			alpha = .3,
		},
		timer = {
			size = 14,
			color = DruidEclipseMonitor_color.nature,
		},
		buff = {
			id = 53213,
			texture = "Interface\\Icons\\Spell_Nature_AbolishMagic",
			type = "debuff",
		},
		duration = 30,
		log = {
			start = "You are afflicted by Natural Solstice",
			stop = "Natural Solstice fades from you",
		},
		sound = nil,
	},
	["Arcane Solstice Invert"] = {
		enabled = false,
		position = "RIGHT",
		offset = { x = -42, y = -32 },
		icon = {
			size = 30,
			texture = "Interface\\Addons\\DruidEclipseMonitor\\textures\\circle-shade.tga",
			alpha = .3,
		},
		timer = {
			size = 14,
			color = DruidEclipseMonitor_color.arcane,
		},
		buff = {
			id = 53212,
			texture = "Interface\\Icons\\Spell_Arcane_StarFire",
			type = "debuff",
		},
		duration = 30,
		log = {
			start = "You are afflicted by Arcane Solstice",
			stop = "Arcane Solstice fades from you",
		},
		sound = nil,
	},
	["Nature's Grace"] = {
		enabled = false,
		position = "BOTTOM",
		offset = { x = 0, y = -16 },
		icon = {
			size = 32,
			texture = "Interface\\Icons\\Spell_Nature_NaturesBlessing",
			alpha = .8,
		},
		timer = {
			size = 14,
		},
		buff = {
			id = 16886,
			texture = "Interface\\Icons\\Spell_Nature_NaturesBlessing",
			type = "buff",
		},
		duration = 15,
		log = {
			start = "You gain Nature's Grace",
			stop = "Nature's Grace fades from you",
		},
		sound = nil,
	},
	["Clearcasting"] = {
		enabled = false,
		position = "BOTTOM",
		offset = { x = 0, y = 0 },
		icon = {
			size = 46,
			texture = "Interface\\Addons\\DruidEclipseMonitor\\textures\\scribble.tga",
			alpha = .5,
		},
		timer = {
			size = 14,
		},
		buff = {
			id = 16870,
			texture = "Interface\\Icons\\Spell_Shadow_ManaBurn",
			type = "buff",
		},
		duration = 15,
		log = {
			start = "You gain Clearcasting",
			stop = "Clearcasting fades from you",
		},
		sound = nil,
	},
	["Spell Blasting"] = {
		enabled = false,
		position = "TOP",
		offset = { x = 0, y = 0 },
		icon = {
			size = 46,
			texture = "Interface\\Addons\\DruidEclipseMonitor\\textures\\scribble.tga",
			alpha = .5,
		},
		timer = {
			size = 14,
		},
		buff = {
			id = 25907,
			texture = "Interface\\Icons\\Spell_Lightning_LightningBolt01",
			type = "buff",
		},
		duration = 10,
		log = {
			start = "You gain Spell Blasting",
			stop = "Spell Blasting fades from you",
		},
		sound = nil,
	},
}


function DruidEclipseMonitor:Init(source)
	if not has_superwow then demonprint("This addon requires SuperWoW to function.") return end
	if UnitClass("player") ~= "Druid" then demonprint("You are not a Druid. Goodbye.") return end

	DruidEclipseMonitor_x = DruidEclipseMonitor_x or DruidEclipseMonitor_default_x
	DruidEclipseMonitor_y = DruidEclipseMonitor_y or DruidEclipseMonitor_default_y
	DruidEclipseMonitor_width = DruidEclipseMonitor_width or DruidEclipseMonitor_default_width
	DruidEclipseMonitor_height = DruidEclipseMonitor_height or DruidEclipseMonitor_default_height
	DruidEclipseMonitor_sound = DruidEclipseMonitor_sound or DruidEclipseMonitor_default_sound

	if DruidEclipseMonitor_invertCooldown == nil then
		demonprint("Invert mode was not yet set. It should now be set to false. (Standard)")
		DruidEclipseMonitor_invertCooldown = DruidEclipseMonitor_default_invertCooldown
	end

	DruidEclipseMonitor:SetPoint("CENTER", DruidEclipseMonitor_x, DruidEclipseMonitor_y)
	DruidEclipseMonitor:SetWidth(DruidEclipseMonitor_width)
	DruidEclipseMonitor:SetHeight(DruidEclipseMonitor_height)

	if DruidEclipseMonitor_invertCooldown == false then
		demondebug("Current cooldown mode: Standard")
	elseif DruidEclipseMonitor_invertCooldown == true then
		demondebug("Current cooldown mode: Inverted")
		DruidEclipseMonitorAuras["Natural Solstice"].enabled = false
		DruidEclipseMonitorAuras["Arcane Solstice"].enabled = false
		DruidEclipseMonitorAuras["Natural Solstice Invert"].enabled = true
		DruidEclipseMonitorAuras["Arcane Solstice Invert"].enabled = true
	end

	-- self:SetBackdrop({
	-- 	-- edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
	-- 	bgFile = "Interface/Tooltips/UI-Tooltip-Background",
	-- 	tile="false",
	-- 	tileSize="8",
	-- 	edgeSize="8",
	-- 	insets={
	-- 		left="0",
	-- 		right="0",
	-- 		top="0",
	-- 		bottom="0"
	-- 	}
	-- })

	self:SetBackdropColor(0,0,0,0)
	self:SetFrameStrata("BACKGROUND")
	self:SetMovable(0)
	self:EnableMouse(0)

	for name,data in pairs(DruidEclipseMonitorAuras) do
		demondebug(name .. " frame created.")

		if data.enabled then
			DruidEclipseMonitor_frames[name] = DruidEclipseMonitor_frames[name] or DruidEclipseMonitorCreateFrame(name, data)
		end
	end
end


function DruidEclipseMonitorCreateFrame(name, data)
	if data.enabled ~= true then return end

	local frame = CreateFrame('Button', name, DruidEclipseMonitor)

	frame.data = data

	frame:EnableMouse(false)
	frame:SetPoint(data.position, 0, 0)
	frame:Hide()

	if type(data.icon.size) == "table" then
		frame:SetWidth(data.icon.size.width)
		frame:SetHeight(data.icon.size.height)
	else
		frame:SetWidth(data.icon.size)
		frame:SetHeight(data.icon.size)
	end

	if data.offset ~= nil then
		frame:SetPoint(data.position, data.offset.x, data.offset.y)
	end

	local icon_alpha = 1
	local timer_alpha = 1

	if data.icon.alpha ~= nil then icon_alpha = data.icon.alpha end
	if data.timer.alpha ~= nil then timer_alpha = data.timer.alpha end

	-- ICON
	frame.icon = frame:CreateTexture(nil, "OVERLAY")
	frame.icon:SetPoint('TOPLEFT', 1, -1)
	frame.icon:SetPoint('BOTTOMRIGHT', -1, 1)
	frame.icon:SetAlpha(icon_alpha)
	frame.icon:SetTexture(data.icon.texture)
	frame.icon:SetTexCoord(0,1,0,1)

	if name == "Natural Boon" then
		frame.icon:SetTexCoord(1,0,0,1)
	end

	if data.icon.textureCoord ~= nil then
		frame.icon:SetTexCoord(data.icon.textureCoord[1], data.icon.textureCoord[2], data.icon.textureCoord[3], data.icon.textureCoord[4])
	end

	if data.icon.color ~= nil then
		frame.icon:SetVertexColor(data.icon.color.r, data.icon.color.g, data.icon.color.b)
	end

	frame.stacks = 0


	if data.strata ~= nil then
		frame:SetFrameStrata(data.strata)
	end

	-- TIMER FRAME
	frame.timer = CreateFrame("Frame", "EMTimer"..name, UIParent)

	function frame.timer:Reset()
	 self.timeStarted = GetTime()
  end

  -- TIMER CLOCK
	frame.timer.text = frame:CreateFontString(nil, "OVERLAY")

	frame.timer.text:SetPoint("CENTER", frame, "CENTER", 0, 0)
	frame.timer.text:SetFont("Interface\\Addons\\DruidEclipseMonitor\\fonts\\PT-Sans-Narrow-Bold.TTF", data.timer.size)
	frame.timer.text:SetTextColor(255, 255, 255, timer_alpha)
	frame.timer.text:SetJustifyH("CENTER")
	frame.timer.text:SetText("")

	if data.timer.color ~= nil then
		frame.timer.text:SetTextColor(data.timer.color.r, data.timer.color.g, data.timer.color.b, timer_alpha)
	else
		frame.timer.text:SetShadowOffset(1, -1)
		frame.timer.text:SetShadowColor(0,0,0,.8)
	end

	if data.timer.offset ~= nil then
		frame.timer.text:SetPoint("CENTER", frame, "CENTER", data.timer.offset.x, data.timer.offset.y)
	end

	frame.timer:SetScript("OnUpdate", function()
		if ( frame.timer.tick or .1) > GetTime() then return else frame.timer.tick = GetTime() + .1 end

		if frame.timer.timeStarted ~= nil and frame.timer.timeStarted > 0 then
			local timeleft = data.duration - (GetTime() - frame.timer.timeStarted)
			local timeleftTrunc = math.floor(timeleft)

			if timeleft <= 3 then
				timeleftTrunc = math.floor(timeleft * 10) / 10

				if timeleftTrunc == math.floor(timeleftTrunc) then
					timeleftTrunc = timeleftTrunc .. ".0"
				end
			end

			frame.timer.text:SetText(timeleftTrunc)
		end
	end)

	demondebug("Created new frame: "..name)
	return frame
end

function DruidEclipseMonitor_frameActivate(name, timestamp)
	demondebug("Activating frame: " .. name)
	local frame = DruidEclipseMonitor_frames[name]
	local data = DruidEclipseMonitorAuras[name]

	frame:Show()
	frame.timer:Show()
	frame.timer.timeStarted = GetTime()
	frame.stacks = 1

	if DruidEclipseMonitor_sound == "on" and data.sound ~= nil and data.sound.start ~= nil then
		PlaySoundFile(data.sound.start)
	end
end

function DruidEclipseMonitor_frameDeactivate(name, timestamp)
	local frame = DruidEclipseMonitor_frames[name]
	local data = DruidEclipseMonitorAuras[name]

	frame.timer.timeStarted = nil
	frame.stacks = 0
	frame:Hide()
	frame.timer:Hide()

	if DruidEclipseMonitor_sound == "on" and data.sound ~= nil and data.sound.stop then
		PlaySoundFile(data.sound.stop)
	end
end

function DruidEclipseMonitorScanAuras(event)
	local i = i or 1;
	while true do
		local texture, stacks, id = UnitBuff("player", i) -- 'id' is only provided if superwow is installed.

		if not texture then
			break;
		end

		demondebug(id .. " - " .. texture .. " - " .. stacks)

		for name, data in pairs(DruidEclipseMonitorAuras) do
			if string.find(name, "Boon") then

				if data.buff.id == id then
					demondebug("Found a match for " .. name .. " (" .. stacks .. ")")


					if stacks > DruidEclipseMonitor_frames[name].stacks then
						demondebug(name .. ': Increased from ' .. DruidEclipseMonitor_frames[name].stacks .. ' to ' .. stacks .. ". Resetting timer.")
						DruidEclipseMonitor_frames[name].timer:Reset()
					end

					if stacks ~= DruidEclipseMonitor_frames[name].stacks then
						DruidEclipseMonitor_frames[name].stacks = stacks

						if stacks == 1 then
							DruidEclipseMonitor_frames[name].icon:SetTexture("Interface\\Addons\\DruidEclipseMonitor\\textures\\boon-pip-1.tga")
						elseif stacks == 2 then
							DruidEclipseMonitor_frames[name].icon:SetTexture("Interface\\Addons\\DruidEclipseMonitor\\textures\\boon-pip-2.tga")
						elseif stacks == 3 then
							DruidEclipseMonitor_frames[name].icon:SetTexture("Interface\\Addons\\DruidEclipseMonitor\\textures\\boon-pip-3.tga")
						end
					end
				end
			end
		end

		i = i + 1;
	end
end

function DruidEclipseMonitorParseLog(event, message)
	local matchFound = false
	local timestamp = GetTime()

	for id, frame in pairs(DruidEclipseMonitor_frames) do
		if frame.data.log.start ~= nil and not matchFound then
			local startPos, endPos = string.find(message, frame.data.log.start)
			if startPos then
				demondebug('"'..id..'" match (start) for "'..message..'"')
				-- matchFound = true
				DruidEclipseMonitor_frameActivate(id, timestamp)
			end
		end

		if frame.data.log.stop ~= nil and not matchFound then
			local startPos, endPos = string.find(message, frame.data.log.stop)
			if startPos then
				demondebug('"'..id..'" match (stop) for "'..message..'"')
				-- matchFound = true
				DruidEclipseMonitor_frameDeactivate(id, timestamp)
			end
		end

		-- if matchFound then
		-- 	break
		-- end
	end
end

function DruidEclipseMonitorResetTimers(event)
	for index, frame in pairs(DruidEclipseMonitor_frames) do
		frame:Hide()
		frame.timer.text:SetText("")
	end
end

function EM_GetPlayerBuff(i)
	local texture, count, id = UnitBuff("player", i)
	return texture, count, id
end

function EM_GetPlayerDebuff(i)
	local texture, count, _, id = UnitDebuff("player", i)
	return texture, count, id
end

function DruidEclipseMonitor:OnEvent()
	if event == "ADDON_LOADED" and arg1 == "DruidEclipseMonitor" then
		DruidEclipseMonitor:Init()
	elseif event == "CHAT_MSG_SPELL_SELF_DAMAGE" then
		DruidEclipseMonitorParseLog(event, arg1)
	elseif event == "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS" then
		DruidEclipseMonitorParseLog(event, arg1)
	elseif event == "CHAT_MSG_SPELL_AURA_GONE_SELF" then
		DruidEclipseMonitorParseLog(event, arg1)
	elseif event == "CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE" then
		DruidEclipseMonitorParseLog(event, arg1)
	elseif event == "PLAYER_AURAS_CHANGED" then
		DruidEclipseMonitorScanAuras(event)
	elseif event == "PLAYER_DEAD" then
		DruidEclipseMonitorResetTimers(event)
	end
end


-------------------------------------------------
-- Slash Command Functions
-------------------------------------------------
function DruidEclipseMonitor:Command_Move(x, y)
	-- DruidEclipseMonitor:SetPoint("CENTER", UIParent, "CENTER", -100, 100)
	DruidEclipseMonitor_x = tonumber(x)
	DruidEclipseMonitor_y = tonumber(y)
	DruidEclipseMonitor:SetPoint("CENTER", DruidEclipseMonitor_x, DruidEclipseMonitor_y)
	demonprint("Moved to " .. DruidEclipseMonitor_x ..", " .. DruidEclipseMonitor_y)
end

function DruidEclipseMonitor:Command_Width(width)
	if width ~= nil then
		local old = DruidEclipseMonitor_width
		DruidEclipseMonitor_width = tonumber(width)

		DruidEclipseMonitor:SetWidth(DruidEclipseMonitor_width)
		demonprint("Width changed from " .. old .. " to " .. DruidEclipseMonitor_width)
	else
		demonprint("Width is " .. DruidEclipseMonitor_width .. ". Change it with /demon width <number>")
	end
end

function DruidEclipseMonitor:Command_Height(height)
	if height ~= nil then
		local old = DruidEclipseMonitor_height
		DruidEclipseMonitor_height = tonumber(height)

		DruidEclipseMonitor:SetHeight(DruidEclipseMonitor_height)

		demonprint("Height changed from " .. old .. " to " .. DruidEclipseMonitor_height)
	else
		demonprint("Height is " .. DruidEclipseMonitor_height .. ". Change it with /demon height <number>")
	end
end

function DruidEclipseMonitor:Command_InvertCD(height)
	DruidEclipseMonitor_invertCooldown = not DruidEclipseMonitor_invertCooldown
	local mode = DruidEclipseMonitor_invertCooldown and "Inverted" or "Standard"

	if DruidEclipseMonitor_invertCooldown == true then
		demonprint("inverted")
	end

	if DruidEclipseMonitor_invertCooldown == false then
		demonprint("standard")
	end

	demonprint("Cooldown presentation set to " .. mode .. " mode. Requires UI reload to take effect.")
end

function DruidEclipseMonitor:Command_Reset(confirmed)
	if confirmed ~= "yes" then
		demonprint("Type |cFFFFFF00 /demon reset yes|r to reset all settings")
		return
	end

	demonprint("Position and size reset to defaults")

	DruidEclipseMonitor_x = DruidEclipseMonitor_default_x
	DruidEclipseMonitor_y = DruidEclipseMonitor_default_y
	DruidEclipseMonitor_width = DruidEclipseMonitor_default_width
	DruidEclipseMonitor_height = DruidEclipseMonitor_default_height
	DruidEclipseMonitor_sound = DruidEclipseMonitor_default_sound

	DruidEclipseMonitor:SetPoint("CENTER", DruidEclipseMonitor_x, DruidEclipseMonitor_y)
	DruidEclipseMonitor:SetWidth(DruidEclipseMonitor_width)
	DruidEclipseMonitor:SetHeight(DruidEclipseMonitor_height)
end

function DruidEclipseMonitor:Command_Demo(arg)
	DruidEclipseMonitor_demo = not DruidEclipseMonitor_demo

	if DruidEclipseMonitor_demo then
		demonprint("Showing demo.")

		if arg == "debug" then
			DruidEclipseMonitor:SetBackdropColor(0,0,0,.5)
		end
	else
		demonprint("Hiding demo. |cFFD54B3FConsider reloading your UI to avoid timer issues.|r")
		DruidEclipseMonitor:SetBackdropColor(0,0,0,0)
	end

	for index, frame in pairs(DruidEclipseMonitor_frames) do
		if DruidEclipseMonitor_demo then
			frame:Show()
			frame.timer.text:SetText(frame.data.duration)

			local startPos, endPos = string.find(index, "Boon")
			if startPos then
			  frame.icon:SetTexture("Interface\\Addons\\DruidEclipseMonitor\\textures\\boon-pip-3.tga")
			end
		else
			frame:Hide()
			frame.timer.text:SetText("")
		end
	end
end

function DruidEclipseMonitor:Command_Sound()
	if DruidEclipseMonitor_sound == "on" then
		DruidEclipseMonitor_sound = "off"
		demonprint("Sound disabled.")
	else
		DruidEclipseMonitor_sound = "on"
		demonprint("Sound enabled.")
	end
end

function DruidEclipseMonitor:Command_Debug()
	if DruidEclipseMonitor_debug == "on" then
		DruidEclipseMonitor_debug = "off"
		demonprint("Debug disabled.")
	else
		DruidEclipseMonitor_debug = "on"
		demonprint("Debug enabled.")
	end
end


-------------------------------------------------
-- Slash Commands
-------------------------------------------------

function DruidEclipseMonitor.slash(arg1)
	local command, args = DruidEclipseMonitor_ProcessSlashArgs(arg1)

	if command == nil or command == "" then
		local invertMode = DruidEclipseMonitor_invertCooldown and "Inverted" or "Standard"
		local soundMode = DruidEclipseMonitor_sound and "Disabled" or "Enabled"

		demonprint("Available commands:")
		demonprint("|cFFFFFF00 /demon demo|r - Toggle HUD visibilty for editing")
		demonprint("|cFFFFFF00 /demon move <x> <y>|r - Move to position. " .. "|cFFAAAAAA("..DruidEclipseMonitor_x .. ', '.. DruidEclipseMonitor_y ..")|r")
		demonprint("|cFFFFFF00 /demon width <width>|r - Set width. " .. "|cFFAAAAAA("..DruidEclipseMonitor_width..")|r")
		demonprint("|cFFFFFF00 /demon height <height>|r - Set height. " .. "|cFFAAAAAA("..DruidEclipseMonitor_height..")|r")
		demonprint("|cFFFFFF00 /demon invertcd|r - Change placement of eclipse cooldown timers. " .. "|cFFAAAAAA("..invertMode..")|r")
		demonprint("|cFFFFFF00 /demon sound|r - Toggle sounds. " .. "|cFFAAAAAA("..soundMode..")|r")
		demonprint("|cFFFFFF00 /demon reset|r - Reset settings")
	else
		if command == "demo" then
			DruidEclipseMonitor:Command_Demo(args[1])
		elseif command == "move" then
			DruidEclipseMonitor:Command_Move(args[1], args[2])
		elseif command == "width" then
			DruidEclipseMonitor:Command_Width(args[1])
		elseif command == "height" then
			DruidEclipseMonitor:Command_Height(args[1])
		elseif command == "invertcd" then
			DruidEclipseMonitor:Command_InvertCD()
		elseif command == "sound" then
			DruidEclipseMonitor:Command_Sound()
		elseif command == "reset" then
			DruidEclipseMonitor:Command_Reset(args[1])
		elseif command == "debug" then
			DruidEclipseMonitor:Command_Debug()
		else
			demonprint("Unknown command \"" .. command .."\"")
		end
	end
end

SlashCmdList['DRUIDECLIPSEMONITOR_SLASH'] = DruidEclipseMonitor.slash
SLASH_DRUIDECLIPSEMONITOR_SLASH1 = '/eclipsemonitor'
SLASH_DRUIDECLIPSEMONITOR_SLASH2 = '/demon'

function DruidEclipseMonitor_ProcessSlashArgs(arg)
	local args = {}
	for v in string.gfind(arg, "[^ ]+") do
		tinsert(args, v)
	end

	local c = table.getn(args);

	if c == 0 then
		return;
	end

	local command = table.remove(args, 1)

	return command, args
end

function demonprint(arg1)
	DEFAULT_CHAT_FRAME:AddMessage("|cFF33FFAFDEMon|r: "..arg1)
end

function demondebug(arg1)
	if not DruidEclipseMonitor_debug then return end
	DEFAULT_CHAT_FRAME:AddMessage("|cFFe65636DEMon|r: "..arg1)
end


-------------------------------------------------
-- Set Script
-------------------------------------------------

DruidEclipseMonitor:SetScript("OnEvent", DruidEclipseMonitor.OnEvent)
DruidEclipseMonitor:SetScript("OnUpdate", DruidEclipseMonitor.Update)
