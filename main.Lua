--// Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

--// Player
local player = Players.LocalPlayer

--// GUI Setup
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "PetRandomizerGui"

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 250, 0, 220)
frame.Position = UDim2.new(0, 20, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 0.2
frame.Name = "MainFrame"
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Pet Randomizer ✨\nMade by – yuri"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.FredokaOne
title.TextSize = 16
title.TextWrapped = true

local randomizeBtn = Instance.new("TextButton", frame)
randomizeBtn.Size = UDim2.new(1, -20, 0, 40)
randomizeBtn.Position = UDim2.new(0, 10, 0, 45)
randomizeBtn.BackgroundColor3 = Color3.fromRGB(255, 123, 0)
randomizeBtn.Text = "🎲 Randomize Pets"
randomizeBtn.Font = Enum.Font.FredokaOne
randomizeBtn.TextSize = 16
randomizeBtn.TextColor3 = Color3.new(1, 1, 1)
randomizeBtn.BorderSizePixel = 0

local espToggleBtn = Instance.new("TextButton", frame)
espToggleBtn.Size = UDim2.new(1, -20, 0, 40)
espToggleBtn.Position = UDim2.new(0, 10, 0, 95)
espToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
espToggleBtn.Text = "👁️ ESP: ON"
espToggleBtn.Font = Enum.Font.FredokaOne
espToggleBtn.TextSize = 16
espToggleBtn.TextColor3 = Color3.new(1, 1, 1)
espToggleBtn.BorderSizePixel = 0

local autoToggleBtn = Instance.new("TextButton", frame)
autoToggleBtn.Size = UDim2.new(1, -20, 0, 40)
autoToggleBtn.Position = UDim2.new(0, 10, 0, 145)
autoToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 153, 77)
autoToggleBtn.Text = "🔁 Auto Randomize: OFF"
autoToggleBtn.Font = Enum.Font.FredokaOne
autoToggleBtn.TextSize = 16
autoToggleBtn.TextColor3 = Color3.new(1, 1, 1)
autoToggleBtn.BorderSizePixel = 0

--// Pet List
local eggPets = {
    ["Mythical Egg"] = {"Grey Mouse", "Brown Mouse", "Squirrel", "Red Giant Ant", "Red Fox"},
    ["Bug Egg"] = {"Caterpillar", "Snail", "Giant Ant", "Praying Mantis", "Dragonfly"},
    ["Bee Egg"] = {"Bee", "Honey Bee", "Bear Bee", "Petal Bee", "Queen Bee"},
    ["Primal Egg"] = {"Parasaurolophus", "Iguanodon", "Pachycephalosaurus", "Dilophosaurus", "Ankylosaurus", "Spinosaurus"},
    ["Dinosaur Egg"] = {"Raptor", "Triceratops", "Stegosaurus", "Pterodactyl", "Brontosaurus", "T-Rex"}
}

--// Functions
local function clearOldLabels()
    for _, v in ipairs(Workspace:GetDescendants()) do
        if v:IsA("BillboardGui") and v.Name == "EggLabel" then
            v:Destroy()
        end
    end
end

local function createLabel(egg, text)
    local gui = Instance.new("BillboardGui")
    gui.Name = "EggLabel"
    gui.Size = UDim2.new(0, 200, 0, 50)
    gui.StudsOffset = Vector3.new(0, 3, 0)
    gui.Adornee = egg
    gui.AlwaysOnTop = true

    local lbl = Instance.new("TextLabel", gui)
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.new(1, 1, 1)
    lbl.TextStrokeTransparency = 0.2
    lbl.TextScaled = true
    lbl.Font = Enum.Font.FredokaOne

    gui.Parent = egg
end

local function randomizePets()
    clearOldLabels()
    for _, egg in ipairs(Workspace:GetDescendants()) do
        if egg:IsA("Model") then
            for eggType, pets in pairs(eggPets) do
                if egg.Name:lower():find(eggType:lower()) then
                    local petName = pets[math.random(1, #pets)]
                    local fullName = eggType .. " | " .. petName
                    if not egg:FindFirstChild("EggLabel") then
                        createLabel(egg, fullName)
                    end
                end
            end
        end
    end
end

--// Auto Randomize
local autoEnabled = false
task.spawn(function()
    while true do
        task.wait(5)
        if autoEnabled then
            randomizePets()
        end
    end
end)

--// Button Callbacks
randomizeBtn.MouseButton1Click:Connect(function()
    randomizePets()
end)

local espEnabled = true
espToggleBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espToggleBtn.Text = espEnabled and "👁️ ESP: ON" or "👁️ ESP: OFF"

    for _, egg in ipairs(Workspace:GetDescendants()) do
        if egg:FindFirstChild("EggLabel") then
            egg.EggLabel.Enabled = espEnabled
        end
    end
end)

autoToggleBtn.MouseButton1Click:Connect(function()
    autoEnabled = not autoEnabled
    autoToggleBtn.Text = autoEnabled and "🔁 Auto Randomize: ON" or "🔁 Auto Randomize: OFF"
end)

--// Initial Call
randomizePets()
