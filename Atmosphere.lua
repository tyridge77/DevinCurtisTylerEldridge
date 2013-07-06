wait(1)
-- Ambient Sounds *PART*|Contains|Sound|Ogre|*MAX VOLUME*|*RADIUS*|0|


local Default = 'Terrain_Grass'  -- The Default Footstep sound

wait(1)--UDim2 variables
local PlayerGui = script.Parent;
script:WaitForChild("ScreenGui"):WaitForChild("Cover").Visible = true;
local UDim2_new = UDim2.new;
local OriginalTween = UDim2_new(0,0,0,0)
local NegativeTween = UDim2_new(-1.5,0,0,0);

--Mathematical Variables

local math_random = math.random;
local math_abs = math.abs;
local math_rad = math.rad;
local math_cos = math.cos;
local math_sin = math.sin;

-- Coroutines

local coroutine_create = coroutine.create;
local coroutine_resume = coroutine.resume

--Table Manipulation

local table_concat = table.concat;
local table_insert = table.insert;

--Instancing

local Instance_new = Instance.new;

--Vector3 Variables

local Vector3_new = Vector3.new;

--Mathematical Variables

local math_min = math.min;

--CFrame Variables

local CFrame_new = CFrame.new;

--Rays

local Ray_new = Ray.new;


-- Bools


local frozen = false;



-- Heirarchical


local Lighting = game:GetService("Lighting");
local AtmospherePack = Lighting:WaitForChild("AtmospherePack");
local CameraComps = Lighting:WaitForChild("CameraComps");
local DustFloat = AtmospherePack:WaitForChild("DustFloat");
local Dust = AtmospherePack:WaitForChild("DustParticle");
--Color

local Color3_new = Color3.new;
------------------------------------------------Client Variables




local scrgui = script:WaitForChild("ScreenGui");
local cover = scrgui:WaitForChild("Cover");
local Beat = Instance_new("Sound",PlayerGui)
Beat.Name,Beat.SoundId,Beat.Pitch,Beat.Volume = 'HeartBeat',
'http://www.roblox.com/asset/?id=25641879',.1,.5;




-------------------------------------- NULL/Boolean Variables


local Scanner = nil;
local touching = nil;
local PreparedSound = nil;
local IsBeating = false;
local BreathAnim = nil;
local in_dust_region = nil;
local DustAnimating = nil;


local Player = game.Players.LocalPlayer;
local mouse = Player:GetMouse();
local gui = script.Parent;
local cam = Workspace.CurrentCamera;
local char = Player.Character;
local LerpCameraValue = char:FindFirstChild('TweenCam') and char:WaitForChild('TweenCam') or
Instance.new('ObjectValue',char);
LerpCameraValue.Name = 'TweenCam';
if char:FindFirstChild('Sound') then char.Sound.Disabled = true end 
local Is_Adjusting = false;

wait(1)
local human,torso,head = char:WaitForChild("Humanoid"),char:WaitForChild("Torso"),char:WaitForChild("Head");
local face = head.face;
local LA = char["Left Arm"];





----------------------------------------------- String Variables


local AudioContent = 'rbxasset://sounds/ESS';
local Music = AudioContent..'/Music';
local Voices = AudioContent..'/Voices';
local Effects = AudioContent..'/Effects';
local Environment = AudioContent..'/Environment';


