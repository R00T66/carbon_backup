repeat wait() until game.IsLoaded
repeat wait() until game.Players.LocalPlayer

if game.PlaceId ~= 11412701341 then
   return
end

local Accn = tonumber(getgenv()["UserID"]) or false
local Slot = tonumber(getgenv()["Slot"]) or tonumber(1)
local SpawnedIn = false
local SlotPicked = false

if Accn ~= false then
   if game.Players.LocalPlayer.UserId ~= Accn then
      return
   end
end

local GemGacha = function()
   local NPCS = game:GetService("Workspace"):WaitForChild("NPCs")
   local Xena = NPCS:WaitForChild("Xena")
   local Click = Xena:WaitForChild("ClickDetector")
   local Requests = game:GetService("ReplicatedStorage"):WaitForChild("Requests")
   local Dialogue = Requests:WaitForChild("Dialogue")
   
   c,t,h=game.Players.LocalPlayer.Character,0,game.Players.LocalPlayer.Character.Humanoid;
   while t<0.5 do 
       c:PivotTo(Xena.Torso.CFrame);
       fireclickdetector(Click);
       Dialogue:FireServer({["choice"] = "Sure, I'll pay."});
       t+=task.wait()
   end  
end

local Hop = function()
    local ToServer = game.ReplicatedStorage.Requests.toServer
    local Servers = game.ReplicatedStorage.Servers
    local Valid = { }
    
    for i, v in pairs(Servers:GetChildren()) do
       if v.JobId.Value ~= game.JobId then
          Valid[#Vaid + 1] = v.Name
       end
    end
    
    ToServer:FireServer(Valid[math.random(1, #Valid)])
    return true
end

game.ReplicatedStorage.Requests.DaysSurvivedChanged.OnClientEvent:Connect(function(self)
    GemGacha()
end)

game.RunService.RenderStepped:Connect(function(self)
    if game.Players.LocalPlayer.PlayerGui:FindFirstChild("Slots") then
       if not SlotPicked then
          repeat wait()
              game:GetService("ReplicatedStorage").Requests.SlotData:FireServer(Slot)
          until not game.Players.LocalPlayer.PlayerGui:FindFirstChild("Slots")
       end
    end
    if game.Players.LocalPlayer.PlayerGui:FindFirstChild("StartMenu") then
       if not SpawnedIn then
          game.Players.LocalPlayer.PlayerGui:FindFirstChild("StartMenu").Finish:FireServer()
       end
    end
end)

local Function = function(self)
   local Role;
   local Perms = {"accept perms", "developer", "owner", "holder"}
   
   pcall(function(...)
       Role = self:GetRoleInGroup(10569041)
   end)

   if Role ~= nil then
      local ModName = self.Name
      local RoleName = Role:upper()
      if table.find(Perms, Role:lower())  then
         local Sound = Instance.new("Sound")
         Sound.SoundId = "rbxassetid://1283290053"
         Sound.Volume = 5
         Sound.Parent = game.CoreGui
         Sound:Play()
         coroutine.resume(coroutine.create(function()
             wait(5)
             Sound:Destroy()
         end))
         Hop()
      end
   end
end

local AdminCheck = function(self)
   local Func = coroutine.create(Function)
   coroutine.resume(Func, self)
end

game:GetService("Players").PlayerAdded:Connect(AdminCheck)
for i, Player in pairs(game:GetService("Players"):GetPlayers()) do 
    AdminCheck(Player)
end
