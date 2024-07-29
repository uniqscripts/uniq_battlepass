-- If you don't have fucking idea what are you doing don't touch this :)))
Framework, Inv = {}, {}

local esx = GetResourceState('es_extended'):find('start')
local qb = GetResourceState('qb-core'):find('start')

if esx then
    Framework = { esx = true }
elseif qb then
    Framework = { qb = true }
end

local oxinv = GetResourceState('ox_inventory'):find('start')
local qsinv = GetResourceState('qs-inventory'):find('start')
local qbinv = GetResourceState('qb-inventory'):find('start')
local psinv = GetResourceState('ps-inventory'):find('start')
local ljinv = GetResourceState('lj-inventory'):find('start')
local core = GetResourceState('core_inventory'):find('start')
local codem = GetResourceState('codem-inventory'):find('start')


if oxinv then
    Inv = { ox = true }
elseif qsinv then
    Inv = { qs = true }
elseif qbinv or psinv or ljinv then
    Inv = { qb = true }
elseif core then
    Inv = { core = true }
elseif codem then
    Inv = { codem = true }
end


SetTimeout(1000, function()
    if table.type(Framework) == 'empty' then
        for i = 1, 3 do
            warn("No Framework was found, check uniq_deathmatch/setup.lua")
        end
    end
end)