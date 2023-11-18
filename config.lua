ESX                             = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

local isJudge = false
local isPolice = false
local isMedic = false
local isDoctor = false
local isNews = false
local isTaksi = false
local isMechanic = false


local isDead = false
local isInstructorMode = false
local isHandcuffed = false
local isHandcuffedAndWalking = false
local hasOxygenTankOn = false
local gangNum = 0
local cuffStates = {}
local HandcuffTimer = {}


rootMenuConfig =  {

    {
        id = "general",
        displayName = "Yleinen",
        icon = "#globe-europe",
        enableMenu = function()
            return not isDead
        end,
        subMenus = {"general:emotes", "general:kartta", "general:suuri", "general:laskut","other:drug", "other:trash", "blips:automaatit", "blips:bensikset", "jaffa:tieto", "jaffa_tuunaukset", "hud:asetukset"}
    },	

	{
        id = "emotet",
        displayName = "Emotet",
        icon = "#expressions",
        enableMenu = function()
            return not isDead
        end,
        subMenus = { "tablet2", "sitchair", "clap", "emote:menu"}
    },
    {
        id = "kimlik",
        displayName = "Henkkarit",
        icon = "#kimlik-islemler",
        enableMenu = function()
            return not isDead
        end,
        subMenus = {"general:henkatso", "general:hennayta", "general:ajokatso", "general:ajonayta"}
    },
    {
        id = "vehicle",
        displayName = "Ajoneuvo",
        icon = "#vehicle-options-vehicle",
        enableMenu = function()
            return not isDead
        end,
		subMenus = {"vehicle:hack", "vehicle:hood","vehicle:trunk", "vehicle:engine", "vehicle:lukitse", "vehicle:ovi0", "vehicle:ovi1", "vehicle:ovi2", "vehicle:ovi3"}
    },
    {
        id = "police-action",
        displayName = "Poliisi",
        icon = "#police-action",
        enableMenu = function()

            return  (isPolice and not isDead)
            
        end,
    
        subMenus = { "poliisi:mdt", "poliisi:saata", "poliisi:siirtolopetus", "poliisi:autoon", "poliisi:autosta", "poliisi:raudoita", "poliisi:raudatpois", "poliisi:laskuta", "poliisi:tarkista", "poliisi:auto", "työ:ilmoitus" }
    },
    {
        id = "emsaction",
        displayName = "Ensihoito",
        icon = "#ensihoito",
        enableMenu = function()
            return (isMedic and not isDead)
        end,
        subMenus = { "ensihoito:tutki", "ensihoito:elvytä", "ensihoito:hoida", "ensihoito:ajoneuvoon" }

    }
}
--"general:kartta", "general:suuri", "general:laskut", "general:onki", "general:henkatso", "general:hennayta", "general:ajokatso", "general:ajonayta" }
newSubMenus = {
--[[
    ['pol:mtd'] = {
        title = "Avaa tietokanta",
        icon = "#kartta",
        functionName = "pol:mtd"
    },

    ['pol:tutka'] = {
        title = "Avaa tutka",
        icon = "#kartta",
        functionName = "pol:tutka"
    },
--]]
	['jaffa_tuunaukset'] = {
        title = "Katso takakonttiin",
        icon = "#ajoneuvo",
        functionName = "trunk:open"
    },

    ['general:emotes'] = {
        title = "Emote Valikko",
        icon = "#general-emotes",
        functionName = "emotevalikko"
    },   
	['general:kartta'] = {
        title = "Hud Menu",
        icon = "#kartta",
        functionName = "hudi"
    },   
	['general:suuri'] = {
        title = "testi",
        icon = "#suuri2",
        functionName = "illenium-appearance:client:OutfitManagementMenu"
    },  
	['general:laskut'] = {
        title = "Laskut",
        icon = "#laskut",
        functionName = "createInvoice"
    },  
	['general:lasku'] = {
        title = "Lasku",
        icon = "#kalasta",
        functionName = "kalasta2"
    }, 
	
	['tablet2'] = {
        title = "Tablet2",
        icon = "#tablet2",
        functionName = "tablet2"
    }, 
    ['emote:menu'] = {
        title = "Emote Menu",
        icon = "#tablet2",
        functionName = "tablet2"
    },  
	
	['clap'] = {
        title = "Clap",
        icon = "#clap",
        functionName = "clap"
    },  
	
	['sitchair'] = {
        title = "Sitchair",
        icon = "#sitchair",
        functionName = "sitchair"
    },  
	
	
	['general:henkatso'] = {
        title = "Katso henkkareita",
        icon = "#kortti",
        functionName = "henkatso"
    }, 
	['general:hennayta'] = {
        title = "Näytä henkkarit",
        icon = "#kortti",
        functionName = "hennayta"
    },  
	['general:ajokatso'] = {
        title = "Katso ajokorttia",
        icon = "#kortti",
        functionName = "ajokatso"
    },  
	['general:ajonayta'] = {
        title = "Näytä ajokortti",
         icon = "#kortti",
        functionName = "ajonayta"
    },    

    ['vehicle:engine'] = {
        title = "Moottori",
        icon = "#vehicle-moottori2",
        functionName = "msk_enginetoggle:Engine"
    },    

	['vehicle:lukitse'] = {
        title = "Lukitse",
        icon = "#lukko",
        functionName = "lukot"
    },

	['vehicle:hood'] = {
        title = "Konepelti",
        icon = "#ajoneuvo",
        functionName = "hood"
    },  

	['vehicle:trunk'] = {
        title = "Takakontti",
        icon = "#ajoneuvo",
        functionName = "trunk"
    }, 
    
    ['vehicle:hack'] = {
        title = "Murtaudu",
        icon = "#ajoneuvo",
        functionName = "johvu:hackero"
    },  

	['vehicle:ovi0'] = {
        title = "Vasen etuovi",
        icon = "#ajoneuvo",
        functionName = "ovi0"
    }, 

	['vehicle:ovi1'] = {
        title = "Oikea etuovi",
        icon = "#ajoneuvo",
        functionName = "ovi1"
    }, 

	['vehicle:ovi2'] = {
        title = "Vasen takaovi",
        icon = "#ajoneuvo",
        functionName = "ovi2"
    },

	['vehicle:ovi3'] = {
        title = "Oikea takaovi",
        icon = "#ajoneuvo",
        functionName = "ovi3"
    }, 

	 ['blips:automaatit'] = {
        title = "Lähin automaatti",
        icon = "#automaatti",
        functionName = "ygx:toggleautomaatti"
    },
	
	['blips:bensikset'] = {
        title = "Lähin bensa-asema",
        icon = "#blips-gasstations",
        functionName = "ygx:togglebensis"
    },

	
	['other:trash'] = {
        title = "Dyykkaa roskista",
        icon = "#globe-europe",
        functionName = "johvu:trash"
    },
    ['työ:ilmoitus'] = {
        title = "ILMOITUS",
        icon = "#tietokanta",
        functionName = "fizzfau-gps:connectGps"
    },
    ['hud:asetukset'] = {
        title = "HUD",
        icon = "#tietokanta",
        functionName = "psmenu"
    },
    --Poliisin Toiminnot
    ['poliisi:mdt'] = {
        title = "MDW",
        icon = "#tietokanta",
        functionName = "mdt:client:OpenMDT"
    },
    ['poliisi:saata'] = {
        title = "Siirrä",
        icon = "#siirrä",
        functionName = "wasabi_police:escortPlayer"
    },
    ['poliisi:autoon'] = {
        title = "Laita Autoon",
        icon = "#autoon",
        functionName = "wasabi_police:inVehiclePlayer"
    },
    ['poliisi:autosta'] = {
        title = "Ota Autosta",
        icon = "#autosta",
        functionName = "wasabi_police:outVehiclePlayer"
    },
    ['poliisi:raudoita'] = {
        title = "Raudoita",
        icon = "#raudoita",
        functionName = "wasabi_police:handcuffPlayer"
    },
    ['poliisi:raudatpois'] = {
        title = "Raudat Pois",
        icon = "#raudatpois",
        functionName = "wasabi_police:uncuff"
    },
    ['poliisi:tutki'] = {
        title = "Tutki Taskut",
        icon = "#taskut",
        functionName = "wasabi_police:searchPlayer"
    },
    ['poliisi:vangitse'] = {
        title = "Vangitse",
        icon = "#taskut",
        functionName = "wasabi_police:jailPlayer"
    },
    ['poliisi:laskuta'] = {
        title = "Laskuta",
        icon = "#sakot",
        functionName = "wasabi_police:finePlayer"
    },
    ['poliisi:tarkista'] = {
        title = "Henkilöllisyys",
        icon = "#henkilöllisyys",
        functionName = "wasabi_police:checkId"
    },
    ['poliisi:auto'] = {
        title = "Ajoneuvo Tiedot",
        icon = "#raudoita",
        functionName = "wasabi_police:vehicleInteractions"
    },
    --Ensihoito
    ['ensihoito:tutki'] = {
        title = "Tutki Potilasta",
        icon = "#raudoita",
        functionName = "wasabi_ambulance:diagnosePatient"
    },
    ['ensihoito:elvytä'] = {
        title = "Elvytä Potilas",
        icon = "#raudoita",
        functionName = "wasabi_ambulance:reviveTarget"
    },
    ['ensihoito:hoida'] = {
        title = "Hoida Haavoja",
        icon = "#raudoita",
        functionName = "wasabi_ambulance:healTarget"
    },
    ['ensihoito:ajoneuvoon'] = {
        title = "Kuljeta Potilasta",
        icon = "#raudoita",
        functionName = "wasabi_ambulance:placeInVehicle"
    },

}

