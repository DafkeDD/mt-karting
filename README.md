# mt-karting
Simple karting tickets system for QBCore

# Preivew: 
- https://youtu.be/tAa4WKA4v1w

# Installation:

Add to qb-core/server/events.lua:
```
RegisterNetEvent('QBCore:Server:RemoveMoney', function(acount, amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    Player.Functions.RemoveMoney(acount, amount)
end)

RegisterNetEvent('QBCore:Server:AddMoney', function(acount, amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    Player.Functions.AddMoney(acount, amount)
end)
```
