function AddItem(playerId, item, amount)
    if Inv.ox then
        exports.ox_inventory:AddItem(playerId, item, amount)
    end
end