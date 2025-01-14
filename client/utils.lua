function SendReactMessage(action, data)
    SendNUIMessage({
        action = action,
        data = data
    })
end

function SetNUIVisibility(shouldShow)
    SetNuiFocus(shouldShow, false)
    SetNuiFocusKeepInput(true)
    SendReactMessage('setVisible', shouldShow)
end
