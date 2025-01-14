local vehicle = {}
local pushing = false
local startTime = 0
local restUntil = 0
local angle = 0.0

lib.locale()

local steeringLeft = false

local steerLeft = lib.addKeybind({
    name = 'steer_left',
    description = locale('steer_left_desc'),
    disabled = true,
    defaultKey = 'A',
    onPressed = function(self)
        if (not vehicle.entity) then return end
        steeringLeft = true

        while (steeringLeft) do
            Wait(100)
            if(angle > 60.0) then
                angle = 60.0
            end
            angle = angle + Config.steeringAnglePer100ms
        end
    end,
    onReleased = function(self)
        steeringLeft = false
    end
})

local steeringRight = false

local steerRight = lib.addKeybind({
    name = 'steer_right',
    description = locale('steer_right_desc'),
    disabled = true,
    defaultKey = 'D',
    onPressed = function(self)
        if (not vehicle.entity) then return end
        steeringRight = true

        while (steeringRight) do
            Wait(100)
            if (angle < -60.0) then
                angle = -60.0
            end
            angle = angle - Config.steeringAnglePer100ms
        end
    end,
    onReleased = function(self)
        steeringRight = false
    end
})

local secondaryButton = false

local secondaryKey = lib.addKeybind({
    name = 'secondary_push',
    description = locale('secondary_button_desc'),
    defaultKey = 'LSHIFT',
    onPressed = function(self)
        secondaryButton = true
    end,
    onReleased = function(self)
        secondaryButton = false
    end
})

function StopPushing()
    SendReactMessage('skillbar', {duration = Config.skillbarDuration, on = false})

    steerLeft:disable(true)
    steerRight:disable(true)

    SetNUIVisibility(false)
    ClearPedTasks(PlayerPedId())
    DetachEntity(PlayerPedId(), false, false)
    pushing = false
    restUntil = GetGameTimer() + Config.restRatioBetweenPushes * (GetGameTimer() - startTime)
end

local pushVehicle = lib.addKeybind({
    name = 'push_vehicle',
    description = 'Push the vehicle',
    defaultKey = 'W',
    onPressed = function(self)
        if (not vehicle.entity) then return end

        if (not secondaryButton) then
            return
        end

        if (restUntil > GetGameTimer()) then
            lib.notify({
                title = locale("push_vehicle_title"),
                description = locale("push_vehicle_delay", math.floor((restUntil - GetGameTimer()) / 1000)),
                type = 'error'
            })
            return
        end

        angle = GetVehicleSteeringAngle(vehicle.entity)
        steerLeft:disable(false)
        steerRight:disable(false)

        if (vehicle.back) then
            AttachEntityToEntity(PlayerPedId(), vehicle.entity, GetPedBoneIndex(PlayerPedId(), 6286), 0.0, -vehicle.dimensions.y, 0.5, 0.0, 0.0, 0.0, 0.0, false, false, true, false, true)
        else
            AttachEntityToEntity(PlayerPedId(), vehicle.entity, GetPedBoneIndex(PlayerPedId(), 6286), 0.0, vehicle.dimensions.y, 0.5, 0.0, 0.0, 180.0, 0.0, false, false, true, false, true)
        end

        lib.requestAnimDict("missfinale_c2ig_11", 1000)
        TaskPlayAnim(PlayerPedId(), 'missfinale_c2ig_11', 'pushcar_offcliff_m', 2.0, -8.0, -1, 35, 0, 0, 0, 0)

        startTime = GetGameTimer()
        pushing = true
        SetNUIVisibility(true)
        SendReactMessage('skillbar', {duration = Config.skillbarDuration, on = true})

        while (pushing) do
            DisableControlAction(0, 24, true)

            if (vehicle.back) then
                SetVehicleForwardSpeed(vehicle.entity, 0.9)
            else
                SetVehicleForwardSpeed(vehicle.entity, -0.9)
            end

            SetVehicleSteeringAngle(vehicle.entity, angle)
            Wait(0)
        end
    end,
    onReleased = function(self)
        if (pushing) then
            StopPushing()
        end
    end
})

local pushVehicleString = locale('push_vehicle_text', Config.defaultKeys.pushVehicleSecondary, pushVehicle.currentKey)

function SetCanPush(closestVehicle, dimension)
    local isOpen, text = lib.isTextUIOpen()

    if (not isOpen and text ~= pushVehicleString) then
        lib.showTextUI(pushVehicleString, {
            icon = 'fa-car',
        })
    end

    vehicle.entity = closestVehicle
    vehicle.dimensions = dimension
end

function HandleCloseVehicle()
    local defaultWait = 2000
    local currentWait = defaultWait

    while (true) do
        local ped = PlayerPedId()
        local playerCoords = GetEntityCoords(ped)
        local closestVehicle = GetClosestVehicle(playerCoords.x, playerCoords.y, playerCoords.z, 5.0, 0, 1|2|4|8|16|32|65536)

        if (closestVehicle and GetVehicleEngineHealth(closestVehicle) < Config.damageNeeded) then
            currentWait = 250
            local dimension = GetModelDimensions(GetEntityModel(closestVehicle))
            dimension = vector3(math.abs(dimension.x), math.abs(dimension.y), 0.0)
            local frontCoords = GetOffsetFromEntityInWorldCoords(closestVehicle, 0.0, dimension.y, 0.0)
            local backCoords = GetOffsetFromEntityInWorldCoords(closestVehicle, 0.0, -dimension.y, 0.0)

            if (not IsPedInAnyVehicle(ped, false)) then
                if (#(frontCoords - playerCoords) < 1.5) then
                    vehicle.front = true
                    vehicle.back = false
                    SetCanPush(closestVehicle, dimension)
                elseif (#(backCoords - playerCoords) < 1.5) then
                    vehicle.back = true
                    vehicle.front = false
                    SetCanPush(closestVehicle, dimension)
                else
                    local isOpen, text = lib.isTextUIOpen()

                    if (isOpen and text == pushVehicleString) then
                        lib.hideTextUI()
                    end

                    vehicle.entity = nil
                    vehicle.back = false
                    vehicle.front = false
                    vehicle.coords = vector3(0.0, 0.0, 0.0)
                    vehicle.dimensions = vector3(0.0, 0.0, 0.0)
                end
            end
        else
            currentWait = defaultWait
        end

        Wait(currentWait)
    end
end

RegisterNUICallback("finishedSkillbar", function(data, cb)
    StopPushing()
    cb({})
end)

CreateThread(function()
    HandleCloseVehicle()
end)

