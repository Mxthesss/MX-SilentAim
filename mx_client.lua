CreateThread(function()
	while true do
        Wait(10000)		
        local model = GetEntityModel(PlayerPedId())
		local min, max 	= GetModelDimensions(model)
		if min.y < -0.29 or max.z > 0.98 then
			TriggerServerEvent("mxantiaim:log")
		end
	end
end)

Citizen.CreateThread(function()
    Citizen.Wait(5000)
    local resName = GetCurrentResourceName()
    local havePermission = false
    local customer = nil
    local actual_server_ip

    if resName ~= "MX-SilentAim" then
        print("^2["..resName.."] - IT WAS NOT STARTED CORRECTLY.")
        print("^2["..resName.."] - THE RESOURCE NAME MUST BE MX-SilentAim")
        Stop_Resource()
    end)

print('^5Made By Dev^7: ^1'..GetCurrentResourceName()..'^7 started ^2successfully^7...') 