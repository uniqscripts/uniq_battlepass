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


function GenerateRandomName(index)
    local firstNames = {
        "Alex", "Jordan", "Taylor", "Morgan", "Casey", "Jamie", "Riley", "Avery", "Quinn", "Sydney",
        "Cameron", "Drew", "Emerson", "Peyton", "Harper", "Bailey", "Rowan", "Sage", "Skyler", "Finley",
        "Aiden", "Ethan", "Liam", "Noah", "Mason", "Jacob", "William", "James", "Benjamin", "Lucas",
        "Henry", "Alexander", "Michael", "Daniel", "Matthew", "Elijah", "Owen", "Samuel", "David", "Joseph",
        "John", "Gabriel", "Julian", "Isaac", "Grayson", "Leo", "Jack", "Luca", "Sebastian", "Leo",
        "Emma", "Olivia", "Ava", "Sophia", "Isabella", "Charlotte", "Amelia", "Mia", "Harper", "Evelyn",
        "Abigail", "Ella", "Scarlett", "Grace", "Lily", "Aria", "Chloe", "Aurora", "Zoey", "Nora"
    }
    local lastNames = {
        "Smith", "Johnson", "Williams", "Jones", "Brown", "Davis", "Miller", "Wilson", "Moore", "Taylor",
        "Anderson", "Thomas", "Jackson", "White", "Harris", "Martin", "Thompson", "Garcia", "Martinez", "Robinson",
        "Clark", "Rodriguez", "Lewis", "Lee", "Walker", "Hall", "Allen", "Young", "King", "Wright",
        "Scott", "Green", "Adams", "Baker", "Nelson", "Carter", "Mitchell", "Perez", "Roberts", "Turner",
        "Phillips", "Campbell", "Parker", "Evans", "Edwards", "Collins", "Stewart", "Sanchez", "Morris", "Rogers",
        "Reed", "Cook", "Morgan", "Bell", "Murphy", "Bailey", "Cooper", "Richardson", "Cox", "Howard"
    }

    local firstName = firstNames[((index - 1) % #firstNames) + 1]
    local lastName = lastNames[((index - 1) % #lastNames) + 1]

    return firstName .. " " .. lastName
end

local bpOptions = {true, false}

local list = {}
RegisterNUICallback('OpenScoreboard', function(data, cb)
    for i = 1, 100 do
        local tier = math.random(1, 100)
        local xp = math.random(1, 1000 * tier)
        local taskdone = math.random(1, tier * 10)

        list[i] = {
            name = GenerateRandomName(i),
            tier = tier,
            xp = xp,
            premium = bpOptions[math.random(#bpOptions)],
            taskdone = taskdone
        }
    end

    cb(json.encode(list))
    table.wipe(list)
end)