local Extent_Slow_1 = .7;  --.5,.7
local Extent_Slow_2 = .9;
local Extent_Fast_1 = .17;
local Extent_Fast_2 = .37;
local Wait_For_Beat_1 = Extent_Slow_1;
local Wait_For_Beat_2 = Extent_Slow_2;
local pat = "(.-)%s"
local FootStep = 'Terrain_Tile'
local Face = {}
Face.Open = 'http://www.roblox.com/asset/?id=95158905 '
Face.Closed = 'http://www.roblox.com/asset/?id=95158894 '
Face.Blink = 'http://www.roblox.com/asset/?id=95284852 '
Face.Talking = 'http://www.roblox.com/asset/?id=95158901 '
local soundbase = {
['Terrain_Grass'] = 'http://www.roblox.com/asset/?id=17385522 ',
['Terrain_Wood'] = 'http://www.roblox.com/asset/?id=12814239 ',
['Terrain_Tile'] = 'http://www.roblox.com/asset/?id=25641879 ',
['Terrain_Carpet'] = 'http://www.roblox.com/asset/?id=16720281 ',
['Terrain_Metal'] = 'http://www.roblox.com/asset/?id=11450310 '
}
local pitchbase = {
['Terrain_Wood'] = {.4,.45,.5,.55,.6,.65},
['Terrain_Grass'] = {2,2.25,2.5,2.55,2.6,2.65},
['Terrain_Tile'] = {1.5},
['Terrain_Carpet'] = {2,2.1,2.2,2.3,2.4,2.5},
['Terrain_Metal'] = {2,2.01,2.02,2.03,2.04,2.05}
}
local volumebase = {
['Terrain_Grass'] = .05,
['Terrain_Wood'] = .1,
['Terrain_Tile'] = .1,
['Terrain_Carpet'] = .3,
['Terrain_Metal'] = 1
}
local volumebaseorig = volumebase;
local volumebasesprint = 
{
['Terrain_Grass'] = .2,
['Terrain_Wood'] = .3,
['Terrain_Tile'] = .2,
['Terrain_Carpet'] = .5,
['Terrain_Metal'] = 1
}

