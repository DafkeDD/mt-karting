local QBCore = exports['qb-core']:GetCoreObject()
local Time = 0

CreateThread(function()
    while true do
        Wait(0)
        ClearAreaOfVehicles(-85.162, -2067.108, 21.797, 1000, false, false, false, false, false)
        RemoveVehiclesFromGeneratorsInArea(-85.162 - 90.0, -2067.108 - 90.0, 21 - 90.0, -85.162 + 90.0, 2067.108 + 90.0, 21 + 90.0)
    end
end)

CreateThread(function()
    RequestModel(`hc_driver`)
      while not HasModelLoaded(`hc_driver`) do
      Wait(1)
    end
    KartingPed = CreatePed(2, `hc_driver`, Config.Locations['Ped'], false, false)
    SetPedFleeAttributes(KartingPed, 0, 0)
    SetPedDiesWhenInjured(KartingPed, false)
    TaskStartScenarioInPlace(KartingPed, "missheistdockssetup1clipboard@base", 0, true)
    SetPedKeepTask(KartingPed, true)
    SetBlockingOfNonTemporaryEvents(KartingPed, true)
    SetEntityInvincible(KartingPed, true)
    FreezeEntityPosition(KartingPed, true)
  
    exports['qb-target']:AddBoxZone("KartingPed", Config.Locations['PedTarget'], 1, 1, {
        name="KartingPed",
        heading=0,
        debugpoly = false,
    }, {
        options = {
            {
                event = "mt-karting:client:MenuAluger",
                icon = "fas fa-car",
                label = "Talk to this guy",
            }
        },
        distance = 2.5
    })
        
    local blip = AddBlipForCoord(Config.Locations['PedTarget'])
    
    SetBlipSprite (blip, 38)
    SetBlipDisplay(blip, 2)
    SetBlipScale  (blip, 0.9)
    SetBlipColour (blip, 37)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('Karting')
    EndTextCommandSetBlipName(blip)
end)

RegisterNetEvent('mt-karting:client:MenuAluger', function()
    exports['qb-menu']:openMenu({
        {
            header = Lang.MenuHeader,
            isMenuHeader = true,
        },
        {
            header = Lang.CloseMenu,
            event = "qb-menu:closeMenu",
            icon = "fas fa-times-circle",
        },
        {
            header = Lang.Ticket1,
            txt = Lang.Duration .. Config.Tickets[1].time .. Lang.Minutes .. "<br>" .. Lang.Price .. Config.Tickets[1].price .. "$",
            icon = "fas fa-ticket",
            event = "mt-karting:client:Ticket1",
            params = {
                event = "mt-karting:client:Ticket",
                args = 1
            },
        },
        {
            header = Lang.Ticket2,
            txt = Lang.Duration .. Config.Tickets[2].time .. Lang.Minutes .. "<br>" .. Lang.Price .. Config.Tickets[2].price .. "$",
            icon = "fas fa-ticket",
            event = "mt-karting:client:Ticket",
            params = {
                event = "mt-karting:client:Ticket",
                args = 2
            },
        },
        {
            header = Lang.Ticket3,
            txt = Lang.Duration .. Config.Tickets[3].time .. Lang.Minutes .. "<br>" .. Lang.Price .. Config.Tickets[3].price .. "$",
            icon = "fas fa-ticket",
            params = {
                event = "mt-karting:client:Ticket",
                args = 3
            },
        },
        {
            header = Lang.Ticket4,
            txt = Lang.Duration .. Config.Tickets[4].time .. Lang.Minutes .. "<br>" .. Lang.Price .. Config.Tickets[4].price .. "$",
            icon = "fas fa-ticket",
            event = "mt-karting:client:Ticket",
            params = {
                event = "mt-karting:client:Ticket",
                args = 4
            },
        },
        {
            header = Lang.StopTicket,
            txt = "",
            icon = "fas fa-ticket",
            event = "mt-karting:client:Ticket",
            params = {
                event = "mt-karting:client:Ticket",
                args = 5
            },
        },
    })
end)

local function drawTxt(text, font, x, y, scale, r, g, b, a)
    SetTextFont(font)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextOutline()
    SetTextCentre(1)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

local function DeleteVehicle(Time, veh)
    local Tempo = Time * 1000
    print(Tempo)

    Wait(Tempo)
    DeleteEntity(veh)
    QBCore.Functions.Notify(Lang.Finished, 'primary', 7500)
end

local function SpawnKart(Time)
    local veiculo = Config.Vehicle
    local coords = Config.Locations['KartSpawn']
    local EliminarVeiculo = GetVehiclePedIsIn(PlayerPedId(), true)

    QBCore.Functions.SpawnVehicle(veiculo, function(veh)
        SetVehicleNumberPlateText(veh, "KART"..tostring(math.random(1000, 9999)))
        exports['LegacyFuel']:SetFuel(veh, 100.0)
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
        SetVehicleEngineOn(veh, true, true)
        DeleteVehicle(Time, veh)
    end, coords, true)
end

local function startTimer(Time)
    local gameTimer = GetGameTimer()
    local EliminarVeiculo = GetVehiclePedIsIn(PlayerPedId(), true)
    CreateThread(function()
        while true do
            if GetGameTimer() < gameTimer + tonumber(1000 * Time) then
                local secondsLeft = GetGameTimer() - gameTimer
                drawTxt(Lang.TimeRemaning .. math.ceil(Time - secondsLeft / 1000) .. Lang.Seconds, 4, 0.5, 0.93, 0.50, 255, 255, 255, 180)
            end
            Wait(0)
        end
    end)
end

RegisterNetEvent('mt-karting:client:Ticket', function(args)
    local EliminarVeiculo = GetVehiclePedIsIn(PlayerPedId(), true)

    if args == 1 then
        local time = Config.Tickets[1].time * 60

        TriggerServerEvent('QBCore:Server:RemoveMoney', 'bank', Config.Tickets[1].price)
        Time = time
        startTimer(Time)
        SpawnKart(Time)
    elseif args == 2 then
        local time2 = Config.Tickets[2].time * 60

        TriggerServerEvent('QBCore:Server:RemoveMoney', 'bank', Config.Tickets[2].price)
        Time = time2
        startTimer(Time)
        SpawnKart(Time)
    elseif args == 3 then
        local time3 = Config.Tickets[3].time * 60

        TriggerServerEvent('QBCore:Server:RemoveMoney', 'bank', Config.Tickets[3].price)
        Time = time3
        startTimer(Time)
        SpawnKart(Time)
    elseif args == 4 then
        local time4 = Config.Tickets[4].time * 60

        TriggerServerEvent('QBCore:Server:RemoveMoney', 'bank', Config.Tickets[4].price)
        Time = time4
        startTimer(Time)
        SpawnKart(Time)
    elseif args == 5 then
        DeleteEntity(EliminarVeiculo)
    else
        QBCore.Functions.Notify(Lang.NoActiveTicket, 'error', 7500)
    end
end)
