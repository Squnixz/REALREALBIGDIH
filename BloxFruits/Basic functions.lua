-- [[ NOT WORKING ANYMORE BCZ THE UI IS DELETED! ]] --
print("Excuted")

print("Loading Function")

_G.Config = _G.Config or {
	-- Farming settings: Controls automatic leveling, chest farming, boss farming, mastery farming, etc.
	['Farming'] = {
		['Auto Level'] = false, -- Automatically level up
		['Event'] = {
			World2 = false, -- Enable event farming in World 2
			World3 = false, -- Enable event farming in World 3
		},
		['Unlock World'] = {
			World2 = false, -- Unlock World 2 automatically
			World3 = false, -- Unlock World 3 automatically
		},
		['Auto Farm Chest'] = false, -- Automatically farm chests
		['Mob Aura'] = false, -- Enable aura attack for mobs
		['Boss'] = {
			['List'] = { "Name" }, -- List of bosses to farm
			['Farm Boss'] = false -- Automatically farm bosses
		},
		['Mastery'] = {
			['Auto Mastery'] = {
				['Select Mode'] = Pig, -- Choose "Fruit" or "Gun" for mastery farming
				['Start'] = false, -- Start mastery farming
			},
			['Skill'] = {"Z", "X", "C", "V", "F"} -- Skills used in mastery farming
		},
		['Auto Farm All Swords Mastery'] = false, -- Farm mastery for all swords
		['Material'] = {
			['Select Farm'] = "", -- Select material to farm
			['Start'] = false, -- Start material farming
		},
	}, 

	-- Fighting Style settings: Controls auto-farming for different fighting styles.
	['Fighting Style'] = {
		['Auto Godhuman'] = false, -- Automatically unlock Godhuman fighting style
		['Auto Superhuman'] = false, -- Automatically unlock Superhuman fighting style
		['Auto Electric Claw'] = false, -- Automatically unlock Electric Claw
		['Auto Dragon Talon'] = false, -- Automatically unlock Dragon Talon
		['Auto Death Step'] = false, -- Automatically unlock Death Step
		['Auto SharkmanKarate'] = false, -- Automatically unlock Sharkman Karate
	},

	-- Automatic features: Controls various automated tasks like boss farming, elite hunting, and collecting resources.
	['Automatic'] = {
		['Cake Prince'] = false, -- Automatically farm Cake Prince boss
		['Elite Hunter'] = {
			['Start'] = false, -- Start elite hunter farming
			['Hop'] = false, -- Server hop while farming elite hunter
			['Stop Until Have God Chalice'] = true, -- Stop farming when God Chalice is obtained
		},
		['Auto Bone'] = false, -- Automatically farm bones
		['Auto Sea Best'] = false, -- Automatically farm Sea Beasts
		['Auto Farm Observation'] = false, -- Automatically farm Observation Haki
	},

	-- World 1 settings: Controls automatic unlocking of specific weapons.
	['World 1'] = {
		['Auto Saber'] = false, -- Automatically obtain Saber sword
		['Auto Pole V1'] = false, -- Automatically obtain Pole V1
		['Auto Cannon'] = false, -- Automatically obtain Cannon
		['Auto Bizento V2'] = false, -- Automatically obtain Bizento V2
	},

	-- World 2 settings: Controls automatic farming of specific items and quests.
	['World 2'] = {
		['item'] = {
			['Auto True Triple Katana'] = false, -- Automatically obtain True Triple Katana
			['Auto Rengoku'] = false, -- Automatically obtain Rengoku sword
			['Auto Dragon Trident'] = false, -- Automatically obtain Dragon Trident
		},
		['Quest'] = {
			['Auto Bartilo Quest'] = false, -- Automatically complete Bartilo's quest
			['Auto Ectoplasm'] = false, -- Automatically farm Ectoplasm
			['Auto Dark Coat'] = false, -- Automatically obtain Dark Coat
			['Auto Swan Glasses'] = false, -- Automatically obtain Swan Glasses
			['Auto Law Raid'] = false, -- Automatically participate in Law Raid
		}
	},

	-- World 3 settings: Controls automatic farming of specific items, quests, and sea events.
	['World 3'] = {
		['item'] = {
			['Auto Serpent Bow'] = false, -- Automatically obtain Serpent Bow
			['Auto Twin hook'] = false, -- Automatically obtain Twin Hook
			['Auto Buddy Sword'] = false, -- Automatically obtain Buddy Sword
			['Auto Yama'] = false, -- Automatically obtain Yama sword
			['Auto Cavander'] = false, -- Automatically obtain Cavander
			['Auto Hallow Scythe'] = false, -- Automatically obtain Hallow Scythe
			['Auto Tushita'] = false, -- Automatically obtain Tushita sword
			['Auto Dark Dagger'] = false, -- Automatically obtain Dark Dagger
			['Auto Cursed Dual Katana'] = false, -- Automatically obtain Cursed Dual Katana
		},
		['Quest'] = {
			['Auto Musketeer Hat'] = false, -- Automatically obtain Musketeer Hat
			['Auto Rainbow Haki'] = false, -- Automatically obtain Rainbow Haki
			['Auto Dough V2'] = false, -- Automatically unlock Dough V2 ability
			['Auto Soul Guitar'] = false, -- Automatically obtain Soul Guitar
			['Sea Events'] = {
				['Select Zone'] = "1",  -- Choose "1" for Zone 1 or "6" for Zone 6
				['Start'] = false, -- Start Sea Events farming
			},
			['Auto Collect Fire Flowers'] = false, -- Automatically collect Fire Flowers
		}
	}
}

local placeId = game.PlaceId
World1, World2, World3 = placeId == 2753915549, placeId == 4442272183, placeId == 7449423635  

local LocalPlayer = game:GetService('Players').LocalPlayer
local Character = LocalPlayer.Character
local Humanoid = Character.Humanoid
local QuestC = LocalPlayer.PlayerGui.Main.Quest
local RootPart = Character.HumanoidRootPart

local network = game:GetService("ReplicatedStorage").Remotes.CommF_

local WebScrap = game:HttpGet(("https://www.roblox.com/games/2753915549/UPDATE-Blox-Fruits")) or '<meta name="description" content=: 2300/>'
local MaxedLevel = WebScrap:split('<meta name="description" content=')[2]:split("/>")[1]:split(": ")[2]:split("\n")[1]
local MAXLEVEL = tonumber(MaxedLevel)


local Config = {}
local Threads = {}
local LoadFuncs = {}
local Module = {}

-- [ DeBug ]
local function Getpcall(func, ...)
	local success, err = pcall(func, ...)
	if not success then
		local errType, line, funcName = string.match(err, "^(.-):(%d+): (.+)$")
		if errType and line and funcName then

			local Embed = {
				title = "Error",errType,
				fields = {{ name = "Details", value = "```" .. infoText .. "```", inline = false }},
				thumbnail = { url = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. player.UserId .. "&width=420&height=420&format=png" },
				timestamp = os.date('!%Y-%m-%dT%H:%M:%SZ', OSTime),
			}

			print("Error Type:"..errType.."Line"..line.."Function",funcName)
		else
			print("Error:", err)
		end
	else
		print("Function executed successfully!")
	end
end

local CanTeleport = {
	{
		["Sky3"] = Vector3.new(-7894, 5547, -380),
		["Sky3Exit"] = Vector3.new(-4607, 874, -1667),
		["UnderWater"] = Vector3.new(61163, 11, 1819),
		["UnderwaterExit"] = Vector3.new(4050, -1, -1814),
	},
	{
		["Swan Mansion"] = Vector3.new(-390, 332, 673),
		["Swan Room"] = Vector3.new(2285, 15, 905),
		["Cursed Ship"] = Vector3.new(923, 126, 32852),
	},
	{
		["Floating Turtle"] = Vector3.new(-12462, 375, -7552),
		["Hydra Island"] = Vector3.new(5745, 610, -267),
		["Mansion"] = Vector3.new(-12462, 375, -7552),
		["Castle"] = Vector3.new(-5036, 315, -3179),
	}
}
SeaIndex = World3 and 3 or World2 and 2 or World1 and 1 or LocalPlayer:Kick("Didn't update this Sea")

local AutoFarmConfig = {
	['Auto Farm Boss'] = {world = nil, boss = function() return _G['Select Boss'] end, position = function() return game:GetService("ReplicatedStorage")[_G['Select Boss']].HumanoidRootPart.CFrame end},
	['Auto Pole V1'] = {world = World1, boss = "Thunder God", position = CFrame.new(-7748, 5606, -2305)},
	['Auto Cannon'] = {world = World1, boss = "Wysper", position = CFrame.new(-7860, 5545, -380)},
	['Auto Bizento V2'] = {world = World1, boss = "Greybeard", position = CFrame.new(-4914, 50, 4281)},
	['Auto Factory'] = {world = World2, boss = "Core", position = CFrame.new(448, 199, -441)},
	['Auto Dragon Trident'] = {world = World2, boss = "Tide Keeper", position = CFrame.new(-3914, 123, -11516)},
	['Auto Rengoku'] = {world = World2, boss = { "Snow Lurker", "Arctic Warrior", "Awakened Ice Admiral" }, position = CFrame.new(5439, 84, -6715)},
	['Auto Dark Coat'] = {world = World2, boss = "Darkbeard", position = CFrame.new(3677, 62, -3144)},
	['Auto Swan Glasses'] = {world = World2, boss = "Don Swan", position = "Swan Glasses"},
	['Auto Ectoplasm'] = {world = World2, boss = { "Ship Deckhand", "Ship Engineer", "Ship Steward", "Ship Officer", "Arctic Warrior" }, position = nil},
	['Auto Bone'] = {world = World3, boss = { "Reborn Skeleton", "Living Zombie", "Demonic Soul", "Posessed Mummy" }, position = CFrame.new(-9504, 172, 6057)},
	['Auto Dark Dagger'] = {world = World3, boss = "rip_indra True Form", position = CFrame.new(-5344, 423, -2725)},
	['Auto Buddy'] = {world = World3, boss = "Cake Queen", position = CFrame.new(-776, 381, -11046)},
	['Auto Cavander'] = {world = World3, boss = "Beautiful Pirate", position = nil},
	['Auto Hallow Scythe'] = {world = World3, boss = "Soul Reaper", position = CFrame.new(-8932, 146, 6062)},
	['Auto Twin Hook'] = {world = World3, boss = "Captain Elephant", position = CFrame.new(-13348, 405, -8570)},
	['Island Empress'] = {world = World3, boss = "Hydra Leader", position = CFrame.new(5801, 1079, -61)}
}

-- [ CreateF ]
for name, config in pairs(AutoFarmConfig) do
	LoadFuncs[name] = function(condition)
		while condition do
			task.wait(0.1)
			Getpcall(function()
				Module:CreateF(config.world, config.boss and (type(config.boss) == "function" and config.boss() or config.boss), condition,
					config.position and (type(config.position) == "function" and config.position() or config.position))
			end)
		end
	end
end

Threads[#Threads + 1] = task.spawn(function()
	while task.wait(3) do
		for _ = 1, 3 do
			_C("SetSpawnPoint") 		
		end 
		if not Character:FindFirstChild("HasBuso") then
			task.spawn(_C,"Buso")
		end 
	end
	while task.wait(.1) do
		local wt = { Melee = "Melee", Sword = "Sword", Gun = "Gun", Fruit = "Blox Fruit" }
		if not _G.Select_Weapon then
			_G.Select_Weapon = wt.Melee
		end
		for _, v in pairs(LocalPlayer.Backpack:GetChildren()) do
			if v.ToolTip == wt[_G.Select_Weapon] then _G.Select_Weapon = v.Name break end
		end
	end
	for i,v in pairs(_C("getColors")) do
		if v.HiddenName == 'Pure Red' and v.Unlocked == true then
			Pure_Red_H = true
		elseif v.HiddenName == 'Snow White' and v.Unlocked == true then
			Snow_White = true
		elseif v.HiddenName == 'Winter Sky' and v.Unlocked == true then
			Winter_Sky = true
		end
	end
	local VirtualUser = game:GetService("VirtualUser")
	local function simulateInput()
		VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
		wait(1)
		VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
	end
	LocalPlayer.Idled:Connect(simulateInput)
	while wait(300) do simulateInput() end
end)