RegisterNetEvent('tshirt')
AddEventHandler('tshirt', function()  
    TriggerEvent('skinchanger:getSkin', function(skin)
		local playerPed = GetPlayerPed(-1)

		RequestAnimDict('clothingshirt')
		while not HasAnimDictLoaded('clothingshirt') do
			Citizen.Wait(1)
		end

		TaskPlayAnim(playerPed, "clothingshirt", "check_out_b", 3.5, -8, -1, 49, 0, 0, 0, 0) 
		Citizen.Wait(3500)
	    ClearPedTasks(playerPed)


		local clothesSkin = {
		['tshirt_1'] = 15, ['tshirt_2'] = 0,
		['torso_1'] = 15, ['torso_2'] = 0,
		['arms'] = 15, ['arms_2'] = 0
		}
		TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
	end)
end)


    Citizen.CreateThread(function(job, name)
        while true do
    
            Citizen.Wait(0)

    if isMedic and job ~= "ems" then isMedic = false end
    if isPolice and ESX.PlayerData.job and ESX.PlayerData.job.name ~= 'police' then isPolice = false end
    if isTaksi and ESX.PlayerData.job and ESX.PlayerData.job.name ~= 'taxi' then isTaksi = false end
    if isMechanic and ESX.PlayerData.job and ESX.PlayerData.job.name ~= 'mechanic' then isMechanic = false end

    if isDoctor and job ~= "doctor" then isDoctor = false end
    if isNews and job ~= "news" then isNews = false end
    if  ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' then isPolice = true end
    if  ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'ambulance' then isMedic = true end
    if  ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'taxi' then isTaksi = true end
    if  ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'mechanic' then isMechanic = true end

    if job == "news" then isNews = true end
    if  ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'ambulance' then isDoctor = true end
        end
end)

