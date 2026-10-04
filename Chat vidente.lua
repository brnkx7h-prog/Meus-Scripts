--// CHAT PAPAGAIO
--// Roblox Studio - LocalScript
--// Usa TextChatService oficial

local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--==================================================
-- CONFIGURAÇÃO
--==================================================

local GUI_NAME = "ChatPapagaio"

local selectedPlayer = nil
local active = false
local messageConnection = nil

--==================================================
-- GUI
--==================================================

local oldGui = PlayerGui:FindFirstChild(GUI_NAME)
if oldGui then
	oldGui:Destroy()
end

local Gui = Instance.new("ScreenGui")
Gui.Name = GUI_NAME
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.Parent = PlayerGui

--==================================================
-- CONTAINER PRINCIPAL
--==================================================

local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(320, 330)
Main.Position = UDim2.new(1, -340, 0, 100)
Main.BackgroundColor3 = Color3.fromRGB(17, 18, 23)
Main.BorderSizePixel = 0
Main.Parent = Gui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(48, 50, 61)
MainStroke.Thickness = 1
MainStroke.Parent = Main

--==================================================
-- BARRA SUPERIOR
--==================================================

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 64)
Header.BackgroundColor3 = Color3.fromRGB(23, 24, 31)
Header.BorderSizePixel = 0
Header.Parent = Main

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 14)
HeaderCorner.Parent = Header

local HeaderBottom = Instance.new("Frame")
HeaderBottom.Size = UDim2.new(1, 0, 0, 15)
HeaderBottom.Position = UDim2.new(0, 0, 1, -15)
HeaderBottom.BackgroundColor3 = Color3.fromRGB(23, 24, 31)
HeaderBottom.BorderSizePixel = 0
HeaderBottom.Parent = Header

--==================================================
-- ÍCONE
--==================================================

local Icon = Instance.new("TextLabel")
Icon.Size = UDim2.fromOffset(42, 42)
Icon.Position = UDim2.fromOffset(12, 11)
Icon.BackgroundColor3 = Color3.fromRGB(45, 110, 220)
Icon.BorderSizePixel = 0
Icon.Text = "🦜"
Icon.TextSize = 21
Icon.Font = Enum.Font.GothamBold
Icon.Parent = Header

local IconCorner = Instance.new("UICorner")
IconCorner.CornerRadius = UDim.new(0, 11)
IconCorner.Parent = Icon

--==================================================
-- TÍTULO
--==================================================

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -125, 0, 24)
Title.Position = UDim2.fromOffset(65, 10)
Title.BackgroundTransparency = 1
Title.Text = "Chat Papagaio"
Title.TextColor3 = Color3.fromRGB(245, 245, 250)
Title.TextSize = 17
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(1, -125, 0, 18)
Subtitle.Position = UDim2.fromOffset(65, 32)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Repetição automática de mensagens"
Subtitle.TextColor3 = Color3.fromRGB(130, 133, 145)
Subtitle.TextSize = 10
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = Header

--==================================================
-- BOTÃO ABRIR / FECHAR
--==================================================

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.fromOffset(36, 36)
ToggleButton.Position = UDim2.new(1, -48, 0, 14)
ToggleButton.BackgroundColor3 = Color3.fromRGB(35, 37, 47)
ToggleButton.BorderSizePixel = 0
ToggleButton.Text = "−"
ToggleButton.TextColor3 = Color3.fromRGB(230, 232, 240)
ToggleButton.TextSize = 22
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.AutoButtonColor = true
ToggleButton.Parent = Header

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 9)
ToggleCorner.Parent = ToggleButton

--==================================================
-- STATUS / ALVO
--==================================================

local TargetBox = Instance.new("Frame")
TargetBox.Size = UDim2.new(1, -24, 0, 47)
TargetBox.Position = UDim2.fromOffset(12, 75)
TargetBox.BackgroundColor3 = Color3.fromRGB(25, 26, 34)
TargetBox.BorderSizePixel = 0
TargetBox.Parent = Main

local TargetCorner = Instance.new("UICorner")
TargetCorner.CornerRadius = UDim.new(0, 9)
TargetCorner.Parent = TargetBox

local TargetIndicator = Instance.new("Frame")
TargetIndicator.Size = UDim2.fromOffset(4, 25)
TargetIndicator.Position = UDim2.fromOffset(9, 11)
TargetIndicator.BackgroundColor3 = Color3.fromRGB(75, 80, 95)
TargetIndicator.BorderSizePixel = 0
TargetIndicator.Parent = TargetBox

