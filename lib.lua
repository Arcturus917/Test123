local library = {}

function library:CreateWindow(title)
    local screenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
    screenGui.Name = "SirHub_UI"

    local mainFrame = Instance.new("Frame", screenGui)
    mainFrame.Size = UDim2.new(0, 300, 0, 500)
    mainFrame.Position = UDim2.new(0.5, -150, 0.5, -250)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true

    local titleLabel = Instance.new("TextLabel", mainFrame)
    titleLabel.Size = UDim2.new(1, 0, 0, 30)
    titleLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    titleLabel.TextColor3 = Color3.new(1, 1, 1)
    titleLabel.Font = Enum.Font.SourceSansSemibold
    titleLabel.TextSize = 16
    titleLabel.Text = title
    titleLabel.TextXAlignment = Enum.TextXAlignment.Center

    local layout = Instance.new("UIListLayout", mainFrame)
    layout.Padding = UDim.new(0, 6)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    return mainFrame
end

function library:AddToggle(parent, text, callback)
    local button = Instance.new("TextButton", parent)
    button.Size = UDim2.new(1, -10, 0, 30)
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Text = "☐ " .. text
    button.Font = Enum.Font.SourceSans
    button.TextSize = 14
    button.AutoButtonColor = false

    local toggled = false
    button.MouseButton1Click:Connect(function()
        toggled = not toggled
        button.Text = (toggled and "☑ " or "☐ ") .. text
        callback(toggled)
    end)
end

function library:AddSlider(parent, text, min, max, default, callback)
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
        local value = tonumber(slider.Text)
        if value and value >= min and value <= max then
            label.Text = text .. ": " .. tostring(value)
            callback(value)
        end
    end)

    callback(default)
end

function library:AddButton(parent, text, callback)
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

function library:AddDropdown(parent, text, options, callback)
    local container = Instance.new("Frame", parent)
    container.Size = UDim2.new(1, -10, 0, 40)
    container.BackgroundTransparency = 1

    local label = Instance.new("TextLabel", container)
    label.Text = text
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.SourceSans
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left

    local dropdown = Instance.new("TextButton", container)
    dropdown.Size = UDim2.new(1, 0, 0, 20)
    dropdown.Position = UDim2.new(0, 0, 0, 20)
    dropdown.Text = "Select..."
    dropdown.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    dropdown.TextColor3 = Color3.new(1, 1, 1)
    dropdown.Font = Enum.Font.SourceSans
    dropdown.TextSize = 14

    local open = false
    local menu = Instance.new("Frame", dropdown)
    menu.Size = UDim2.new(1, 0, 0, #options * 20)
    menu.Position = UDim2.new(0, 0, 1, 0)
    menu.Visible = false
    menu.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    menu.BorderSizePixel = 0

    for _, opt in pairs(options) do
        local btn = Instance.new("TextButton", menu)
        btn.Size = UDim2.new(1, 0, 0, 20)
        btn.Text = opt
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.SourceSans
        btn.TextSize = 14

        btn.MouseButton1Click:Connect(function()
            dropdown.Text = opt
            menu.Visible = false
            open = false
            callback(opt)
        end)
    end

    dropdown.MouseButton1Click:Connect(function()
        open = not open
        menu.Visible = open
    end)
end

function library:AddTextbox(parent, text, default, callback)
    local container = Instance.new("Frame", parent)
    container.Size = UDim2.new(1, -10, 0, 40)
    container.BackgroundTransparency = 1

    local label = Instance.new("TextLabel", container)
    label.Text = text
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.SourceSans
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left

    local textbox = Instance.new("TextBox", container)
    textbox.Size = UDim2.new(1, 0, 0, 20)
    textbox.Position = UDim2.new(0, 0, 0, 20)
    textbox.Text = default or ""
    textbox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    textbox.TextColor3 = Color3.new(1, 1, 1)
    textbox.Font = Enum.Font.SourceSans
    textbox.TextSize = 14
    textbox.ClearTextOnFocus = false

    textbox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            callback(textbox.Text)
        end
    end)
end

return library