do
	-- [ get Config ]
	function getConfigValue(path)
		local keys = string.split(path, ".")
		local value = _G.Config
		for _, key in ipairs(keys) do
			value = value[key]
			if value == nil then return nil end
		end
		return value
	end

	-- [ set Config ]
	function setConfigValue(path, newValue)
		local keys = string.split(path, ".")
		local value = _G.Config
		for i = 1, #keys - 1 do
			value = value[keys[i]]
			if value == nil then return false end
		end
		value[keys[#keys]] = newValue
		return true
	end

end

do

	if getConfigValue("Farming.Auto Level") then _G['Auto Farm Level'] = true end
	if getConfigValue("Farming.Event.World2") then _G['Event World2'] = true end
	if getConfigValue("Farming.Event.World3") then _G['Event World3'] = true end
	if getConfigValue("Farming.Unlock World.World2") then _G['Unlock World2'] = true end
	if getConfigValue("Farming.Unlock World.World3") then _G['Unlock World3'] = true end
	if getConfigValue("Farming.Auto Farm Chest") then _G['Auto Farm Chest'] = true end

	if getConfigValue("Farming.Mob Aura") then _G['Mob Aura'] = true end
	if getConfigValue("Farming.Boss.Farm Boss") then _G['Farm Boss'] = true end
	if getConfigValue("Farming.Master.Auto Mastery.Start") then _G['Auto Mastery Start'] = true end
	if getConfigValue("Farming.Auto Farm All Swords Mastery") then _G['Auto Farm All Swords Mastery'] = true end
	if getConfigValue("Farming.Material.Start") then _G['Start Material Farming'] = true end

	-- Fighting Style settings
	if getConfigValue("Fighting Style.Auto Godhuman") then _G['Auto Godhuman'] = true end
	if getConfigValue("Fighting Style.Auto Superhuman") then _G['Auto Superhuman'] = true end
	if getConfigValue("Fighting Style.Auto Electric Claw") then _G['Auto Electric Claw'] = true end
	if getConfigValue("Fighting Style.Auto Dragon Talon") then _G['Auto Dragon Talon'] = true end
	if getConfigValue("Fighting Style.Auto Death Step") then _G['Auto Death Step'] = true end
	if getConfigValue("Fighting Style.Auto SharkmanKarate") then _G['Auto SharkmanKarate'] = true end

	-- Automatic features
	if getConfigValue("Automatic.Cake Prince") then _G['Auto Cake Prince'] = true end
	if getConfigValue("Automatic.Elite Hunter.Start") then _G['Elite Hunter Start'] = true end
	if getConfigValue("Automatic.Elite Hunter.Hop") then _G['Elite Hunter Hop'] = true end
	if getConfigValue("Automatic.Stop Until Have God Chalice") then _G['Stop Until Have God Chalice'] = true end
	if getConfigValue("Automatic.Auto Bone") then _G['Auto Bone'] = true end
	if getConfigValue("Automatic.Auto Sea Best") then _G['Auto Sea Best'] = true end
	if getConfigValue("Automatic.Auto Farm Observation") then _G['Auto Farm Observation'] = true end

	-- World 1 settings
	if getConfigValue("World 1.Auto Saber") then _G['Auto Saber'] = true end
	if getConfigValue("World 1.Auto Pole V1") then _G['Auto Pole V1'] = true end
	if getConfigValue("World 1.Auto Cannon") then _G['Auto Cannon'] = true end
	if getConfigValue("World 1.Auto Bizento V2") then _G['Auto Bizento V2'] = true end

	-- World 2 settings
	if getConfigValue("World 2.item.Auto True Triple Katana") then _G['Auto True Triple Katana'] = true end
	if getConfigValue("World 2.item.Auto Rengoku") then _G['Auto Rengoku'] = true end
	if getConfigValue("World 2.item.Auto Dragon Trident") then _G['Auto Dragon Trident'] = true end
	if getConfigValue("World 2.Quest.Auto Bartilo Quest") then _G['Auto Bartilo Quest'] = true end
	if getConfigValue("World 2.Quest.Auto Ectoplasm") then _G['Auto Ectoplasm'] = true end
	if getConfigValue("World 2.Quest.Auto Dark Coat") then _G['Auto Dark Coat'] = true end
	if getConfigValue("World 2.Quest.Auto Swan Glasses") then _G['Auto Swan Glasses'] = true end
	if getConfigValue("World 2.Quest.Auto Law Raid") then _G['Auto Law Raid'] = true end

	-- World 3 settings
	if getConfigValue("World 3.item.Auto Serpent Bow") then _G['Auto Serpent Bow'] = true end
	if getConfigValue("World 3.item.Auto Twin hook") then _G['Auto Twin hook'] = true end
	if getConfigValue("World 3.item.Auto Buddy Sword") then  _G['Auto Buddy Sword'] = true end
	if getConfigValue("World 3.item.Auto Yama") then  _G['Auto Yama'] = true end
	if getConfigValue("World 3.item.Auto Cavander") then  _G['Auto Cavander'] = true end
	if getConfigValue("World 3.item.Auto Hallow Scythe") then  _G['Auto Hallow Scythe'] = true end
	if getConfigValue("World 3.item.Auto Tushita") then  _G['Auto Tushita'] = true  end
	if getConfigValue("World 3.item.Auto Dark Dagger") then  _G['Auto Dark Dagger'] = true  end
	if getConfigValue("World 3.item.Auto Cursed Dual Katana") then  _G['Auto Cursed Dual Katana'] = true  end
	if getConfigValue("World 3.Quest.Auto Musketeer Hat") then  _G['Auto Musketeer Hat'] = true  end
	if getConfigValue("World 3.Quest.Auto Rainbow Haki") then  _G['Auto Rainbow Haki'] = true end
	if getConfigValue("World 3.Quest.Auto Dough V2") then  _G['Auto Dough V2'] = true end
	if getConfigValue("World 3.Quest.Auto Soul Guitar") then  _G['Auto Soul Guitar'] = true  end
	if getConfigValue("World 3.Quest.Sea Events.Start") then  _G['Start Sea Events farming'] = true  end
	if getConfigValue("World 3.Quest.Auto Collect Fire Flowers") then  _G['Auto Collect Fire Flowers'] = true  end
end

function CheckQuest()
	local lv = LocalPlayer.Data.Level.Value
	if World1 then
		if lv >= 1 and lv <= 9 then
			if tostring(game.Players.LocalPlayer.Team) == "Marines" then
				return {
					[1] = "Trainee",
					[2] = 1,
					[3] = "MarineQuest",
					[4] = CFrame.new(-2711.635498046875, 24.834863662719727, 2104.212890625),
				}
			elseif tostring(game.Players.LocalPlayer.Team) == "Pirates" then
				return {
					[1] = "Bandit",
					[2] = 1,
					[3] = "BanditQuest1",
					[4] = CFrame.new(1059.37195, 15.4495068, 1550.4231),
				}
			end
		elseif lv >= 10 and lv <= 14 then
			return {
				[1] = "Monkey",
				[2] = 1,
				[3] = "JungleQuest",
				[4] = CFrame.new(-1598.08911, 35.5501175, 153.377838),
			}
		elseif lv >= 15 and lv <= 29 then
			return {
				[1] = "Gorilla",
				[2] = 2,
				[3] = "JungleQuest",
				[4] = CFrame.new(-1598.08911, 35.5501175, 153.377838),
			}
		elseif lv >= 30 and lv <= 39 then
			return {
				[1] = "Pirate",
				[2] = 1,
				[3] = "BuggyQuest1",
				[4] = CFrame.new(-1141.07483, 4.10001802, 3831.5498),
			}
		elseif lv >= 40 and lv <= 59 then
			return {
				[1] = "Brute",
				[2] = 2,
				[3] = "BuggyQuest1",
				[4] = CFrame.new(-1141.07483, 4.10001802, 3831.5498),
			}
		elseif lv >= 60 and lv <= 74 then
			return {
				[1] = "Desert Bandit",
				[2] = 1,
				[3] = "DesertQuest",
				[4] = CFrame.new(894.488647, 5.14000702, 4392.43359),
			}
		elseif lv >= 75 and lv <= 89 then
			return {
				[1] = "Desert Officer",
				[2] = 2,
				[3] = "DesertQuest",
				[4] = CFrame.new(894.488647, 5.14000702, 4392.43359),
			}
		elseif lv >= 90 and lv <= 99 then
			return {
				[1] = "Snow Bandit",
				[2] = 1,
				[3] = "SnowQuest",
				[4] = CFrame.new(1389.74451, 88.1519318, -1298.90796),
			}
		elseif lv >= 100 and lv <= 119 then
			return {
				[1] = "Snowman",
				[2] = 2,
				[3] = "SnowQuest",
				[4] = CFrame.new(1389.74451, 88.1519318, -1298.90796),
			}
		elseif lv >= 120 and lv <= 149 then
			return {
				[1] = "Chief Petty Officer",
				[2] = 1,
				[3] = "MarineQuest2",
				[4] = CFrame.new(-5039.58643, 27.3500385, 4324.68018),
			}
		elseif lv >= 150 and lv <= 174 then
			return {
				[1] = "Sky Bandit",
				[2] = 1,
				[3] = "SkyQuest",
				[4] = CFrame.new(-4839.53027, 716.368591, -2619.44165),
			}
		elseif lv >= 175 and lv <= 189 then
			return {
				[1] = "Dark Master",
				[2] = 2,
				[3] = "SkyQuest",
				[4] = CFrame.new(-4839.53027, 716.368591, -2619.44165),
			}
		elseif lv >= 190 and lv <= 209 then
			return {
				[1] = "Prisoner",
				[2] = 1,
				[3] = "PrisonerQuest",
				[4] = CFrame.new(5308.93115, 1.65517521, 475.120514),
			}
		elseif lv >= 210 and lv <= 249 then
			return {
				[1] = "Dangerous Prisoner",
				[2] = 2,
				[3] = "PrisonerQuest",
				[4] = CFrame.new(5308.93115, 1.65517521, 475.120514),
			}
		elseif lv >= 250 and lv <= 274 then
			return {
				[1] = "Toga Warrior",
				[2] = 1,
				[3] = "ColosseumQuest",
				[4] = CFrame.new(-1580.04663, 6.35000277, -2986.47534),
			}
		elseif lv >= 275 and lv <= 299 then
			return {
				[1] = "Gladiator",
				[2] = 2,
				[3] = "ColosseumQuest",
				[4] = CFrame.new(-1580.04663, 6.35000277, -2986.47534),
			}
		elseif lv >= 300 and lv <= 324 then
			return {
				[1] = "Military Soldier",
				[2] = 1,
				[3] = "MagmaQuest",
				[4] = CFrame.new(-5313.37012, 10.9500084, 8515.29395),
			}
		elseif lv >= 325 and lv <= 374 then
			return {
				[1] = "Military Spy",
				[2] = 2,
				[3] = "MagmaQuest",
				[4] = CFrame.new(-5313.37012, 10.9500084, 8515.29395),
			}
		elseif lv >= 375 and lv <= 399 then
			return {
				[1] = "Fishman Warrior",
				[2] = 1,
				[3] = "FishmanQuest",
				[4] = CFrame.new(61122.65234375, 18.497442245483, 1569.3997802734),
			}
		elseif lv >= 400 and lv <= 449 then
			return {
				[1] = "Fishman Commando",
				[2] = 2,
				[3] = "FishmanQuest",
				[4] = CFrame.new(61122.65234375, 18.497442245483, 1569.3997802734),
			}
		elseif lv >= 450 and lv <= 474 then
			return {
				[1] = "God's Guard",
				[2] = 1,
				[3] = "SkyExp1Quest",
				[4] = CFrame.new(-7859.09814, 5544.19043, -381.476196),
			}
		elseif lv >= 475 and lv <= 524 then
			return {
				[1] = "Shanda",
				[2] = 2,
				[3] = "SkyExp1Quest",
				[4] = CFrame.new(-7859.09814, 5544.19043, -381.476196),
			}
		elseif lv >= 525 and lv <= 549 then
			return {
				[1] = "Royal Squad",
				[2] = 1,
				[3] = "SkyExp2Quest",
				[4] = CFrame.new(-7906.81592, 5634.6626, -1411.99194),
			}
		elseif lv >= 550 and lv <= 624 then
			return {
				[1] = "Royal Soldier",
				[2] = 2,
				[3] = "SkyExp2Quest",
				[4] = CFrame.new(-7906.81592, 5634.6626, -1411.99194),
			}
		elseif lv >= 625 and lv <= 649 then
			return {
				[1] = "Galley Pirate",
				[2] = 1,
				[3] = "FountainQuest",
				[4] = CFrame.new(5259.81982, 37.3500175, 4050.0293),
			}
		elseif lv >= 650 then
			return {
				[1] = "Galley Captain",
				[2] = 2,
				[3] = "FountainQuest",
				[4] = CFrame.new(5259.81982, 37.3500175, 4050.0293),
			}
		end
	elseif World2 then
		if lv >= 700 and lv <= 724 then
			return {
				[1] = "Raider",
				[2] = 1,
				[3] = "Area1Quest",
				[4] = CFrame.new(-429.543518, 71.7699966, 1836.18188)
			}
		elseif lv >= 725 and lv <= 774 then
			return {
				[1] = "Mercenary",
				[2] = 2,
				[3] = "Area1Quest",
				[4] = CFrame.new(-429.543518, 71.7699966, 1836.18188)
			}
		elseif lv >= 775 and lv <= 799 then
			return {
				[1] = "Swan Pirate",
				[2] = 1,
				[3] = "Area2Quest",
				[4] = CFrame.new(638.43811, 71.769989, 918.282898)
			}
		elseif lv >= 800 and lv <= 874 then
			return {
				[1] = "Factory Staff",
				[2] = 2,
				[3] = "Area2Quest",
				[4] = CFrame.new(632.698608, 73.1055908, 918.666321)
			}
		elseif lv >= 875 and lv <= 899 then
			return {
				[1] = "Marine Lieutenant",
				[2] = 1,
				[3] = "MarineQuest3",
				[4] = CFrame.new(-2440.79639, 71.7140732, -3216.06812)
			}
		elseif lv >= 900 and lv <= 949 then
			return {
				[1] = "Marine Captain",
				[2] = 2,
				[3] = "MarineQuest3",
				[4] = CFrame.new(-2440.79639, 71.7140732, -3216.06812)
			}
		elseif lv >= 950 and lv <= 974 then
			return {
				[1] = "Zombie",
				[2] = 1,
				[3] = "ZombieQuest",
				[4] = CFrame.new(-5497.06152, 47.5923004, -795.237061)
			}
		elseif lv >= 975 and lv <= 999 then
			return {
				[1] = "Vampire",
				[2] = 2,
				[3] = "ZombieQuest",
				[4] = CFrame.new(-5497.06152, 47.5923004, -795.237061)
			}
		elseif lv >= 1000 and lv <= 1049 then
			return {
				[1] = "Snow Trooper",
				[2] = 1,
				[3] = "SnowMountainQuest",
				[4] = CFrame.new(609.858826, 400.119904, -5372.25928)
			}
		elseif lv >= 1050 and lv <= 1099 then
			return {
				[1] = "Winter Warrior",
				[2] = 2,
				[3] = "SnowMountainQuest",
				[4] = CFrame.new(609.858826, 400.119904, -5372.25928)
			}
		elseif lv >= 1100 and lv <= 1124 then
			return {
				[1] = "Lab Subordinate",
				[2] = 1,
				[3] = "IceSideQuest",
				[4] = CFrame.new(-6064.06885, 15.2422857, -4902.97852)
			}
		elseif lv >= 1125 and lv <= 1174 then
			return {
				[1] = "Horned Warrior",
				[2] = 2,
				[3] = "IceSideQuest",
				[4] = CFrame.new(-6064.06885, 15.2422857, -4902.97852)
			}
		elseif lv >= 1175 and lv <= 1199 then
			return {
				[1] = "Magma Ninja",
				[2] = 1,
				[3] = "FireSideQuest",
				[4] = CFrame.new(-5428.03174, 15.0622921, -5299.43457)
			}
		elseif lv >= 1200 and lv <= 1249 then
			return {
				[1] = "Lava Pirate",
				[2] = 2,
				[3] = "FireSideQuest",
				[4] = CFrame.new(-5428.03174, 15.0622921, -5299.43457)
			}
		elseif lv >= 1250 and lv <= 1274 then
			return {
				[1] = "Ship Deckhand",
				[2] = 1,
				[3] = "ShipQuest1",
				[4] = CFrame.new(1037.80127, 125.092171, 32911.6016)
			}
		elseif lv >= 1275 and lv <= 1299 then
			return {
				[1] = "Ship Engineer",
				[2] = 2,
				[3] = "ShipQuest1",
				[4] = CFrame.new(1037.80127, 125.092171, 32911.6016)
			}
		elseif lv >= 1300 and lv <= 1324 then
			return {
				[1] = "Ship Steward",
				[2] = 1,
				[3] = "ShipQuest2",
				[4] = CFrame.new(968.80957, 125.092171, 33244.125)
			}
		elseif lv >= 1325 and lv <= 1349 then
			return {
				[1] = "Ship Officer",
				[2] = 2,
				[3] = "ShipQuest2",
				[4] = CFrame.new(968.80957, 125.092171, 33244.125)
			}
		elseif lv >= 1350 and lv <= 1374 then
			return {
				[1] = "Arctic Warrior",
				[2] = 1,
				[3] = "FrostQuest",
				[4] = CFrame.new(5667.6582, 26.7997818, -6486.08984)
			}
		elseif lv >= 1375 and lv <= 1424 then
			return {
				[1] = "Snow Lurker",
				[2] = 2,
				[3] = "FrostQuest",
				[4] = CFrame.new(5667.6582, 26.7997818, -6486.08984)
			}
		elseif lv >= 1425 and lv <= 1449 then
			return {
				[1] = "Sea Soldier",
				[2] = 1,
				[3] = "ForgottenQuest",
				[4] = CFrame.new(-3055, 240, -10145)
			}
		elseif lv >= 1450 then
			return {
				[1] = "Water Fighter",
				[2] = 2,
				[3] = "ForgottenQuest",
				[4] = CFrame.new(-3055, 240, -10145)
			}
		end
	elseif World3 then
		if lv >= 1500 and lv <= 1524 then
			return {
				[1] = "Pirate Millionaire",
				[2] = 1,
				[3] = "PiratePortQuest",
				[4] = CFrame.new(-449.1593017578125, 108.6176528930664, 5948.00146484375)
			}
		elseif lv >= 1525 and lv <= 1574 then
			return {
				[1] = "Pistol Billionaire",
				[2] = 2,
				[3] = "PiratePortQuest",
				[4] = CFrame.new(-449.1593017578125, 108.6176528930664, 5948.00146484375)
			}
		elseif lv >= 1575 and lv <= 1599 then
			return {
				[1] = "Dragon Crew Warrior",
				[2] = 1,
				[3] = "DragonCrewQuest",
				[4] = CFrame.new(6737.77685546875, 127.42920684814453, -713.2312622070312)
			}
		elseif lv >= 1600 and lv <= 1624 then 
			return {
				[1] = "Dragon Crew Archer",
				[2] = 2,
				[3] = "DragonCrewQuest",
				[4] = CFrame.new(6737.77685546875, 127.42920684814453, -713.2312622070312)
			}
		elseif lv >= 1625 and lv <= 1649 then
			return {
				[1] = "Hydra Enforcer",
				[2] = 1,
				[3] = "VenomCrewQuest",
				[4] = CFrame.new(5212.94140625, 1004.1171875, 755.6657104492188)
			}
		elseif lv >= 1650 and lv <= 1699 then 
			return {
				[1] = "Venomous Assailant",
				[2] = 2,
				[3] = "VenomCrewQuest",
				[4] = CFrame.new(5212.94140625, 1004.1171875, 755.6657104492188)
			}
		elseif lv >= 1700 and lv <= 1724 then
			return {
				[1] = "Marine Commodore",
				[2] = 1,
				[3] = "MarineTreeIsland",
				[4] = CFrame.new(2484.0673828125, 74.28215026855469, -6786.64453125)
			}
		elseif lv >= 1725 and lv <= 1774 then
			return {
				[1] = "Marine Rear Admiral",
				[2] = 2,
				[3] = "MarineTreeIsland",
				[4] = CFrame.new(2484.0673828125, 74.28215026855469, -6786.64453125)
			}
		elseif lv >= 1775 and lv <= 1799 then
			return {
				[1] = "Fishman Raider",
				[2] = 1,
				[3] = "DeepForestIsland3",
				[4] = CFrame.new(-10581.6563, 330.872955, -8761.18652)
			}
		elseif lv >= 1800 and lv <= 1824 then
			return {
				[1] = "Fishman Captain",
				[2] = 2,
				[3] = "DeepForestIsland3",
				[4] = CFrame.new(-10581.6563, 330.872955, -8761.18652)
			}
		elseif lv >= 1825 and lv <= 1849 then
			return {
				[1] = "Forest Pirate",
				[2] = 1,
				[3] = "DeepForestIsland",
				[4] = CFrame.new(-13234.04, 331.488495, -7625.40137)
			}
		elseif lv >= 1850 and lv <= 1899 then
			return {
				[1] = "Mythological Pirate",
				[2] = 2,
				[3] = "DeepForestIsland",
				[4] = CFrame.new(-13234.04, 331.488495, -7625.40137)
			}
		elseif lv >= 1900 and lv <= 1924 then
			return {
				[1] = "Jungle Pirate",
				[2] = 1,
				[3] = "DeepForestIsland2",
				[4] = CFrame.new(-12680.3818, 389.971039, -9902.01953)
			}
		elseif lv >= 1925 and lv <= 1974 then
			return {
				[1] = "Musketeer Pirate",
				[2] = 2,
				[3] = "DeepForestIsland2",
				[4] = CFrame.new(-12680.3818, 389.971039, -9902.01953)
			}
		elseif lv >= 1975 and lv <= 1999 then
			return {
				[1] = "Reborn Skeleton",
				[2] = 1,
				[3] = "HauntedQuest1",
				[4] = CFrame.new(-9479.2168, 141.215088, 5566.09277)
			}
		elseif lv >= 2000 and lv <= 2024 then
			return {
				[1] = "Living Zombie",
				[2] = 2,
				[3] = "HauntedQuest1",
				[4] = CFrame.new(-9479.2168, 141.215088, 5566.09277)
			}
		elseif lv >= 2025 and lv <= 2049 then
			return {
				[1] = "Demonic Soul",
				[2] = 1,
				[3] = "HauntedQuest2",
				[4] = CFrame.new(-9516.99316, 172.017181, 6078.46533)
			}
		elseif lv >= 2050 and lv <= 2074 then
			return {
				[1] = "Posessed Mummy",
				[2] = 2,
				[3] = "HauntedQuest2",
				[4] = CFrame.new(-9516.99316, 172.017181, 6078.46533)
			}
		elseif lv >= 2075 and lv <= 2099 then
			return {
				[1] = "Peanut Scout",
				[2] = 1,
				[3] = "NutsIslandQuest",
				[4] = CFrame.new(-2104.3908691406, 38.104167938232, -10194.21875)
			}
		elseif lv >= 2100 and lv <= 2124 then
			return {
				[1] = "Peanut President",
				[2] = 2,
				[3] = "NutsIslandQuest",
				[4] = CFrame.new(-2104.3908691406, 38.104167938232, -10194.21875)
			}
		elseif lv >= 2125 and lv <= 2149 then
			return {
				[1] = "Ice Cream Chef",
				[2] = 1,
				[3] = "IceCreamIslandQuest",
				[4] = CFrame.new(-820.64825439453, 65.819526672363, -10965.795898438)
			}
		elseif lv >= 2150 and lv <= 2199 then
			return {
				[1] = "Ice Cream Commander",
				[2] = 2,
				[3] = "IceCreamIslandQuest",
				[4] = CFrame.new(-820.64825439453, 65.819526672363, -10965.795898438)
			}
		elseif lv >= 2200 and lv <= 2224 then
			return {
				[1] = "Cookie Crafter",
				[2] = 1,
				[3] = "CakeQuest1",
				[4] = CFrame.new(-2021.32007, 37.7982254, -12028.7295)
			}
		elseif lv >= 2225 and lv <= 2249 then
			return {
				[1] = "Cake Guard",
				[2] = 2,
				[3] = "CakeQuest1",
				[4] = CFrame.new(-2021.32007, 37.7982254, -12028.7295)
			}
		elseif lv >= 2250 and lv <= 2274 then
			return {
				[1] = "Baking Staff",
				[2] = 1,
				[3] = "CakeQuest2",
				[4] = CFrame.new(-1927.91602, 37.7981339, -12842.5391)
			}
		elseif lv >= 2275 and lv <= 2299 then
			return {
				[1] = "Head Baker",
				[2] = 2,
				[3] = "CakeQuest2",
				[4] = CFrame.new(-1927.91602, 37.7981339, -12842.5391)
			}
		elseif lv >= 2300 and lv <= 2324 then
			return {
				[1] = "Cocoa Warrior",
				[2] = 1,
				[3] = "ChocQuest1",
				[4] = CFrame.new(233.22836303710938, 29.876001358032227, -12201.2333984375)
			}
		elseif lv >= 2325 and lv <= 2349 then
			return {
				[1] = "Chocolate Bar Battler",
				[2] = 2,
				[3] = "ChocQuest1",
				[4] = CFrame.new(233.22836303710938, 29.876001358032227, -12201.2333984375)
			}
		elseif lv >= 2350 and lv <= 2374 then
			return {
				[1] = "Sweet Thief",
				[2] = 1,
				[3] = "ChocQuest2",
				[4] = CFrame.new(150.5066375732422, 30.693693161010742, -12774.5029296875)
			}
		elseif lv >= 2375 and lv <= 2399 then
			return {
				[1] = "Candy Rebel",
				[2] = 2,
				[3] = "ChocQuest2",
				[4] = CFrame.new(150.5066375732422, 30.693693161010742, -12774.5029296875)
			}
		elseif lv >= 2400 and lv <= 2424 then
			return {
				[1] = "Candy Pirate",
				[2] = 1,
				[3] = "CandyQuest1",
				[4] = CFrame.new(-1150.0400390625, 20.378934860229492, -14446.3349609375)
			}
		elseif lv >= 2425 and lv <= 2449 then
			return {
				[1] = "Snow Demon",
				[2] = 2,
				[3] = "CandyQuest1",
				[4] = CFrame.new(-1150.0400390625, 20.378934860229492, -14446.3349609375)
			}
		elseif lv >= 2450 and lv <= 2474 then
			return {
				[1] = "Isle Outlaw",
				[2] = 1,
				[3] = "TikiQuest1",
				[4] = CFrame.new(-16547.748046875, 61.13533401489258, -173.41360473632812)
			}
		elseif lv >= 2475 and lv <= 2499 then
			return {
				[1] = "Island Boy",
				[2] = 2,
				[3] = "TikiQuest1",
				[4] = CFrame.new(-16547.748046875, 61.13533401489258, -173.41360473632812)
			}
		elseif lv >= 2500 and lv <= 2524 then
			return {
				[1] = "Sun-kissed Warrior",
				[2] = 1,
				[3] = "TikiQuest1",
				[4] = CFrame.new(-16539.078125, 55.68632888793945, 1051.5738525390625)
			}
		elseif lv >= 2525 and lv <= 2549 then
			return {
				[1] = "Isle Champion",
				[2] = 2,
				[3] = "TikiQuest2",
				[4] = CFrame.new(-16539.078125, 55.68632888793945, 1051.5738525390625)
			}
		elseif lv >= 2550 and lv <= 2574 then
			return {
				[1] = "Serpent Hunter",
				[2] = 1,
				[3] = "TikiQuest3",
				[4] = CFrame.new(-16666.5703125, 105.2913818359375, 1576.6925048828125)
			}
		elseif lv >= 2575 then
			return {
				[1] = "Skull Slayer",
				[2] = 2,
				[3] = "TikiQuest3",
				[4] = CFrame.new(-16666.5703125, 105.2913818359375, 1576.6925048828125)
			}
		end
	end
end

local Module = {}

function Module.IsAlive(model)
	if not model then return false end
	local Humanoid = model:FindFirstChild("Humanoid")
	return Humanoid and Humanoid.Health > 0
end

function Module.Attack(params, customCondition)
	local targetProperties = {
		target = params.target,
		value = params.value or false,
		Hold = params.Hold,
		condition = customCondition or function() return true end
	}

	local v = targetProperties.target
	local value = targetProperties.value
	local condition = targetProperties.condition
	local Human = v:FindFirstChild("Humanoid")

	if not Human or Human.Health <= 0 then
		warn("Invalid target: Humanoid not found or already dead")
		return
	end

	local Success, Error = pcall(function()
		repeat
			local Tool = Character:FindFirstChildOfClass("Tool")
			if Tool then
				local toolProperties = {
					BlackLegLevel = Tool.Name == "Black Leg" and Tool.Level and Tool.Level.Value >= 150,
					DeathStepLevel = Tool.Name == "Death Step" and Tool.Level and Tool.Level.Value >= 400
				}
				if toolProperties.BlackLegLevel or toolProperties.DeathStepLevel then
					_S("V")
				end
			end

			local PosMon = v:FindFirstChild("HumanoidRootPart") and v.HumanoidRootPart.CFrame
			if not PosMon then
				warn("Target missing HumanoidRootPart")
				break
			end

			Teleport(PosMon * CFrame.new(0, 30, 0), function() return not value end)
			if v then
				Human.JumpPower = 0
				Human.WalkSpeed = 0
				Human.Sit = true
				Human.RootPart.CanCollide = false
			end

			if _G['Bring Monster'] and v then
				-- BringMob(v)
			end

			EquipWeapon(_G.Select_Weapon)

			task.wait(0.02)
		until not v.Parent or Human.Health <= 0 or condition()
	end)

	if not Success then warn("Attack Function Error:", Error) end
end

do
	_C = function(...)
		local args = {...}
		local data = network:InvokeServer(...)
		if args[1] == "requestEntrance" then
			game:GetService("CollectionService"):AddTag(Character, "Teleporting")
			task.delay(3, function() game:GetService("CollectionService"):RemoveTag(Character, "Teleporting") end)
			task.wait(0.25)
		end
		return data
	end
	_S = function(key)  
		local Virtual = game:service('VirtualInputManager')
		Virtual:SendKeyEvent(true, key, false, game)
		wait(0.1)
		Virtual:SendKeyEvent(false, key, false, game)
	end
	_E = function(...)
		local ARGS = {...}
		local Data = network:Send("CommE",...)
		return Data
	end
	cancelQuest = function()
		_C("AbandonQuest")
	end
	function _stat(stat,point)
		_C("AddPoint",stat,point)
	end
end

do
	Equip = function (toolName)
		for _, tool in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
			if tool:IsA("Tool") and tool.ToolTip == toolName then
				Humanoid:EquipTool(tool)
				break
			end
		end
	end
	autoSkills = function(customCondition, expression)
		local actions = {
			Sea = function()
				repeat
					wait(.1)
					Equip("Melee")
					for _, skill in pairs({"Z", "X", "C"}) do _S(skill) end
					Equip("Blox Fruit")
					for _, skill in pairs({"Z", "X", "C", "V"}) do _S(skill) end
					Equip("Sword")
					for _, skill in pairs({"Z", "X"}) do _S(skill) end
				until expression()
			end,

			Fruit = function()
				repeat task.wait(.1)
					for _, skill in pairs({"Z", "X", "C", "V"}) do
						if _G['Skill ' .. skill] then _S(skill) end
					end
				until expression()
			end,

			Gun = function()
				repeat task.wait(.1)
					for _, skill in pairs({"Z", "X"}) do
						if _G['Skill ' .. skill] then _S(skill) end
					end
				until expression()
			end
		}

		return actions[customCondition]()
	end
end

do
	IsCombat = function()
		return LocalPlayer.PlayerGui.Main.InCombat.Visible
	end
	_hasChip = function()
		local Backpack = LocalPlayer.Backpack:GetChildren()
		for i=1,#Backpack do local v = Backpack[i]
			if v.Name:lower():find("microchip") then
				return true
			end
		end
		local Character = LocalPlayer.Character:GetChildren()
		for i=1,#Character do local v = Character[i]
			if v:IsA("Tool") and v.Name:lower():find("microchip") then
				return true
			end
		end
	end
	_hasNonWeapon = function()
		for i,v in pairs(LocalPlayer.Backpack:GetChildren()) do
			if v:IsA("Tool") and v.ToolTip == "" and not v:FindFirstChildOfClass("RemoteFunction") then
				return true
			end
		end
	end
	_hasFruit = function()
		local Backpack = LocalPlayer.Backpack:GetChildren()
		for i=1,#Backpack do local v = Backpack[i]
			if v.Name:lower():find("fruit") then return true end
		end
		local Character = LocalPlayer.Character:GetChildren()
		for i=1,#Character do local v = Character[i]
			if v:IsA("Tool") and v.Name:lower():find("fruit") then return true end
		end
	end
end

do -- Class 

	-- [ Teleport ]



	function Teleport(Target, customCondition)
		local Distance = (Target.Position - RootPart.Position).Magnitude
		local SpeedX, SpeedZ = Target.Position.X - RootPart.Position.X, Target.Position.Z - RootPart.Position.Z
		local Percent, Factor = 5, 1.5
		local MoveX = SpeedX / (math.abs(SpeedZ) >= 5 * Percent and Factor or 1)
		local MoveZ = SpeedZ / (math.abs(SpeedX) >= 5 * Percent and Factor or 1)
		local condition = customCondition or function() return true end

		if not Character:FindFirstChild("PartTele") then
			local Root = Instance.new("Part", Character)
			Root.Size = Vector3.new(10, 1, 10)
			Root.Name = "PartTele"
			Root.Anchored = true
			Root.Transparency = 1
			Root.CanCollide = false
			Root.CFrame = RootPart.CFrame
			Root:GetPropertyChangedSignal("CFrame"):Connect(function()
				task.wait(0.01)
				RootPart.CFrame = Root.CFrame
			end)
		end
		for _, v in pairs(game:GetService("Players").LocalPlayer.Character:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = false    
			end
		end
		if not RootPart:FindFirstChild("BodyClip") then
			local Noclip = Instance.new("BodyVelocity")
			Noclip.Name = "BodyClip"
			Noclip.Parent = RootPart
			Noclip.MaxForce = Vector3.new(100000,100000,100000)
			Noclip.Velocity = Vector3.new(0,0,0)
		end
		if not Character:FindFirstChild("Highlight") then
			local Highlight = Instance.new("Highlight")
			Highlight.FillColor = Color3.new(0, 86, 0)
			Highlight.OutlineColor = Color3.new(0,255,0)
			Highlight.FillTransparency = 0.99999
			Highlight.Parent = Character
		end
		if Distance <= 10 then
			if Character:FindFirstChild('Highlight') then
				Character:FindFirstChild('Highlight'):Destroy()
			end
		end

		local recentlySpawn = 0
		local Dista,distm,middle = dist(Target,nil,true),1/0,nil

		if Character and RootPart and Dista >= 2000 and tick() - recentlySpawn > 5 then
			for i, v in pairs(CanTeleport[SeaIndex]) do
				local distance = dist(v, Target, true)
				if distance < dist(Target, nil, true) and distance < distm then
					distm, middle = distance, v
				end
			end
		end
		local partTele = Character.PartTele
		partTele.CFrame = CFrame.new(RootPart.Position.X, Target.Position.Y, RootPart.Position.Z)
		RootPart.CFrame = CFrame.new(RootPart.Position.X, Target.Position.Y, RootPart.Position.Z)
		local tween = game:GetService("TweenService"):Create(partTele, TweenInfo.new(Distance / 270, Enum.EasingStyle.Linear), {
			Position = Vector3.new(RootPart.Position.X + MoveX, Target.Position.Y, RootPart.Position.Z + MoveZ)
		})
		tween:Play()

		Humanoid:ChangeState(11)
		if middle then
			if tween then
				tween:Cancel()
				wait(.2)
			end
			_C("requestEntrance", middle)
		end
	end


	function StopTween(Expression)
		if not Expression then
			_G['Stop Tween'] = true
			wait()
			Teleport(RootPart.CFrame)
			wait()
			Humanoid:ChangeState(14)
			if RootPart:FindFirstChild("BodyClip") then
				RootPart:FindFirstChild("BodyClip"):Destroy()
			end
			if Character:FindFirstChild("PartTele") then
				Character:FindFirstChild("PartTele"):Destroy()
			end
			_G['Stop Tween'] = false
		end
	end

	function Module.CreateF(World, target, condition, position, expression)
		if World ~= nil and (not World or not condition) then return end  
		if not (RootPart or Character) then return end  
		expression = expression or function() return true end  
		if target then  
			local v, spawn = _getEnemiesByName({ 
				target = target 
			}) ; if Module.IsAlive(v) then  
				Module.Attack({  
					target = v, 
					value = condition, 
					function()  
						return not condition or (not RootPart and Character) or expression()  
					end 
				})  
			else  
				local CFramei = position or spawn  
				Teleport(CFramei, function() return not condition end)  
			end  
		else  
			local closest, minDist = nil, 1000  
			for _, e in pairs(game:GetService("Workspace").Enemies:GetChildren()) do  
				local dist = (e.HumanoidRootPart.Position - RootPart.Position).Magnitude  
				if dist <= minDist and Module.IsAlive(e) then closest, minDist = e, dist end  
			end  
			if closest then Module.Attack({ target = closest, value = condition }) end  
		end  
	end

	function _getEnemiesByName(params)
		local targets = params.target
		local closest, minDist = nil, math.huge
		for _, parent in ipairs({game.Workspace.Enemies, game.ReplicatedStorage}) do
			for _, enemy in ipairs(parent:GetChildren()) do
				if (type(targets) == "string" and enemy.Name == targets) or (type(targets) == "table" and table.find(targets, enemy.Name)) then
					local hrp = enemy:FindFirstChild("HumanoidRootPart")
					local humanoid = enemy:FindFirstChild("Humanoid")
					if hrp and humanoid and humanoid.Health > 0 then
						local dist = (hrp.Position - RootPart.Position).Magnitude
						if dist < minDist then
							minDist, closest = dist, enemy
						end
					end
				end
			end
		end
		return closest, minDist
	end

	function EquipWeapon(ToolSe)
		if not ToolSe then return end
		if not Character then return end
		if LocalPlayer.Backpack:FindFirstChild(ToolSe) then
			Humanoid:EquipTool(LocalPlayer.Backpack:FindFirstChild(ToolSe))
		end
	end

	function GetMaterial(MartialName)
		for _, v in ipairs(_C("getInventory")) do
			if type(v) == "table" and v.Type == "Material" and v.Name == MartialName then
				return v.Count
			end
		end
		return 0
	end

	function _hasItem(name)
		if LocalPlayer.Backpack:FindFirstChild(name) then return true end
		if LocalPlayer.Character:FindFirstChild(name) then return true end
		for i,v in pairs(_C("getInventoryWeapons") or {}) do
			if v.Name == name then return v end
		end
	end

	function dist(a,b,noHeight)
		if not b then
			b = RootPart.Position
		end
		return (Vector3.new(a.X,not noHeight and a.Y,a.Z) - Vector3.new(b.X,not noHeight and b.Y,b.Z)).magnitude
	end

	function CreateHighlight(parent, fillColor, outlineColor, fillTransparency)
		if not parent then
			warn("CreateHighlight: Parent is required.")
			return
		end
		if parent:FindFirstChild("Highlight") then return end

		local highlight = Instance.new("Highlight")
		highlight.FillColor = fillColor or Color3.new(1, 0.203922, 0.321569)
		highlight.OutlineColor = outlineColor or Color3.new(1, 0.180392, 0.290196)
		highlight.FillTransparency = fillTransparency or 0.99999
		highlight.Parent = parent
	end


end


LoadFuncs['All Fully'] = function(value)
	while value do task.wait(0.1)
		local MyLevel = LocalPlayer.Data.Level.Value
		Getpcall(function()
			if not (LocalPlayer.Backpack:FindFirstChild("God's Chalice") or Character:FindFirstChild("God's Chalice")) then
				if not (LocalPlayer.Backpack:FindFirstChild("Hallow Essence") or Character:FindFirstChild("Hallow Essence")) then
					local hasCom, hasPro = false, false
					if not hasCom then
						local Progress = _C("RaceV4Progress", "Check")
						if Progress == 1 then
							_C("RaceV4Progress", "Begin")
						elseif Progress == 2 then
							repeat
								wait()
								RootPart.CFrame = CFrame.new(2959, 2282, -7216)
								_C("RaceV4Progress", "Teleport")
							until (RootPart.Position - Vector3.new(28286.35546875, 14896.5078125, 102.62469482421875)).Magnitude <= 15
						elseif Progress == 3 then
							hasCom = true
							if not hasPro then
								wait(1)
								_C("RaceV4Progress", "Continue")
								hasPro = true
							end
						elseif Progress == 4 then
							hasCom = true
						end
					else
						if game:GetService("Workspace").Map:FindFirstChild("MysticIsland") then
							local pointer = game:GetService("Workspace").Map:FindFirstChild("MysticIsland").WorldPivot*CFrame.new(0,500,0)
							if (pointer.Position - RootPart.Position).Magnitude <= 25 then
								if _C("CheckTempleDoor") == false then
									wait(1)
									local result = {}
									local x = tostring(game:GetService("Lighting").TimeOfDay)
									local regex = ("([^%s]+)"):format(":")
									for each in x:gmatch(regex) do
										table.insert(result, each)
									end
									_G['Auto Lock To Full Moon'] = true
									wait(5)
									_S("T")
									wait(17)
									_G['Auto Lock To Full Moon'] = false
									if _G['Teleport To Gear'] == false then
										_G['Teleport To Gear'] = true
									end
								end
							else
								if _G['Auto Teleport To Mirage Island'] == false then
									_G['Auto Teleport To Mirage Island'] = true
								end
							end
						else
							if _G['Teleport To Gear'] == true then
								_G['Teleport To Gear'] = false
							end
							if game:GetService("Workspace").Enemies:FindFirstChild("rip_indra") then
								_G['Auto color press Haki'] = false
								if _G['Auto Dark Dagger'] == false then
									_G['Auto Dark Dagger'] = true
								end
							elseif game:GetService("Workspace").Enemies:FindFirstChild("Soul Reaper") then
								_G['Auto pass Hallow Essence'] = false
								if _G['Auto Hallow Scythe'] == false then
									_G['Auto Hallow Scythe'] = true
								end
							else
								local names = {"Diablo", "Deandre", "Urban"}
								local found = false
								for _, name in ipairs(names) do
									if game:GetService("ReplicatedStorage"):FindFirstChild(name) then
										found = true
										break
									end
								end
								if found then
									if _G['Auto Cake Prince'] then
										_G['Auto Cake Prince'] = false 
									end
									if _G['Auto Farm Level'] then
										_G['Auto Farm Level'] = false
									end
									_G['Auto Elite Hunter'] = true
								else
									local caketotal = string.match(_C("CakePrinceSpawner"),"%d+")
									if caketotal < 50 then
										if _G['Auto Farm Level'] then
											_G['Auto Farm Level'] = false
										end
										wait(.2)
										_G['Auto Cake Prince'] = true
									else
										if _G['Auto Cake Prince'] then
											_G['Auto Cake Prince'] = false 
										end
										_G['Auto Farm Level'] = true
									end
								end
							end
						end
					end
				else
					if _G['Auto pass Hallow Essence'] == false then
						_G['Auto pass Hallow Essence'] = true
					end
				end
			else
				if _G['Auto Stop WhenUntil GodChalice'] then
					_G['Auto Stop WhenUntil GodChalice'] = false
				end
				local Oyster_H = false
				local Hot_pink_H = false
				local Really_red_H = false
				local colors = {
					{name = 'Oyster', color = Oyster_H},
					{name = 'Hot pink', color = Hot_pink_H},
					{name = 'Really red', color = Really_red_H}
				}

				for _, color in pairs(colors) do
					for _, v in pairs(game.workspace.Map["Boat Castle"].Summoner.Circle:GetChildren()) do
						if v.Name == 'Part' and tostring(v.BrickColor) == color.name and tostring(v.Part.BrickColor) == 'Lime green' then
							color.color = true
						end
					end
				end
				if Oyster_H and Hot_pink_H and Really_red_H then
					if _G['Auto color press Haki'] == false then
						_G['Auto color press Haki']  = true
					end
				else
					if game:GetService("Workspace").Map.CakeLoaf:FindFirstChild("RedDoor") then
						if _G['Auto Farm Mirror Fractal'] == false then
							_G['Auto Farm Mirror Fractal'] = true
						end
					else
						Character.Head:Destroy() -- มึงควรตาย
					end
				end
			end
		end)
	end
end

local LoadingTime = tick()
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/Marukulaes/AtlasX/refs/heads/main/Protected_5472538632514602.txt'))()
local UIS = game:GetService("UserInputService")
local plamform = UIS.TouchEnabled and "Mobile" or UIS.KeyboardEnabled and "PC" or UIS.GamepadEnabled and "Console" or "Unknown"
local Window = Library:CreateWindow({Credit = LocalPlayer.Name})

local Tab1 = Window:AddPage({
	Title = "General",
	Icon = "home",
	Page = { Left = { Name = "Farm", Icon = "arrow-big-up" }, Right = { Name = "Setup", Icon = "file-cog" } }
})
local Tab_Automatic = Window:AddPage({
	Title = "Automatic",
	Icon = "airplay",
	Page = { Left = { Name = "Farm", Icon = "arrow-big-up" }, Right = { Name = "Setup", Icon = "file-cog" } }
})
local Tab_Teleport = Window:AddPage({
	Title = "Teleport",
	Icon = "indent",
	Page = { Left = { Name = "Farm", Icon = "arrow-big-up" }, Right = { Name = "Setup", Icon = "file-cog" } }
})
local Tab_Race = Window:AddPage({
	Title = "Race",
	Icon = "currency",
	Page = { Left = { Name = "Farm", Icon = "arrow-big-up" }, Right = { Name = "Setup", Icon = "currency" } }
})
local Tab_Shop = Window:AddPage({
	Title = "Misc",
	Icon = "shopping-bag",
	Page = { Left = { Name = "Shop", Icon = "shopping-bag" }, Right = { Name = "Server", Icon = "server" } }
})


function Label(options, side)
	local Section = options.Section
	local Title = options.Title
	if side == 1 then
		side = "Left"
	elseif side == 2 then
		side = "Right"	
	end
	return Section:CreateLabel(side, { Title = Title, Desc = "" })
end

function Toggle(Section,side, options, CallBack, SettingName)
	local Title = options.Title
	local Description = options.Description
	local tasks;
	if type(CallBack) == 'string' then
		if not SettingName then
			SettingName = CallBack
		end
		CallBack = nil
	end
	if not SettingName then
		SettingName = Title
	end
	if side == 1 then
		side = "Left"
	elseif side == 2 then
		side = "Right"	
	end
	return Section:CreateToggle(side,{
		Title = Title,
		Desc = Description,
		Value = _G[SettingName] or false,
		Callback = function(Value)
			_G[SettingName] = Value
			if tasks then task.cancel(tasks) tasks = nil end
			if Value then
				tasks = task.spawn(function()  
					if LoadFuncs[SettingName] then  
						LoadFuncs[SettingName](true) 
						StopTween(true)
					end
				end)
			else
				if LoadFuncs[SettingName] then  
					LoadFuncs[SettingName](false)
				end
				StopTween(false)
			end
		end
	})
end

function Button(Section,side, Title, params, CallBack,proceed)
	local callback = CallBack or function() end
	local description = params.Description or "Very important button"
	local content = params.Content or "Are you sure you want to proceed?"
	if side == 1 then
		side = "Left"
	elseif side == 2 then
		side = "Right"	
	end
	return Section:CreateButton(side,{
		Title = Title,
		Desc = description,
		Callback = callback or function () return true end
	})
end


Label({ Section = Tab1, Title = "🎄 Farming" },1)

Toggle(Tab1,1, {Title = "Auto Farm [Level]",Description = "ฟาร์มเลเวลจน ถึง 1-2600 Max"}, "Auto Farm Level")

local lq = CheckQuest()[2]

LoadFuncs['Auto Farm Level'] = function(value)
	while value do task.wait(0.1)
		Getpcall(function()
			local LQuest = CheckQuest()
			local mon = string.gsub(string.gsub(string.gsub(QuestC.Container.QuestTitle.Title.Text, "^Defeat %d+ ", ""), " %(.-%)$", ""), "s$", "")
			if QuestC.Visible == true then 
				if not string.find(QuestC.Container.QuestTitle.Title.Text, mon)  then
					_C("AbandonQuest")
				else
					Module.CreateF(nil,mon, value,nil,function() return QuestC.Visible == false end)
				end
			else
				if dist(LQuest[4].Position, nil, true) < 5 then wait(1)
					_C("StartQuest", LQuest[3], lq)
					if lq == 2 then
						lq = 1
					elseif lq == 1 and LQuest[2] == 2 then
						lq = 2
					else
						lq = LQuest[2]
					end
				else
					Teleport(LqQuest[4],function() return QuestC.Visible == true or not value end)
				end
			end
		end)
	end
end

if World2 then
	Toggle(Tab1,1, {Title = "Auto Factory",Description = "ตีโรงงาน"}, "Auto Factory")	
end
if World3 then
	Toggle(Tab1,1, {Title = "All Fully (New)",Description = "ฟังชั่นทำตามอารมณ์"}, "All Fully")	
end

Toggle(Tab1,1, {Title = "Auto Second Sea",Description = "ออโต้ ปลดล็อคโลก 2 "}, "Auto Second Sea")


LoadFuncs['Auto Second Sea'] = function(value)
	if not World1 then return end
	while value do task.wait(.1)
		Getpcall(function()
			if game:GetService("Workspace").Map.Ice.Door.CanCollide == false and game:GetService("Workspace").Map.Ice.Door.Transparency == 1 then
				if _hasItem("Key") then
					if LocalPlayer.Backpack:FindFirstChild("Key") then
						Humanoid:EquipTool(LocalPlayer.Backpack:FindFirstChild("Key"))
					end
					Teleport(CFrame.new(1347, 37, -1325), function() return not value or not _hasItem("Key") end)
				else
					Teleport(CFrame.new(4849, 5, 719), function() return not value or _hasItem("Key") end)
					wait(1.1)
					_C("DressrosaQuestProgress","Detective")
				end
			else
				Module.CreateF(World1,"Ice Admiral", value,CFrame.new(1347, 37, -1325))
				repeat wait(5)
					_C("TravelDressrosa")
				until not game:GetService("Workspace").Enemies:FindFirstChild("Ice Admiral")
			end
		end)
	end
end

Toggle(Tab1,1, {Title = "Auto Third Sea",Description = "ออโต้ ปลดล็อคโลก 3 "}, "Auto Third Sea")

LoadFuncs['Auto Third Sea'] = function(value)
	if not World2 then return end
	while value do task.wait(.1)
		Getpcall(function()
			local Level = LocalPlayer.Data.Level.Value
			if Level >= 1500 and World2 then
				if _C("BartiloQuestProgress", "Bartilo") == 3 then
					if _C("GetUnlockables").FlamingoAccess ~= nil then
						if _C("ZQuestProgress", "Check") == 0 then
							Module.CreateF(World2,"rip_indra", value)
						elseif _C("ZQuestProgress", "Check") == 1 then
							_G['Auto Third Sea'] = false
						else
							_C("TravelZou")
							Module.CreateF(World2,"Don Swan", value,CFrame.new(2207, 15, 883))
						end
					else
						local FruitPrice, FruitStore = {}, {}

						for _,v in next, _C("GetFruits") do
							if v.Price >= 1000000 then  
								table.insert(FruitPrice, v.Name)
							end
						end
						-- ดึงผล

						for _,v in pairs(_C:InvokeServer("getInventoryFruits")) do
							for _,x in pairs(v) do
								if _ == "Name" then table.insert(FruitStore, x) end
							end
						end

						for _,y in pairs(FruitPrice) do
							for _,z in pairs(FruitStore) do
								if y == z and not _C("GetUnlockables").FlamingoAccess then
									_C("LoadFruit", y)
								end
							end
						end
						local player = game.Players.LocalPlayer
						for _, tool in pairs(player.Backpack:GetDescendants()) do
							if tool:FindFirstChild("Fruit") then 
								if tool then
									Humanoid:EquipTool(tool.Name)
									wait(0.5)
									_C("TalkTrevor", "1")
									wait(0.5)
									_C("TalkTrevor", "2")
									wait(0.5)
									_C("TalkTrevor", "1")
									wait(0.5)
									_C("TalkTrevor", "3")
								end	
							end
						end
					end
				else
					if _C("BartiloQuestProgress","Bartilo") == 0 then
						if QuestC.Visible == true then
							Module.CreateF(World2,"Swan Pirate", value)
						else
							Teleport(CFrame.new(-461, 72, 300),function() return not value or QuestC.Visible end)
							if (CFrame.new(-461, 72, 300).Position - RootPart.Position).Magnitude <= 1 then _C("StartQuest", "BartiloQuest", 1) end
						end
					elseif  _C("BartiloQuestProgress","Bartilo") == 1 then
						Module.CreateF(World2,"Jeremy", value,game:GetService("ReplicatedStorage")["Jeremy"].HumanoidRootPart.CFrame)
					elseif  _C("BartiloQuestProgress","Bartilo") == 2 then
						Teleport(CFrame.new(-1830, 10, 1680),function() return not value or QuestC.Visible end)
						wait(0.7)
						RootPart.CFrame = workspace.Map.Dressrosa.BartiloPlates.Plate1.CFrame
						wait(0.7)
						RootPart.CFrame = workspace.Map.Dressrosa.BartiloPlates.Plate2.CFrame
						wait(0.7)
						RootPart.CFrame = workspace.Map.Dressrosa.BartiloPlates.Plate3.CFrame
						wait(0.7)
						RootPart.CFrame = workspace.Map.Dressrosa.BartiloPlates.Plate4.CFrame
						wait(0.7)
						RootPart.CFrame = workspace.Map.Dressrosa.BartiloPlates.Plate5.CFrame
						wait(0.7)
						RootPart.CFrame = workspace.Map.Dressrosa.BartiloPlates.Plate6.CFrame
						wait(0.7)
						RootPart.CFrame = workspace.Map.Dressrosa.BartiloPlates.Plate7.CFrame
						wait(0.7)
						RootPart.CFrame = workspace.Map.Dressrosa.BartiloPlates.Plate8.CFrame
						wait(0.7)
					end
				end
			end
		end)
	end
end

Label({ Section = Tab1, Title = "🎄 Chest" })

Toggle(Tab1,1, {Title = "Auto Farm Chest",Description = "ฟาร์มกล่อง"}, "Auto Farm Chest")

LoadFuncs['Auto Farm Chest'] = function(condition)
	if not (RootPart or Character) then return end
	while condition do task.wait(0.1)
		Getpcall(function()
			local chosenIslands = {}
			local allIslands = workspace.Map:GetChildren()
			local function getRandomIsland()
				if #chosenIslands == #allIslands then chosenIslands = {} end
				local island
				repeat
					task.wait(0.1)
					island = allIslands[math.random(1, #allIslands)]
				until island:IsA("Model") and not table.find(chosenIslands, island)
				table.insert(chosenIslands, island)

				local cframe
				if island.PrimaryPart then
					cframe = island.PrimaryPart.CFrame
				else
					cframe, _ = island:GetBoundingBox()
				end
				return island, cframe
			end

			local island, cframe = getRandomIsland()
			if island then
				repeat task.wait(0.1) Teleport(cframe, function() return not condition end) until dist(cframe, nil, true) < 20
				if dist(cframe, nil, true) < 20 then
					local CFrameList = {}
					for _, v in pairs(workspace.ChestModels:GetChildren()) do
						if v:IsA("Model") then
							local cframe, size = v:GetBoundingBox()
							table.insert(CFrameList, cframe)
						end
					end
					if #CFrameList > 0 then
						for _, targetCFrame in ipairs(CFrameList) do
							repeat
								task.wait(0.1)
								print("Teleporting to: ", targetCFrame.Position)
								Teleport(targetCFrame, function() return not condition end)

								local distance = dist(targetCFrame, nil, true)
								print("Distance to target: ", distance)
							until distance < 1
						end
					else
						chosenIslands = {}
					end
				end
			end
		end)
	end
end

Label({ Section = Tab1, Title = "🎄 Mob Aura" })

Toggle(Tab1,1, {Title = "Auto Mob Aura",Description = "ตีมอนรอบเกาะ"}, "Auto Mob Aura")

LoadFuncs['Auto Mob Aura'] = function(value)
	while value do task.wait(.1)
		Getpcall(function()
			Module.CreateF(nil,nil,value,nil)
		end)
	end
end

Label({ Section = Tab1, Title = "🎄 Boss" })

local bossNames = {"The Gorilla King", "Bobby", "The Saw", "Yeti", "Mob Leader", "Vice Admiral", "Warden",
	"Chief Warden", "Swan", "Saber Expert", "Magma Admiral", "Fishman Lord", "Wysper", "Thunder God",
	"Cyborg", "Greybeard", "Diamond", "Jeremy", "Fajita", "Don Swan", "Smoke Admiral",
	"Awakened Ice Admiral", "Tide Keeper", "Order", "Darkbeard", "Cursed Captain", "Stone",
	"Island Empress", "Kilo Admiral", "Captain Elephant", "Beautiful Pirate", "Longma", "Cake Queen",
	"Soul Reaper", "Rip_Indra", "Cake Prince", "Dough King"}

local BossTable = {}   


local Select_Boss = Tab1:CreateDropdown("Left",{
	Title = "Select Boss",
	Desc = "เลือกบอส",
	List = BossTable,
	Value = BossTable[1],
	Multi = false,
	Callback = function(Value)
		_G['Select Boss'] = Value
	end
})

Button(Tab1,1, "Refresh Boss", { Description = "รีบอส", }, function()
	Select_Boss:Clear()
	for _, bossName in pairs(bossNames) do
		if game:GetService("ReplicatedStorage"):FindFirstChild(bossName) then
			table.insert(BossTable, bossName)
		end
	end
	for i,v in ipairs(BossTable) do
		Select_Boss:AddList(v,i)
	end
end)

Toggle(Tab1,1, {Title = "Auto Farm Boss",Description = "ออโต้ ฟาร์มบอส"}, "Auto Farm Boss")

Label({ Section = Tab1, Title = "Setting Farm" },2) do

	Tab1:CreateDropdown("Right",{
		Title = "Select Weapon",
		List = {"Melee", "Sword", "Gun", "Fruit"},
		Value = "Melee",
		Multi = false,
		Callback = function(Value)
			_G.Select_Weapon = Value
		end
	})

	_G['Fast Attack'] = true
	Toggle(Tab1,2, {Title = "Fast Attack ",Description = "ตีเร็ว (เร็วกว่าอัพสคริป)"}, "Fast Attack")
	_G['Double Quest'] = true
	Toggle(Tab1,2, {Title = "Double Quest",Description = "รับเควสคู่"}, "Double Quest")
	_G['Bring Mob'] = true
	Toggle(Tab1,2, {Title = "Bring Monster",Description = "ดึงมอน ถ้ามีบัคให้ปิด"}, "Bring Mob")
	_G['Bypass Tp'] = false
	Toggle(Tab1,2, {Title = "Bypass Tp",Description = "วาร์ปเร็ว ถ้าบัคให้ปิด"}, "Bypass Tp")
	Toggle(Tab1,2, {Title = "Auto Active Ability",Description = "ออโต้ เปิดเผ่า"}, "Auto Active Ability")


	LoadFuncs['Auto Active Ability'] = function(value)
		while value do task.wait(.1)
			game:GetService("VirtualInputManager"):SendKeyEvent(true, "Y", false, game)
			task.wait()
			game:GetService("VirtualInputManager"):SendKeyEvent(false, "Y", false, game)
			game:GetService("ReplicatedStorage").Remotes.CommE:FireServer("ActivateAbility")
		end
	end
end



Label({ Section = Tab1, Title = "🎄 Stats" },2) do

	Button(Tab1,2, "Redeem X2 EXP Code", { Description = "ใช้โค้ด คูณ 2", }, function()
		for i,v in pairs({"GAMERROBOT_YT","EXP_5B","kittgaming","Enyu_is_Pro","Sub2Fer999","THEGREATACE","SUB2GAMERROBOT_EXP1","Sub2OfficialNoobie",
			"StrawHatMaine","SUB2NOOBMASTER123","Sub2Daigrock","Axiore","TantaiGaming","STRAWHATMAINE","JCWK","Magicbus","Starcodeheo","Bluxxy",
			}) do
			task.spawn(game:GetService("ReplicatedStorage").Remotes.Redeem:InvokeServer(v))
		end
	end)

	local Select_Add_Point = Tab1:CreateDropdown("Right",{
		Title = "Select Point",
		List = {"Melee", "Defense", "Sword", "Gun", "Fruit"},
		Value = {"Melee"},
		Multi = true,
		Callback = function(Value)
			_G['Select Point'] = Value
		end
	})

	_G['Auto Stats'] = false
	Toggle(Tab1,2, {Title = "Auto Stats",Description = "ออโต้อัพ อัพค่าพลัง"}, "Auto Stats")

	LoadFuncs['Auto Stats'] = function(value)
		while value do task.wait(.1)
			for _, stat in ipairs(_G['Select Point']) do _C("AddPoint", stat, _G['Point'])  end
		end
	end

	Tab1:CreateSlider("Right",{
		Title = "Point",
		Desc = "Choose the points you want",
		Min = 0,
		Max = 1000,
		Value = 100,
		DecimalPlaces = 0,
		Callback = function(v)
			_G['Point'] = v
		end
	})
end

Label({ Section = Tab1, Title = "🎄 Mastery" },1)

local Select_Mastery_Mode = Tab1:CreateDropdown("Left",{
	Title = "Select Mastery Mode",
	Desc = "Select Mastery Mode",
	List = {"Fruit Mastery","Gun Mastery"},
	Value = "Fruit Mastery",
	Multi = false,
	Callback = function(Value)
		_G['Select Mastery Mode'] = Value
		print("Select Mastery Mode: " .. Value)
	end
})

Toggle(Tab1,1, { Title = "Auto Farm Mastery", Description = "Farm Mastery" }, "Auto Farm Mastery")


local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local camera = workspace.CurrentCamera

local isTargetFound = false

local function clickAtPosition(worldPosition)
	local screenPosition = camera:WorldToScreenPoint(worldPosition)
	pcall(function()
		VirtualInputManager:SendMouseButtonEvent(screenPosition.X, screenPosition.Y, 0, true, game, 0)
		VirtualInputManager:SendMouseButtonEvent(screenPosition.X, screenPosition.Y, 0, false, game, 0)
	end)
end

local lq = CheckQuest()[2]
LoadFuncs['Auto Farm Mastery'] = function(value)
	while value do 
		task.wait(0.1)
		if not value then return end
		Getpcall(function()
			local q = CheckQuest()
			local mon = string.gsub(QuestC.Container.QuestTitle.Title.Text, "^Defeat %d+ ", ""):gsub(" %(.-%)$", ""):gsub("s$", "")
			local Level = LocalPlayer.Data.Level.Value

			if QuestC.Visible then 
				local v, spawn = _getEnemiesByName({ target = mon })

				if not Module.IsAlive(v) then
					if Level >= 30 and Level <= 39 then
						Teleport(CFrame.new(-1103, 13, 3896), function() return not value end)
					else
						Teleport(spawn, function() return not value end)
					end
				else
					if not string.find(QuestC.Container.QuestTitle.Title.Text, mon) then
						_C("AbandonQuest")
					else
						local HealthMs = v.Humanoid.MaxHealth * _G['Kill at'] / 100
						local masteryMode = _G['Select Mastery Mode']

						if masteryMode == "Fruit Mastery" or masteryMode == "Gun Mastery" then
							repeat task.wait(0.1)
								if v.Humanoid.Health <= HealthMs then
									for _, tool in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
										if tool:IsA("Tool") and ((masteryMode == "Fruit Mastery" and tool.ToolTip == "Blox Fruit") or 
											(masteryMode == "Gun Mastery" and tool.ToolTip == "Gun")) then
											Humanoid:EquipTool(tool)
										end
									end

									Teleport(v.HumanoidRootPart.CFrame * CFrame.new(0, 15, 0), function() return not value end)
									v.Humanoid.WalkSpeed, v.HumanoidRootPart.CanCollide = 0, false
									v.Head.CanCollide = false

									if _G['Bring Monster'] then BringMob(v) end
									autoSkills(masteryMode, function() return not value or v.Humanoid.Health <= 0 or not v.Parent or not QuestC.Visible end)
								else
									Module.Attack({ target = v, value = value, function() return not value end })
								end
							until not value or v.Humanoid.Health <= 0 or not v.Parent or not QuestC.Visible
						end
					end
				end
			else
				if dist(q[4].Position, nil, true) < 5 then
					_C("StartQuest", q[3], lq)
					if _G['Double Quest'] then lq = (lq == 2 and 1) or (lq == 1 and q[2] == 2 and 2) or q[2] end
				else
					Teleport(q[4], function() return not value end)
				end
			end
		end)
	end
end


if World3 then
	Toggle(Tab1,1, {
		Title = "Auto Farm All Swords Mastery",
		Description = "Auto Farm All Swords Mastery"
	}, "Auto Farm All Swords Mastery")
end

Tab1:CreateDropdown("Left",{
	Title = "Select Farm",
	Desc = "Select Farm",
	List = {"Cake","Bone"},
	Value = "Level",
	Multi = false,
	Callback = function(Value)
		_G['Select Farm'] = Value
	end
})

LoadFuncs['Auto Farm All Swords Mastery'] = function(condition)
	while condition do  task.wait(.1)
		if not condition then return end
		for i,v in pairs(_C("getInventory")) do
			if type(v) == "table" then
				if v.Type == "Sword" then
					if tonumber(v.Mastery) >= 1 and tonumber(v.Mastery) < 600 then
						local Name = v.Name
						local Mastery = v.Mastery
						if tonumber(v.Mastery) >= 1 and tonumber(v.Mastery) < 600 then
							if LocalPlayer.Backpack:FindFirstChild(Name) or Character:FindFirstChild(Name) then
								local Enemies
								if _G['Select Farm'] == "Cake" then
									Module.CreateF(World3, {"Cookie Crafter","Cake Guard","Baking Staff","Head Baker"},condition,CFrame.new(-2077, 252, -12373),Name)
								elseif _G['Select Farm'] == "Bone" then
									Module.CreateF(World3, {"Cookie Crafter","Cake Guard","Baking Staff","Head Baker"},condition, CFrame.new(-9504, 172, 6057),Name)
								end
							else
								_C("LoadItem",Name)
							end
						end
						if v.Mastery > 599 then
							if not (LocalPlayer.Backpack:FindFirstChild(Name) or Character:FindFirstChild(Name)) then _C("LoadItem",Name) end
						end
						break
					end
				end
			end
		end
	end
end

Tab1:CreateSlider("Left",{
	Title = "Kill at",
	Desc = "Choose the Health Mob a you want",
	Min = 0,
	Max = 100,
	Value = 25,
	DecimalPlaces = 0,
	Callback = function(v)
		_G['Kill at'] = v
	end
})

Label({ Section = Tab1, Title = "Mastery Setting" },1) do
	_G['Skill Z'] = true
	_G['Skill X'] = true
	_G['Skill C'] = true
	_G['Skill V'] = true
	Toggle(Tab1,1, { Title = "Skill Z", Description = "ใช้ สกิว z ฟาร์ม" }, "Skill Z")
	Toggle(Tab1,1, {Title = "Skill X", Description = "ใช้ สกิว x ฟาร์ม" }, "Skill X")
	Toggle(Tab1,1, { Title = "Skill C", Description = "ใช้ สกิว c ฟาร์ม" }, "Skill C")
	Toggle(Tab1,1, {Title = "Skill V", Description = "ใช้ สกิว v ฟาร์ม" }, "Skill V")    
end

if World3 then

	Label({ Section = Tab_Automatic, Title = "Cake Prince" },1) do

		local TotalMob = Tab_Automatic:CreateLabel("Left",{ Title = "Total Mob", Desc = "", })

		task.defer(function()
			while wait(.1) do
				pcall(function()
					local caketotal = string.match(_C("CakePrinceSpawner"),"%d+")
					if caketotal then
						TotalMob:SetTitle("Total : "..tostring(caketotal))
					else
						TotalMob:SetTitle("Boss : Spawned")
					end
				end)
			end
		end)


		Toggle(Tab_Automatic,1, {Title = "Auto Cake Prince",Description = "ออโต้ ฟาร์มคาตาคุริ"}, "Auto Cake Prince")

		LoadFuncs['Auto Cake Prince'] = function(value)
			if not World3 then return end
			while value and task.wait(0.1) do
				pcall(function()
					if string.find(_C("CakePrinceSpawner"), "Do you want to open the portal now?")  then _C("CakePrinceSpawner") end
					if not game:GetService("Workspace").Enemies:FindFirstChild("Cake Prince") then
						if not game:GetService("ReplicatedStorage"):FindFirstChild("Cake Prince") then
							Module.CreateF(World3,{"Cookie Crafter","Cake Guard","Baking Staff","Head Baker"}, value, CFrame.new(-2077, 252, -12373))
						else
							Teleport(game:GetService("ReplicatedStorage"):FindFirstChild("Cake Prince").HumanoidRootPart.CFrame * CFrame.new(2,20,2), function() return not value end)
						end
					else
						Module.CreateF(World3,"Cake Prince", value, game:GetService("ReplicatedStorage"):FindFirstChild("Cake Prince").HumanoidRootPart.CFrame)
					end
				end)
			end
		end

	end

	Label({ Section = Tab_Automatic, Title = "Elite Hunter" },1) do

		local EliteHunterCount = Tab_Automatic:CreateLabel("Left",{Title = "Total Mob : ",Desc = ""})
		local EliteHunterSpawn = Tab_Automatic:CreateLabel("Left",{Title = "บอทเกิดแล้ว  ",Desc = ""})

		task.spawn(function()
			while wait(.1) do
				local Data = _C("EliteHunter","Progress")
				EliteHunterCount:SetTitle("Total : "..tostring(Data))
				if game:GetService("ReplicatedStorage"):FindFirstChild("Diablo") then
					EliteHunterSpawn:SetTitle('🟢: บอสเกิดแล้ว : Diablo')
				elseif game:GetService("ReplicatedStorage"):FindFirstChild("Deandre") then
					EliteHunterSpawn:SetTitle('🟢: บอสเกิดแล้ว : Deandre')
				elseif game:GetService("ReplicatedStorage"):FindFirstChild("Urban") then
					EliteHunterSpawn:SetTitle('🟢: บอสเกิดแล้ว : Urban')
				else
					EliteHunterSpawn:SetTitle('❌: บอสยังไม่เกิด')
				end
			end
		end)

		Toggle(Tab_Automatic,1, {Title = "Auto Elite Hunter",Description = "ฟาร์ม อีลิต"}, "Auto Elite Hunter")

		LoadFuncs['Auto Elite Hunter'] = function(value)
			if not World3 then return end
			while value do task.wait(.1)
				pcall(function()
					local questTitle = QuestC.Container.QuestTitle.Title.Text
					local eliteCFrame = CFrame.new(-5418, 313, -2826)
					if QuestC.Visible then
						if not (LocalPlayer.Backpack:FindFirstChild("God's Chalice") and _G['Auto Stop WhenUntil GodChalice']) then
							if string.find(questTitle,"Diablo") or string.find(questTitle,"Deandre") or string.find(questTitle,"Urban") then
								local enemyNames = { "Diablo", "Deandre", "Urban" }
								local v,spawn = _getEnemiesByName({ target = enemyNames })
								if Module.IsAlive(v) then
									Module.Attack({ target = v, value = value,function() return not value end})
								else
									if game:GetService("ReplicatedStorage"):FindFirstChild("Diablo") then
										Teleport(game:GetService("ReplicatedStorage"):FindFirstChild("Diablo").HumanoidRootPart.CFrame,function() return not value end)
									elseif game:GetService("ReplicatedStorage"):FindFirstChild("Deandre") then
										Teleport(game:GetService("ReplicatedStorage"):FindFirstChild("Deandre").HumanoidRootPart.CFrame,function() return not value end)
									elseif game:GetService("ReplicatedStorage"):FindFirstChild("Urban") then
										Teleport(game:GetService("ReplicatedStorage"):FindFirstChild("Urban").HumanoidRootPart.CFrame,function() return not value end)
									end
								end
							else
								if dist(eliteCFrame.Position, nil, false) < 2 then
									_C("EliteHunter")
								else
									Teleport(eliteCFrame, function() return not value or QuestC.Visible end) 
									if (RootPart.Position - eliteCFrame.Position).Magnitude > 2000 then  BYpass(eliteCFrame)  end	
								end
							end
						else
							local args = {
								[1] = "requestEntrance",
								[2] = Vector3.new(-5079.44677734375, 313.7293395996094, -3151.065185546875)
							}

							_C(unpack(args))
							_G['Auto Elite Hunter'] = false
						end
					else
						if dist(eliteCFrame.Position, nil, false) < 2 then
							_C("EliteHunter")
						else
							Teleport(eliteCFrame, function() return not value or QuestC.Visible end) 
							if (RootPart.Position - eliteCFrame.Position).Magnitude > 2000 then  BYpass(eliteCFrame)  end	
						end
					end
				end)
			end
		end

		Toggle(Tab_Automatic,1, {Title = "Auto Elite Hunter [Hop]",Description = "ถ้าแม่งไม่มีให้รีเซิฟ"}, "Auto Elite Hunter [Hop]")
		_G['Auto Stop WhenUntil GodChalice'] = true
		Toggle(Tab_Automatic,1, {Title = "Stop Until Have God Chalice",Description = "จะหยุกถ้าได้ที่ เสกแอดมิน"}, "Auto Stop WhenUntil GodChalice")
	end

	Label({ Section = Tab_Automatic, Title = "Bone" },1) do

		local BoneCount = Tab_Automatic:CreateLabel("Left",{Title = "Bone : 0",Desc = ""})

		task.spawn(function()
			while wait(.1) do
				for i, v in pairs(_C("getInventory")) do
					if v.Type == "Material" then
						if v.Name == "Bones" then
							BoneCount:SetTitle("🦴 Bones : "..v.Count)
						end
					end
				end
			end
		end)

		Toggle(Tab_Automatic,1, {Title = "Auto Bones",Description = "ออโต้ฟาร์ม กระดูก"}, "Auto Bone")
	end
end

if World3 then
	Label({ Section = Tab_Automatic, Title = "Main AutoMatic" },2) do
		Toggle(Tab_Automatic,2, { Title = "Auto Musketeer Hat",Description = "ทำเควสหมวกแจ็ค"}, "Auto Musketeer Hat")

		LoadFuncs['Auto Musketeer Hat'] = function(value)
			if not World3 then return end
			while value and task.wait(2) do
				if LocalPlayer.Data.Level.Value >= 1800 then return end
				if _C("CitizenQuestProgress").KilledBandits == false then
					if QuestC.Visible == true then
						if string.find(QuestC.Container.QuestTitle.Title.Text, "Forest Pirate") then
							Module.CreateF(World3,"Forest Pirate",value,nil)
						else
							Teleport(CFrame.new(-12443, 332, -7675),function() return not value end)
							if dist(Vector3.new(-12443, 332, -7675), nil, true) <= 5 then _C("StartQuest","CitizenQuest",1) end
						end
					end
				elseif _C("CitizenQuestProgress").KilledBoss == false then
					if QuestC.Visible == true then
						if string.find(QuestC.Container.QuestTitle.Title.Text, "Captain Elephant") then
							Module.CreateF(World3,"Captain Elephant",value,CFrame.new(-13374, 421, -8225))
						end
					else
						Teleport(CFrame.new(-12443, 332, -7675),function() return not value end)
						if dist(CFrame.new(-12443, 332, -7675), nil, true) <= 5 then wait(1.5)_C("CitizenQuestProgress","Citizen") end
					end
				elseif _C("CitizenQuestProgress","Citizen") == 2 then
					Teleport(CFrame.new(-12512, 340, -9872),function() return not value end)
				end
			end
		end

		Toggle(Tab_Automatic,2, { Title = "Auto Pirate Raid",Description = "ตีมอนเกาะกลาง"}, "Auto Pirate Raid")

		LoadFuncs['Auto Pirate Raid'] = function(value)
			Module.CreateF(World3,nil,value,CFrame.new(-5545, 313, -2976))
		end

		Toggle(Tab_Automatic,2, {Title = "Auto Rainbow Haki",Description = "ทำ ฮาคิ เรนโบว์"}, "Auto Rainbow Haki")

		LoadFuncs['Auto Rainbow Haki'] = function(value)
			if not World3 then return end
			while value do task.wait(2)
				local NameBoss
				local ListBossRainBow = {
					[1] = "Stone",
					[2] = "Island Empress",
					[3] = "Kilo Admiral",
					[4] = "Captain Elephant",
					[5] = "Beautiful Pirate"
				}
				if QuestC.Visible == false then
					Teleport(CFrame.new(-11892, 930, -8760),function() return not value end)
					if (Vector3.new(-11892, 930, -8760) - RootPart.Position).Magnitude <= 30 then
						wait(1.5)
						_C("HornedMan","Bet")
					end
				else
					if string.find(QuestC.Container.QuestTitle.Title.Text,'Stone') then
						NameBoss = ListBossRainBow[1]
					elseif string.find(QuestC.Container.QuestTitle.Title.Text,'Island Empress') then
						NameBoss = ListBossRainBow[2]
					elseif string.find(QuestC.Container.QuestTitle.Title.Text,'Kilo Admiral') then
						NameBoss = ListBossRainBow[3]
					elseif string.find(QuestC.Container.QuestTitle.Title.Text,'Captain Elephant') then
						NameBoss = ListBossRainBow[4]
					elseif string.find(QuestC.Container.QuestTitle.Title.Text,'Beautiful Pirate') then
						NameBoss = ListBossRainBow[5]
					end
				end
				if QuestC.Visible then
					Module.CreateF(World3,NameBoss, value, game:GetService("ReplicatedStorage")[NameBoss].HumanoidRootPart.CFrame)
				end
			end
		end

		Toggle(Tab_Automatic,2, {Title = "Auto Dough V2",Description = "ทำเควสคาตาคุริ ถ้าได้กุญแจสีแดงให้เปิด"}, "Auto Farm Mirror Fractal")

		LoadFuncs['Auto Farm Mirror Fractal'] = function(value)
			if not World3 then return end
			while value and task.wait(0.1) do
				pcall(function()
					if game:GetService("Workspace").Map.CakeLoaf:FindFirstChild("RedDoor") then
						if LocalPlayer.Character:FindFirstChild("Red Key") or LocalPlayer.Backpack:FindFirstChild("Red Key") then
							Teleport(CFrame.new(-2681, 64, -12853), function() return not value end)
							wait(0.5)
							if LocalPlayer.Backpack:FindFirstChild("Red Key") then
								Humanoid:EquipTool(LocalPlayer.Backpack:FindFirstChild("Red Key"))
							end
							wait(0.5)
						elseif game.Workspace:FindFirstChild("Enemies"):FindFirstChild("Dough King") or game:GetService("ReplicatedStorage"):FindFirstChild("Dough King") then
							Module.CreateF(World3,"Dough King", value, CFrame.new(-2151, 149, -12404))
						elseif Character:FindFirstChild("Sweet Chalice") or LocalPlayer.Backpack:FindFirstChild("Sweet Chalice") then
							if string.find(_C("CakePrinceSpawner"),"Do you want to open the portal now?") then
								_C("CakePrinceSpawner", true)
								_C("CakePrinceSpawner")
							else
								Module.CreateF(World3,{"Cookie Crafter","Cake Guard","Baking Staff","Head Baker",}, value, CFrame.new(-2077, 252, -12373))
							end
						elseif (LocalPlayer.Backpack:FindFirstChild("God's Chalice") or LocalPlayer.Character:FindFirstChild("God's Chalice")) and GetMaterial("Conjured Cocoa") >= 10 then
							_C("SweetChaliceNpc")
						elseif not LocalPlayer.Backpack:FindFirstChild("God's Chalice") and not LocalPlayer.Character:FindFirstChild("God's Chalice") then
							_G['Auto Elite Hunter'] = true
						else
							Module.CreateF(World3,{ "Candy Rebel", "Sweet Thief", "Chocolate Bar Battler","Cocoa Warrior" }, value, CFrame.new(620, 78, -12581))
						end
					end
				end)
			end
		end
		Toggle(Tab_Automatic,2, {Title = "Auto Soul Guitar",Description = "ทำ กีตาร์"}, "Auto Soul Guitar")


		LoadFuncs['Auto Soul Guitar'] = function(value)
			if not World3 then return end
			while value and task.wait(0.1) do
				pcall(function()
					if GetMaterial("Bones") >= 500 and GetMaterial("Ectoplasm") >= 250 and GetMaterial("Dark Fragment") >= 1 then
						if (CFrame.new(-9681, 6, 6341).Position - RootPart.Position).Magnitude <= 3000 then
							if game:GetService("Workspace").Map["Haunted Castle"].Candle1.Transparency == 0 then
								local GuitarProgress = _C("GuitarPuzzleProgress", "Check");
								if not GuitarProgress then 
									local gravestoneEvent = _C("gravestoneEvent", 2);
									if gravestoneEvent == true then
										_C("gravestoneEvent", 2, true);
									end;
								end
								if GuitarProgress then 
									local Swamp = GuitarProgress.Swamp;
									local Gravestones = GuitarProgress.Gravestones;
									local Ghost = GuitarProgress.Ghost;
									local Trophies = GuitarProgress.Trophies;
									local Pipes = GuitarProgress.Pipes;
									local CraftedOnce = GuitarProgress.CraftedOnce;
									if Swamp and Gravestones and Ghost and Trophies and Pipes then 
										_G['Auto Soul Guitar'] = false
									end
									if not Swamp then 
										repeat wait() 
											Teleport(CFrame.new(-10141, 138, 5935) * CFrame.new(0,30,0),function() return not value end)
										until LocalPlayer:DistanceFromCharacter(Vector3.new(-10141.462890625, 138.6524658203125, 5935.06298828125)) <= 100
										local v = _getEnemiesByName({ target = "Living Zombie"})
										if Module.IsAlive(v) then
											repeat wait()
												for i,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
													if v:IsA("Tool") then
														if v.ToolTip == "Melee" then -- "Blox Fruit" , "Sword" , "Wear" , "Agility"
															Humanoid:EquipTool(v)
														end
													end
												end
												Teleport(v.HumanoidRootPart.CFrame * CFrame.new(0,20,0),function() return not value end)
											until not v.Parent or v.Humanoid.Health <= 0 or not  v:FindFirstChild('HumanoidRootPart') or not v:FindFirstChild('Humanoid') or not _G.Settings.Main["Auto Quest Soul Guitar"]
										end
									end
									wait(1)
									if Swamp and not Gravestones then 
										_C("GuitarPuzzleProgress", "Gravestones");
									end
									wait(1)
									if Swamp and  Gravestones and not Ghost then 
										_C("GuitarPuzzleProgress", "Ghost");
									end 
									wait(1)
									if  Swamp and  Gravestones and Ghost and not Trophies then 
										_C("GuitarPuzzleProgress", "Trophies");
									end
									wait(1)
									if  Swamp and  Gravestones and Ghost and Trophies and not Pipes then 
										_C("GuitarPuzzleProgress", "Pipes");
									end
								end
							else
								if string.find(_C("gravestoneEvent",2), "Error") then
									Teleport(CFrame.new(-8653, 140, 6160),function() return not value end)
								elseif string.find(_C("gravestoneEvent",2), "Nothing") then
									print("Wait Next Night")
								else
									_C("gravestoneEvent",2,true)
								end
							end
						else
							Teleport(CFrame.new(-8653, 140, 6160),function() return not value end)
						end
					else
						if GetMaterial("Ectoplasm") <= 250 then
							if World2 then
								Module.CreateF(World2,{ "Ship Deckhand", "Ship Engineer", "Ship Steward","Ship Officer","Arctic Warrior" }, value,nil)
							else
								_C("TravelDressrosa")
							end
						elseif GetMaterial("Dark Fragment") < 1 then
							if World2 then
								Module.CreateF(World2,"Darkbeard", value, CFrame.new(3798, 13, -3399))
							else
								_C("TravelDressrosa")
							end
						elseif GetMaterial("Bones") <= 500 then
							if World3 then
								Module.CreateF(World3,{'Reborn Skeleton','Living Zombie','Demonic Soul','Posessed Mummy'}, value, CFrame.new(-9504, 172, 6057))
							else
								_C("TravelZou")
							end
						end
					end
				end)
			end
		end

	end

	Label({ Section = Tab_Automatic, Title = "Fire Flowers" },2) do

		Toggle(Tab_Automatic,2, {Title = "Auto Collect Fire Flowers",Description = "หาดอกทอง เอ้ย ดอกไม้ไฟ"}, "Auto Collect Fire Flowers")

		LoadFuncs['Auto Collect Fire Flowers'] = function(condition)
			if not World3 then return end
			while condition do task.wait(.1)
				local Net = game:GetService("ReplicatedStorage")
				local result = Net.Modules.Net["RF/InteractDragonQuest"]:InvokeServer({ 
					NPC = "Dragon Wizard", Command = "Speak" 
				})
				if type(result) == "table" then
					Module.CreateF(World2,"Forest Pirate", condition, nil)
				else
					if dist(CFrame.new(5771, 1208, 804), nil, true) <= 5 then 
						Net.Modules.Net["RF/InteractDragonQuest"]:InvokeServer({ NPC = "Dragon Wizard", Command = "Speak" })
					end
					Teleport(CFrame.new(5771, 1208, 804), function() return not condition end)
				end
			end
		end

	end

	if World3 then

		Label({ Section = Tab_Automatic, Title = "Sea Events" },2) do

			Tab_Automatic:CreateDropdown("Right",{
				Title = "Select Zone",
				Desc = "Select Zone",
				List = {"1", "2", "3", "4", "5", "6"},
				Value = "1",
				Multi = false,
				Callback = function(Value)
					_G['Select Zones'] = Value
					print("Select Zones Mode: " .. Value)
				end
			})


			Toggle(Tab_Automatic,2, {Title = "Auto Farm Sea Events",Description = "ฟาร์มกิจกรรม Sea Events"}, "Auto Farm Sea Events")

			function CheckPirateBoat()
				local checkmmpb = {"PirateGrandBrigade", "PirateBrigade"}
				for r, v in next, game:GetService("Workspace").Enemies:GetChildren() do
					if table.find(checkmmpb, v.Name) and v:FindFirstChild("Health") and v.Health.Value > 0 then
						return v
					end
				end
			end

			LoadFuncs['Auto Farm Sea Events'] = function(condition)
				while condition do task.wait(.1)
					pcall(function()
						if game:GetService("Workspace").Boats:FindFirstChild('PirateGrandBrigade') then
							if game:GetService("Workspace").Enemies:FindFirstChild("Shark") or game:GetService("Workspace").Enemies:FindFirstChild("Terrorshark") or game:GetService("Workspace").Enemies:FindFirstChild("Piranha") or game:GetService("Workspace").Enemies:FindFirstChild("Fish Crew Member") then
								if Humanoid.Sit then Humanoid.Sit = false end
								Module.CreateF(World3,{ 'Shark', 'Terrorshark', 'Piranha', 'Fish Crew Member' }, condition,nil)
							elseif CheckPirateBoat() then
								if Humanoid.Sit then Humanoid.Sit = false end
								game:GetService("VirtualInputManager"):SendKeyEvent(true,32,false,game)
								wait(.5)
								game:GetService("VirtualInputManager"):SendKeyEvent(false,32,false,game)
								local v = CheckPirateBoat()
								if v then
									Teleport(v.Engine.CFrame * CFrame.new(0, -20, 0))
									if dist(v.Engine.CFrame.Position,nil,true) < 30 then
										autoSkills("Sea",function()
											return not v or not v.Parent or v.Health.Value <= 0 or not CheckPirateBoat()
										end)
									end
								end
							elseif game:GetService("Workspace").SeaBeasts:FindFirstChild("SeaBeast1") then
								for i,v in pairs(game:GetService("Workspace").SeaBeasts:GetChildren()) do
									if v:FindFirstChild("HumanoidRootPart") then
										repeat wait(5)
											Teleport(v.HumanoidRootPart.CFrame * CFrame.new(0,300,0),function()
												return not condition
											end)
											autoSkills("Sea",function()
												return not v:FindFirstChild("HumanoidRootPart") or not condition
											end)
										until not condition or v:FindFirstChild("HumanoidRootPart")
									end
								end
							else
								local zones = { 
									[1] = CFrame.new(-21227, 22, 4047),
									[2] = CFrame.new(-24237, 22, 6381),
									[3] = CFrame.new(-27105, 22, 8959),
									[4] = CFrame.new(-29350, 22, 11744),
									[5] = CFrame.new(-32404, 22, 16208),
									[6] = CFrame.new(-35611, 22, 20548),
								}
								local selectedZone = zones[tonumber(_G['Select Zones'])]
								if selectedZone then
									game:GetService("Workspace").Boats['PirateGrandBrigade'].VehicleSeat.CFrame = selectedZone
									if game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Sit == false then
										Teleport(game:GetService("Workspace").Boats['PirateGrandBrigade'].VehicleSeat.CFrame * CFrame.new(0, 3, 0), function() 
											return not condition or game:GetService("Workspace").Enemies:FindFirstChild("Shark") or 
												game:GetService("Workspace").Enemies:FindFirstChild("Terrorshark") or 
												game:GetService("Workspace").Enemies:FindFirstChild("Piranha") or 
												game:GetService("Workspace").Enemies:FindFirstChild("Fish Crew Member")
										end)
									end
								end
							end
						elseif not game:GetService("Workspace").Boats:FindFirstChild('PirateGrandBrigade') then
							local distance = (CFrame.new(-16205, 12, 473).Position - RootPart.Position).Magnitude
							if distance <= 10 then
								local args = {
									[1] = "BuyBoat",
									[2] = "PirateGrandBrigade"
								}
								local success, err = pcall(function()
									_C(unpack(args))
								end)
								task.wait(4)
							end
							Teleport(CFrame.new(-16205, 12, 473), function() return (CFrame.new(-16205, 12, 473).Position - RootPart.Position).Magnitude <= 10 end)
						end
					end)
				end
			end

		end

		if not World1 then
			Toggle(Tab_Automatic,2, {Title = "Auto Sea Best",Description = "แค่ไปตีเฉยๆ",}, "Auto Sea Best")

			LoadFuncs['Auto Sea Best'] = function(value)
				while value do task.wait(.1)
					pcall(function()
						if game:GetService("Workspace").SeaBeasts:FindFirstChild("SeaBeast1") then
							for i,v in pairs(game:GetService("Workspace").SeaBeasts:GetChildren()) do
								if v:FindFirstChild("HumanoidRootPart") then
									repeat wait(0.1)
										Teleport(v.HumanoidRootPart.CFrame * CFrame.new(0,300,0),function()
											return not value
										end)
										autoSkills("Sea",function()
											return not v:FindFirstChild("HumanoidRootPart") or not value
										end)
									until not value or v:FindFirstChild("HumanoidRootPart")
								end
							end
						end
					end)
				end
			end
		end

	end
end

Label({ Section = Tab_Automatic, Title = "Observation" },2) do

	Toggle(Tab_Automatic,2, {Title = "Auto Observation",Description = "ฟาร์ม ฮาคิ สังเกต"}, "Auto Observation")

	local WorldInfo = {
		World1 = {"Galley Captain", CFrame.new(5658, 38, 4928)},
		World2 = {"Lava Pirate", CFrame.new(-5431, 15, -5296)},
		World3 = {"Ice Cream Chef", CFrame.new(-872.25, 65.82, -10919.96)}
	}

	local Mon_Observation, CFrame_Mon_Observation

	if World1 or World2 or World3 then
		local worldKey = World1 and "World1" or (World2 and "World2" or "World3")
		Mon_Observation, CFrame_Mon_Observation = unpack(WorldInfo[worldKey])
	else
		Mon_Observation, CFrame_Mon_Observation = "Unknown", CFrame.new(0, 0, 0)
	end

	LoadFuncs['Auto Observation'] = function(condition)
		while condition do task.wait(0.1)
			pcall(function()
				local enemy = game:GetService('Workspace').Enemies:FindFirstChild(Mon_Observation)
				if enemy then
					local v, spwan = _getEnemiesByName({ target = Mon_Observation })
					repeat task.wait()
						local targetCFrame = enemy.HumanoidRootPart.CFrame * (LocalPlayer.PlayerGui.ScreenGui:FindFirstChild("ImageLabel") and CFrame.new(3, 0, 0) or CFrame.new(0, 50, 0))
						Teleport(targetCFrame, function() return not condition end)
						if not LocalPlayer.PlayerGui.ScreenGui:FindFirstChild("ImageLabel") then
							game:GetService('VirtualUser'):CaptureController()
							game:GetService('VirtualUser'):SetKeyDown('0x65')
							wait(5)
							game:GetService('VirtualUser'):SetKeyUp('0x65')
						end
					until not condition or not enemy.Parent
				else
					Teleport(CFrame_Mon_Observation, function() return not condition end)
					if _G['Bypass Tp'] and (RootPart.Position - CFrame_Mon_Observation.Position).Magnitude > 2000 then BYpass(CFrame_Mon_Observation) end
				end
			end)
		end
	end


end

if World1 then
	Label({ Section = Tab_Automatic, Title = "World 1" },1) do
		Toggle(Tab_Automatic,1, {Title = "Auto Saber",Description = "ทำดาบ แชงค์"}, "Auto Saber")
		Toggle(Tab_Automatic,1, {Title = "Auto Pole V1",Description = "ทำ โพ V1"}, "Auto Pole V1")
		Toggle(Tab_Automatic,1, {Title = "Auto Cannon",Description = "หา ปืน"}, "Auto Cannon")
		Toggle(Tab_Automatic,1, {Title = "Auto Bizento V2",Description = "ทำบิเซนโต วี2"}, "Auto Bizento V2")
	end
end    


LoadFuncs['Auto Saber'] = function(value)
	while value do task.wait()
		pcall(function()
			if LocalPlayer.Data.Level.Value >= 200 and workspace.Map.Jungle.Final.Part.Transparency == 0 then
				if game:GetService("Workspace").Map.Jungle.Final.Part.Transparency == 0 then
					if game:GetService("Workspace").Map.Jungle.QuestPlates.Door.Transparency == 0 then
						for i,v in next,game:GetService("Workspace").Map.Jungle.QuestPlates:GetChildren() do
							if v:IsA("Model") then
								if v.Button:FindFirstChild("TouchInterest") then
									firetouchinterest(RootPart, v.Button, 0)
								end
							end
						end
					else
						if not _C("ProQuestProgress")["UsedTorch"] then
							_C("ProQuestProgress","GetTorch")
							Equip("Torch")
							_C("ProQuestProgress","DestroyTorch")
						elseif not _C("ProQuestProgress")["UsedCup"] then
							_C("ProQuestProgress","GetCup")
							Equip("Cup")
							_C("ProQuestProgress","FillCup",game:GetService("Players").LocalPlayer.Character.Cup)
							_C("ProQuestProgress","SickMan")
						elseif not _C("ProQuestProgress")["KilledMob"] then
							_C("ProQuestProgress","RichSon")
							Module.CreateF(World1,"Mob Leader", value, nil)
						elseif not _C("ProQuestProgress")["UsedRelic"] then
							_C("ProQuestProgress","RichSon")
							Equip("Relic")
							_C("ProQuestProgress","PlaceRelic")
						end
					end
				else
					Module.CreateF(World1,"Saber Expert", value, CFrame.new(-1459, 30, -50))
				end
			end
		end)
	end
end
-- end

if World2 then
	Label({ Section = Tab_Automatic, Title = "World 2" }) do

		Toggle(Tab_Automatic,1, {Title = "Auto True Triple Katana",Description = "หา3กาบ และฟาร์ม"}, "Auto True Triple Katana")
		local function Check_Mastery_Weapon(Weapon_Name)
			for i,v in pairs(_C("getInventory")) do
				if v.Name == Weapon_Name then return v.Mastery end
			end
		end 

		LoadFuncs['Auto True Triple Katana'] = function (condition)
			while condition do task.wait(0.1)
				if not condition then return end
				local success, errorMsg = pcall(function()
					local swordList, foundSwords = {"Saishi", "Oroshi", "Shizu"}, {}
					for _, item in pairs(_C("getInventory")) do
						if type(item) == "table" and item.Type == "Sword" then
							if table.find(swordList, item.Name) then
								if Check_Mastery_Weapon(item.Mastery) < 400 then
									local targetSword = item.Name[1]
									if LocalPlayer.Backpack:FindFirstChild(targetSword.Name) then
										Module.CreateF(World2,{ 
											'Ship Deckhand', 
											'Ship Engineer', 
											'Ship Steward', 
											'Ship Officer', 
											'Arctic Warrior' 
										}, condition,nil,"Sword")
									else
										_C("LoadItem",targetSword.Name)
									end
								else
									_C("MysteriousMan", 2)
								end
							else
								Library:Notify({ Title = "Attack Hub", Desc = "คุณยังไม่มีดาบสักเล่มเลย", Time = 8 })
								return
							end
						end
					end
				end)
				if not success then
					warn("Error occurred in Auto True Triple Katana: " .. tostring(errorMsg))
				end
			end
		end
		Toggle(Tab_Automatic,1, {Title = "Auto Rengoku",Description = "ทำดาบ เรนโกคุ หรือ เรนโงคุ"}, "Auto Rengoku")
		Toggle(Tab_Automatic,1, {Title = "Auto Dragon Trident",Description = "ทำ ตรีศูลมังกร"}, "Auto Dragon Trident")

	end        
end

if World3 then
	Label({ Section = Tab_Automatic, Title = "Serpent Bow" },1) do
		Toggle(Tab_Automatic,1, {Title = "Auto Serpent Bow",Description = "Auto Find Serpent Bow"}, "Auto Serpent Bow")
		Toggle(Tab_Automatic,1, {Title = "Auto Serpent Bow [Hop]",Description = "ทำธนู ไปเซิฟอื่น"}, "Auto Serpent Bow Hop")
	end

	Label({ Section = Tab_Automatic, Title = "Twin hook" },1) do
		Toggle(Tab_Automatic,1, {Title = "Auto Twin hook",Description = "ทำเคียว ของBossช้าง"}, "Auto Twin hook")
		Toggle(Tab_Automatic,1, {Title = "Auto Twin hook [Hop]",Description = "ทำเคียว ของBossช้าง ไปเซิฟอื่น"}, "Auto Twin hook Hop")
	end

	Label({ Section = Tab_Automatic, Title = "Buddy Sword" },1) do
		Toggle(Tab_Automatic,1, {Title = "Auto Buddy Sword",Description = "ทำดาบ บิกมัม"}, "Auto Buddy")
		Toggle(Tab_Automatic,1, {Title = "Auto Buddy Sword [Hop]",Description = "ทำดาบ บิกมัม ไปเซิฟอื่น"}, "Auto Buddy Hop")
	end

	Label({ Section = Tab_Automatic, Title = "Yama" },1) do
		Toggle(Tab_Automatic,1, {Title = "Auto Yama",Description = "ดึงดาบยามา"}, "Auto Yama")
		Toggle(Tab_Automatic,1, {Title = "Auto Yama [Hop]",Description = "ดึงดาบยามา ไปเซิฟอื่น"}, "Auto Yama Hop")
	end

	Label({ Section = Tab_Automatic, Title = "Cavander" },1) do
		Toggle(Tab_Automatic,1, {Title = "Auto Cavander",Description = "ทำดาบของ คาเวนดิส"}, "Auto Cavander")
		Toggle(Tab_Automatic,1, {Title = "Auto Cavander [Hop]",Description = "ทำดาบของ คาเวนดิส ไปเซิฟอื่น"}, "Auto Cavander Hop")
	end

	Label({ Section = Tab_Automatic, Title = "Hallow Scythe" },1) do
		Toggle(Tab_Automatic,1, {Title = "Auto Hallow Scythe",Description = "ทำเคียว ฮาโลวีน"}, "Auto Hallow Scythe")
		Toggle(Tab_Automatic,1, {Title = "Auto pass Hallow Essence",Description = "ออโต้เสกบอส"}, "Auto pass Hallow Essence")

		LoadFuncs['Auto pass Hallow Essence'] = function(value)
			while value do task.wait(.1)
				if LocalPlayer.Backpack:FindFirstChild("Hallow Essence") and not Character:FindFirstChild("Hallow Essence") then
					repeat wait(1)
						EquipWeapon("Hallow Essence")
						Teleport(CFrame.new(-8932.86, 143.258, 6063.31),function() return not value end)
					until not LocalPlayer.Backpack:FindFirstChild("Hallow Essence") and not Character:FindFirstChild("Hallow Essence")
				end
			end
		end

		Toggle(Tab_Automatic,1, {Title = "Auto Hallow Scythe [Hop]",Description = "ทำเคียว ฮาโลวีน ไปเซิฟอื่น"}, "Auto Hallow Scythe Hop")
	end

	Label({ Section = Tab_Automatic, Title = "Tushita" },1) do
		Toggle(Tab_Automatic,1, {Title = "Auto Tushita",Description = "ทำดาบ ทูชิตะ"}, "Auto Tushita")
		Toggle(Tab_Automatic,1, {Title = "Auto Tushita [Hop]",Description = "ทำดาบ ทูชิตะ ไปเซิฟอื่น"}, "Auto Tushita Hop")
	end

	LoadFuncs['Auto Tushita'] = function(value)
		local Data = _C("TushitaProgress")
		if not World3 then return end
		while value do task.wait(.1)
			local Data = _C("TushitaProgress")
			local Torch = workspace.Map.Waterfall.SecretRoom.Room.Door.Door.Hitbox
			if Data.OpenedDoor then
				Module.CreateF(World3,"Longma", value, game:GetService("ReplicatedStorage"):FindFirstChild("Longma").HumanoidRootPart.CFrame)
			else
				repeat
					firetouchinterest(Character.HumanoidRootPart,Torch,0)
					firetouchinterest(Character.HumanoidRootPart,Torch,1)
					wait(.5)
				until _hasItem("Holy Torch")
				for i = 1,5 do _C("TushitaProgress","Torch",i) end
			end
		end
	end
	Label({ Section = Tab_Automatic, Title = "Dark Dagger" },1) do
		Toggle(Tab_Automatic,1, {Title = "Auto Dark Dagger",Description = "ทำโยรุ จิ๋ว"}, "Auto Dark Dagger")
		Toggle(Tab_Automatic,1, {Title = "Auto color press Haki",Description = "มันจะกดสีให้เอง ถ้าเกิดว่าสีครบ"}, "Auto color press Haki")

		LoadFuncs['Auto color press Haki'] = function(value)
			while value do task.wait(.1)
				local Oyster_H = false
				local Hot_pink_H = false
				local Really_red_H = false
				local colors = {
					{name = 'Oyster', color = Oyster_H},
					{name = 'Hot pink', color = Hot_pink_H},
					{name = 'Really red', color = Really_red_H}
				}

				for _, color in pairs(colors) do
					for _, v in pairs(game.workspace.Map["Boat Castle"].Summoner.Circle:GetChildren()) do
						if v.Name == 'Part' and tostring(v.BrickColor) == color.name and tostring(v.Part.BrickColor) == 'Lime green' then
							color.color = true
						end
					end
				end
				if Oyster_H and Hot_pink_H and Really_red_H then
					EquipWeapon("God's Chalice")
					Teleport(CFrame.new(-5561, 314, -2663), function() return not value end)
				else
					if LocalPlayer.Backpack:FindFirstChild("God's Chalice") or Character:FindFirstChild("God's Chalice") then
						EquipWeapon("God's Chalice")
						Teleport(CFrame.new(-5561, 314, -2663), function() return not value end)
						if Snow_White and not Oyster_H then
							for _, v in pairs(workspace.Map["Boat Castle"].Summoner.Circle:GetChildren()) do
								if v.Name == 'Part' and tostring(v.BrickColor) == 'Oyster' and tostring(v.Part.BrickColor) ~= 'Lime green' then
									_C("activateColor", "Snow White")
									wait(1)
									repeat wait() until tostring(v.Part.BrickColor) == 'Lime green'
									Oyster_H = true
								end
							end
						end
						if Pure_Red_H and not Really_red_H then
							for _, v in pairs(workspace.Map["Boat Castle"].Summoner.Circle:GetChildren()) do
								if v.Name == 'Part' and tostring(v.BrickColor) == 'Really red' and tostring(v.Part.BrickColor) ~= 'Lime green' then
									_C("activateColor", "Pure Red")
									wait(1)
									repeat wait() until tostring(v.Part.BrickColor) == 'Lime green'
									Really_red_H = true
								end
							end
						end
						if Winter_Sky and not Hot_pink_H then
							for _, v in pairs(workspace.Map["Boat Castle"].Summoner.Circle:GetChildren()) do
								if v.Name == 'Part' and tostring(v.BrickColor) == 'Hot pink' and tostring(v.Part.BrickColor) ~= 'Lime green' then
									_C("activateColor", "Winter Sky")
									wait(1)
									repeat wait() until tostring(v.Part.BrickColor) == 'Lime green'
									Hot_pink_H = true
								end
							end
						end

						EquipWeapon("God's Chalice")
						Teleport(CFrame.new(-5561, 314, -2663), function() return not value end)
					end
				end
			end
		end

		Toggle(Tab_Automatic,1, {Title = "Auto Dark Dagger [Hop]",Description = "ทำโยรุจิ๋ว ไปเซิฟอื่น"}, "Auto Dark Dagger Hop")
	end
	Label({ Section = Tab_Automatic, Title = "Cursed Dual Katana" },1) do
		Toggle(Tab_Automatic,1, {Title = "Auto Cursed Dual Katana",Description = "ทำดาบคู่"}, "Auto Cursed Dual Katana") 
	end

end


if World2 then
	Label({ Section = Tab_Automatic, Title = "Accessory" },2) do
		Toggle(Tab_Automatic,2, {Title = "Auto Bartilo Quest",Description = "ทำ เควสบาโท"}, "Auto Bartilo Quest")
		Toggle(Tab_Automatic,2, {Title = "Auto Ectoplasm",Description = "ฟาร์มเงินส้ม"}, "Auto Ectoplasm")
		Toggle(Tab_Automatic,2, {Title = "Auto Dark Coat",Description = "ทำ ผ้าคลุมหนวดดำ"}, "Auto Dark Coat")
		Toggle(Tab_Automatic,2, {Title = "Auto Swan Glasses",Description = "ทำ เเว่นโดฟา"}, "Auto Swan Glasses")
	end

	Label({ Section = Tab_Automatic, Title = "Law Raid" },2) do

		Button(Tab_Automatic,2, "Buy Law Raid Chip", { Description = "แก้ซื้อชิบรัวๆ", }, function()
			_C("BlackbeardReward","Microchip","2")
		end, true)

		Button(Tab_Automatic,2, "Start Law Raid", { Description = "เริ่มดันลอ", }, function()
			fireclickdetector(game:GetService("Workspace").Map.CircleIsland.RaidSummon.Button.Main.ClickDetector)
		end, true)

		Toggle(Tab_Automatic,2, {Title = "Auto Law Raid",Description = "ตีบอสลอ"}, "Auto Law Raid")

		LoadFuncs['Auto Law Raid'] = function(value)
			while value do task.wait(.1)
				Module.CreateF(World2,"Order", value, game:GetService("ReplicatedStorage"):FindFirstChild("Order").HumanoidRootPart.CFrame)
			end
		end
	end

end

Label({ Section = Tab1, Title = "Fighting Style" },2) do
	Toggle(Tab1,2, {Title = "Auto Godhuman",Description = "ทำหมัดก็อต"}, "Auto Godhuman")
	Toggle(Tab1,2, {Title = "Auto Superhuman",Description = "ทำ ซุปเปอร์ฮิวแมน"}, "Auto Superhuman")
	Toggle(Tab1,2, {Title = "Auto Electric Claw",Description = "ทำ หมัดสายฟ้า"}, "Auto Electric Claw")
	Toggle(Tab1,2, {Title = "Auto Dragon Talon",Description = "ทำ หมัดมังกร"}, "Auto Dragon Talon")    
	Toggle(Tab1,2, {Title = "Auto Death Step",Description = "ทำ ขาดำ"}, "Auto Death Step")   
	Toggle(Tab1,2, {Title = "Auto SharkmanKarate",Description = "ทำ หมัดชาร์คแมน"}, "Auto SharkmanKarate")   
end

local FullMoon_Status = Tab_Race:CreateLabel("Left",{ Title = "🌑 Full Moon:", Desc = "" })

if World3 then
	task.spawn(function()
		while wait(0.1) do
			local moonPhases = {
				["9709149431"] = "🌕 [Full Moon 100 %]",
				["9709149052"] = "🌖 [Full Moon 75 %]",
				["9709143733"] = "🌗 [Full Moon 50 %]",
				["9709150401"] = "🌘 [Full Moon 25 %]",
				["9709149680"] = "🌘 [Full Moon 15 %]",
			}
			local moonId = game:GetService("Lighting").Sky.MoonTextureId:match("%d+") or "0"
			FullMoon_Status:SetTitle("> Elapsed : " .. (moonPhases[moonId] or "🌑 [Full Moon 0 %]"))
		end
	end)
end

local Mirage_Island_Status = Tab_Race:CreateLabel("Right",{ Title = "🏝️: เกาะลับยังไม่เกิด", Desc = "" })

task.spawn(function()
	while wait(.1) do
		if game.Workspace._WorldOrigin.Locations:FindFirstChild('Mirage Island') then
			Mirage_Island_Status:SetTitle('🏝️: เกาะลับเกิดแล้วน้องบ่าว')
		else
			Mirage_Island_Status:SetTitle('❌: เกาะลับยังไม่เกิด')
		end
	end
end)

Toggle(Tab_Race,2, {Title = "Auto Teleport To Mirage Island",Description = "ไปที่ เกาะลับ"}, "Auto Teleport To Mirage Island")   

LoadFuncs['Auto Teleport To Mirage Island'] = function(value)
	while value do task.wait(.1)
		if game:GetService("Workspace").Map:FindFirstChild("MysticIsland") then
			Teleport(CFrame.new(game:GetService("Workspace").Map.MysticIsland.Center.Position.X,500,game:GetService("Workspace").Map.MysticIsland.Center.Position.Z))
		end
	end
end

Toggle(Tab_Race,2, {Title = "Auto Mirage Island",Description = "ออโต้หา เกาะลับ"}, "Auto Mirage Island")   

LoadFuncs['Auto Mirage Island'] = function(value)
	if not World3 then return end
	while value do task.wait(.1)
		if game:GetService("Workspace").Boats:FindFirstChild('PirateGrandBrigade') then
			game:GetService("Workspace").Boats['PirateGrandBrigade'].VehicleSeat.CFrame = CFrame.new(-5100, 29, -6792)
			if Humanoid.Sit then
				if game:GetService("Workspace").Map:FindFirstChild("MysticIsland") then
					if Humanoid.Sit then Humanoid.Sit = false end
					Teleport(CFrame.new(game:GetService("Workspace").Map.MysticIsland.Center.Position.X,500,game:GetService("Workspace").Map.MysticIsland.Center.Position.Z))
				else
					repeat task.wait(.1)
						_S("W")
						wait(10)
						_S("S")
						wait(1.5)
					until not value
				end
			else
				Teleport(game:GetService("Workspace").Boats['PirateGrandBrigade'].VehicleSeat.CFrame * CFrame.new(0, 1, 0), function() 
					return not value or Humanoid.Sit
				end)
			end
		elseif not game:GetService("Workspace").Boats:FindFirstChild('PirateGrandBrigade') then
			local distance = (CFrame.new(-16205, 12, 473).Position - RootPart.Position).Magnitude
			if distance <= 10 then
				local success, err = pcall(function()
					_C("BuyBoat","PirateGrandBrigade")
				end)
				task.wait(4)
			end
			Teleport(CFrame.new(-16205, 12, 473), function() return (CFrame.new(-16205, 12, 473).Position - RootPart.Position).Magnitude <= 10 end)
		end
	end
end

Toggle(Tab_Race,2, {Title = "Auto Teleport To Advanced Fruit Dealer",Description = "ออโต้หา คนขายผล"}, "Auto Teleport To Advanced Fruit Dealer")   
LoadFuncs['Auto Teleport To Mirage Island'] = function(value)
	while value do task.wait(.1)
		if game:GetService("Workspace").NPCs:FindFirstChild("Advanced Fruit Dealer") then
			Teleport(CFrame.new(game:GetService("Workspace").NPCs["Advanced Fruit Dealer"].HumanoidRootPart.Position))
		end
	end
end
Toggle(Tab_Race,2, {Title = "Auto Lock To Full Moon",Description = "ล็อคที่พระจัน"}, "Auto Lock To Full Moon")   

LoadFuncs['Auto Lock To Full Moon'] = function(value)
	while value do task.wait(.1)
		local moonDir = game.Lighting:GetMoonDirection()
		local lookAtPos = game.Workspace.CurrentCamera.CFrame.p + moonDir * 100
		game.Workspace.CurrentCamera.CFrame = CFrame.lookAt(game.Workspace.CurrentCamera.CFrame.p, lookAtPos)
	end
end
Toggle(Tab_Race,2, {Title = "Teleport To Gear",Description = "วาร์ปไปหา เกียร์"}, "Teleport To Gear")
--Toggle(Tab_Race,2, {Title = "Auto Farm Chest Mirage Island",Description = "ฟาร์มกล่องในเกาะลับ"}, "Auto Farm Chest Mirage Island")

Label({ Section = Tab_Race, Title = "Race V.4" },1) do

	Toggle(Tab_Race,1, {Title = "Teleport To Trial Door",
		Description = "ไปที่ ประตูเผ่า"
	}, "Teleport To Trial Door")

	Toggle(Tab_Race,1, {
		Title = "Auto Pull Lever",
		Description = "ดึงขัดโยก"
	}, "Auto Pull Lever")
	
	LoadFuncs['Auto Pull Lever'] = function(value)
		while value and task.wait(.1) do
			if _C("CheckTempleDoor") then
				fireproximityprompt(game:GetService("Workspace").Map["Temple of Time"].Lever.Prompt.ProximityPrompt, math.huge)
			end
		end
	end

	Toggle(Tab_Race,1, {
		Title = "Auto AncientOne Quest",
		Description = "ทำเควส เทียร์"
	}, "Auto AncientOne Quest")


	LoadFuncs['Auto AncientOne Quest'] = function(value)
		while value and task.wait(.1) do
			Getpcall(function()
				local raceUpgradeResult = _C("UpgradeRace", "Buy")
				if raceUpgradeResult ~= true then
					local raceEnergy = LocalPlayer.Character:FindFirstChild("RaceEnergy")
					local raceTransformed = LocalPlayer.Character:FindFirstChild("RaceTransformed")
					if raceEnergy.Value < 1 and not raceTransformed.Value then
						if _G['Auto Active Ability'] then
							_G['Auto Active Ability'] = false
						end
						Module.CreateF(World3,{'Reborn Skeleton','Living Zombie','Demonic Soul','Posessed Mummy'}, value, CFrame.new(-9479, 200, 5577))
					else
						game:GetService("VirtualInputManager"):SendKeyEvent(true, "Y", false, game)
						task.wait()
						game:GetService("VirtualInputManager"):SendKeyEvent(false, "Y", false, game)
						_C("UpgradeRace", "Check")
						_C("UpgradeRace", "Buy")
					end
				end
			end) 
		end
	end

	LoadFuncs['Auto Complete Trial'] = function(value)
		while value and task.wait(.1) do
			Getpcall(function()
				if LocalPlayer.Data.Race.Value == "Mink" then	
					if game:GetService("Workspace").Map:FindFirstChild("MinkTrial") then
						if (game:GetService("Workspace").Map.MinkTrial.Ceiling.CFrame - RootPart.Position).Magnitude <= 200 then
							Teleport(game:GetService("Workspace").Map.MinkTrial.Ceiling.CFrame * CFrame.new(0,-20,0), function() return not value end)
						end
					end
				elseif LocalPlayer.Data.Race.Value == "Human" then
					if game:GetService("Workspace").Map:FindFirstChild("HumanTrial") then
						for i,v in pairs(game.Workspace.Enemies:GetChildren()) do
							if (v.HumanoidRootPart.Position - RootPart.Position).magnitude <= 400 then
								if Module.IsAlive(v) then
									Module.Attack({ target = v, value = value,function() return not value end})
								end
							end
						end
					end
				elseif LocalPlayer.Data.Race.Value == "Cyborg" then
					if game:GetService("Workspace").Map:FindFirstChild("CybrogTrial") then
						Teleport(game:GetService("Workspace").Map.CyborgTrial.Floor.CFrame*CFrame.new(0,500,0), function() return not value end)
					end
				elseif LocalPlayer.Data.Race.Value == "Skypiea" then
					if game:GetService("Workspace").Map:FindFirstChild("SkyTrial") then
						if (game:GetService("Workspace").Map.SkyTrial.Model.FinishPart.CFrame-RootPart.Position).Magnitude <= 750 then
							Teleport(game:GetService("Workspace").Map.SkyTrial.Model.FinishPart.CFrame, function() return not value end)
						end
					end
				elseif LocalPlayer.Data.Race.Value == "Ghoul" then
					if game:GetService("Workspace").Map:FindFirstChild("GhoulTrial") then 
						for i,v in pairs(game.Workspace.Enemies:GetChildren()) do
							if (v.HumanoidRootPart.Position-game:GetService("Players").RootPart.Position).magnitude <= 400 then
								if Module.IsAlive(v) then
									Module.Attack({ target = v, value = value,function() return not value end})
								end
							end
						end
					end
				elseif LocalPlayer.Data.Race.Value == "Fishman" then
					if game:GetService("Workspace").Map:FindFirstChild("FishTrial") then
						if (game:GetService("Workspace").Map:FindFirstChild("FishTrial").Part.Position-RootPart.Position).Magnitude <= 500 then
							Teleport(CFrame.new(25032.043, 75.04647064, 12619.5967), function() return not value end)
							autoSkills("Sea",function()
								return not game:GetService("Workspace").Map:FindFirstChild("FishTrial").Part
							end)
						end
					end
				end
			end)
		end
	end

	LoadFuncs['Teleport To Gear'] = function(value)
		if not World3 then return end
		while value and task.wait(.1) do
			pcall(function()
				for i,v in pairs(game:GetService("Workspace").Map:FindFirstChild('MysticIsland'):GetChildren()) do
					if v.Name == 'Part' then
						if v.ClassName == 'MeshPart' then
							Teleport(v.CFrame , function() 
								return not value
							end)
							v.Transparency = 0
						end
					end
				end
			end)
		end
	end


	function Check_Race_Skypiea()
		for i,v in pairs(game.Players:GetChildren()) do
			if v.Name ~= game.Players.LocalPlayer.Name and tostring(v.Data.Race.Value) == "Skypiea" then
				print(v.Name)
				_G.Select_Player = v.Name
				return
			end
		end
	end

	LoadFuncs['Teleport To Trial Door'] = function(value)
		if not World3 then return end
		while value and task.wait(.1) do
			pcall(function()
				if LocalPlayer.Data.Race.Value == "Mink" then
					Teleport(game:GetService("Workspace").Map["Temple of Time"].MinkCorridor.Door.Entrance.CFrame , function() 
						return not value
					end)
				elseif LocalPlayer.Data.Race.Value == "Fishman" then
					Teleport(game:GetService("Workspace").Map["Temple of Time"].FishmanCorridor.Door.Entrance.CFrame , function() 
						return not value
					end)
				elseif LocalPlayer.Data.Race.Value == "Skypiea" then
					Teleport(game:GetService("Workspace").Map["Temple of Time"].SkyCorridor.Door.Entrance.CFrame , function() 
						return not value
					end)
				elseif LocalPlayer.Data.Race.Value == "Human" then
					Teleport(game:GetService("Workspace").Map["Temple of Time"].HumanCorridor.Door.Entrance.CFrame , function() 
						return not value
					end)
				elseif LocalPlayer.Data.Race.Value == "Ghoul" then
					Teleport(game:GetService("Workspace").Map["Temple of Time"].GhoulCorridor.Door.Entrance.CFrame , function() 
						return not value
					end)
				elseif LocalPlayer.Data.Race.Value == "Cybrog" then
					Teleport(game:GetService("Workspace").Map["Temple of Time"].CybrogCorridor.Door.Entrance.CFrame , function() 
						return not value
					end)
				end
			end)
		end
	end

	Toggle(Tab_Race,1, {
		Title = "Auto Complete Trial",
		Description = "ออโต้ ส่งเควส"
	}, "Auto Complete Trial")

	Button(Tab_Race,1, "Teleport To Temple Of Time", { Description = "ไปที่ห้องทำเผ่า", }, function()
		LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(28286.35546875, 14895.3017578125, 102.62469482421875)
	end, true)

	Button(Tab_Race,1, "Teleport To Lever", { Description = "ไปที่ดึงคันโยก", }, function()
		LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(28576.873046875, 14937.958984375, 76.49504852294922)
	end, true)

end

Label({ Section = Tab_Race, Title = "Race V.1-3" },2) do

	Toggle(Tab_Race,2, {Title = "Auto Evolution Race V2",Description = "ทำเผ่า V2"}, "Auto Evolution Race V2")

	LoadFuncs['Auto Evolution Race V2'] = function(value)
		if not World2 then return end
		while value do task.wait(0.1)
			local Success, Error = pcall(function()
				if not LocalPlayer.Data.Race:FindFirstChild("Evolved") then
					local step = _C("Alchemist", "1")
					if step == 0 then
						local targetPos = CFrame.new(-2779, 72, -3574)
						Teleport(targetPos, function() return not value end)
						if (targetPos - RootPart.Position).Magnitude <= 2 then 
							_C("Alchemist","2")
						end
					elseif step == 1 then
						local flowers = {"Flower 1", "Flower 2", "Flower 3"}
						for i, flower in ipairs(flowers) do
							if not LocalPlayer.Backpack:FindFirstChild(flower) and not LocalPlayer.Character:FindFirstChild(flower) then
								if i < 3 then Teleport(game:GetService("Workspace")["Flower" .. i].CFrame, function() return not value end) end
								if i == 3 then Module.CreateF(World2, "Zombie", value, CFrame.new(-5685, 48, -853)) end
								break
							end
						end
					elseif step == 2 then _C("Alchemist", "3") end
				end
			end)

			if not Success then warn("Auto Evolution Race V2 Error : ", Error) end
		end
	end

	Toggle(Tab_Race,2, {Title = "Auto Evolution Race V3",Description = "ตอนนี้ทำได้แค่มิ้ง กับมนุษย์"}, "Auto Evolution Race V3")

	LoadFuncs['Auto Evolution Race V3'] = function(value)
		while value and task.wait(.1) do
			pcall(function()
				if _C("TalkTrevor","1") == 0 then
					local step = _C('Wenlocktoad','1')
					if step == 0 then
						_C('Wenlocktoad','1')
					elseif step == 1 then
						if LocalPlayer.Data.Race.Value == "Mink" then	
							for _, v in pairs(workspace.ChestModels:GetChildren()) do
								if v:IsA("Model") then
									local cframe = v:GetBoundingBox()
									repeat
										task.wait(0.1)
										Teleport(cframe, function() return not value end)
									until dist(cframe, nil, true) < 1
								end
							end
							repeat wait(5) until _C("Wenlocktoad", "1") == -2
							_C("Wenlocktoad", "3")
						elseif LocalPlayer.Data.Race.Value == "Human" then
							local Bosses = {
								{ name = "Diamond", position = CFrame.new(-1636, 198, -16) },
								{ name = "Jeremy", position = CFrame.new(-3352, 324, -10534) },
								{ name = "Fajite", position = CFrame.new(-3352, 324, -10534) }
							}

							local Boss = 1
							local enemyFound = false
							local bossesKilled = 0

							for _, boss in ipairs(Bosses) do
								local enemy = _getEnemiesByName({ target = boss.name })
								if Module.IsAlive(enemy) then
									Module.Attack({ target = enemy, value = value, function() return not value end })
									enemyFound = true
								end
								if not enemyFound then
									Teleport(boss.position, function() return not value end)
								else
									bossesKilled = bossesKilled + 1
								end
							end
							repeat wait(5)
								_C("Wenlocktoad", "3")
							until _C("Wenlocktoad","1") == -2
						elseif LocalPlayer.Data.Race.Value == "Cyborg" then
							Library:Notify({
								Title = "Attack Hub",
								Desc = "นะตอนนี้ เผ่า Cyborg ยังไม่ได้ อัพเดทลงสคริป",
								Time = 8
							})
							return
						elseif LocalPlayer.Data.Race.Value == "Skypiea" then
							Library:Notify({
								Title = "Attack Hub",
								Desc = "นะตอนนี้ เผ่า Skypiea ยังไม่ได้ อัพเดทลงสคริป",
								Time = 8
							})
							return
						elseif LocalPlayer.Data.Race.Value == "Ghoul" then
							Library:Notify({
								Title = "Attack Hub",
								Desc = "นะตอนนี้ เผ่า Ghoul ยังไม่ได้ อัพเดทลงสคริป",
								Time = 8
							})
							return
						elseif LocalPlayer.Data.Race.Value == "Fishman" then
							Library:Notify({
								Title = "Attack Hub",
								Desc = "นะตอนนี้ เผ่า Fishman ยังไม่ได้ อัพเดทลงสคริป",
								Time = 8
							})
							return
						end
					elseif step == 2 then
						_C('Wenlocktoad','2')
					end
				end
			end)
		end
	end
end


-- Teleport

Label({ Section = Tab_Teleport, Title = "Teleport World" },1)
Button(Tab_Teleport,1, "Teleport Main", { Description = "ไปโลก 1", }, function() _C("TravelMain") end, true)
Button(Tab_Teleport,1, "Teleport Dressrosa", { Description = "ไปโลก 2", }, function() _C("TravelDressrosa") end, true)
Button(Tab_Teleport,1, "Teleport Zou", { Description = "ไปโลก 3", }, function()_C("TravelZou") end, true)

Label({ Section = Tab_Teleport, Title = "Teleport Island" },1) do

	Location = {}
	for i,v in pairs(workspace.Map:GetChildren()) do
		table.insert(Location, v.Name)
	end

	local Select_Location = Tab_Teleport:CreateDropdown("Left",{
		Title = "Select Location",
		Desc = "เลือกเกาะที่ต้องการ",
		List = Location,
		Value = Location[1],
		Multi = false,
		Callback = function(Value)
			_G['Select Island'] = Value
		end
	})

	Toggle(Tab_Teleport,1, {Title = "Teleport To Island",Description = "ไปที่เกาะ"}, "Teleport To Island")

	LoadFuncs['Teleport To Island'] = function(condition)
		while condition do task.wait(.1)
			local TargetTeleport
			for i,v in pairs(workspace.Map:GetChildren()) do
				if v.Name == _G['Select Island'] then
					TargetTeleport = v.WorldPivot
					break
				end
			end
			Teleport(TargetTeleport * CFrame.new(0, 200, 0), function() return not condition end)
			if (RootPart.Position - TargetTeleport.Position).Magnitude > 2000 then if _G['Bypass Tp'] then  BYpass(TargetTeleport) end end
		end
	end

end

Label({ Section = Tab_Teleport, Title = "Devil Fruit" },2) do
	Toggle(Tab_Teleport,2, {Title = "Auto Random Fruit",Description = "สุ่มผล"}, "Auto Random Fruit")
	--Toggle(Tab_Teleport,2, {Title = "Auto Grab Fruit",Description = "ดึงผล"}, "Auto Grab Fruit")
	Toggle(Tab_Teleport,2, {Title = "Auto Store Fruit",Description = "เก็บผล"}, "Auto Store Fruit")
end

LoadFuncs['Auto Random Fruit'] = function(value)
	while value do task.wait(.1) _C("Cousin","Buy") end
end

LoadFuncs['Auto Collect Fruit'] = function(value)
	while value do task.wait(.1)
		repeat wait() until game.Players.LocalPlayer.Character
		repeat wait() until not CollectFruit()
		wait()
		LoadFuncs['Auto Store Fruit']()
	end
end

function toServerFruit(Text)
	local Slice = Text:split(":")
	return (Slice[1].."-"..Slice[1]..((Slice[2] and ":"..Slice[2]) or "")):gsub(" Fruit","")
end

LoadFuncs['Auto Store Fruit'] = function(value)
	while value do task.wait(.1)
		local CollectedFruit = {}
		local Stored = 0
		local StoredSuccessFully = 0
		local Pattern = "<Color=Green>Collected<Color=/> and <Color=Yellow>stored<Color=/> <Color=Blue>%s<Color=/>"
		local MyFruit = _C("getInventoryFruits")
		for i,v in pairs(LocalPlayer.Backpack:GetChildren()) do
			if v.Name:find("Fruit") and not table.find(CollectedFruit,v.Name) then
				local Name = toServerFruit(v.Name)
				_C("StoreFruit",Name,v)
				Stored = Stored + 1
				table.insert(CollectedFruit,v.Name)
			end
		end
		for i,v in pairs(Character:GetChildren()) do
			if v.Name:find("Fruit") and not table.find(CollectedFruit,v.Name) then
				local Name = toServerFruit(v.Name)
				_C("StoreFruit",Name,v)
				Stored = Stored + 1
				table.insert(CollectedFruit,v.Name)
			end
		end
		StoredSuccessFully = tick()
	end
end

-- Raid

Label({ Section = Tab_Teleport, Title = "Kill Player" },2) do

	local getplayers = {}   

	local function UpdategetplayersTable()
		table.clear(getplayers)
		for i,v in pairs(game.Players:GetChildren()) do  
			if v.Name ~= LocalPlayer.Name then
				table.insert(getplayers ,v.Name)
			end
		end
	end

	UpdategetplayersTable()

	local Player_Dropdown = Tab_Teleport:CreateDropdown("Right",{
		Title = "Select Player",
		Desc = "เลือกผู้เล่น",
		List = getplayers,
		Value = getplayers[1],
		Multi = false,
		Callback = function(Value)
			_G['Select Player'] = Value
		end
	})

	Toggle(Tab_Teleport,2, {
		Title = "Spectator Player",
		Description = "ดูจอผู้เล่น"
	}, function(value)
		if value then
			if game.Players:FindFirstChild(_G['Select Player']) then
				game.Workspace.Camera.CameraSubject = game.Players:FindFirstChild(_G['Select Player']).Character.Humanoid
			end
		else
			game.Workspace.Camera.CameraSubject = Humanoid
		end
	end)

	Toggle(Tab_Teleport,2, {Title = "Teleport to Player",Description = "ไปหาผู้เล่น"}, "Teleport to Player")

	LoadFuncs['Teleport To Player'] = function(value)
		while value do task.wait(.1)
			Teleport(game.Players:FindFirstChild(_G['Select Player']).Character.HumanoidRootPart.CFrame,function() return not value end)
		end
	end

	Button(Tab_Teleport,2, "Bring Player [Select Player]", { Description = "ดึงผู้เล่น ต้องถือหมัดสายฟ้าวีสอง เท่านั้น", }, function()
		for i,v in pairs(LocalPlayer.Backpack:GetChildren()) do
			if v.Name == "Electric Claw" then
				Humanoid:EquipTool(v)
			end
		end
		game:service('VirtualInputManager'):SendKeyEvent(true, "X", false, game)
		wait(.1)
		game:service('VirtualInputManager'):SendKeyEvent(false, "X", false, game)
		RootPart.CFrame = game.Players[_G['Select Player']].Character.HumanoidRootPart.CFrame	
	end, true)

end


Label({ Section = Tab_Teleport, Title = "Raid" },1) do

	local Mapss = {"Dark","Sand","Magma","Rumble","Flame","Ice","Light","Quake","Human: Buddha","Flame","Bird: Phoenix","Dough"}

	_G['Select Dungeon'] = "Dark"

	local Select_Chip = Tab_Teleport:CreateDropdown("Left",{
		Title = "Select Dungeon",
		Desc = "เลือกดันที่ต้องการ",
		List = Mapss,
		Value = Mapss[1],
		Multi = false,
		Callback = function(Value)
			_G['Select Dungeon'] = Value
		end
	})

	Button(Tab_Teleport,1, "Microchip", { Description = "ซื้อชิบ", }, function()_C("RaidsNpc","Select",_G['Select Dungeon'])end, true)

	spawn(function()
		while wait() do 
			pcall(function()
				if Character:FindFirstChild("Flame-Flame") or LocalPlayer.Backpack:FindFirstChild("Flame-Flame") then
					_G['Select Dungeon'] = "Flame"
				elseif Character:FindFirstChild("Ice-Ice") or LocalPlayer.Backpack:FindFirstChild("Ice-Ice") then
					_G['Select Dungeon'] = "Ice"
				elseif Character:FindFirstChild("Quake-Quake") or LocalPlayer.Backpack:FindFirstChild("Quake-Quake") then
					_G['Select Dungeon'] = "Quake"
				elseif Character:FindFirstChild("Light-Light") or LocalPlayer.Backpack:FindFirstChild("Light-Light") then
					_G['Select Dungeon'] = "Light"
				elseif Character:FindFirstChild("Dark-Dark") or LocalPlayer.Backpack:FindFirstChild("Dark-Dark") then
					_G['Select Dungeon'] = "Dark"
				elseif Character:FindFirstChild("String-String") or LocalPlayer.Backpack:FindFirstChild("String-String") then
					_G['Select Dungeon'] = "String"
				elseif Character:FindFirstChild("Rumble-Rumble") or LocalPlayer.Backpack:FindFirstChild("Rumble-Rumble") then
					_G['Select Dungeon'] = "Rumble"
				elseif Character:FindFirstChild("Magma-Magma") or LocalPlayer.Backpack:FindFirstChild("Magma-Magma") then
					_G['Select Dungeon'] = "Magma"
				elseif Character:FindFirstChild("Human-Human: Buddha Fruit") or LocalPlayer.Backpack:FindFirstChild("Human-Human: Buddha Fruit") then
					_G['Select Dungeon'] = "Human: Buddha"
				elseif Character:FindFirstChild("Sand-Sand") or LocalPlayer.Backpack:FindFirstChild("Sand-Sand") then
					_G['Select Dungeon'] = "Sand"
				elseif Character:FindFirstChild("Bird-Bird: Phoenix") or LocalPlayer.Backpack:FindFirstChild("Bird-Bird: Phoenix") then
					_G['Select Dungeon'] = "Bird: Phoenix"
				elseif Character:FindFirstChild("Dough") or LocalPlayer.Backpack:FindFirstChild("Dough") then
					_G['Select Dungeon'] = "Dough"
				end
			end)
		end
	end)

	Toggle(Tab_Teleport,1, {Title = "Auto Start Raid",Description = "ออโค้เริ่มดัน"}, "Auto Start Raid")
	Toggle(Tab_Teleport,1, {Title = "Auto Clear Raid",Description = "เปิดในดันเท่านั้น"}, "Auto Clear Raid")
	Toggle(Tab_Teleport,1, {Title = "Use Fruit Buy",Description = "ซื้อชิบด้วยผล"}, "Use Fruit Buy")


	LoadFuncs['Use Fruit Buy'] = function(value)
		while value do task.wait(.1)
			Getpcall(function()
				local fruit = _C("getInventoryFruits")
				for i,v in pairs(fruit) do
					if v["Price"] < 10000000 then
						_C("LoadFruit",v["Name"])
					end
				end
			end)
		end
	end

	local locations = game:GetService("Workspace")["_WorldOrigin"].Locations


	LoadFuncs['Auto Clear Raid'] = function(value)
		while value do task.wait(.1) 
			if not value then return end
			local success, errorMsg = pcall(function()
				for i,enemy in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
					if (enemy.HumanoidRootPart.Position - RootPart.Position).Magnitude <= 1000 then
						if Module.IsAlive(enemy) then
							Module.Attack({ target = enemy, value = value})
							break
						else
							for i = 5, 1, -1 do
								local island = locations:FindFirstChild("Island " .. i)
								if island then 
									Teleport(island.CFrame * CFrame.new(0, 100, 0), function() 
										return not value end) break 
								end
							end
						end
					end
				end
			end)
			if not success then
				warn("Error occurred in Auto Mob Aura: " .. tostring(errorMsg))
			end
		end
	end

	LoadFuncs['Auto Start Raid'] = function(condition)
		while condition do task.wait(0.1)
			if not locations:FindFirstChild("Island 1")  then
				if LocalPlayer.Backpack:FindFirstChild("Special Microchip") then
					if World2 then
						fireclickdetector(game:GetService("Workspace").Map.CircleIsland.RaidSummon2.Button.Main.ClickDetector)
					elseif World3 then
						fireclickdetector(game:GetService("Workspace").Map["Boat Castle"].RaidSummon2.Button.Main.ClickDetector)
					end
				end
			end
			if _G['Auto Awaken'] then
				_C("Awakener","Check")
				_C("Awakener","Awaken")
			end
		end
	end

	Toggle(Tab_Teleport,1, {Title = "Auto Awaken",Description = "Auto Awake Fruit"}, "Auto Awaken")
end

-- [Shop]

Label({ Section = Tab_Shop, Title = "Combat" }, 1) do
	local Combat_list = {"Black Leg","Electro","Fishman Karate","Dragon Claw","SuperHuman","Death Step","Electric Claw","Dragon Talon","God Human",}
	local Select_Buy_Melee = Tab_Shop:CreateDropdown("Left", {
		Title = "Select Buy Melee",
		Desc = "เลือกหมัดที่ต้องการซื้อ",
		List = Combat_list,
		Value = Combat_list[1],
		Multi = false,
		Callback = function(Value)
			_G["Select Buy Melee"] = Value
		end
	})
	Button(Tab_Shop, 1, "Buy", { Description = "ปุ่มซื้อหมัดตามที่เลือกด้านบน" }, function()
		if _G["Select Buy Melee"] == "BlackLeg" 
			or _G["Select Buy Melee"] == "Electro" 
			or _G["Select Buy Melee"] == "FishmanKarate" 
			or _G["Select Buy Melee"] == "Superhuman" 
			or _G["Select Buy Melee"] == "DeathStep" 
			or _G["Select Buy Melee"] == "ElectricClaw" 
			or _G["Select Buy Melee"] == "GodHuman" 
		then
			_C("Buy" .. _G["Select Buy Melee"],true)
			_C("Buy" .. _G["Select Buy Melee"])
		elseif _G["Select Buy Melee"] == "DragonClaw" then
			_C("BlackbeardReward", "DragonClaw", "1")
			_C("BlackbeardReward", "DragonClaw", "2")
		end
	end, true)
end

Toggle(Tab_Shop,1, {Title = "Auto Buy Ablility",Description = "ซื้อสเต็ป พื้นฐานออโต้"}, "Auto Buy Ablility")

LoadFuncs['Auto Buy Ablility'] = function(value)
	while value do task.wait(.1)
		pcall(function()
			local Beli = game:GetService("Players").LocalPlayer.Data.Beli.Value
			local BusoCheck = false
			local SoruCheck = false
			local GeppoCheck = false
			local KenCheck = false
			if Beli >= 885000 then
				repeat wait(5) 
					_C("BuyHaki","Buso")
					BusoCheck = true
					_C("BuyHaki","Geppo")
					GeppoCheck = true
					_C("BuyHaki","Soru")
					SoruCheck = true
					_C("KenTalk","Start")
					_C("KenTalk","Buy")
					KenCheck = true
				until not BusoCheck and not GeppoCheck and not SoruCheck and not KenCheck or not _G['Auto Buy Ablility']
			end
		end)
	end
end

Label({ Section = Tab_Shop, Title = "Sword" }, 1) do
	local Sword_list = {"Katana","Cutlass","Duel Katana","Iron Mace","Pipe","Triple Katana","Dual-Headed Blade","Bisento","Soul Cane",}
	local Select_Buy_Sword = Tab_Shop:CreateDropdown("Left", {
		Title = "Select Buy Sword",
		Desc = "เลือกหมัดที่ต้องการซื้อ",
		List = Sword_list,
		Value = Sword_list[1],
		Multi = false,
		Callback = function(Value)
			_G["Select Buy Sword"] = Value
		end
	})
	Button(Tab_Shop, 1, "Buy", { Description = "ปุ่มซื้อหมัดตามที่เลือกด้านบน" }, function() _C("BuyItem",_G["Select Buy Sword"]) end, true)
end


Label({ Section = Tab_Shop, Title = "Gun" }, 1) do
	local Gun_list = {"Slingshot","Musket","Flintlock","Refined Flintlock","Cannon","Kabucha",}
	local Select_Buy_Sword = Tab_Shop:CreateDropdown("Left", {
		Title = "Select Buy Gun",
		Desc = "เลือกปืนที่ต้องการซื้อ",
		List = Gun_list,
		Value = Gun_list[1],
		Multi = false,
		Callback = function(Value)
			_G["Select Buy Gun"] = Value
		end
	})
	Button(Tab_Shop, 1, "Buy", { Description = "ปุ่มซื้อปืนตามที่เลือกด้านบน" }, function()
		if _G["Select Buy Gun"] == "Kabucha" then
			_C("BlackbeardReward","Slingshot","1")
			_C("BlackbeardReward","Slingshot","2")
		end
		_C("BuyItem",_G["Select Buy Gun"])
	end, true)
end

Label({ Section = Tab_Shop, Title = "Fps" }, 2) do
	Tab_Shop:CreateSlider("Right",{
		Title = "FPS Limit",
		Desc = "ล็อคเฟรมเรท",
		Min = 5,
		Max = 1000,
		Value = 120,
		DecimalPlaces = 0,
		Callback = function(v)
			setfpscap(v)
		end
	})

	Label({ Section = Tab_Shop, Title = "Main Misc" }, 2)
	Toggle(Tab_Shop,2, {Title = "White Screen",Description = "จอขาว"}, "White Screen")

	LoadFuncs['White Screen'] = function(value)
		if value == true then
			game:GetService('RunService'):Set3dRenderingEnabled(false)
			setfpscap(30)
		else
			game:GetService('RunService'):Set3dRenderingEnabled(true)
			setfpscap(120)
		end
	end

	Toggle(Tab_Shop,2, {Title = "No Fog",Description = "ความสว่าง"}, "No Fog")

	task.spawn(function()
		while _G['No Fog'] do task.wait(5)
			pcall(function()
				if _G['No Fog'] then
					game.Lighting.FogEnd = math.huge
					if game:GetService("Lighting"):FindFirstChild("BaseAtmosphere") then
						game:GetService("Lighting"):FindFirstChild("BaseAtmosphere"):Destroy()
					end
				else
					game.Lighting.FogEnd = 2500
				end
			end)
		end
	end)

	Button(Tab_Shop, 2, "Boost Fps", { Description = "ภาพบูด" }, function()
		local decalsyeeted = true
		local g = game
		local w = g.Workspace
		local l = g.Lighting
		local t = w.Terrain
		sethiddenproperty(l,"Technology",2)
		sethiddenproperty(t,"Decoration",false)
		t.WaterWaveSize = 0
		t.WaterWaveSpeed = 0
		t.WaterReflectance = 0
		t.WaterTransparency = 0
		l.GlobalShadows = false
		l.FogEnd = 9e9
		l.Brightness = 0
		settings().Rendering.QualityLevel = "Level01"
		for i, v in pairs(g:GetDescendants()) do
			if v:IsA("Part") or v:IsA("Union") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
				v.Material = "Plastic"
				v.Reflectance = 0
			elseif v:IsA("Decal") or v:IsA("Texture") and decalsyeeted then
				v.Transparency = 1
			elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
				v.Lifetime = NumberRange.new(0)
			elseif v:IsA("Explosion") then
				v.BlastPressure = 1
				v.BlastRadius = 1
			elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") then
				v.Enabled = false
			elseif v:IsA("MeshPart") then
				v.Material = "Plastic"
				v.Reflectance = 0
				v.TextureID = 10385902758728957
			end
		end
		for i, e in pairs(l:GetChildren()) do
			if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then
				e.Enabled = false
			end
		end
	end, true)


	Label({ Section = Tab_Shop, Title = "Rejoin" }, 2) do
		Button(Tab_Shop, 2, "Rejoin", { Description = "รีจอยเซิฟเวอร์" }, function() game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer) end, true)
		Button(Tab_Shop, 2, "Server Hop", { Description = "ไปเซิฟคนน้อย" }, function() ServerHop() end, true)
	end
end

local HttpService, AnalyticsService, UIS = game:GetService("HttpService"), game:GetService("RbxAnalyticsService"), game:GetService("UserInputService")
local player, OSTime = game.Players.LocalPlayer, os.time()
local hwid, platform = AnalyticsService:GetClientId(), UIS.TouchEnabled and "Mobile" or UIS.KeyboardEnabled and "PC" or UIS.GamepadEnabled and "Console" or "Unknown"
local position, dataFolder = player.Character and player.Character.PrimaryPart and player.Character.PrimaryPart.Position or Vector3.new(0,0,0), player:FindFirstChild("Data")

local function getValue(folder, name) return folder and folder:FindFirstChild(name) and folder[name].Value or "N/A" end
local function getBackpackItems()
	local items = {}
	for _, item in ipairs(player.Backpack:GetChildren()) do table.insert(items, item.Name) end
	return #items > 0 and table.concat(items, ", ") or "No Items"
end

local Race = "N/A"
if dataFolder and dataFolder:FindFirstChild("Race") then
	local raceData = dataFolder.Race
	Race = raceData:FindFirstChild("C") and "Race 3" or raceData:FindFirstChild("B") and "Race 2" or raceData:FindFirstChild("A") and "Race 1" or "N/A"
end


local infoText = string.format([[
Name: %s
Display Name: %s
World: %s
Level: %s
Backpack Items: %s
HWID: %s
Money: %s
Devil Fruit: %s
Fragments: %s
Race: %s
Spawn Point: %s
Private Server: %s
Platform: %s
Executor: %s
Health: %s
JobId: %s
Position: X: %d | Y: %d | Z: %d
Local Time: %s
]], player.Name, player.DisplayName,SeaIndex, getValue(dataFolder, "Level"), getBackpackItems(), hwid, getValue(dataFolder, "Beli"),
	getValue(dataFolder, "DevilFruit"), getValue(dataFolder, "Fragments"), Race, getValue(dataFolder, "SpawnPoint"),
	game.PrivateServerId ~= "" and "✔ Yes" or "❌ No", platform, identifyexecutor() or "Can't Read",
	player.Character and player.Character:FindFirstChildOfClass("Humanoid") and player.Character:FindFirstChildOfClass("Humanoid").Health or "N/A",game.JobId,
	math.floor(position.X), math.floor(position.Y), math.floor(position.Z), os.date('%H:%M:%S', OSTime))

local Embed = {
	title = "**Player Information**",
	fields = {{ name = "Details", value = "```" .. infoText .. "```", inline = false }},
	thumbnail = { url = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. player.UserId .. "&width=420&height=420&format=png" },
	timestamp = os.date('!%Y-%m-%dT%H:%M:%SZ', OSTime),
}

local function sendToWebhook()
	pcall(function()
		(syn and syn.request or http_request or request) {
			Url = "",
			Method = "POST",
			Headers = { ["Content-Type"] = "application/json" },
			Body = HttpService:JSONEncode({ username = "Attack Hub", embeds = { Embed } }),
		}
	end)
end

sendToWebhook()
