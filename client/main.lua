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