local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}
local QBCore = exports['qb-core']:GetCoreObject()
local started = false
local displayed = false
local progress = 0
local CurrentVehicle 
local pause = false
local selection = 0
local quality = 0

local LastCar

RegisterNetEvent('pkl:showCountryWelcome')
AddEventHandler('pkl:showCountryWelcome', function(text)
    Notif(text)
end)
function Notif( text )
    SetNotificationTextEntry( "STRING" )
    AddTextComponentString( text )
    DrawNotification( false, false )
end

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

RegisterNetEvent('esx_methcar:stop')
AddEventHandler('esx_methcar:stop', function()
	started = false
	DisplayHelpText("~r~生产停止...")
	FreezeEntityPosition(LastCar, false)
end)
RegisterNetEvent('esx_methcar:stopfreeze')
AddEventHandler('esx_methcar:stopfreeze', function(id)
	FreezeEntityPosition(id, false)
end)
RegisterNetEvent('esx_methcar:notify')
AddEventHandler('esx_methcar:notify', function(message)
	ESX.ShowNotification(message)
end)

RegisterNetEvent('esx_methcar:startprod')
AddEventHandler('esx_methcar:startprod', function()
	DisplayHelpText("~g~开始生产")
	started = true
	FreezeEntityPosition(CurrentVehicle,true)
	displayed = false
	print('开始生产冰毒')
	ESX.ShowNotification("~r~冰毒生产已经开始")	
	SetPedIntoVehicle(GetPlayerPed(-1), CurrentVehicle, 3)
	SetVehicleDoorOpen(CurrentVehicle, 2)
end)

RegisterNetEvent('esx_methcar:blowup')
AddEventHandler('esx_methcar:blowup', function(posx, posy, posz)
	AddExplosion(posx, posy, posz + 2,23, 20.0, true, false, 1.0, true)
	if not HasNamedPtfxAssetLoaded("core") then
		RequestNamedPtfxAsset("core")
		while not HasNamedPtfxAssetLoaded("core") do
			Citizen.Wait(1)
		end
	end
	SetPtfxAssetNextCall("core")
	local fire = StartParticleFxLoopedAtCoord("ent_ray_heli_aprtmnt_l_fire", posx, posy, posz-0.8 , 0.0, 0.0, 0.0, 0.8, false, false, false, false)
	Citizen.Wait(6000)
	StopParticleFxLooped(fire, 0)
	
end)


