-- Macro Ranura 2 - MÁXIMA VELOCIDAD (Ultra Fast Shot)
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local localPlayer = Players.LocalPlayer

-- Tiempos reducidos al mínimo para máxima velocidad de ráfaga
local TIEMPO_DISPARO = 0.01  
local TIEMPO_ESPERA  = 0.01  

local ejecutando = false
local nombreArmaSlot2 = nil

local function actualizarArmaSlot2()
    local herramientas = localPlayer.Backpack:GetChildren()
    local contador = 0
    for _, obj in ipairs(herramientas) do
        if obj:IsA("Tool") then
            contador = contador + 1
            if contador == 2 then
                nombreArmaSlot2 = obj.Name
                break
            end
        end
    end
end

actualizarArmaSlot2()

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed or ejecutando then return end
    
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        local character = localPlayer.Character
        if not character or not character:FindFirstChild("Humanoid") or character.Humanoid.Health <= 0 then 
            return 
        end
        
        local herramientaEquipada = character:FindFirstChildOfClass("Tool")
        if herramientaEquipada and herramientaEquipada.Name ~= nombreArmaSlot2 then 
            return 
        end
        
        if not nombreArmaSlot2 then
            actualizarArmaSlot2()
        end
        
        local armaSlot2 = localPlayer.Backpack:FindFirstChild(nombreArmaSlot2) or character:FindFirstChild(nombreArmaSlot2)
        
        if armaSlot2 then
            ejecutando = true
            
            task.spawn(function()
                character.Humanoid:UnequipTools()
                
                armaSlot2.Parent = character
                
                -- Ejecuta el disparo instantáneamente
                armaSlot2:Activate()
                task.wait(TIEMPO_DISPARO)
                
                armaSlot2:Deactivate()
                task.wait(TIEMPO_ESPERA)
                armaSlot2.Parent = localPlayer.Backpack
                
                ejecutando = false
            end)
        end
    end
end)

localPlayer.CharacterAdded:Connect(function()
    nombreArmaSlot2 = nil
    ejecutando = false
    task.wait(0.5)
    actualizarArmaSlot2()
end)

print("¡Macro Ultra Rápida de Ranura 2 Cargada con Éxito!")