local TargetIndicatorCorner = Instance.new("UICorner")
TargetIndicatorCorner.CornerRadius = UDim.new(1, 0)
TargetIndicatorCorner.Parent = TargetIndicator

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, -30, 1, 0)
Status.Position = UDim2.fromOffset(22, 0)
Status.BackgroundTransparency = 1
Status.Text = "Nenhum jogador selecionado"
Status.TextColor3 = Color3.fromRGB(155, 158, 170)
Status.TextSize = 12
Status.Font = Enum.Font.GothamMedium
Status.TextXAlignment = Enum.TextXAlignment.Left
Status.Parent = TargetBox

--==================================================
-- BOTÃO SELECIONAR
--==================================================

local SelectButton = Instance.new("TextButton")
SelectButton.Size = UDim2.new(1, -24, 0, 42)
SelectButton.Position = UDim2.fromOffset(12, 132)
SelectButton.BackgroundColor3 = Color3.fromRGB(45, 95, 190)
SelectButton.BorderSizePixel = 0
SelectButton.Text = "SELECIONAR JOGADOR"
SelectButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SelectButton.TextSize = 12
SelectButton.Font = Enum.Font.GothamBold
SelectButton.AutoButtonColor = true
SelectButton.Parent = Main

local SelectCorner = Instance.new("UICorner")
SelectCorner.CornerRadius = UDim.new(0, 9)
SelectCorner.Parent = SelectButton

local SelectStroke = Instance.new("UIStroke")
SelectStroke.Color = Color3.fromRGB(70, 125, 235)
SelectStroke.Transparency = 0.45
SelectStroke.Parent = SelectButton

--==================================================
-- LISTA DE JOGADORES
--==================================================

local PlayerList = Instance.new("ScrollingFrame")
PlayerList.Size = UDim2.new(1, -24, 0, 145)
PlayerList.Position = UDim2.fromOffset(12, 180)
PlayerList.BackgroundColor3 = Color3.fromRGB(21, 22, 29)
PlayerList.BorderSizePixel = 0
PlayerList.ScrollBarThickness = 4
PlayerList.ScrollBarImageColor3 = Color3.fromRGB(75, 78, 92)
PlayerList.Visible = false
PlayerList.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerList.Parent = Main

local PlayerListCorner = Instance.new("UICorner")
PlayerListCorner.CornerRadius = UDim.new(0, 9)
PlayerListCorner.Parent = PlayerList

local PlayerListStroke = Instance.new("UIStroke")
PlayerListStroke.Color = Color3.fromRGB(43, 45, 55)
PlayerListStroke.Transparency = 0.2
PlayerListStroke.Parent = PlayerList

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 5)
ListLayout.Parent = PlayerList

local ListPadding = Instance.new("UIPadding")
ListPadding.PaddingTop = UDim.new(0, 7)
ListPadding.PaddingLeft = UDim.new(0, 7)
ListPadding.PaddingRight = UDim.new(0, 7)
ListPadding.PaddingBottom = UDim.new(0, 7)
ListPadding.Parent = PlayerList

--==================================================
-- BOTÃO ATIVAR
--==================================================

local ActivateButton = Instance.new("TextButton")
ActivateButton.Size = UDim2.new(1, -24, 0, 42)
ActivateButton.Position = UDim2.fromOffset(12, 180)
ActivateButton.BackgroundColor3 = Color3.fromRGB(38, 155, 82)
ActivateButton.BorderSizePixel = 0
ActivateButton.Text = "ATIVAR PAPAGAIO"
ActivateButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ActivateButton.TextSize = 12
ActivateButton.Font = Enum.Font.GothamBold
ActivateButton.AutoButtonColor = true
ActivateButton.Parent = Main

local ActivateCorner = Instance.new("UICorner")
ActivateCorner.CornerRadius = UDim.new(0, 9)
ActivateCorner.Parent = ActivateButton

local ActivateStroke = Instance.new("UIStroke")
ActivateStroke.Color = Color3.fromRGB(70, 190, 105)
ActivateStroke.Transparency = 0.5
ActivateStroke.Parent = ActivateButton

--==================================================
-- INFORMAÇÃO
--==================================================

local Info = Instance.new("TextLabel")
Info.Size = UDim2.new(1, -24, 0, 34)
Info.Position = UDim2.fromOffset(12, 235)
Info.BackgroundTransparency = 1
Info.Text = "Selecione alguém e ative o papagaio."
Info.TextColor3 = Color3.fromRGB(105, 108, 120)
Info.TextSize = 10
Info.Font = Enum.Font.Gotham
Info.TextXAlignment = Enum.TextXAlignment.Center
Info.Parent = Main

