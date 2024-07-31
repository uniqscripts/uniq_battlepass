if not lib then return end

MySQL.ready(function()
    local found = false
    local datatype = MySQL.query.await(('SHOW COLUMNS FROM `%s`'):format(Framework.esx and 'users' or 'players'))

    if datatype then
        for i = 1, #datatype do
            if datatype[i].Field == 'battlepass' then
                found = true
                break
            end
        end

        if not found then
            MySQL.query(('ALTER TABLE `%s` ADD COLUMN `battlepass` LONGTEXT DEFAULT "[]"'):format(Framework.esx and 'users' or 'players'))
            print('^2Successfully added column battlepass to database^0')
        end
    end
end)


lib.addCommand(Config.Commands.battlepass.name, {
    help = Config.Commands.battlepass.help,
}, function(source, args, raw)
    
end)





-- lib.versionCheck('uniqscripts/uniq_battlepass')