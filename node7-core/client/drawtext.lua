local positions = {
    left = 'left-center',
    right = 'right-center',
    top = 'top-center'
}

local currentText = nil
local currentPosition = nil
local requestedVisible = false

local function resolvePos(pos)
    return positions[pos] or pos or 'right-center'
end

local function pauseMenuOpen()
    return Node7Core.UI and Node7Core.UI.IsPauseMenuOpen and Node7Core.UI.IsPauseMenuOpen()
end

local function renderCurrentText()
    if not requestedVisible or currentText == nil or pauseMenuOpen() then
        lib.hideTextUI()
        return
    end

    lib.showTextUI(currentText, {
        position = resolvePos(currentPosition)
    })
end

local function showText(text, pos)
    currentText = text
    currentPosition = pos
    requestedVisible = true
    renderCurrentText()
end

local function updateText(text, pos)
    currentText = text
    currentPosition = pos
    requestedVisible = true
    lib.hideTextUI()
    renderCurrentText()
end

local function hideText()
    requestedVisible = false
    currentText = nil
    currentPosition = nil
    lib.hideTextUI()
end

local function keyPressed()
    hideText()
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

AddEventHandler('Node7Core:Client:PauseMenuStateChanged', function(isOpen)
    if isOpen then
        lib.hideTextUI()
    else
        renderCurrentText()
    end
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
