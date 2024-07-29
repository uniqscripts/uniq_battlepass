if not lib then return end


MySQL.ready(function()
    if Framework.esx then
        print 'da'
    end
end)


lib.addCommand(Config.Commands.battlepass.name, {
    help = Config.Commands.battlepass.help,
}, function(source, args, raw)
    
end)



-- lib.versionCheck('uniqscripts/uniq_battlepass')