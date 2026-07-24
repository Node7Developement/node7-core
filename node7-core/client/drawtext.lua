local positions = {
    left = 'left-center',
    right = 'right-center',
    top = 'top-center'
}

local function resolvePos(pos)
    return positions[pos] or pos or 'right-center'
end

local function showText(text, pos)
    lib.showTextUI(text, {
        position = resolvePos(pos)
    })
end

local function updateText(text, pos)
    lib.hideTextUI()
    lib.showTextUI(text, {
        position = resolvePos(pos)
    })
end

local function hideText()
    lib.hideTextUI()
end

local function keyPressed()
    lib.hideTextUI()
end

RegisterNetEvent('node7-core:client:DrawText', function(text, pos)
    showText(text, pos)
end)

RegisterNetEvent('node7-core:client:ChangeText', function(text, pos)
    updateText(text, pos)
end)

RegisterNetEvent('node7-core:client:HideText', function()
    hideText()
end)

RegisterNetEvent('node7-core:client:KeyPressed', function()
    keyPressed()
end)

AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() then
        lib.hideTextUI()
    end
end)

exports('DrawText', showText)
exports('ChangeText', updateText)
exports('HideText', hideText)
exports('KeyPressed', keyPressed)