RegisterNetEvent('pd:deathcheck')
AddEventHandler('pd:deathcheck', function()
    if not isDead then
        isDead = true
    else
        isDead = false
    end
end)



function GetPlayers()
    local players = {}

    for i = 0, 255 do
        if NetworkIsPlayerActive(i) then
            players[#players+1]= i
        end
    end

    return players
end


RegisterNetEvent('maske')
AddEventHandler('maske', function()
    local playerPed = GetPlayerPed(-1)

    RequestAnimDict('misscommon@std_take_off_masks')
    while not HasAnimDictLoaded('misscommon@std_take_off_masks') do
        Citizen.Wait(1)
    end

    RequestAnimDict('mp_masks@on_foot')
    while not HasAnimDictLoaded('mp_masks@on_foot') do
        Citizen.Wait(1)
    end

    if not mask then
    mask = true
    MaskDrawable, MaskTexture, MaskPalette = GetPedDrawableVariation(playerPed, 1), GetPedTextureVariation(playerPed, 1), GetPedPaletteVariation(playerPed, 1)
    TaskPlayAnim(playerPed, "misscommon@std_take_off_masks", "take_off_mask_rps", 3.5, -8, -1, 49, 0, 0, 0, 0)
    Citizen.Wait(1000)
    SetPedComponentVariation(playerPed, 1, 0, 0, MaskPalette)
    ClearPedTasks(playerPed)
end
end)



RegisterNetEvent('kask')
AddEventHandler('kask', function() 
       local playerPed = GetPlayerPed(-1)

    RequestAnimDict('veh@common@fp_helmet@')
    while not HasAnimDictLoaded('veh@common@fp_helmet@') do
        Citizen.Wait(1)
    end

    RequestAnimDict('missheistdockssetup1hardhat@')
    while not HasAnimDictLoaded('missheistdockssetup1hardhat@') do
        Citizen.Wait(1)
    end

    if not hat then 
    hat = true
    HatDrawable, HatTexture = GetPedPropIndex(playerPed, 0), GetPedPropTextureIndex(playerPed, 0)
    TaskPlayAnim(playerPed, "veh@common@fp_helmet@", "take_off_helmet_stand", 3.5, -8, -1, 49, 0, 0, 0, 0)
    Citizen.Wait(800)
    ClearPedProp(playerPed, 0)
    Citizen.Wait(400)
    ClearPedTasks(playerPed)
end
end)

    RegisterNetEvent('canta')
AddEventHandler('canta', function()  
    local playerPed = GetPlayerPed(-1)

    RequestAnimDict('missclothing')
    while not HasAnimDictLoaded('missclothing') do
        Citizen.Wait(1)
    end

    if not ryg then
    ryg = true
    rygDrawable, rygTexture, rygPalette = GetPedDrawableVariation(playerPed, 5), GetPedTextureVariation(playerPed, 5), GetPedPaletteVariation(playerPed, 5)
    TaskPlayAnim(playerPed, "missclothing", "wait_choice_a_storeclerk", 3.5, -8, -1, 49, 0, 0, 0, 0)
    Citizen.Wait(3000)
    SetPedComponentVariation(playerPed, 5, 0, 0, rygPalette)
    ClearPedTasks(playerPed)
else 
    ryg = false
    TaskPlayAnim(playerPed, "missclothing", "wait_choice_a_storeclerk", 3.5, -8, -1, 49, 0, 0, 0, 0) 
    Citizen.Wait(3000)
    SetPedComponentVariation(playerPed, 5, rygDrawable, rygTexture, rygPalette)
    ClearPedTasks(playerPed)
end
end)


    RegisterNetEvent('tshirt')
AddEventHandler('tshirt', function()  
    TriggerEvent('skinchanger:getSkin', function(skin)
		local playerPed = GetPlayerPed(-1)

		RequestAnimDict('clothingshirt')
		while not HasAnimDictLoaded('clothingshirt') do
			Citizen.Wait(1)
		end

		TaskPlayAnim(playerPed, "clothingshirt", "check_out_b", 3.5, -8, -1, 49, 0, 0, 0, 0) 
		Citizen.Wait(3500)
	    ClearPedTasks(playerPed)


		local clothesSkin = {
		['tshirt_1'] = 15, ['tshirt_2'] = 0,
		['torso_1'] = 15, ['torso_2'] = 0,
		['arms'] = 15, ['arms_2'] = 0
		}
		TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
	end)
end)


RegisterNetEvent('AracBagla')
AddEventHandler('AracBagla', function()
	local playerPed = PlayerPedId()
    local vehicle   = ESX.Game.GetVehicleInDirection()
    
    TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)

     Citizen.Wait(10000)
     TriggerEvent('pogressBar:drawBar', 10000, 'Aracı bağlıyorsun.')

     ClearPedTasksImmediately(playerPed)

	if IsPedInAnyVehicle(playerPed, true) then
		vehicle = GetVehiclePedIsIn(playerPed, false)
	end

    if DoesEntityExist(vehicle) then
        ESX.Game.DeleteVehicle(vehicle)
        Citizen.Wait(10000)
	end
end)



