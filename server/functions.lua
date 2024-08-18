if Inv.core then
    function GetCoreInv(playerId, prefix)
        local identifier = GetIdentifier(playerId)

        if identifier then
            return Framework.esx and ('%s-%s'):format(prefix, identifier:gsub(':','')) or ('%s-%s'):format(prefix, identifier)
        end

        return false
    end
end

function AddItem(playerId, item, amount, metadata)
    if Inv.ox then
        Inv.exp:AddItem(playerId, item, amount, metadata)
    elseif Inv.qb then
        QBCore.Functions.GetPlayer(playerId)?.Functions.AddItem(item, amount, nil, metadata)
    elseif Inv.qs then
        Inv.exp:AddItem(playerId, item, amount, nil, metadata)
    elseif Inv.core then
        local inventory = GetCoreInv(playerId, 'content')
        Inv.exp:addItem(inventory, item, amount, metadata, 'content')
    elseif Inv.codem then
        exports['codem-inventory']:AddItem(playerId, item, amount, nil, metadata)
    end
end