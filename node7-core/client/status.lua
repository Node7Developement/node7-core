local statusConfig = Node7Core.Config.StatusHUD or {}
local statusVisible = statusConfig.DefaultVisible ~= false
local playerLoaded = false

local function sendStatus(playerData)
    if statusConfig.Enabled == false then return end
    playerData = playerData or Node7Core.PlayerData or {}
    local money = playerData.money or {}
    local metadata = playerData.metadata or {}
    local charinfo = playerData.charinfo or {}
    local fullName = (('%s %s'):format(charinfo.firstname or '', charinfo.lastname or '')):gsub('^%s+', ''):gsub('%s+$', '')

    SendNUIMessage({
        action = 'status:update',
        visible = playerLoaded and statusVisible,
        status = {
            cash = tonumber(money.cash) or 0,
            bank = tonumber(money.bank) or 0,
            gold = tonumber(money.gold) or 0,
            bloodtype = tostring(metadata.bloodtype or '--'),
            blood = tonumber(metadata.blood) or 100,
            name = fullName,
            showName = statusConfig.ShowCharacterName ~= false,
            showBloodType = statusConfig.ShowBloodType ~= false,
        }
    })
end

RegisterNetEvent('Node7Core:Client:OnPlayerLoaded', function()
    playerLoaded = true
    Wait(250)
    sendStatus()
end)

RegisterNetEvent('Node7Core:Client:OnPlayerUnload', function()
    playerLoaded = false
    SendNUIMessage({ action = 'status:hide' })
end)

RegisterNetEvent('Node7Core:Player:SetPlayerData', function(playerData)
    Node7Core.PlayerData = playerData or {}
    sendStatus(Node7Core.PlayerData)
end)

RegisterNetEvent('Node7Core:Client:OnMoneyChange', function()
    Wait(50)
    sendStatus()
end)

RegisterNetEvent('Node7Core:Client:OnPlayerUpdated', function()
    sendStatus()
end)

RegisterCommand(statusConfig.ToggleCommand or 'togglemoneyhud', function()
    if statusConfig.Enabled == false then return end
    statusVisible = not statusVisible
    sendStatus()
end, false)

CreateThread(function()
    while true do
        Wait(5000)
        if playerLoaded and statusVisible then
            sendStatus()
        end
    end
end)
