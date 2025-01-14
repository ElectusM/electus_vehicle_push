Config = {
    damageNeeded = 100.0, -- min damage needed to push
    steeringAnglePer100ms = 1.0,
    restRatioBetweenPushes = 0.5, -- 0.5 means 50% of the last push the player has to wait until pushing again, set to 0.0 if you do not want any rest
    skillbarDuration = 20000, -- 20 seconds higher = easier
    defaultKeys = {
        steerLeft = 'A',
        steerRight = 'D',
        pushVehicle = 'W',
        pushVehicleSecondary = 'LSHIFT' -- first required key for push
    }
}