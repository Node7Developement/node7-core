local function send(action, data)
    SendNUIMessage({ action = action, data = data })
end

local function DrawText(text, position)
    send('drawtext', { text = tostring(text or ''), position = position or 'left' })
end

local function ChangeText(text, position)
    DrawText(text, position)
end

local function HideText()
    send('drawtext:hide')
end

local function KeyPressed()
    send('drawtext:key')
end

RegisterNetEvent('node7:client:drawText', DrawText)
RegisterNetEvent('node7:client:changeText', ChangeText)
RegisterNetEvent('node7:client:hideText', HideText)
RegisterNetEvent('node7:client:keyPressed', KeyPressed)

exports('DrawText', DrawText)
exports('ChangeText', ChangeText)
exports('HideText', HideText)
exports('KeyPressed', KeyPressed)
