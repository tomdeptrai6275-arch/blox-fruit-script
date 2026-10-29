Settings = Settings or {}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local Plr = Players.LocalPlayer

-- Hệ thống dịch thuật (Translator)
if Settings.Translator then
    pcall(function()
        _G.RedzTranslator = HttpService:JSONDecode(game:HttpGet("https://githubusercontent.com"))
    end)
end

-- Hệ thống tự động chọn phe (Join Team)
local function JoinTeam()
    local targetTeam = Settings.JoinTeam == "Pirates" and "Pirates" or "Marines"
    
    if not Plr.Team or (Plr.Team.Name ~= "Marines" and Plr.Team.Name ~= "Pirates") then
        pcall(function()
            ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("SetTeam", targetTeam)
        end)
    end
end
JoinTeam()

-- Chặn hiệu ứng Chết/Hồi sinh để giảm mượt game (Bypass Effects)
for _, effectName in ipairs({"Death", "Respawn"}) do
    local success, effectModule = pcall(require, ReplicatedStorage:WaitForChild("Effect"):WaitForChild("Container"):WaitForChild(effectName))
    if success and type(effectModule) == "function" then
        hookfunction(effectModule, function() end)
    end
end

-- Xác định Thế giới (World/Sea) dựa trên PlaceId
local currentPlaceId = game.PlaceId
World1 = (currentPlaceId == 2753915549 or currentPlaceId == 85211729168715)
World2 = (currentPlaceId == 4442272183 or currentPlaceId == 79091703265657)
World3 = (currentPlaceId == 7449423635 or currentPlaceId == 100117331123089)

-- Quản lý Farm Nguyên liệu (Material Configs)
local MaterialData = {
    ["Angel Wings"] = {Mon = "Royal Soldier", Pos = CFrame.new(-7759.45898, 5606.93652, -1862.70276, -0.866007447, 0, -0.500031412, 0, 1, 0, 0.500031412, 0, -0.866007447), SP = "SkyArea2"},
    ["Mystic Droplet"] = {Mon = "Water Fighter", Pos = CFrame.new(-3331.70459, 239.138336, -10553.3564, -0.29242146, 0, 0.95628953, 0, 1, 0, -0.95628953, 0, -0.29242146), SP = "ForgottenIsland"},
    ["Vampire Fang"] = {Mon = "Vampire", Pos = CFrame.new(-6132.39453, 9.00769424, -1466.16919, -0.927179813, 0, -0.374617696, 0, 1, 0, 0.374617696, 0, -0.927179813), SP = "Graveyard"},
    ["Gunpowder"] = {Mon = "Pistol Billionaire", Pos = CFrame.new(-185.693283, 84.7088699, 6103.62744, 0.90629667, 0, -0.422642082, 0, 1, 0, 0.422642082, 0, 0.90629667), SP = "Mansion"},
    ["Conjured Cocoa"] = {Mon = "Chocolate Bar Battler", Pos = CFrame.new(582.828674, 25.5824986, -12550.7041, -0.766061664, 0, -0.642767608, 0, 1, 0, 0.642767608, 0, -0.766061664), SP = "Chocolate"},
    ["Mini Tusk"] = {Mon = "Mythological Pirate", Pos = CFrame.new(-13456.0498, 469.433228, -7039.96436, 0, 0, 1, 0, 1, 0, -1, 0, 0), SP = "BigMansion"},
    ["Radiactive Material"] = {Mon = "Factory Staff", Pos = CFrame.new(-105.889565, 72.8076935, -670.247986, -0.965929747, 0, -0.258804798, 0, 1, 0, 0.258804798, 0, -0.965929747), SP = "Bar"}
}

