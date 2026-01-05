# 🍃 VAYU HUB UI LIBRARY

![Lua](https://img.shields.io/badge/Language-Lua-blue) ![Platform](https://img.shields.io/badge/Platform-Roblox-red) ![Version](https://img.shields.io/badge/Version-13.0-green)

The Ultimate UI Library for Roblox Scripts. Inspired by WindUI/Orion but optimized for both **PC & Mobile**. Features Mac-style window controls, smooth animations, and a fully customizable theme system.

---

## ✨ Features
- **🍎 Mac-Style Controls:** Minimize, Maximize, and Close buttons with smooth animations.
- **📱 Mobile Optimized:** Auto-detects mobile devices. Includes a draggable floating toggle button.
- **🎨 Pro Colorpicker:** HSV Colorpicker with live preview and hex input.
- **🔧 Advanced Elements:** Keybinds, Dropdowns, Sliders, and Inputs with modern styling.
- **💨 Smooth Animations:** Uses `Quint` easing style for a premium feel.

---

## 🚀 Getting Started

---

## 🚀 Installation

Copy and paste this code at the top of your script:

```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/IRONJAM1/Vayu-Hub-UI/refs/heads/main/source.lua"))()
```

📖 Documentation & Examples
1. Create Window (สร้างหน้าต่าง)
Initialize the library window.
```lua
local Window = Library:CreateWindow({
    Title = "My Script Name", -- ชื่อสคริปต์ของคุณ
    ThemeColor = Color3.fromRGB(0, 145, 255), -- สีธีมหลัก
    Logo = "90392555143990", -- ใส่ ID รูปภาพ (หรือปล่อยว่างก็ได้)
    UseBlur = true -- เปิดเอฟเฟกต์เบลอ
})
```

2. Create Tab (สร้างแท็บ)
Create categories for your features.
```lua
-- Format: Window:CreateTab("Tab Name", "IconID")
local MainTab = Window:CreateTab("Main", "6034509993")
local SettingsTab = Window:CreateTab("Settings", "6031280882")
```
3. Add Elements (เพิ่มปุ่มและฟังก์ชัน)
Section (หัวข้อแบ่งหมวดหมู่)
```lua
MainTab:CreateSection("Character Features")
Toggle (สวิตช์เปิด-ปิด)
MainTab:CreateToggle("Auto Farm", false, function(Value)
    _G.AutoFarm = Value
    print("Auto Farm set to:", Value)
end)
```
Slider (ตัวเลื่อนปรับค่า)
```lua
MainTab:CreateSlider("WalkSpeed", 16, 500, 16, function(Value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
end)
Button (ปุ่มกด)

MainTab:CreateButton("Reset Character", function()
    game.Players.LocalPlayer.Character.Humanoid.Health = 0
end, "6023426915") -- Optional Icon ID
```
Dropdown (เมนูเลือก)
```lua
MainTab:CreateDropdown("Select Weapon", {"Sword", "Gun", "Fist"}, "Sword", function(Option)
    print("Selected:", Option)
end)
```
Colorpicker (ตัวเลือกสี)
```lua
MainTab:CreateColorPicker("ESP Color", Color3.fromRGB(255, 0, 0), function(Color)
    print("New Color:", Color)
end)
```
Input & Keybind (ช่องกรอกและปุ่มลัด)
```lua
SettingsTab:CreateInput("Target Player", "Username...", function(Text)
    print("Target:", Text)
end)

SettingsTab:CreateKeybind("Toggle UI", Enum.KeyCode.RightControl, function()
    print("UI Toggled")
end)
```
