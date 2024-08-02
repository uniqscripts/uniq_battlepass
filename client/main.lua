if not lib then return end

RegisterNetEvent('uniq_battlepass:client:OpenMenu', function(data)
    if source == '' then return end

    SetNuiFocus(true, true)
	SendNUIMessage({enable = true, info = data })
end)



RegisterNUICallback('quit', function(data, cb)
	SetNuiFocus(false, false)

    cb(1)
end)


RegisterNUICallback('OpenScoreboard', function(data, cb)
    local players = lib.callback.await('uniq_battlepass:server:GetScoreboardData', 100)

    cb(json.encode(players))
end)