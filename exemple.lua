local LIBRARY_URL = "https://raw.githubusercontent.com/brskofdp/urban-doodle/refs/heads/main/Library.lua"
local SAVE_MANAGER_URL = "https://raw.githubusercontent.com/brskofdp/urban-doodle/refs/heads/main/SaveManager.lua"
local THEME_MANAGER_URL = "https://raw.githubusercontent.com/brskofdp/urban-doodle/refs/heads/main/ThemeManager.lua"

local Library = loadstring(game:HttpGet(LIBRARY_URL))()
local SaveManager = loadstring(game:HttpGet(SAVE_MANAGER_URL))()
local ThemeManager = loadstring(game:HttpGet(THEME_MANAGER_URL))()

local Window = Library:CreateWindow({
    Title = "My Script",
    Footer = "v1.0.0 — by me",

    Icon = "gamepad-2",
    IconSize = UDim2.fromOffset(28, 28),

    Size = UDim2.fromOffset(720, 600),
    CornerRadius = 6,

    BackgroundTransparency = 0.30,

    ToggleKeybind = Enum.KeyCode.PageUp,
    NotifySide = "Right",
    ShowCustomCursor = true,
    Resizable = true,
    Center = true,

    GlobalSearch = true,
    EnableCompacting = true,
})

Library:SetDPIScale(66)

local MainTab = Window:AddTab("Main", "home")
local VisualsTab = Window:AddTab("Visuals", "eye")
local SettingsTab = Window:AddTab("Settings", "settings")

local MainLeft = MainTab:AddLeftGroupbox("Main", "zap")
local MainRight = MainTab:AddRightGroupbox("Options", "list")

MainLeft:AddToggle("my_enabled", {
    Text = "Enabled",
    Default = false,
    Tooltip = "Turns the feature on or off",
    Callback = function(state)
        print("Enabled:", state)
    end,
})

local SpeedSlider = MainLeft:AddSlider("my_speed", {
    Text = "Speed",
    Default = 16,
    Min = 1,
    Max = 200,
    Rounding = 0,
    Suffix = " studs/s",
    Callback = function(value)
        print("Speed:", value)
    end,
})

MainLeft:AddDropdown("my_mode", {
    Text = "Mode",
    Default = "Balanced",
    Values = { "Fast", "Balanced", "Accurate" },
    Callback = function(value)
        print("Mode:", value)
    end,
})

MainLeft:AddDropdown("my_features", {
    Text = "Features",
    Multi = true,
    Values = { "Aimbot", "ESP", "Fly", "Speed", "Noclip" },
    Callback = function(values)
        for name, on in pairs(values) do
            print(name, on)
        end
    end,
})

MainLeft:AddInput("my_username", {
    Text = "Target player",
    Default = "",
    Placeholder = "Enter a name...",
    Finished = true,
    Callback = function(text)
        print("Typed:", text)
    end,
})

MainLeft:AddButton("Click me", function()
    Library:Notify({
        Title = "Button",
        Description = "You clicked the button!",
        Time = 4,
    })
end)

MainLeft:AddDivider()

MainLeft:AddLabel("Box color"):AddColorPicker("my_box_color", {
    Default = Color3.fromRGB(125, 85, 255),
    Callback = function(color)
        print("Color:", color)
    end,
})

MainLeft:AddLabel("Toggle key"):AddKeyPicker("my_toggle_key", {
    Text = "Keybind",
    Default = "F1",
    Mode = "Toggle",
    SyncToggleState = false,
    Callback = function()
        print("Key pressed!")
    end,
})

local AdvancedToggle = MainRight:AddToggle("my_advanced", {
    Text = "Advanced options",
    Default = false,
})

local DepBox = MainRight:AddDependencyBox()
DepBox:AddSlider("my_advanced_value", {
    Text = "Advanced value",
    Default = 50,
    Min = 0,
    Max = 100,
})
DepBox:AddInput("my_advanced_text", {
    Text = "Note",
    Default = "",
})
DepBox:SetupDependencies({
    { AdvancedToggle, true },
})

local VisualsBox = VisualsTab:AddLeftTabbox("ESP Settings")
local PlayersPage = VisualsBox:AddTab("Players", "user")
local ObjectsPage = VisualsBox:AddTab("Objects", "box")

PlayersPage:AddToggle("esp_players", { Text = "Player ESP", Default = false })
PlayersPage:AddToggle("esp_names", { Text = "Show names", Default = true })
PlayersPage:AddSlider("esp_transparency", {
    Text = "Transparency",
    Default = 0.5,
    Min = 0,
    Max = 1,
    Rounding = 2,
})

ObjectsPage:AddToggle("esp_objects", { Text = "Object ESP", Default = false })

local SettingsLeft = SettingsTab:AddLeftGroupbox("Interface", "monitor")

SettingsLeft:AddLabel("Menu keybind"):AddKeyPicker("menu_keybind", {
    Text = "Open / close menu",
    Default = "PageUp",
    Mode = "Toggle",
})
Library.ToggleKeybind = Library.Options.menu_keybind

SettingsLeft:AddButton("Unload script", function()
    Library:Unload()
end)

ThemeManager:SetLibrary(Library)
ThemeManager:SetFolder("MyScript")
ThemeManager:ApplyToTab(SettingsTab)

local ACCENT = Color3.fromRGB(255, 45, 45)
Library.Scheme.AccentColor = ACCENT
if Library.Options.AccentColor then
    Library.Options.AccentColor:SetValueRGB(ACCENT)
end
Library:UpdateColorsUsingRegistry()

SaveManager:SetLibrary(Library)
SaveManager:SetFolder("MyScript")
SaveManager:IgnoreThemeSettings()
SaveManager:BuildConfigSection(SettingsTab)

SaveManager:LoadAutoloadConfig()

Library:Notify({
    Title = "My Script",
    Description = "Loaded successfully.",
    Time = 5,
})

Library:OnUnload(function()
    print("My Script unloaded, cleaning up...")
end)