RegisterNetEvent('esx_methcar:smoke')
AddEventHandler('esx_methcar:smoke', function(posx, posy, posz, bool)

	if bool == 'a' then

		if not HasNamedPtfxAssetLoaded("core") then
			RequestNamedPtfxAsset("core")
			while not HasNamedPtfxAssetLoaded("core") do
				Citizen.Wait(1)
			end
		end
		SetPtfxAssetNextCall("core")
		local smoke = StartParticleFxLoopedAtCoord("exp_grd_flare", posx, posy, posz + 1.7, 0.0, 0.0, 0.0, 2.0, false, false, false, false)
		SetParticleFxLoopedAlpha(smoke, 0.8)
		SetParticleFxLoopedColour(smoke, 0.0, 0.0, 0.0, 0)
		Citizen.Wait(22000)
		StopParticleFxLooped(smoke, 0)
	else
		StopParticleFxLooped(smoke, 0)
	end

end)
RegisterNetEvent('esx_methcar:drugged')
AddEventHandler('esx_methcar:drugged', function()
	SetTimecycleModifier("drug_drive_blend01")
	SetPedMotionBlur(GetPlayerPed(-1), true)
	SetPedMovementClipset(GetPlayerPed(-1), "MOVE_M@DRUNK@SLIGHTLYDRUNK", true)
	SetPedIsDrunk(GetPlayerPed(-1), true)

	Citizen.Wait(300000)
	ClearTimecycleModifier()
end)



Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		
		playerPed = GetPlayerPed(-1)
		local pos = GetEntityCoords(GetPlayerPed(-1))
		if IsPedInAnyVehicle(playerPed) then
			
			
			CurrentVehicle = GetVehiclePedIsUsing(PlayerPedId())

			car = GetVehiclePedIsIn(playerPed, false)
			LastCar = GetVehiclePedIsUsing(playerPed)
	
			local model = GetEntityModel(CurrentVehicle)
			local modelName = GetDisplayNameFromVehicleModel(model)
			
			if modelName == 'JOURNEY' and car then
				
					if GetPedInVehicleSeat(car, -1) == playerPed then
						if started == false then
							if displayed == false then
								DisplayHelpText("按 ~INPUT_THROW_GRENADE~ 开始制作药物")
								displayed = true
							end
						end
						if IsControlJustReleased(0, Keys['H']) then
							if pos.y >= 3500 then
								if IsVehicleSeatFree(CurrentVehicle, 3) then
									TriggerServerEvent('esx_methcar:start')	
									progress = 0
									pause = false
									selection = 0
									quality = 0
									
								else
									DisplayHelpText('~r~车子已经有人了')
								end
							else
								ESX.ShowNotification('~r~你离城市太近了, 继续往北走,才能开始生产冰毒')
							end
							
							
							
							
		
						end
					end
					
				
				
			
			end
			
		else

				
				if started then
					started = false
					displayed = false
					TriggerEvent('esx_methcar:stop')
					print('停止制造毒品')
					FreezeEntityPosition(LastCar,false)
				end
		end
		
		if started == true then
			
			if progress < 96 then
				Citizen.Wait(6000)
				if not pause and IsPedInAnyVehicle(playerPed) then
					progress = progress +  1
					ESX.ShowNotification('~r~冰毒生产: ~g~~h~' .. progress .. '%')
					Citizen.Wait(6000) 
				end

				--
				--   EVENT 1
				--
				if progress > 22 and progress < 24 then
					pause = true
					if selection == 0 then
						ESX.ShowNotification('~o~丙烷管漏水,怎么办?')	
						ESX.ShowNotification('~o~1. 使用胶带固定')
						ESX.ShowNotification('~o~2. 就这样吧 ')
						ESX.ShowNotification('~o~3. 换个新的')
						ESX.ShowNotification('~c~请选择任意一个答案(这会影响生产)')
					end
					if selection == 1 then
						print("已选 1")
						ESX.ShowNotification('~r~胶带有点阻止泄漏')
						quality = quality - 3
						pause = false
					end
					if selection == 2 then
						print("已选 2")
						ESX.ShowNotification('~r~丙烷管爆炸了,你搞砸了...')
						TriggerServerEvent('esx_methcar:blow', pos.x, pos.y, pos.z)
						SetVehicleEngineHealth(CurrentVehicle, 0.0)
						quality = 0
						started = false
						displayed = false
						ApplyDamageToPed(GetPlayerPed(-1), 10, false)
						print('停止制造毒品')
					end
					if selection == 3 then
						print("已选 3")
						ESX.ShowNotification('~r~做得好, 管道状况良好')
						pause = false
						quality = quality + 5
					end
				end
				--
				--   EVENT 5
				--
				if progress > 30 and progress < 32 then
					pause = true
					if selection == 0 then
						ESX.ShowNotification('~o~你把一瓶丙酮在地上, 你要怎么处理?')	
						ESX.ShowNotification('~o~1. 打开窗户去除异味')
						ESX.ShowNotification('~o~2. 就这样吧')
						ESX.ShowNotification('~o~3. 戴上带空气过滤器的口罩')
						ESX.ShowNotification('~c~请选择任意一个答案(这会影响生产)')
					end
					if selection == 1 then
						print("已选 1")
						ESX.ShowNotification('~r~你打开窗户去除异味')
						quality = quality - 1
						pause = false
					end
					if selection == 2 then
						print("已选 2")
						ESX.ShowNotification('~r~你因吸入过多丙酮而兴奋不已')
						pause = false
						TriggerEvent('esx_methcar:drugged')
					end
					if selection == 3 then
						print("已选 3")
						ESX.ShowNotification('~r~这是解决问题的简单方法.. 我猜')
						SetPedPropIndex(playerPed, 1, 26, 7, true)
						pause = false
					end
				end
				--
				--   EVENT 2
				--
				if progress > 38 and progress < 40 then
					pause = true
					if selection == 0 then
						ESX.ShowNotification('~o~冰毒变固体太快, 你要怎么处理? ')	
						ESX.ShowNotification('~o~1. 提高压力')
						ESX.ShowNotification('~o~2. 提高温度')
						ESX.ShowNotification('~o~3. 降低压力')
						ESX.ShowNotification('~c~请选择任意一个答案(这会影响生产)')
					end
					if selection == 1 then
						print("已选 1")
						ESX.ShowNotification('~r~你提高了压力,丙烷开始溢出,你立刻又降低了到初始值,现在没问题')
						pause = false
					end
					if selection == 2 then
						print("已选 2")
						ESX.ShowNotification('~r~提高温度有帮助...')
						quality = quality + 5
						pause = false
					end
					if selection == 3 then
						print("已选 3")
						ESX.ShowNotification('~r~降低压力只会让情况变得更糟...')
						pause = false
						quality = quality -4
					end
				end
				--
				--   EVENT 8 - 3
				--
				if progress > 41 and progress < 43 then
					pause = true
					if selection == 0 then
						ESX.ShowNotification('~o~你不小心倒了太多丙酮, 你要怎么处理?')	
						ESX.ShowNotification('~o~1. 没做什么')
						ESX.ShowNotification('~o~2. 尝试用注射器吸出来')
						ESX.ShowNotification('~o~3. 添加更多的麻黄碱来平衡它')
						ESX.ShowNotification('~c~请选择任意一个答案(这会影响生产)')
					end
					if selection == 1 then
						print("已选 1")
						ESX.ShowNotification('~r~冰毒闻起来不像丙酮')
						quality = quality - 3
						pause = false
					end
					if selection == 2 then
						print("已选 2")
						ESX.ShowNotification('~r~它有点奏效,但还是太多了')
						pause = false
						quality = quality - 1
					end
					if selection == 3 then
						print("已选 3")
						ESX.ShowNotification('~r~你成功地平衡了这两种化学物质,它又好了')
						pause = false
						quality = quality + 3
					end
				end
				--
				--   EVENT 3
				--
				if progress > 46 and progress < 49 then
					pause = true
					if selection == 0 then
						ESX.ShowNotification('~o~你发现了一些水彩, 你要怎么处理?')	
						ESX.ShowNotification('~o~1. 加进去')
						ESX.ShowNotification('~o~2. 把它扔掉')
						ESX.ShowNotification('~o~3. 喝吧')
						ESX.ShowNotification('~c~请选择任意一个答案(这会影响生产)')
					end
					if selection == 1 then
						print("已选 1")
						ESX.ShowNotification('~r~好主意,人们喜欢颜色')
						quality = quality + 4
						pause = false
					end
					if selection == 2 then
						print("已选 2")
						ESX.ShowNotification('~r~是的,它可能会破坏冰毒的味道')
						pause = false
					end
					if selection == 3 then
						print("已选 3")
						ESX.ShowNotification('~r~你有点奇怪,头晕,但一切都很好')
						pause = false
					end
				end
				--
				--   EVENT 4
				--
				if progress > 55 and progress < 58 then
					pause = true
					if selection == 0 then
						ESX.ShowNotification('~o~过滤器堵塞, 你要怎么处理?')	
						ESX.ShowNotification('~o~1. 使用压缩空气清洁')
						ESX.ShowNotification('~o~2. 更换过滤器')
						ESX.ShowNotification('~o~3. 用牙刷清洁')
						ESX.ShowNotification('~c~请选择任意一个答案(这会影响生产)')
					end
					if selection == 1 then
						print("已选 1")
						ESX.ShowNotification('~r~压缩空气将液态冰毒喷洒在你身上')
						quality = quality - 2
						pause = false
					end
					if selection == 2 then
						print("已选 2")
						ESX.ShowNotification('~r~更换它可能是最好的选择')
						pause = false
						quality = quality + 3
					end
					if selection == 3 then
						print("已选 3")
						ESX.ShowNotification('~r~这工作得很好,但它仍然有点脏')
						pause = false
						quality = quality - 1
					end
				end
				--
				--   EVENT 5
				--
				if progress > 58 and progress < 60 then
					pause = true
					if selection == 0 then
						ESX.ShowNotification('~o~你把一瓶丙酮在地上, 你要怎么处理?')	
						ESX.ShowNotification('~o~1. 打开窗户去除异味')
						ESX.ShowNotification('~o~2. 就这样吧')
						ESX.ShowNotification('~o~3. 戴上带空气过滤器的口罩')
						ESX.ShowNotification('~c~请选择任意一个答案(这会影响生产)')
					end
					if selection == 1 then
						print("已选 1")
						ESX.ShowNotification('~r~你打开窗户去除异味')
						quality = quality - 1
						pause = false
					end
					if selection == 2 then
						print("已选 2")
						ESX.ShowNotification('~r~你因吸入过多丙酮而兴奋不已')
						pause = false
						TriggerEvent('esx_methcar:drugged')
					end
					if selection == 3 then
						print("已选 3")
						ESX.ShowNotification('~r~这是解决问题的简单方法.. 我猜')
						SetPedPropIndex(playerPed, 1, 26, 7, true)
						pause = false
					end
				end
				--
				--   EVENT 1 - 6
				--
				if progress > 63 and progress < 65 then
					pause = true
					if selection == 0 then
						ESX.ShowNotification('~o~丙烷管漏水, 你要怎么处理?')	
						ESX.ShowNotification('~o~1. 使用胶带固定')
						ESX.ShowNotification('~o~2. 就这样吧 ')
						ESX.ShowNotification('~o~3. 换个新的')
						ESX.ShowNotification('~c~请选择任意一个答案(这会影响生产)')
					end
					if selection == 1 then
						print("已选 1")
						ESX.ShowNotification('~r~胶带有点阻止泄漏')
						quality = quality - 3
						pause = false
					end
					if selection == 2 then
						print("已选 2")
						ESX.ShowNotification('~r~丙烷管爆炸了,你搞砸了...')
						TriggerServerEvent('esx_methcar:blow', pos.x, pos.y, pos.z)
						SetVehicleEngineHealth(CurrentVehicle, 0.0)
						quality = 0
						started = false
						displayed = false
						ApplyDamageToPed(GetPlayerPed(-1), 10, false)
						print('停止制造毒品')
					end
					if selection == 3 then
						print("已选 3")
						ESX.ShowNotification('~r~做的好, 管道状况良好')
						pause = false
						quality = quality + 5
					end
				end
				--
				--   EVENT 4 - 7
				--
				if progress > 71 and progress < 73 then
					pause = true
					if selection == 0 then
						ESX.ShowNotification('~o~过滤器堵塞, 你要怎么处理?')	
						ESX.ShowNotification('~o~1. 使用压缩空气清洁')
						ESX.ShowNotification('~o~2. 更换过滤器')
						ESX.ShowNotification('~o~3. 用牙刷清洁')
						ESX.ShowNotification('~c~请选择任意一个答案(这会影响生产)')
					end
					if selection == 1 then
						print("已选 1")
						ESX.ShowNotification('~r~压缩空气将液态冰毒喷洒在你身上')
						quality = quality - 2
						pause = false
					end
					if selection == 2 then
						print("已选 2")
						ESX.ShowNotification('~r~更换它可能是最好的选择')
						pause = false
						quality = quality + 3
					end
					if selection == 3 then
						print("已选 3")
						ESX.ShowNotification('~r~这工作得很好,但它仍然有点脏')
						pause = false
						quality = quality - 1
					end
				end
				--
				--   EVENT 8
				--
				if progress > 76 and progress < 78 then
					pause = true
					if selection == 0 then
						ESX.ShowNotification('~o~你不小心倒了太多丙酮, 你要怎么处理?')	
						ESX.ShowNotification('~o~1. 没做什么')
						ESX.ShowNotification('~o~2. 尝试用注射器吸出来')
						ESX.ShowNotification('~o~3. 添加更多的麻黄碱来平衡它')
						ESX.ShowNotification('~c~请选择任意一个答案(这会影响生产)')
					end
					if selection == 1 then
						print("已选 1")
						ESX.ShowNotification('~r~冰毒闻起来不像丙酮')
						quality = quality - 3
						pause = false
					end
					if selection == 2 then
						print("已选 2")
						ESX.ShowNotification('~r~它有点奏效,但还是太多了')
						pause = false
						quality = quality - 1
					end
					if selection == 3 then
						print("已选 3")
						ESX.ShowNotification('~r~你成功地平衡了这两种化学物质,它又好了')
						pause = false
						quality = quality + 3
					end
				end
				--
				--   EVENT 9
				--
				if progress > 82 and progress < 84 then
					pause = true
					if selection == 0 then
						ESX.ShowNotification('~o~你需要拉屎, 你要怎么处理?')	
						ESX.ShowNotification('~o~1. 试着堵住它')
						ESX.ShowNotification('~o~2. 到外面拉屎')
						ESX.ShowNotification('~o~3. 在车里拉屎')
						ESX.ShowNotification('~c~请选择任意一个答案(这会影响生产)')
					end
					if selection == 1 then
						print("已选 1")
						ESX.ShowNotification('~r~干得好,你得先工作,再拉屎')
						quality = quality + 1
						pause = false
					end
					if selection == 2 then
						print("已选 2")
						ESX.ShowNotification('~r~当你在外面时,试管从桌子上掉下来,洒在地板上...')
						pause = false
						quality = quality - 2
					end
					if selection == 3 then
						print("已选 3")
						ESX.ShowNotification('~r~空气现在闻起来像屎,冰毒现在闻起来像屎')
						pause = false
						quality = quality - 1
					end
				end
				--
				--   EVENT 10
				--
				if progress > 88 and progress < 90 then
					pause = true
					if selection == 0 then
						ESX.ShowNotification('~o~你在试管中加了一些冰毒碎片,这样看起来你会有更多?')	
						ESX.ShowNotification('~o~1. 是的!')
						ESX.ShowNotification('~o~2. 不是')
						ESX.ShowNotification('~o~3. 如果我将冰毒添加到试管中会怎样?')
						ESX.ShowNotification('~c~请选择任意一个答案(这会影响生产)')
					end
					if selection == 1 then
						print("已选 1")
						ESX.ShowNotification('~r~现在你有更多的袋子了')
						quality = quality + 1
						pause = false
					end
					if selection == 2 then
						print("已选 2")
						ESX.ShowNotification('~r~你是一个很好的制药商, 你的产品质量高')
						pause = false
						quality = quality + 1
					end
					if selection == 3 then
						print("已选 3")
						ESX.ShowNotification('~r~这有点太多了, 它的试管比冰毒多,但还可以')
						pause = false
						quality = quality - 1
					end
				end
				
				
				
				
				
				
				
				if IsPedInAnyVehicle(playerPed) then
					TriggerServerEvent('esx_methcar:make', pos.x,pos.y,pos.z)
					if pause == false then
						selection = 0
						quality = quality + 1
						progress = progress +  math.random(1, 2)
						ESX.ShowNotification('~r~冰毒生产: ~g~~h~' .. progress .. '%')
					end
				else
					TriggerEvent('esx_methcar:stop')
				end

			else
				TriggerEvent('esx_methcar:stop')
				progress = 100
				ESX.ShowNotification('~r~冰毒生产: ~g~~h~' .. progress .. '%')
				ESX.ShowNotification('~g~~h~生产完成')
				TriggerServerEvent('esx_methcar:finish', quality)
				FreezeEntityPosition(LastCar, false)
			end	
			
		end
		
	end
end)
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
			if IsPedInAnyVehicle(GetPlayerPed(-1)) then
			else
				if started then
					started = false
					displayed = false
					TriggerEvent('esx_methcar:stop')
					print('停止制造毒品')
					FreezeEntityPosition(LastCar,false)
				end		
			end
	end

end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)		
		if pause == true then
			if IsControlJustReleased(0, Keys['1']) then
				selection = 1
				ESX.ShowNotification('~g~选择的选项编号 1')
			end
			if IsControlJustReleased(0, Keys['2']) then
				selection = 2
				ESX.ShowNotification('~g~选择的选项编号 2')
			end
			if IsControlJustReleased(0, Keys['3']) then
				selection = 3
				ESX.ShowNotification('~g~选择的选项编号 3')
			end
		end

	end
end)




