local ESX = exports['es_extended']:getSharedObject()

ESX.RegisterServerCallback('SKP_Development:GetScoreboardData', function(_, cb)
    local totalPlayers = 0
    local policeCount = 0
    local players = {}

    for _, v in pairs(ESX.GetPlayers()) do
        if v then
            totalPlayers += 1

            if v.PlayerData.job.name == "police" and v.PlayerData.job.onduty then
                policeCount += 1
            end

            players[v.PlayerData.source] = {}
            players[v.PlayerData.source].optin = v.PlayerData.source
        end
    end
    cb(totalPlayers, policeCount, players)
end)

RegisterNetEvent('SKP_Development:SetActivityBusy', function(activity, bool)
    Config.IllegalActions[activity].busy = bool
    TriggerClientEvent('SKP_Development:SetActivityBusy', -1, activity, bool)
end)

ESX.RegisterServerCallback("SKP_Scoreboard:GetJobs", function (source, cb)
    local _source = source
    local copcount = 0
    local emscount = 0
    local mechcount = 0
    local Players = ESX.GetPlayers()
    local tabela = {}

    for i = 1, #Players, 1 do
        local xPlayer = ESX.GetPlayerFromId(Players[i])

        if xPlayer.job.name == Config.PoliceJob then
            copcount = copcount + 1
        end
        if xPlayer.job.name == Config.AmbulanceJob then
            emscount = emscount + 1
        end
        if xPlayer.job.name == Config.MechanicJob then
            mechcount = mechcount + 1
        end

        table.insert(tabela, {value = copcount, value2 = emscount, value3 = mechcount})
        Wait(100)
        cb(tabela)
    end
end)