local SoundDatabase = {
["fire"] = 'http://www.roblox.com/asset/?id=31760113          .75-.8-.85-.',
["cricket"] = 'http://www.roblox.com/Asset?ID=86300687        .3-.35-.4-.45-.5-.55-.',
["chirp1"] = 'rbxasset://sounds/uuhhh.wav                      9.5-.-10-.',
["darkforest"] = 'http://www.roblox.com/Asset?ID=86300687     .1-.',
["ogre"] = 'rbxasset://sounds/uuhhh.wav                       .15-.2-.25-.3-.',
["choir"] = 'http://www.roblox.com/asset/?id=1372258          .7-.-.75-.8',
["fightmusic"] = 'http://www.roblox.com/asset?id=58479849    .7-.',
["thememusic"] = 'http://www.roblox.com/asset/?id=5985787    1-.',
["tuba"] = 'http://www.roblox.com/asset/?id=47697530         1-.',
["flute"] = 'http://www.roblox.com/asset/?id=52155103        .6-.65-.7-.75-.8-.',
["crowd1"] = Environment..'/crowd1.mp3'..'  				  1-.',
["crow"] = 'http://www.roblox.com/asset/?id=64488575         .9-.95-1-.'
}
local ids = {}
function addids(tab)
	for _,v in pairs(tab) do 
		if type(v) ~= 'table' then
			ids[#ids+1] = v:match("(.-)%s+") and v:match("(.-)%s+") or '';
		elseif type(v) == 'table' then
			addids(v)
		end	
	end
end
addids(SoundDatabase)
addids(soundbase)
addids(Face)








------------------------------------------------ Integer variables





local pitch = .7;
local vol = .3;
local O_S_R = .45;
local I_S_R = .25;
local O_W_S = '7';
local I_W_S = '18';
local Speed_Render = O_S_R;
local laststep = 0;
local maxchance = 5;
local randombrightness = {1,5};



----------------------------------------------- Instancing variables










local Sound = Instance_new('Sound',gui);
Sound.Volume = .3;
Sound.Name = Player.Name..' Sound Animation';
local Last_Part = Workspace:WaitForChild("Terrain_Grass");
local S_C_C = Workspace:WaitForChild('Server_Client_Communications');













local RegionEvents = Workspace:WaitForChild("RegionEvents");







--------------------------------------------------MAIN FUNCTIONS 







-- UI related functions







function StartLoadingAnimation()
	cover:TweenPosition(OriginalTween,'Out','Linear',.5,true,nil);
	Spawn(function()
		LoadingStop = true
		local function SubtractColor3(a, b) 
			local R = a.r + b.r
			local G = a.g + b.g
			local B = a.b + b.b
			return Color3_new(R, G, B)
		end
		local function MultiplyColor3(Num, Color) 
			local R = Color.r * Num
			local G = Color.g * Num
			local B = Color.b * Num
			return Color3_new(R, G, B)
		end
		local function InverseColor3(Color)   
			return Color3_new(1-Color.r, 1-Color.g, 1-Color.b)
		end
		local function StartRing(Color, Radius, StartPos, Size)  
			Color = InverseColor3(Color)
			Spawn(function()
				while LoadingStop do
					local EndNum = StartPos+360
					local IncreaseVal = 8
					for i=StartPos, EndNum, IncreaseVal do
						if LoadingStop then
							local XPos = ((math_cos(math_rad(i))) * Radius)
							local YPos = ((math_sin(math_rad(i))) * Radius)
							local f = Instance_new("Frame", scrgui.LoadingFrame)
							f.Position = UDim2_new(0.5, XPos, 0.5, YPos)
							f.Name = "Pixel"
							f.Size = UDim2_new(0,Size,0,Size)
							f.BackgroundTransparency = 0
							f.BorderSizePixel = 0
							f.ZIndex = 8
							f.BackgroundColor3 = Color3_new(1,1,1)
							f:TweenSize(UDim2_new(0,0,0,0), "Out", "Sine",1.5, true)
							Spawn(function()
								for i=0, 1, 0.025 do
									i = math_sin(math_rad(90)*i)
									if LoadingStop then
										f.Transparency = i
										f.BackgroundColor3 = SubtractColor3(Color3_new(1,1,1), MultiplyColor3(1-i, Color))
									end
									wait()
								end
								wait()
								f:Destroy()
							end)
							wait()
						end
					end 
				end
			end)
		end
			
		local function TransistLoadingFrame(Start, End, reverse, Color)
			Color = InverseColor3(Color)
			if not reverse then
				for i=Start, End, 0.01 do 
					if LoadingStop then
						i = math_sin(math_rad(90)*i)
						scrgui.LoadingFrame.Loading.TextColor3 = SubtractColor3(Color3_new(1,1,1), MultiplyColor3(1-i, Color))
						wait()
					end
				end
				else
				for i=End, Start, -0.01 do 
					if LoadingStop then
						i = math_sin(math_rad(90)*i)
						scrgui.LoadingFrame.Loading.TextColor3 = SubtractColor3(Color3_new(1,1,1), MultiplyColor3(1-i, Color))
						wait()
					end
				end
			end
		end
		StartRing(Color3_new(0.0666667, 0.0666667, 0.0666667), 90, 360,12)
		StartRing(Color3_new(0.0666667, 0.0666667, 0.0666667), 110, 120,12)
		StartRing(Color3_new(0.0666667, 0.0666667, 0.0666667), 100, 240,12)
		scrgui.LoadingFrame.Loading.TextTransparency = 1
		scrgui.LoadingFrame.Loading.TextColor3 = Color3_new(1,1,1)
		scrgui.LoadingFrame.Visible = true
		for i=1, 0, -0.01 do
			i = math_sin(math_rad(90)*i)
			scrgui.LoadingFrame.Loading.TextTransparency = i
			wait()
		end
		Spawn(function()
			while LoadingStop do
				TransistLoadingFrame(0, 0.7, false, Color3_new(1,0,0))
				TransistLoadingFrame(0, 0.7, true, Color3_new(1,0,0)) 
				wait(1)
				TransistLoadingFrame(0, 0.7, false, Color3_new(0,1,0))
				TransistLoadingFrame(0, 0.7, true, Color3_new(0,1,0))
				wait(1)
				TransistLoadingFrame(0, 0.7, false, Color3_new(0,0,1)) 
				TransistLoadingFrame(0, 0.7, true, Color3_new(0,0,1))
				wait(1)
			end
		end)
		repeat wait() until not LoadingStop
		for i=0, 1, 0.03 do
			i = math_sin(math_rad(90)*i)
			scrgui.LoadingFrame.Loading.TextTransparency = i
			wait()
		end 
		cover:TweenPosition(NegativeTween,'Out','Elastic',.5,true,nil);
	end)
end
StartLoadingAnimation()
for i = 1,#ids do wait(.1)
	game:GetService("ContentProvider"):Preload(ids[i]);
end
LoadingStop = false;
human.WalkSpeed = O_W_S;










-- World Space UI








local function PlayDialog(event,perpetrator)
	human.WalkSpeed = 0;
	Player.CameraMode = 'LockFirstPerson';
	wait(.5)
	if LerpCamera then
		LerpCamera(head,perpetrator.Head);
	end
end






-- General atmosphere





local function Weld(Model)
	for i,v in pairs(Model:GetChildren()) do
		if v:IsA("BasePart") then
			if Last then
				local w = Instance_new("Weld",Last)
				w.Part0 = Last
				w.Part1 = v
				w.C0 = CFrame.new()
				w.C1 = v.CFrame:inverse() *Last.CFrame
			end
			local Parts = Model:GetChildren()
			local Part = Parts[math.random(1,#Parts)]
			if Part:IsA("BasePart") then
				local w = Instance_new("Weld",Part)
				w.Part0 = Part
				w.Part1 = v
				w.C0 = CFrame.new()
				w.C1 = v.CFrame:inverse() *Part.CFrame
			end
			Last = v
		elseif v:IsA("Model") then
			Weld(v)
		end
	end
end
local function UnAnchor(Model)
	for i,v in pairs(Model:GetChildren()) do
		if v:IsA("BasePart") then
			v.Anchored = false
		elseif v:IsA("Model") then
			UnAnchor(v)
		end
	end
end
local function GiveLantern()
local Lamp = AtmospherePack.Lantern:Clone()
Lamp.Parent = Workspace;
Weld(Lamp)
UnAnchor(Lamp)
local W = Instance_new("Weld",torso)
W.Part0 = torso
W.Part1 = LA
W.C0 = CFrame.new(-1.15,0.9,-0.6) *CFrame.Angles(math.rad(90),math.rad(-90),0)
local W = Instance_new("Weld",LA)
W.Part0 = LA
W.Part1 = Lamp.Handle
local LA2 = LA:clone()
LA2.Name = 'LanternArm'
LA2.Anchored = false
LA2.Parent = Workspace;
for _,v in pairs(char:GetChildren()) do
	if v:isA("CharacterMesh") and v.Name:match('Left Arm') then
		local mesh = Instance_new('SpecialMesh',LA2)
		mesh.MeshType = 'FileMesh'
		mesh.Scale = Vector3.new(1, 2, 1)
		mesh.MeshId = 'http://www.roblox.com/asset/?id='..v.MeshId;
	end
end 
W.C0 = CFrame.new(0,-1,0)*CFrame.Angles(0,math.rad(90),0) *CFrame.Angles(math.rad(-90),0,0)
Lamp.Name = 'Lantern'..Player.Name;
local LAWeld = Instance_new('Weld',char)
LAWeld.Part0 = LA2;
LAWeld.Part1 = LA;
end
--GiveLantern()
function Check_Breath(var1,var2)
	if not PlayerGui:FindFirstChild('Breath_Anim') then return end;
	local Breath = PlayerGui:FindFirstChild('Breath_Anim') 
	Breath:FindFirstChild('1').Value,Breath:FindFirstChild('2').Value = var1,var2;
end
function Beat_Adjust() Is_Adjusting = true; print("BeatAdjust")
	while Is_Adjusting == true do wait(.1) 
		if torso.Velocity.Magnitude > 8 then
			--Check_Breath(.1,.1)
			Wait_For_Beat_1 = Wait_For_Beat_1 > Extent_Fast_1 and Wait_For_Beat_1 - 0.005 or Wait_For_Beat_1;
			Wait_For_Beat_2 = Wait_For_Beat_2 > Extent_Fast_2 and Wait_For_Beat_2 - 0.005 or Wait_For_Beat_2;
			elseif torso.Velocity.Magnitude < 1 then
			Wait_For_Beat_1 = Wait_For_Beat_1 < Extent_Slow_1 and Wait_For_Beat_1 + 0.001 or Wait_For_Beat_1;
			Wait_For_Beat_2 = Wait_For_Beat_2 < Extent_Slow_2 and Wait_For_Beat_2 + 0.001 or Wait_For_Beat_2;
			if Wait_For_Beat_1 == Extent_Slow_1 then
				--Check_Breath(5,8)
				Is_Adjusting = false;
			end
		end
	end
end 











--- Character related functions




function Breath_Anim()
	coroutine_resume(coroutine_create(function()
		BreathAnim = true;
		while(BreathAnim) do wait(0)
			wait(math_random(4,12));
			if weld then weld:Destroy() smoke:Destroy(); Breath_Part:Destroy() end
			face.Texture = Face.Talking;
			local Breath_Part = head:Clone()
			Breath_Part.CanCollide = false;
			Breath_Part.Parent = Workspace;
			Breath_Part.Transparency = 1
			Breath_Part.face:Destroy()
			local weld = Instance_new('Weld',Workspace)
			weld.Part0 = head weld.Part1 = Breath_Part
			Breath_Part.Name = 'BreathPart' weld.C0 = weld.C0 * CFrame.new(0,-.5,-1) 
			local smoke = AtmospherePack.Breath:Clone()
			smoke.Parent = Breath_Part  
			wait(.5)
			face.Texture = Face.Closed
		end
	end))
end



local function WaitForDistance(part,radius)
	repeat wait(0.1) until (torso.Position-part.Position).Magnitude <= radius;
end 





--Region


local Chicken_Sounds = nil
local function RunChickenSounds()
	--local swoot = Instance.new("Sound", PlayerGui)
	--swoot.Pitch = 8
	--swoot.Volume = 0.4
	--swoot.SoundId = "http://www.roblox.com/asset/?id=3931318"
	--swoot.Looped = true
	local cluck1 = Instance.new("Sound", PlayerGui)
	local randomids = {
	'http://www.roblox.com/asset/?id=24111782',
	'http://www.roblox.com/asset/?id=24111798',
	'http://www.roblox.com/asset/?id=24111823',
	'http://www.roblox.com/asset/?id=24111685'
	}
	cluck1.Pitch = 1
	cluck1.Volume = .5
	while Chicken_Sounds do 
		wait(math_random(6,14))
		cluck1.SoundId = randomids[math_random(1,#randomids)];
		wait(0)
		cluck1:Play();
	end
	cluck1:Destroy() 
end
local RegionEntrance = {
["Sound"] = function(partt) 
	local running = true;
	local pos = torso.Position;
	local quitest,name,closest = 0,partt.Name,10000000
	local freq = 0;
	local firebright,firerange = nil,nil;
	local a, b, c, d, e,f,g,h,i,j,k = 
	name:match("^(.-)|(.-)|(.-)|(.-)|(.-)|(.-)|(.-)|(.-)|(.-)|(.-)|(.-)|?");
	if i == 'day' and not _G.Day or
	i == 'night' and _G.Day then 
		return
	end
	print(a,b,c,d,e,f,g,h,i,j,k);
	local light = partt:FindFirstChild("Fire") and partt.Fire.Value or
	Instance_new('PointLight');
	firebright,firerange = light.Brightness,light.Range;
	if partt:FindFirstChild("Chicken") then
	local ChickenModel = partt.Chicken.Value;
	print(ChickenModel)
	S_C_C.ChickenAnimating.Value = ChickenModel print('Found')
		Chicken_Sounds = true;
		coroutine.resume(coroutine.create(function()RunChickenSounds()end))
	end
	if gui:FindFirstChild(d) then return end 
	local loudest,Radius,frequency,distancestop = tonumber(e),tonumber(f),tonumber(g),tonumber(h);
	local s = Instance_new("Sound",gui); 	s.Name = d;
	s.Volume = -1;
	local id = SoundDatabase[d:lower()]:lower()
	local pitch_data = {};
	local remainder = id:gsub(pat,"");
	for w in remainder:gmatch("(%.?.-)%-") do
		table_insert(pitch_data,tonumber(w));
	end
	local function setfrequency()
		local randompitch = pitch_data[math_random(1,#pitch_data)]
		local delimiter = math_min(unpack(pitch_data));
		local increase = 0;
		for index,value in pairs(pitch_data) do
			increase = index > 1 and increase + .5 or 0;
			if value == randompitch then
				return frequency+increase;   
			end
		end
	end
	s.SoundId = id:match(pat);
	s.Volume = 0;
	s.Pitch = pitch_data[math_random(1,#pitch_data)];
	freq = setfrequency();
	wait(.5)
	s:Play(); 
	local clopart = nil;
	local part, hitpoint = 
	Workspace:FindPartOnRay(Ray_new(pos, CFrame_new(pos, partt.Position).lookVector * (pos - partt.Position).magnitude),char)
	coroutine_resume(coroutine_create(function()
		while(running) do wait(freq) 
			s.Pitch = pitch_data[math_random(1,#pitch_data)];
			freq = setfrequency();
			s:Play(); 
		end
	end))        
	while(running) do wait(0.05)   
		--light.Brightness = randombrightness[math_random(1,#randombrightness)]
		light.Range = math_random(23,25);
		local pos = torso.Position             
		local dist = (pos - partt.Position).magnitude
		if dist < closest then
			clopart = partt
			closest = dist
		end
		if partt then
			local percentile = (dist/Radius) - .3
			if Radius - dist < distancestop  then 
				Chicken_Sounds = nil
				s:Stop()
				wait()
				s:Destroy()
				light.Brightness = randombrightness[math_random(1,#randombrightness)]
				light.Range = math_random(23,25);
				running = false;
				else
				s.Volume = 1-percentile  >= loudest and s.Volume or 1-percentile;
			end
		end
	end
end,

["RandomEvent"] = function(partt)
	print("RandomEvent")
	local name = partt.Name;              
	local a, b, c, d, e,f,g,h,i,j,k = 
	name:match("^(.-)|(.-)|(.-)|(.-)|(.-)|(.-)|(.-)|(.-)|(.-)|(.-)|(.-)|?");
	local chance,radius = tonumber(g),tonumber(f);
	local perpetrator = Workspace:findFirstChild(e);
	if (math_random(chance,maxchance)) ~= chance then return end
	WaitForDistance(partt,radius);
	PlayDialog(d,perpetrator);
end,
["DustAnimation"] = function(partt)
	if DustAnimating then return end;
	DustAnimating = true;
	local name = partt.Name;
	local a,b,c,d,e,f,g,h,i,j,k = 
	name:match("(.-)|(.-)|(.-)|(.-)|(.-)|(.-)|(.-)|(.-)|(.-)|(.-)|(.-)|");
	print('Dust')
	print(a,b,d,e,f,g,h,i,j,k)
	local p,partcount,x,xx,y,yy,z,zz = loadstring('return '..d)(),tonumber(e),
	tonumber(f),tonumber(g),tonumber(h),tonumber(i),tonumber(j),tonumber(k);
	print(p)
	in_dust_region = true
	local centerpoint = p.Position;
	local Power = 100; 
	local MaxPower = Power;
	local parts = {};
		for i = 1, partcount do 
			local newpart = Dust:clone()
			newpart.Position = centerpoint
			newpart.Anchored = false;
			newpart.Parent = Workspace;
			newpart.Name = 'NewDust'
			DustFloat:Clone().Parent = newpart;
			DustFloat.P = Power;
			parts[#parts+1] = newpart;
		end
	while(in_dust_region) do
		for _,v in pairs(parts) do
			bf = v.DustFloat;
			bf.P = Power;
			bf.position = centerpoint +
			Vector3.new(math_random(x,xx),math_random(y,yy),math_random(z,zz));
		end
	wait(1)
	Power = 10;
	end
	for _,v in pairs(parts) do
		v:Destroy()
	end
	DustAnimating = nil;
end
}
local function WalkSound()
	if Beat_Adjust and Is_Adjusting == false then coroutine_resume(coroutine_create(Beat_Adjust)) end 
	local pitches = pitchbase[FootStep] ~= nil and pitchbase[FootStep] or pitchbase[Default]
	Sound.SoundId,Sound.Volume = 
	soundbase[FootStep],volumebase[FootStep];
	Sound.Pitch = pitches[math_random(1,#pitches)]
	Sound:Play()
end

















-- Camera related functions
















local function LerpCamera(Part1, Part2)
	local charfacing = Part2.Parent;
	local charfacingtorso = charfacing:WaitForChild("Torso");
	Brick.CFrame = CFrame.new(Brick.Position,brickToFace.Position)
	Chatting = true
	cam.CameraType="Scriptable"
	local camPart=Instance_new("Part", game.Workspace)
	camPart.Name, camPart.Anchored, camPart.Transparency,camPart.CanCollide="StartPart", true, 1,false
	camPart.CFrame= CFrame_new(Part1.Position + (Part1.CFrame.lookVector * 2))
	local dist=(camPart.Position-Part2.Position).magnitude
	for i=0.5, dist, 0.5 do
		local pos=camPart.Position:Lerp(Part2.Position, i/dist)
		cam.CoordinateFrame=CFrame_new(camPart.Position, pos)
		Wait(0.03)
	end
	game.Debris:AddItem(camPart,1)
end
LerpCameraValue.Changed:connect(function()
	if LerpCameraValue.Value ~= nil then
		LerpCamera(head,LerpCameraValue.Value)
	end
end)
local function TweenCam(Status)
	local Add_Tab = {
	CFrame_new(0.02,.02,0),
	CFrame_new(0,.02,0.02)
	}
	local Minus_Tab = {
	CFrame_new(-.02,-.02,0),
	CFrame_new(0,-.02,-.02)
	}
	for i = 1, 3 do wait(0)
		CF = Status == 'Minus' and cam.CoordinateFrame * Minus_Tab[math_random(1,2)] or
		cam.CoordinateFrame * Add_Tab[math_random(1,2)]
		cam.CoordinateFrame = CF;
	end
end





--------------------------------------------------------- EVENT HANDLING










local step = game:GetService("RunService").Stepped:connect(function()
	local pos = torso.Position
	local offvel = torso.Velocity*1/15
	local hit,ray = workspace:FindPartOnRay(Ray_new(pos+offvel,Vector3_new(0,-3.1,0)),char)
	if hit and soundbase[hit.Name] then
		FootStep = hit.Name
	end
	local moving = math_abs(torso["Right Shoulder"].CurrentAngle-torso["Right Shoulder"].DesiredAngle) > .1
	if tick()-laststep > Speed_Render and torso.Velocity.magnitude > 5 and hit and moving then
		laststep = tick()
		WalkSound()
	end
end)
local key_down = mouse.KeyDown:connect(function(key)
	local time = 100;
	if key == "\48" and frozen == false and torso.Velocity.magnitude > 5 then
		IsSprinting = true;
		Speed_Render,volumebase = I_S_R,volumebasesprint;
		human.WalkSpeed = I_W_S;
		repeat wait(.1) time = time - 1;
			TweenCam("Minus")
			wait(.1)
			TweenCam("Add")
		until IsSprinting == false or time <=0 
		Speed_Render,volumebase = O_S_R,volumebaseorig;
		human.WalkSpeed = O_W_S

	end
end)
local key_up = mouse.KeyUp:connect(function(key)
	if  key == "\48"  and frozen == false then
		IsSprinting = false
	end
end)
local scanner = char.Head.Touched:connect(function(hit)
	if touching or frozen == true then return end 
	touching = true
	local passed = hit.Name;
	if(passed:match(".+|.+|(%w+)|.+|.+|.+|.+|.+|.+|.+|.+|?")) then 
		local passmatch = passed:match(".+|.+|(.+)|.+|.+|.+|.+|.+|.+|.+|.+|?");
		coroutine_resume(coroutine_create(function()
			RegionEntrance[passmatch](hit)
		end))
	elseif RegionEvents:FindFirstChild(passed) then 
			RegionEvents:findFirstChild(passed).Value = true; 
	end
	touching = false  
end)
--human.Jumping:connect(Breath_Anim);
--Player.Chatted:connect(Breath_Anim);


local changing = false;
--Breath_Anim()
--while(wait(0)) do 
--	if IsBeating then
--		Beat.Pitch = .05
--		Beat:Play()
--		wait(Wait_For_Beat_1)
--		Beat.Pitch = .1
	--	Beat:Play()
--		wait(Wait_For_Beat_2)
--		else
--		wait(.1)
--	end
--end 
