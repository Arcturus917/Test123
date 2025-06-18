-- SirHub-style UI Library
local SirHub = {}

function SirHub:CreateWindow(title)
    local screenGui = Instance.new("ScreenGui", game.CoreGui)
    screenGui.Name = "SirHub_UI"

    local mainFrame = Instance.new("Frame", screenGui)
    mainFrame.Size = UDim2.new(0, 300, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true

    local titleLabel = Instance.new("TextLabel", mainFrame)
    titleLabel.Text = title
    titleLabel.Size = UDim2.new(1, 0, 0, 30)
    titleLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    titleLabel.TextColor3 = Color3.new(1, 1, 1)
    titleLabel.Font = Enum.Font.SourceSansSemibold
    titleLabel.TextSize = 16

    local layout = Instance.new("UIListLayout", mainFrame)
    layout.Padding = UDim.new(0, 6)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.VerticalAlignment = Enum.VerticalAlignment.Top
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.Parent = mainFrame

    return mainFrame
end

function SirHub:AddToggle(parent, text, callback)
    local toggle = Instance.new("TextButton", parent)
    toggle.Size = UDim2.new(1, -10, 0, 30)
    toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    toggle.TextColor3 = Color3.new(1, 1, 1)
    toggle.Text = "☐ " .. text
    toggle.Font = Enum.Font.SourceSans
    toggle.TextSize = 14
    toggle.AutoButtonColor = false
    toggle.LayoutOrder = 1

    local toggled = false
    toggle.MouseButton1Click:Connect(function()
        toggled = not toggled
        toggle.Text = (toggled and "☑ " or "☐ ") .. text
        callback(toggled)
    end)
end

function SirHub:AddSlider(parent, text, min, max, default, callback)
    local container = Instance.new("Frame", parent)
    container.Size = UDim2.new(1, -10, 0, 50)
    container.BackgroundTransparency = 1

    local label = Instance.new("TextLabel", container)
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Text = text .. ": " .. tostring(default)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.SourceSans
    label.TextSize = 14

    local slider = Instance.new("TextButton", container)
    slider.Size = UDim2.new(1, 0, 0, 20)
    slider.Position = UDim2.new(0, 0, 0, 25)
    slider.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    slider.Text = tostring(default)
    slider.TextColor3 = Color3.new(1, 1, 1)
    slider.Font = Enum.Font.SourceSans
    slider.TextSize = 14
    slider.AutoButtonColor = false

    slider.MouseButton1Click:Connect(function()
        local input = tonumber(game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("SirHub_UI").TextBox or "0")
        if input and input >= min and input <= max then
            label.Text = text .. ": " .. tostring(input)
            slider.Text = tostring(input)
            callback(input)
        end
    end)

    callback(default)
end

function SirHub:AddButton(parent, text, callback)
    local button = Instance.new("TextButton", parent)
    button.Size = UDim2.new(1, -10, 0, 30)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Text = text
    button.Font = Enum.Font.SourceSans
    button.TextSize = 14
    button.AutoButtonColor = true

    button.MouseButton1Click:Connect(callback)
end

return SirHub
