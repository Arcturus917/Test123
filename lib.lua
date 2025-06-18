local library = {}

-- Create main window
function library:CreateWindow(title)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "SirHub_UI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = game:GetService("CoreGui")

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 300, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 30)
    titleLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    titleLabel.TextColor3 = Color3.new(1, 1, 1)
    titleLabel.Font = Enum.Font.SourceSansSemibold
    titleLabel.TextSize = 16
    titleLabel.Text = title
    titleLabel.TextXAlignment = Enum.TextXAlignment.Center
    titleLabel.Parent = mainFrame

    local scrollingFrame = Instance.new("ScrollingFrame")
    scrollingFrame.Size = UDim2.new(1, 0, 1, -30)
    scrollingFrame.Position = UDim2.new(0, 0, 0, 30)
    scrollingFrame.BackgroundTransparency = 1
    scrollingFrame.BorderSizePixel = 0
    scrollingFrame.ScrollBarThickness = 6
    scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scrollingFrame.Parent = mainFrame
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollingFrame.ClipsDescendants = true

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 6)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = scrollingFrame

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 5)
    padding.PaddingLeft = UDim.new(0, 5)
    padding.PaddingRight = UDim.new(0, 5)
    padding.Parent = scrollingFrame

    -- Update canvas size on content size change
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
    end)

    return mainFrame, scrollingFrame
end

-- Toggle button
function library:AddToggle(parent, text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -10, 0, 30)
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Text = "☐ " .. text
    button.Font = Enum.Font.SourceSans
    button.TextSize = 14
    button.AutoButtonColor = false
    button.Parent = parent

    local toggled = false
    button.MouseButton1Click:Connect(function()
        toggled = not toggled
        button.Text = (toggled and "☑ " or "☐ ") .. text
        callback(toggled)
    end)
end

-- Draggable horizontal slider
function library:AddSlider(parent, text, min, max, default, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -10, 0, 50)
    container.BackgroundTransparency = 1
    container.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Text = text .. ": " .. tostring(default)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.SourceSans
    label.TextSize = 14
    label.Parent = container

    local sliderBack = Instance.new("Frame")
    sliderBack.Size = UDim2.new(1, 0, 0, 20)
    sliderBack.Position = UDim2.new(0, 0, 0, 25)
    sliderBack.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    sliderBack.BorderSizePixel = 0
    sliderBack.Parent = container

    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(100, 170, 255)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBack

    local dragging = false

    local function updateValue(input)
        local relativeX = math.clamp(input.Position.X - sliderBack.AbsolutePosition.X, 0, sliderBack.AbsoluteSize.X)
        local percent = relativeX / sliderBack.AbsoluteSize.X
        local value = math.floor(min + (max - min) * percent + 0.5)
        sliderFill.Size = UDim2.new(percent, 0, 1, 0)
        label.Text = text .. ": " .. tostring(value)
        callback(value)
    end

    sliderBack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            updateValue(input)
        end
    end)

    sliderBack.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateValue(input)
        end
    end)

    -- Initialize callback with default
    callback(default)
end

-- Simple button
function library:AddButton(parent, text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -10, 0, 30)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Text = text
    button.Font = Enum.Font.SourceSans
    button.TextSize = 14
    button.AutoButtonColor = true
    button.Parent = parent
    button.MouseButton1Click:Connect(callback)
end

-- Dropdown menu
function library:AddDropdown(parent, text, options, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -10, 0, 20) -- start small, will expand
    container.BackgroundTransparency = 1
    container.ClipsDescendants = true
    container.Parent = parent

    local label = Instance.new("TextLabel")
    label.Text = text
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.SourceSans
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local dropdown = Instance.new("TextButton")
    dropdown.Size = UDim2.new(1, 0, 0, 20)
    dropdown.Position = UDim2.new(0, 0, 0, 20)
    dropdown.Text = "Select..."
    dropdown.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    dropdown.TextColor3 = Color3.new(1, 1, 1)
    dropdown.Font = Enum.Font.SourceSans
    dropdown.TextSize = 14
    dropdown.Parent = container

    local optionsFrame = Instance.new("Frame")
    optionsFrame.Position = UDim2.new(0, 0, 0, 40)
    optionsFrame.Size = UDim2.new(1, 0, 0, 0)
    optionsFrame.Visible = false
    optionsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    optionsFrame.BorderSizePixel = 0
    optionsFrame.ClipsDescendants = true
    optionsFrame.Parent = container

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 2)
    layout.Parent = optionsFrame

    local expanded = false

    -- Create option buttons
    for _, opt in ipairs(options) do
        local optBtn = Instance.new("TextButton")
        optBtn.Size = UDim2.new(1, 0, 0, 20)
        optBtn.Text = opt
        optBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        optBtn.TextColor3 = Color3.new(1, 1, 1)
        optBtn.Font = Enum.Font.SourceSans
        optBtn.TextSize = 14
        optBtn.AutoButtonColor = true
        optBtn.Parent = optionsFrame

        optBtn.MouseButton1Click:Connect(function()
            dropdown.Text = opt
            optionsFrame.Visible = false
            expanded = false
            container.Size = UDim2.new(1, -10, 0, 40)
            callback(opt)
        end)
    end

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        optionsFrame.Size = UDim2.new(1, 0, 0, layout.AbsoluteContentSize.Y)
    end)

    dropdown.MouseButton1Click:Connect(function()
        expanded = not expanded
        optionsFrame.Visible = expanded
        if expanded then
            container.Size = UDim2.new(1, -10, 0, 40 + optionsFrame.Size.Y.Offset)
        else
            container.Size = UDim2.new(1, -10, 0, 40)
        end
    end)
end

-- Textbox
function library:AddTextbox(parent, text, default, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -10, 0, 40)
    container.BackgroundTransparency = 1
    container.Parent = parent

    local label = Instance.new("TextLabel")
    label.Text = text
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.SourceSans
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local textbox = Instance.new("TextBox")
    textbox.Size = UDim2.new(1, 0, 0, 20)
    textbox.Position = UDim2.new(0, 0, 0, 20)
    textbox.Text = default or ""
    textbox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    textbox.TextColor3 = Color3.new(1, 1, 1)
    textbox.Font = Enum.Font.SourceSans
    textbox.TextSize = 14
    textbox.ClearTextOnFocus = false
    textbox.Parent = container

    textbox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            callback(textbox.Text)
        end
    end)
end

return library
