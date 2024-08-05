if not lib then return end

RegisterNetEvent('uniq_battlepass:client:OpenMenu', function(data, week)
    if source == '' then return end

    SetNuiFocus(true, true)
	SendNUIMessage({enable = true, info = data, items = Config.Rewards.free[week], path = Config.ImagePath })
end)



RegisterNUICallback('quit', function(data, cb)
	SetNuiFocus(false, false)

    cb(1)
end)


RegisterNUICallback('OpenScoreboard', function(data, cb)
    local players = lib.callback.await('uniq_battlepass:server:GetScoreboardData', 100)

    cb(players)
end)



-- Define the XP required for each tier. This could be a formula or a lookup table.
function xp_required_for_tier(tier)
    -- For simplicity, let's assume the XP required increases linearly by 100 XP per tier
    return 1000 + (tier - 1) * 100
end

-- Calculate the current tier and XP progress
function calculate_tier_and_progress(current_xp)
    local tier = 1
    local xp_for_next_tier = xp_required_for_tier(tier)
    
    while current_xp >= xp_for_next_tier do
        current_xp = current_xp - xp_for_next_tier
        tier = tier + 1
        xp_for_next_tier = xp_required_for_tier(tier)
    end
    
    return tier, current_xp, xp_for_next_tier
end

-- Example usage:
current_xp = 28500 -- This is the total XP the player has

tier, xp_in_current_tier, xp_for_next_tier = calculate_tier_and_progress(current_xp)

print("Current Tier:", tier)
print("XP in current Tier:", xp_in_current_tier)
print("XP required for next Tier:", xp_for_next_tier)
print("Progress: " .. xp_in_current_tier .. "/" .. xp_for_next_tier)