-- NODE7 western notification NUI.
-- Visuals are rendered by html/index.html. The game sound remains native.
-- ox_lib notifications are intentionally not used.

local PLAY_SOUND_FRONTEND_NATIVE = 0x67C540AA08E4A6F5
local DEFAULT_SOUND_DICT = 'Transaction_Feed_Sounds'
local DEFAULT_SOUND_NAME = 'Transaction_Positive'
local notificationSequence = 0

local function notifyConfig()
    return (Node7Core.Config and Node7Core.Config.Notify) or {}
end

local function normalizeType(value)
    value = tostring(value or 'info'):lower()

    local aliases = {
        inform = 'info',
        primary = 'info',
        default = 'info',
        danger = 'error',
        fail = 'error',
        failed = 'error',
        warn = 'warning',
        cash = 'money',
        bank = 'money',
    }

    value = aliases[value] or value
    local allowed = {
        info = true,
        success = true,
        error = true,
        warning = true,
        money = true,
        alert = true,
    }

    return allowed[value] and value or 'info'
end

local function typeProfile(notificationType)
    local config = notifyConfig()
    local profiles = config.Types or {}
    return profiles[notificationType] or profiles.info or {}
end

local function clampDuration(value)
    local config = notifyConfig()
    local duration = tonumber(value) or tonumber(config.DefaultDuration) or 5000
    local minimum = tonumber(config.MinDuration) or 1000
    local maximum = tonumber(config.MaxDuration) or 30000

    duration = math.floor(duration)
    if duration < minimum then duration = minimum end
    if duration > maximum then duration = maximum end
    return duration
end

local function looksLikeImagePath(value)
    if type(value) ~= 'string' then return false end
    local lower = value:lower()
    return lower:find('%.png$', 1, false)
        or lower:find('%.jpg$', 1, false)
        or lower:find('%.jpeg$', 1, false)
        or lower:find('%.webp$', 1, false)
        or lower:find('^https?://')
        or lower:find('^nui://')
end

local function normalizePayload(text, textType, duration, title)
    local config = notifyConfig()
    local payload = type(text) == 'table' and text or {
        description = text,
        type = textType,
        duration = duration,
        title = title,
    }

    local notificationType = normalizeType(payload.type or textType)
    local profile = typeProfile(notificationType)

    local resolvedTitle = payload.title
    local resolvedDescription = payload.description or payload.message or payload.text or payload.subtitle

    -- QBCore-style notifications frequently put the complete message in title.
    if (resolvedDescription == nil or tostring(resolvedDescription) == '') and resolvedTitle ~= nil then
        resolvedDescription = resolvedTitle
        resolvedTitle = nil
    end

    resolvedDescription = tostring(resolvedDescription or '')
    resolvedTitle = tostring(resolvedTitle or profile.title or config.DefaultTitle or 'NODE7')

    if resolvedDescription == '' then
        resolvedDescription = resolvedTitle
        resolvedTitle = tostring(profile.title or config.DefaultTitle or 'NODE7')
    end

    notificationSequence = notificationSequence + 1

    return {
        id = tostring(payload.id or ('node7-' .. notificationSequence)),
        title = resolvedTitle,
        description = resolvedDescription,
        type = notificationType,
        duration = clampDuration(payload.duration or duration),
        image = tostring(payload.image or payload.portrait or profile.image or config.DefaultImage or 'images/default-portrait.png'),
        soundDict = tostring(payload.soundDict or payload.audioRef or profile.soundDict or config.DefaultSoundDict or DEFAULT_SOUND_DICT),
        soundName = tostring(payload.soundName or payload.audioName or profile.soundName or config.DefaultSoundName or DEFAULT_SOUND_NAME),
        silent = payload.silent == true or profile.silent == true or config.EnableSound == false,
    }
end

local function playNotificationSound(notification)
    if notification.silent or notification.soundName == '' or notification.soundDict == '' then
        return
    end

    local ok, err = pcall(function()
        Citizen.InvokeNative(
            PLAY_SOUND_FRONTEND_NATIVE,
            -1,
            notification.soundName,
            notification.soundDict,
            true
        )
    end)

    if not ok and notifyConfig().DevelopmentMode then
        print(('[node7-core] Notification sound failed: %s'):format(tostring(err)))
    end
end

