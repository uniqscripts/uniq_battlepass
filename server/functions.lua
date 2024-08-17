function AddItem(playerId, item, amount, metadata)
    if Inv.ox then
        exports.ox_inventory:AddItem(playerId, item, amount, metadata)
    end
end