--==================================================
-- FUNÇÃO PARA AJUSTAR A INTERFACE
--==================================================

local function updateInterfaceLayout()
	if PlayerList.Visible then

		-- Expande a interface para a lista não ficar
		-- por cima dos outros elementos.
		Main.Size = UDim2.fromOffset(320, 500)

		ActivateButton.Position = UDim2.fromOffset(12, 335)

		Info.Position = UDim2.fromOffset(12, 390)

	else

		Main.Size = UDim2.fromOffset(320, 330)

		ActivateButton.Position = UDim2.fromOffset(12, 180)

		Info.Position = UDim2.fromOffset(12, 235)

	end
end

--==================================================
-- FUNÇÕES
--==================================================

local function updateStatus()
	if selectedPlayer and selectedPlayer.Parent then
		Status.Text = "Alvo: " .. selectedPlayer.DisplayName
	else
		Status.Text = "Nenhum jogador selecionado"
	end
end

local function refreshPlayerList()
	for _, child in ipairs(PlayerList:GetChildren()) do
		if child:IsA("TextButton") then
			child:Destroy()
		end
	end

	local players = Players:GetPlayers()

	table.sort(players, function(a, b)
		return a.DisplayName:lower() < b.DisplayName:lower()
	end)

	for _, player in ipairs(players) do

		local Button = Instance.new("TextButton")
		Button.Size = UDim2.new(1, 0, 0, 34)
		Button.BackgroundColor3 = Color3.fromRGB(31, 32, 41)
		Button.BorderSizePixel = 0
		Button.Text = player.DisplayName .. "  @" .. player.Name
		Button.TextColor3 = Color3.fromRGB(235, 236, 242)
		Button.TextSize = 11
		Button.Font = Enum.Font.GothamMedium
		Button.TextXAlignment = Enum.TextXAlignment.Left
		Button.AutoButtonColor = true
		Button.Parent = PlayerList

		local ButtonPadding = Instance.new("UIPadding")
		ButtonPadding.PaddingLeft = UDim.new(0, 10)
		ButtonPadding.Parent = Button

		local ButtonCorner = Instance.new("UICorner")
		ButtonCorner.CornerRadius = UDim.new(0, 7)
		ButtonCorner.Parent = Button

		Button.MouseButton1Click:Connect(function()

			if player == LocalPlayer then
				Status.Text = "Você não pode ser o próprio alvo."
				Status.TextColor3 = Color3.fromRGB(255, 170, 70)
				return
			end

			selectedPlayer = player
			PlayerList.Visible = false

			updateInterfaceLayout()

			Status.Text = "Alvo: " .. player.DisplayName
			Status.TextColor3 = Color3.fromRGB(120, 220, 140)

		end)
	end

	task.wait()

	PlayerList.CanvasSize = UDim2.new(
		0,
		0,
		0,
		ListLayout.AbsoluteContentSize.Y + 14
	)
end

--==================================================
-- ENCONTRAR CANAL DE CHAT
--==================================================

local function getChatChannel()

	local channels = TextChatService:FindFirstChild("TextChannels")

	if not channels then
		return nil
	end

	-- Canal padrão do chat público
	local general = channels:FindFirstChild("RBXGeneral")

	if general and general:IsA("TextChannel") then
		return general
	end

	-- Caso o jogo tenha outro canal público
	for _, channel in ipairs(channels:GetChildren()) do
		if channel:IsA("TextChannel") then
			return channel
		end
	end

	return nil
end

--==================================================
-- REPETIR MENSAGEM
--==================================================

local function repeatMessage(text)

	if not active then
		return
	end

	if text == nil or text == "" then
		return
	end

	local channel = getChatChannel()

	if not channel then
		Status.Text = "Canal de chat não encontrado."
		Status.TextColor3 = Color3.fromRGB(255, 90, 90)
		return
	end

	local success, err = pcall(function()
		channel:SendAsync(text)
	end)

	if success then
		Status.Text = "Papagaio: mensagem repetida!"
		Status.TextColor3 = Color3.fromRGB(100, 220, 130)
	else
		Status.Text = "Erro ao enviar mensagem."
		Status.TextColor3 = Color3.fromRGB(255, 90, 90)
		warn("[Chat Papagaio] " .. tostring(err))
	end
end

--==================================================
-- DETECTOR DE CHAT
--==================================================

