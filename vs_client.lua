CurrentWeather = 'Sunny'
local lastWeather = CurrentWeather
local baseTime = 0
local timeOffset = 0
local timer = 0
local freezeTime = false
local blackout = false

RegisterNetEvent('vSync:updateWeather')
AddEventHandler('vSync:updateWeather', function(NewWeather, newblackout)
    CurrentWeather = NewWeather
    blackout = newblackout
end)

Citizen.CreateThread(function()
    while true do
        if lastWeather ~= CurrentWeather then
            lastWeather = CurrentWeather
            --SetWeatherTypeOverTime(CurrentWeather, 15.0)
            --Citizen.Wait(15000)
        end
        Citizen.Wait(100) -- Wait 0 seconds to prevent crashing.
       -- SetBlackout(blackout)
        --ClearOverrideWeather()
        --ClearWeatherTypePersist()
        --SetWeatherTypePersist(lastWeather)
        --SetWeatherTypeNow(lastWeather)
        --SetWeatherTypeNowPersist(lastWeather)
        Citizen.InvokeNative(0x59174F1AFE095B5A, GetHashKey(lastWeather), true, false, true, true, false)
    end
end)

RegisterNetEvent('vSync:updateTime')
AddEventHandler('vSync:updateTime', function(base, offset, freeze)
    freezeTime = freeze
    timeOffset = offset
    baseTime = base
end)

Citizen.CreateThread(function()
    local hour = 0
    local minute = 0
    while true do
        Citizen.Wait(0)
        local newBaseTime = baseTime
        if GetGameTimer() - 500  > timer then
            newBaseTime = newBaseTime + 0.25
            timer = GetGameTimer()
        end
        if freezeTime then
            timeOffset = timeOffset + baseTime - newBaseTime			
        end
        baseTime = newBaseTime
        hour = math.floor(((baseTime+timeOffset)/60)%24)
        minute = math.floor((baseTime+timeOffset)%60)
        SetClockTime(hour, minute, 0)
        AdvanceClockTimeTo(hour, minute, 0)
        NetworkClockTimeOverride(hour, minute, 0, 0, true)
        NetworkClockTimeOverride_2(hour, minute, 0, 0, true, true)
    end
end)

AddEventHandler('playerSpawned', function()
    TriggerServerEvent('vSync:requestSync')
end)

Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/weather', 'Change the weather.', {{ name="weatherType", help="Available types: Blizzard, Clouds, Drizzle, Fog, GroundBlizzard, Hail, HighPressure, Hurricane, Misty, Overcast, OvercastDark, Rain, Sandstorm, shower, sleet, snow, snowclearing, snowlight, sunny, thunder, thunderstorm, and whiteout."}})
    TriggerEvent('chat:addSuggestion', '/time', 'Change the time.', {{ name="hours", help="A number between 0 - 23"}, { name="minutes", help="A number between 0 - 59"}})
    TriggerEvent('chat:addSuggestion', '/freezetime', 'Freeze / unfreeze time.')
    TriggerEvent('chat:addSuggestion', '/freezeweather', 'Enable/disable dynamic weather changes.')
    TriggerEvent('chat:addSuggestion', '/morning', 'Set the time to 09:00')
    TriggerEvent('chat:addSuggestion', '/noon', 'Set the time to 12:00')
    TriggerEvent('chat:addSuggestion', '/evening', 'Set the time to 18:00')
    TriggerEvent('chat:addSuggestion', '/night', 'Set the time to 23:00')
    TriggerEvent('chat:addSuggestion', '/blackout', 'Toggle blackout mode.')
end)

-- Display a notification above the minimap.
--function ShowNotification(text, blink)
  --  if blink == nil then blink = false end
  --  SetNotificationTextEntry("STRING")
  --  AddTextComponentSubstringPlayerName(text)
    --DrawNotification(blink, false)
--end

--RegisterNetEvent('vSync:notify')
--AddEventHandler('vSync:notify', function(message)
--    TriggerEvent("vorp:Tip", message, 5000) 
--end)
