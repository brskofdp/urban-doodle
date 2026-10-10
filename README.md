# urban-doodle

A lightweight Roblox UI library (**Obsidian**, Luau) bundled with a config **SaveManager**, a **ThemeManager**, and a ready-to-run example script.

The UI is built for script executors that support `loadstring`, `game:HttpGet`, and the usual filesystem functions (`writefile`, `readfile`, `isfile`, `isfolder`, `makefolder`, `listfiles`, `delfile`).

---

## Features

- **Window system** — draggable / resizable, collapsible sidebar, global search, custom cursor.
- **Tabs & groupboxes** — `AddTab`, `AddLeftGroupbox`, `AddRightGroupbox`, `AddTabbox`.
- **Elements** — Toggle, Slider, Dropdown (single & multi), Input, Button, Label, Divider, ColorPicker, KeyPicker, Viewport, Image, Video.
- **Dependency boxes** — show/hide elements based on another element's value.
- **Notifications** — `Library:Notify(...)`.
- **Dialogs & loading screens** — `Window:AddDialog`, `Library:CreateLoading`.
- **Config saving** — `SaveManager.lua` (save / load / delete / autoload).
- **Themes** — `ThemeManager.lua` with many built-in themes plus custom theme save/load.
- **Window background transparency** — fade the whole window (see below).

---

## Files

| File | Description |
| --- | --- |
| `Library.lua` | Core UI library (Obsidian). Returns the `Library` table. |
| `source.lua` | Lucide icon module (spritesheet icon lookup). Returns a Lucide module. |
| `SaveManager.lua` | Config save/load/delete + configuration UI. |
| `ThemeManager.lua` | Built-in + custom themes + theme UI. |
| `Example.lua` | Full example script showing how to use everything. |

---

## Quick start

`Example.lua` is a complete, commented reference. The short version:

```lua
-- Load the library and the addons
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/brskofdp/urban-doodle/refs/heads/main/Library.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/brskofdp/urban-doodle/refs/heads/main/SaveManager.lua"))()
local ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/brskofdp/urban-doodle/refs/heads/main/ThemeManager.lua"))()

-- Create the window
local Window = Library:CreateWindow({
    Title = "My Script",
    Footer = "v1.0.0",
    Icon = "gamepad-2",
    Size = UDim2.fromOffset(720, 600),
    CornerRadius = 6,
    BackgroundTransparency = 0.30,
    ToggleKeybind = Enum.KeyCode.PageUp,
})

-- DPI scale (percent)
Library:SetDPIScale(66)

-- Tabs
local MainTab = Window:AddTab("Main", "home")
local SettingsTab = Window:AddTab("Settings", "settings")

-- Elements
local Main = MainTab:AddLeftGroupbox("Main", "zap")
Main:AddToggle("my_toggle", { Text = "Enabled", Default = false })
Main:AddSlider("my_slider", { Text = "Speed", Default = 16, Min = 1, Max = 100 })
Main:AddDropdown("my_mode", { Text = "Mode", Values = { "Fast", "Slow" } })
Main:AddButton("Click me", function()
    Library:Notify("Hello!")
end)

-- Menu keybind (Page Up by default)
SettingsTab:AddLeftGroupbox("Interface", "monitor")
    :AddLabel("Menu keybind")
    :AddKeyPicker("menu_keybind", { Text = "Open / close menu", Default = "PageUp", Mode = "Toggle" })
Library.ToggleKeybind = Library.Options.menu_keybind
```

> **Important:** `AddKeyPicker` (and `AddColorPicker`) return their **parent label**, not the picker itself — that's for chaining. To get the real object, read it from `Library.Options[<id>]`.

---

## Opening the menu

- **Page Up** (default) toggles the menu open/closed.
- Change it at runtime via `Settings → Interface → Menu keybind`.
- Or from code:
  ```lua
  Library:Toggle()        -- toggle
  Library:Toggle(true)    -- force open
  Library:Toggle(false)   -- force close
  ```
- On mobile, on-screen toggle/lock buttons appear while the menu is closed.

The menu ignores the keybind while a text box is focused (search bar / input).

---

## SaveManager