RegisterNetEvent('pantolon')
AddEventHandler('pantolon', function() 
    	TriggerEvent('skinchanger:getSkin', function(skin)
	
		local playerPed = GetPlayerPed(-1)

		RequestAnimDict('clothingtrousers')
		while not HasAnimDictLoaded('clothingtrousers') do
			Citizen.Wait(1)
		end
		TaskPlayAnim(playerPed, "clothingtrousers", "try_trousers_negative_a", 3.5, -8, -1, 49, 0, 0, 0, 0) 
		Citizen.Wait(3000)
		ClearPedTasks(playerPed)
		local clothesSkin = {
		['pants_1'] = 21, ['pants_2'] = 0
		}
		TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
	end)
end)

    RegisterNetEvent('ayakkabı')
AddEventHandler('ayakkabı', function() 
	TriggerEvent('skinchanger:getSkin', function(skin)
		local playerPed = GetPlayerPed(-1)

		RequestAnimDict('clothingshoes')
		while not HasAnimDictLoaded('clothingshoes') do
			Citizen.Wait(1)
		end
		TaskPlayAnim(playerPed, "clothingshoes", "check_out_a", 3.5, -8, -1, 49, 0, 0, 0, 0) 
		Citizen.Wait(2500)
		ClearPedTasks(playerPed)	

		local clothesSkin = {
		['shoes_1'] = 34, ['shoes_2'] = 0
		}
		TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
	end)
end)


    RegisterNetEvent('giyin')
    AddEventHandler('giyin', function() 
	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
		TriggerEvent('skinchanger:loadSkin', skin)
		end)

