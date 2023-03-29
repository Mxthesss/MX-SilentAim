local QBCore = nil
local ESX = nil
local Webhook = '' -- insert your webhook in here


if Webhook == '' then
    print('^1[MX-AntiAim] ^1Please set your discord bot Webhook in config.lua ^7')
    return
end

if Config.Framework == '' then
    print('^1[MX-AntiAim] ^1Please set your framework in config.lua ^7')
    return
end

if Config.Framework == 'qb' then
    QBCore = exports['qb-core']:GetCoreObject()
    while QBCore == nil do
        Citizen.Wait(200)
    end
elseif Config.Framework == 'esx' then
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    while ESX == nil do
        Citizen.Wait(200)
    end
end


local function logEvent(source)
    local src = source
    local license = GetPlayerIdentifier(src)
    local steamname = GetPlayerName(src)
    local playerTrust = false

    -- Player data
    if Config.Framework == 'qb' then
        if QBCore.Functions.HasPermission(src, 'god') or QBCore.Functions.HasPermission(src, 'admin') or QBCore.Functions.HasPermission(src, 'mod') then
            playerTrust = true
        end
    elseif Config.Framework == 'esx' then
        if ESX.GetPlayerFromId(src).getGroup() == 'admin' or ESX.GetPlayerFromId(src).getGroup() == 'mod'  or ESX.GetPlayerFromId(src).getGroup() == 'developer' or ESX.GetPlayerFromId(src).getGroup() == 'hladmin'or ESX.GetPlayerFromId(src).getGroup() == 'owner' then
            playerTrust = true
        end
    end

    if Config.PlayerAcePermission and string.len(Config.PlayerAcePermission) > 0 and IsPlayerAceAllowed(src, Config.PlayerAcePermission) then
        playerTrust = true
    end

    -- If player is not trusted, kick them and send a log to the discord
    if not playerTrust then
        -- 1st we create the embed, this is a JSON object
        local embedData = {
            {
                ['title'] = '[MX-AntiAim] Modified RPF files detected',
                ['color'] = 070121,
                ['footer'] = {
                    ['text'] = os.date('%c'),
                },
                ['description'] = 'Player: ' .. steamname .. '\nLicense: ' .. license .. '\nSteamID: ' .. GetPlayerIdentifier(src, 1) .. '\nIP: ||' .. GetPlayerEndpoint(src) .. '||',
                ['author'] = {
                    ['name'] = '[Mxthess]',
                    ['icon_url'] = Config.Avatar,
                },
            }
        }
        PerformHttpRequest(Webhook, function() end, 'POST', json.encode({ username = '[MX-AntiAim]', embeds = embedData}), { ['Content-Type'] = 'application/json' })
        if not Config.DropStaff then
            print('^1[MX-AntiAim] ^1STAFF USING MODIFIED RPF FILES: ' .. steamname .. ' ^7')
            return
        end
        print('^1[MX-AntiAim] ^1Player ' .. steamname .. ' has been kicked for using modified RPF files. ^7')
        DropPlayer(src, 'You have been kicked for using modified RPF files.')
    end
end


RegisterNetEvent('mxantiaim:log', function()
    if QBCore == nil and ESX == nil then
        print('^1[MX-AntiAim] ^3Framework not found. Please check your config.lua ^7')
        return
    end
    local src = source
    logEvent(src)
end)


Citizen.CreateThread(function()
    Citizen.Wait(5000)
    local resName = GetCurrentResourceName()
    local havePermission = false
    local customer = nil
    local actual_server_ip

    if resName ~= "MX-SilentAim" then
        print("^2["..resName.."] - IT WAS NOT STARTED CORRECTLY.")
        print("^2["..resName.."] - THE RESOURCE NAME MUST BE MX-SilentAim")
        Stop_Resource()
    end)

print('^5Made By Dev^7: ^1'..GetCurrentResourceName()..'^7 started ^2successfully^7...') 



-- Test command, use this to test if the webhook is working
--RegisterCommand('tWebhook', function(source, args)
--    local src = source
--    logEvent(src)
--end)
