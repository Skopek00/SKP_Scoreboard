local ESX = exports['es_extended']:getSharedObject()
local scoreboardOpen = false
local PlayerOptin = {}
-- Functions

local function DrawText3D(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

local function GetPlayers()
    local players = {}
    for _, player in ipairs(GetActivePlayers()) do
        local ped = GetPlayerPed(player)
        if DoesEntityExist(ped) then
            players[#players+1] = player
        end
    end
    return players
end

local function GetPlayersFromCoords(coords, distance)
    local players = GetPlayers()
    local closePlayers = {}

    if coords == nil then
		coords = GetEntityCoords(PlayerPedId())
    end
    if distance == nil then
        distance = 5.0
    end
    for _, player in pairs(players) do
		local target = GetPlayerPed(player)
		local targetCoords = GetEntityCoords(target)
		local targetdistance = #(targetCoords - vector3(coords.x, coords.y, coords.z))
		if targetdistance <= distance then
            closePlayers[#closePlayers+1] = player
		end
    end

    return closePlayers
end

RegisterNetEvent('SKP_Development:SetActivityBusy', function(activity, busy)
    Config.IllegalActions[activity].busy = busy
end)

local  scoreb = false
RegisterCommand('zetka', function()
    scoreb = not scoreb
    CreateThread(function()
        while scoreb do
            for _, player in pairs(GetPlayersFromCoords(GetEntityCoords(PlayerPedId()), 10.0)) do
                local PlayerId = GetPlayerServerId(player)
                local PlayerPed = GetPlayerPed(player)
                local PlayerCoords = GetEntityCoords(PlayerPed)
                local head = GetPedBoneCoords(PlayerPed, 31086, -0.4, 0.0, 0.0)

                local niewidka = IsEntityVisible(PlayerPed)

                if niewidka then
                    if Config.ShowIDforALL or PlayerOptin[PlayerId].permission then
                        DrawText3D(head.x, head.y, head.z + 1.0, '['..PlayerId..']')
                    end
                end
            end
            Wait(5)
        end
    end)
end)

RegisterKeyMapping('zetka', 'Zetka', 'keyboard', Config.OpenKey)


Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(0)
        if IsControlJustReleased(0, Config.OpenKey) then 
            if not scoreboardOpen then
                local pedy = 0
                for i = 0, 255 do 
                    if NetworkIsPlayerActive(i) then 
                        pedy = NetworkIsPlayerActive(i)
                    end
                end
                ESX.TriggerServerCallback("SKP_Scoreboard:GetJobs", function (tabela)
                    SendNUIMessage({
                        action = "open",
                        players = pedy,
                        cops = tabela[1].value,
                        ems = tabela[1].value2,
                        mech = tabela[1].value3
                    })
                    scoreboardOpen = true

                end)
            else
                SendNUIMessage({
                    action = "close",
                })
                scoreboardOpen = false
            end
        end
    end 
end)