end)

function AracKilit()
    local playerPed = PlayerPedId()

    local coords  = GetEntityCoords(playerPed)
  local  vehicle = ESX.Game.GetVehicleInDirection()

if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 3.0) then
    TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_WELDING', 0, true)
    Citizen.Wait(20000)
    TriggerEvent('pogressBar:drawBar', 20000, 'Araç kilidini açıyorsun.')

    ClearPedTasksImmediately(playerPed)

    SetVehicleDoorsLocked(vehicle, 1)
    SetVehicleDoorsLockedForAllPlayers(vehicle, false)
    ESX.ShowNotification("Araç Açıldı")
end
end

RegisterNetEvent('AracKilit')
AddEventHandler('AracKilit', function()
AracKilit()

end)







function GetClosestPlayer()
    local players = GetPlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local closestPed = -1
    local ply = PlayerPedId()
    local plyCoords = GetEntityCoords(ply, 0)
    if not IsPedInAnyVehicle(PlayerPedId(), false) then
        for index,value in ipairs(players) do
            local target = GetPlayerPed(value)
            if(target ~= ply) then
                local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
                local distance = #(vector3(targetCoords["x"], targetCoords["y"], targetCoords["z"]) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
                if(closestDistance == -1 or closestDistance > distance) and not IsPedInAnyVehicle(target, false) then
                    closestPlayer = value
                    closestPed = target
                    closestDistance = distance
                end
            end
        end
        return closestPlayer, closestDistance, closestPed
    end
end

