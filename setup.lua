-- If you don't have fucking idea what are you doing don't touch this :)))
Framework, Inv = {}, {}

local esx = GetResourceState('es_extended'):find('start')
local qb = GetResourceState('qb-core'):find('start')
local oxinv = GetResourceState('ox_inventory'):find('start')
local qsinv = GetResourceState('qs-inventory'):find('start')
local qbinv = GetResourceState('qb-inventory'):find('start')
local psinv = GetResourceState('ps-inventory'):find('start')
local ljinv = GetResourceState('lj-inventory'):find('start')
local core = GetResourceState('core_inventory'):find('start')
local codem = GetResourceState('codem-inventory'):find('start')

if esx then
    Framework = { esx = true }
elseif qb then
    Framework = { qb = true }
end

if oxinv then
    Inv = { ox = true, exp = exports.ox_inventory }
elseif qsinv then
    Inv = { qs = true, exp = exports['qs-inventory'] }
elseif qbinv or psinv or ljinv then
    Inv = { qb = true }
elseif core then
    Inv = { core = true, exp = exports.core_inventory }
elseif codem then
    Inv = { codem = true }
end


SetTimeout(1000, function()
    if table.type(Framework) == 'empty' then
        for i = 1, 5 do
            warn(('No Framework was found - either this asset is started before framework or you renamed your framework, check %s/setup.lua'):format(GetCurrentResourceName()))
        end
    end

    if not lib then
        for i = 1, 5 do
            warn('You are missing ox_lib, download from https://github.com/overextended/ox_lib/releases - zip file')
        end
    end
end)