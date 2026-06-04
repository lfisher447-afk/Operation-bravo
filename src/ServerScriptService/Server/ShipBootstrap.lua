local ReplicatedStorage = game:GetService('ReplicatedStorage')
local flightEvents = Instance.new('Folder', ReplicatedStorage)
flightEvents.Name = 'FlightEvents'
local shipEvent = Instance.new('RemoteEvent', flightEvents)
shipEvent.Name = 'ShipEvent'
print('[FLIGHT] Flight remote systems built.')