function MaterialMon()
    local selected = _G.SelectMaterial
    if MaterialData[selected] then
        MMon = MaterialData[selected].Mon
        MPos = MaterialData[selected].Pos
        SP = MaterialData[selected].SP
        return
    end

    -- Xử lý các nguyên liệu phụ thuộc vào World (PlaceId)
    if selected == "Fish Tail" then
        if currentPlaceId == 2753915549 then
            MMon = "Fishman Commando"
            MPos = CFrame.new(61760.8984, 18.0800781, 1460.11133, -0.632549644, 0, -0.774520278, 0, 1, 0, 0.774520278, 0, -0.632549644)
            SP = "Underwater City"
        elseif currentPlaceId == 7449423635 then
            MMon = "Fishman Captain"
            MPos = CFrame.new(-10828.1064, 331.825989, -9049.14648, -0.0912091732, 0, 0.995831788, 0, 1, 0, -0.995831788, 0, -0.0912091732)
            SP = "PineappleTown"
        end
    elseif selected == "Magma Ore" then
        if currentPlaceId == 2753915549 then
            MMon = "Military Spy"
            MPos = CFrame.new(-5806.70068, 78.5000458, 8904.46973, 0.707134247, 0, 0.707079291, 0, 1, 0, -0.707079291, 0, 0.707134247)
            SP = "Magma"
        elseif currentPlaceId == 4442272183 then
            MMon = "Lava Pirate"
            MPos = CFrame.new(-5158.77051, 14.4791956, -4654.2627, -0.848060489, 0, -0.529899538, 0, 1, 0, 0.529899538, 0, -0.848060489)
            SP = "CircleIslandFire"
        end
    elseif selected == "Leather + Scrap Metal" then
        if currentPlaceId == 2753915549 then
            MMon = "Brute"
            MPos = CFrame.new(-1191.41235, 15.5999985, 4235.50928, 0.629286051, 0, -0.777173758, 0, 1, 0, 0.777173758, 0, 0.629286051)
            SP = "Pirate"
        elseif currentPlaceId == 4442272183 then
            MMon = "Mercenary"
            MPos = CFrame.new(-986.774475, 72.8755951, 1088.44653, -0.656062722, 0, 0.754706323, 0, 1, 0, -0.754706323, 0, -0.656062722)
            SP = "DressTown"
        elseif currentPlaceId == 7449423635 then
            MMon = "Pirate Millionaire"
            MPos = CFrame.new(-118.809372, 55.4874573, 5649.17041, -0.965929747, 0, 0.258804798, 0, 1, 0, -0.258804798, 0, -0.965929747)
            SP = "Default"
        end
    end
end

-- Hệ thống tự động nhận diện Nhiệm vụ (Quest Level Manager)
local QuestDataWorld1 = {
    {Min = 1, Max = 9, Target = "Bandit", Mon = "Bandit", QNum = 1, QName = "BanditQuest1", QCP = CFrame.new(1059.37195, 15.4495068, 1550.4231, 0.939700544, -0, -0.341998369, -0, 1, -0, 0.341998369, -0, 0.939700544), MCP = CFrame.new(1045.962646484375, 27.00250816345215, 1560.8203125)},
    {Min = 60, Max = 74, Target = "Desert Bandit", Mon = "Desert Bandit", QNum = 1, QName = "DesertQuest", QCP = CFrame.new(894.488647, 5.14000702, 4392.43359, 0.819155693, -0, -0.573571265, -0, 1, -0, 0.573571265, -0, 0.819155693), MCP = CFrame.new(924.7998046875, 6.44867467880249, 4481.5859375)},
    {Min = 100, Max = 119, Target = "Snowman", Mon = "Snowman", QNum = 2, QName = "SnowQuest", QCP = CFrame.new(1386.824, 87.265, -1301.378), MCP = CFrame.new(1272.541, 135.251, -1412.361)}
}

function CheckQuest()
    local MyLevel = Plr.Data.Level.Value
    
    if World1 then
        for _, quest in ipairs(QuestDataWorld1) do
            if (MyLevel >= quest.Min and MyLevel <= quest.Max) or _G.SelectMonster == quest.Target then
                Mon = quest.Mon
                LevelQuest = quest.QNum
                NameQuest = quest.QName
                NameMon = quest.Mon
                CFrameQuest = quest.QCP
                CFrameMon = quest.MCP
                return
            end
        end
    end
end