local function connectChat()

	if messageConnection then
		messageConnection:Disconnect()
		messageConnection = nil
	end

	messageConnection = TextChatService.MessageReceived:Connect(function(message)

		if not active then
			return
		end

		if not selectedPlayer then
			return
		end

		if not message.TextSource then
			return
		end

		if message.Status ~= Enum.TextChatMessageStatus.Success then
			return
		end

		local authorId = message.TextSource.UserId

		if authorId == LocalPlayer.UserId then
			return
		end

		if authorId ~= selectedPlayer.UserId then
			return
		end

		if not message.TextChannel then
			return
		end

		if message.TextChannel.Name ~= "RBXGeneral" then
			return
		end

		local text = message.Text

		if text and text ~= "" then
			repeatMessage(text)
		end
	end)
end

--==================================================
-- BOTÃO SELECIONAR
--==================================================

SelectButton.MouseButton1Click:Connect(function()

	PlayerList.Visible = not PlayerList.Visible

	if PlayerList.Visible then
		refreshPlayerList()
	end

	updateInterfaceLayout()

end)

--==================================================
-- BOTÃO ATIVAR
--==================================================

ActivateButton.MouseButton1Click:Connect(function()

	if not selectedPlayer then
		Status.Text = "Selecione um jogador primeiro."
		Status.TextColor3 = Color3.fromRGB(255, 170, 70)
		return
	end

	if not selectedPlayer.Parent then
		selectedPlayer = nil
		updateStatus()
		return
	end

	active = not active

	if active then

		ActivateButton.Text = "DESATIVAR PAPAGAIO"
		ActivateButton.BackgroundColor3 = Color3.fromRGB(190, 60, 65)

		Status.Text = "Papagaio ativo: " .. selectedPlayer.DisplayName
		Status.TextColor3 = Color3.fromRGB(100, 220, 130)

		connectChat()

	else

		ActivateButton.Text = "ATIVAR PAPAGAIO"
		ActivateButton.BackgroundColor3 = Color3.fromRGB(38, 155, 82)

		Status.Text = "Papagaio desativado."
		Status.TextColor3 = Color3.fromRGB(170, 170, 170)

		if messageConnection then
			messageConnection:Disconnect()
			messageConnection = nil
		end

	end

end)

--==================================================
-- BOTÃO ABRIR / FECHAR
--==================================================

local interfaceOpen = true

ToggleButton.MouseButton1Click:Connect(function()

	interfaceOpen = not interfaceOpen

	if interfaceOpen then

		-- Abre a interface
		TargetBox.Visible = true
		SelectButton.Visible = true
		PlayerList.Visible = false
		ActivateButton.Visible = true
		Info.Visible = true

		ToggleButton.Text = "−"

		updateInterfaceLayout()

	else

		-- Fecha somente o conteúdo visual.
		-- O funcionamento do papagaio continua normalmente.
		TargetBox.Visible = false
		SelectButton.Visible = false
		PlayerList.Visible = false
		ActivateButton.Visible = false
		Info.Visible = false

		Main.Size = UDim2.fromOffset(320, 64)

		ToggleButton.Text = "+"

	end

end)

--==================================================
-- JOGADORES ENTRANDO/SAINDO
--==================================================

Players.PlayerAdded:Connect(function()
	refreshPlayerList()
end)

Players.PlayerRemoving:Connect(function(player)

	if selectedPlayer == player then

		selectedPlayer = nil
		active = false

		if messageConnection then
			messageConnection:Disconnect()
			messageConnection = nil
		end

		ActivateButton.Text = "ATIVAR PAPAGAIO"
		ActivateButton.BackgroundColor3 = Color3.fromRGB(38, 155, 82)

		Status.Text = "O jogador saiu do servidor."
		Status.TextColor3 = Color3.fromRGB(255, 170, 70)
	end

	task.defer(refreshPlayerList)

end)

--==================================================
-- ARRASTAR UI
--==================================================

local dragging = false
local dragStart
local startPosition

Title.InputBegan:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		dragging = true
		dragStart = input.Position
		startPosition = Main.Position

	end

end)

Title.InputEnded:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		dragging = false

	end

end)

UserInputService.InputChanged:Connect(function(input)

	if not dragging then
		return
	end

	if input.UserInputType ~= Enum.UserInputType.MouseMovement
		and input.UserInputType ~= Enum.UserInputType.Touch then
		return
	end

	local delta = input.Position - dragStart

	Main.Position = UDim2.new(
		startPosition.X.Scale,
		startPosition.X.Offset + delta.X,
		startPosition.Y.Scale,
		startPosition.Y.Offset + delta.Y
	)

end)

--==================================================
-- INICIALIZAÇÃO
--==================================================

refreshPlayerList()
updateStatus()
updateInterfaceLayout()

print("[Chat Papagaio] iniciado com sucesso.")