```lua
SaveManager:SetLibrary(Library)
SaveManager:SetFolder("MyScript")            -- where configs are stored
SaveManager:IgnoreThemeSettings()            -- don't save theme colors
SaveManager:BuildConfigSection(SettingsTab)  -- adds the "Configuration" groupbox
SaveManager:LoadAutoloadConfig()             -- load the config marked as autoload
```

Configs are stored as JSON under `<Folder>/settings/`. Elements are identified by the **id** you pass as their first argument, so give each saved element a unique id.

---

## ThemeManager

```lua
ThemeManager:SetLibrary(Library)
ThemeManager:SetFolder("MyScript")     -- where custom themes are stored
ThemeManager:ApplyToTab(SettingsTab)   -- adds the "Themes" groupbox
```

- Pick a built-in theme or create/save/load custom themes.
- Set a default theme that loads on start.

Accent color can be forced after the theme is applied:

```lua
local ACCENT = Color3.fromRGB(255, 45, 45)
Library.Scheme.AccentColor = ACCENT
if Library.Options.AccentColor then
    Library.Options.AccentColor:SetValueRGB(ACCENT)
end
Library:UpdateColorsUsingRegistry()
```

---

## Window background transparency

Set it in `CreateWindow` (0 = opaque, 1 = fully see-through):

```lua
local Window = Library:CreateWindow({ BackgroundTransparency = 0.30 })
```

Change it at runtime:

```lua
Window:SetBackgroundTransparency(0.5)
print(Window:GetBackgroundTransparency())
```

This fades the window chrome (main frame, bottom bar, sidebar, content area) **and** every panel/groupbox tied to the `BackgroundColor` scheme. The window outline and divider lines stay visible, giving a transparent panel with a border.

---

## Element reference (common options)

| Element | Call | Key options | Methods |
| --- | --- | --- | --- |
| Toggle | `Groupbox:AddToggle(id, opts)` | `Text`, `Default`, `Callback` | `SetValue`, `OnChanged` |
| Slider | `Groupbox:AddSlider(id, opts)` | `Text`, `Default`, `Min`, `Max`, `Rounding`, `Suffix` | `SetValue`, `OnChanged` |
| Dropdown | `Groupbox:AddDropdown(id, opts)` | `Text`, `Values`, `Multi`, `Default` | `SetValue`, `SetValues`, `AddValues`, `OnChanged` |
| Input | `Groupbox:AddInput(id, opts)` | `Text`, `Default`, `Placeholder`, `Finished`, `Numeric` | `SetValue`, `OnChanged` |
| Button | `Groupbox:AddButton(text, fn)` | `Text`, `Func`, `DoubleClick` | — |
| Label | `Groupbox:AddLabel(text)` | `Text`, `DoesWrap` | `SetText` |
| Divider | `Groupbox:AddDivider()` | — | — |
| ColorPicker | `Label:AddColorPicker(id, opts)` | `Default`, `Transparency` | `SetValueRGB`, `OnChanged` |
| KeyPicker | `Label:AddKeyPicker(id, opts)` | `Text`, `Default`, `Mode` (`Always`/`Toggle`/`Hold`), `SyncToggleState` | `SetValue`, `OnChanged` |

Dependency box:

```lua
local Toggle = Groupbox:AddToggle("adv", { Text = "Advanced" })
local Box = Groupbox:AddDependencyBox()
Box:AddSlider("adv_value", { Text = "Value", Min = 0, Max = 100 })
Box:SetupDependencies({ { Toggle, true } }) -- visible only when Toggle is true
```

---

## Notes

- Give every element you want saved a **unique id** (first argument).
- `Library:Unload()` destroys the UI; register cleanup with `Library:OnUnload(fn)`.
- Icons come from `source.lua` (lucide names like `"home"`, `"settings"`, `"zap"`), or use `rbxassetid://...`.

---

## Credits

- Core UI (**Obsidian**) by [deividcomsono](https://github.com/deividcomsono/Obsidian).
- Lucide icon module by [upio](https://gitlab.com/upio/lucide-roblox-direct).
- SaveManager / ThemeManager / packaging by [brskofdp](https://github.com/brskofdp).