local function showNotification(notification)
    SendNUIMessage({
        action = 'show',
        notification = {
            id = notification.id,
            title = notification.title,
            description = notification.description,
            type = notification.type,
            duration = notification.duration,
            image = notification.image,
        }
    })

    playNotificationSound(notification)
    return true
end

---Display the NODE7 western left-side notification UI.
---@param text string|table
---@param textType? string
---@param duration? number
---@param title? string
---@return boolean success
function Node7Core.Functions.Notify(text, textType, duration, title)
    return showNotification(normalizePayload(text, textType, duration, title))
end

---Backward-compatible explicit left notification wrapper.
---@param title string
---@param description string
---@param iconDict? string Ignored unless it is an image path.
---@param icon? string Used as an image only when it is a file/URL path.
---@param duration? number
---@param color? string Retained for compatibility.
---@param soundDict? string
---@param soundName? string
---@return boolean success
function Node7Core.Functions.NotifyLeft(title, description, iconDict, icon, duration, color, soundDict, soundName)
    local image
    if looksLikeImagePath(icon) then
        image = icon
    elseif looksLikeImagePath(iconDict) then
        image = iconDict
    end

    return Node7Core.Functions.Notify({
        title = title,
        description = description,
        image = image,
        duration = duration,
        type = 'info',
        soundDict = soundDict,
        soundName = soundName,
    })
end

---Display the screenshot-style ALERT!! notification.
---@param description string
---@param duration? number
---@param title? string
---@param iconDict? string Ignored unless it is an image path.
---@param icon? string Used as an image only when it is a file/URL path.
---@return boolean success
function Node7Core.Functions.NotifyAlert(description, duration, title, iconDict, icon)
    local config = notifyConfig()
    local image
    if looksLikeImagePath(icon) then
        image = icon
    elseif looksLikeImagePath(iconDict) then
        image = iconDict
    end

    return Node7Core.Functions.Notify({
        title = title or config.AlertTitle or 'ALERT!!',
        description = description,
        duration = duration or config.AlertDuration or config.DefaultDuration,
        image = image or config.AlertImage or config.DefaultImage,
        type = 'alert',
        soundDict = config.AlertSoundDict or config.DefaultSoundDict or DEFAULT_SOUND_DICT,
        soundName = config.AlertSoundName or config.DefaultSoundName or DEFAULT_SOUND_NAME,
    })
end

local function registerNotificationEvent(eventName)
    RegisterNetEvent(eventName, function(text, textType, duration, title)
        Node7Core.Functions.Notify(text, textType, duration, title)
    end)
end

registerNotificationEvent('Node7Core:Notify')
registerNotificationEvent('Node7Core:Client:Notify')
registerNotificationEvent('node7-core:client:Notify')
registerNotificationEvent('node7-core:Notify')

local function registerNotifyLeftEvent(eventName)
    RegisterNetEvent(eventName, function(title, description, iconDict, icon, duration, color, soundDict, soundName)
        Node7Core.Functions.NotifyLeft(title, description, iconDict, icon, duration, color, soundDict, soundName)
    end)
end

registerNotifyLeftEvent('Node7Core:NotifyLeft')
registerNotifyLeftEvent('Node7Core:Client:NotifyLeft')
registerNotifyLeftEvent('node7-core:client:NotifyLeft')
registerNotifyLeftEvent('node7-core:NotifyLeft')

local function registerNotifyAlertEvent(eventName)
    RegisterNetEvent(eventName, function(description, duration, title, iconDict, icon)
        Node7Core.Functions.NotifyAlert(description, duration, title, iconDict, icon)
    end)
end

registerNotifyAlertEvent('Node7Core:NotifyAlert')
registerNotifyAlertEvent('Node7Core:Client:NotifyAlert')
registerNotifyAlertEvent('node7-core:client:NotifyAlert')
registerNotifyAlertEvent('node7-core:NotifyAlert')

RegisterNetEvent('node7-core:client:ClearNotifications', function()
    SendNUIMessage({ action = 'clear' })
end)

exports('Notify', Node7Core.Functions.Notify)
exports('NotifyLeft', Node7Core.Functions.NotifyLeft)
exports('NotifyAlert', Node7Core.Functions.NotifyAlert)

local config = notifyConfig()
if config.EnableTestCommand ~= false then
    RegisterCommand(config.TestCommand or 'node7notifytest', function()
        Node7Core.Functions.NotifyAlert(
            'Your alert was sent! You can use /alertcancel if you do not need help anymore.',
            7000,
            'ALERT!!'
        )
    end, false)
end
