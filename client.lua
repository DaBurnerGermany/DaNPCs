local requestedModels = {}
local npcsSpawned = {}

Citizen.CreateThread(function()
	for key, values in pairs(Config.NPCs) do

		local model = GetHashKey(values.model)

		if requestedModels[model] == nil then
			RequestModel(model)
			while not HasModelLoaded(model) do
				Wait(1)
			end

			requestedModels[model] = true
		end


		local npc = CreatePed(4, model, values.x, values.y, values.z, values.heading, false, true)

		table.insert(npcsSpawned, npc)
		
		SetEntityHeading(npc, values.heading)
		if values.freezePos then 
			FreezeEntityPosition(npc, true)
		end 
		if values.canDie == false then 
			SetEntityInvincible(npc, true)
		end 
		
		if values.reactToSurrounding == false then 
			SetBlockingOfNonTemporaryEvents(npc, true)
		end 
	end
	
end)

AddEventHandler('onResourceStop', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
	  --print("not  "..tostring(resourceName))
	  return
	end
	
	for key, npc in pairs(npcsSpawned) do
		DeletePed(npc)
	end
  
  	npcsSpawned = {}
	
	print('The resource ' .. resourceName .. ' was stopped.')
  end)