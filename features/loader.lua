-- shrub hub loader

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "bobby's shrub hub",
    LoadingTitle = "shrub hub",
    LoadingSubtitle = "by bobby"
})

local Movement = Window:CreateTab("movement", "walk")

-- load fly module
local Fly = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/bobbywds11-hue/Bobby-s-Shrub-Hub/main/features/fly.lua"
))()

Movement:CreateButton({
    Name = "fly",
    Callback = function()
        Fly()
    end
})
