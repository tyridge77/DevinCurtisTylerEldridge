wait(1)
--Particle Engine 
-- July 05, 2013, 1:23


local entering = nil;
local Players = game:GetService('Players')
local Lighting = game:GetService('Lighting');
local CameraComps = Lighting.CameraComps;
local Player = Players.LocalPlayer;
local human = Player.Character.Humanoid;
local PlayerGui = Player.PlayerGui;
local MagicUI = PlayerGui:WaitForChild('Magic');
local BG = MagicUI:WaitForChild('BG')
local MagicUIShowing = false;
local mouse = Player:GetMouse();
local moving = Instance.new('BoolValue')
moving.Value = false;

local CharacterMenu = PlayerGui:WaitForChild('CharMenu');
local ActionBar = CharacterMenu:WaitForChild('ActionBar');
local ActionBarChildren = ActionBar:GetChildren();
local Panel = MagicUI.Panel;
local Description = Panel:WaitForChild('Description');

local Background = CharacterMenu:WaitForChild('Background');
local Buffs = CharacterMenu:WaitForChild('Buffs');
local PartyGui = CharacterMenu:WaitForChild('PartyGui');
local Main = CharacterMenu:WaitForChild('Main');
local enterevents = {};
local clickevents = {};
local leaveevents = {};
local KeyBinds = {};
local CurrentlyAssigning = nil;
local mr = math.random;
local cam = Workspace.CurrentCamera;
local string_to_boolean = {['true']=true,['false']=false};
local cr = coroutine.resume;
local cc = coroutine.create;
local DescriptionLibrary = {
['Call of Keilfur'] = ' Summons orbs to heal all around you, including yourself.',
['Illuminating Orb'] = ' Casts an orb to brighten the radius around you in a dark environment.',
["Esstin's Sanctum"] = ' Blinds your foes by spawning a series of hindering clouds'
}
local SpellLibrary = {
['Call of Keilfur'] = 
[=[
        dust/
        Duration: 20 seconds/
        Flicker:False(15,17)/
        AddObjects:false/
        BrickColor:Institutional White/
        LightColor:Deep blue/
        Range: 0/
        HealthImpact: -.1/
        MeshX: 1/
        MeshY: 1/
        MeshZ: 1/ 
        PartCount: 100/
        PartTransparency: 0.7/
        TransitionTimeToFullPower: 3/
        FullPower: 500/
        RandomX1: -20/
        RandomX2: 20/
        RandomY1: 0/
        RandomY2: 4/
        RandomZ1: -20/
        RandomZ2: 20
]=],
['Illuminating Orb'] = 
[=[
dust/
        Duration:1 minute/
        Flicker:False/
        AddObjects:false/
        BrickColor:Bright blue/
        LightColor:Deep blue/
        Range: 25/
        HealthImpact: 0/
        MeshX: 1/
        MeshY: 1/
        MeshZ: 1/
        PartCount: 1/
        PartTransparency: .6/
        TransitionTimeToFullPower: .5/
        FullPower: 1000/
        RandomX1: 0/
        RandomX2: 0/
        RandomY1: 3/
        RandomY2: 6/
        RandomZ1: 0/
        RandomZ2: 0
]=],
["Esstin's Sanctum"] = 
[=[
dust/
	 	Duration:20 seconds/
        Flicker:False/
        AddObjects:false/
        BrickColor:Light stone grey/
        LightColor:Deep blue/
        Range: 0/
        HealthImpact: 0/
        MeshX: 15/
        MeshY: 15/
        MeshZ: 15/
        PartCount: 40/
        PartTransparency: .3/
        TransitionTimeToFullPower: .5/
        FullPower: 1000/
        RandomX1: -20/
        RandomX2: 20/
        RandomY1: 3/
        RandomY2: 6/
        RandomZ1: -20/
        RandomZ2: 20
]=]
}


local function Particles(OptionalStopBoolean,
        p,particlelocation,duration,flicker,addobjects,color,color2,range,healthimpact,
        meshx,meshy,meshz,partcount,parttrans,transition,
        transitionpower,x,xx,y,yy,z,zz
)		
        print(p,particlelocation,duration,flicker,addobjects,color,color2,range,healthimpact,meshx,meshy,meshz,partcount,parttrans,transition,transitionpower,x,xx,y,yy,z,zz);
		moving.Value = true;
        cr(cc(function()wait(duration) if moving.Value == true then moving.Value = false end end))
		if OptionalStopBoolean ~= nil then
			OptionalStopBoolean.Changed:connect(function()
				moving.Value = false
				transition = 0;
				transitionpower = 0;
			end)
		end
		local ParticlesModel = particlelocation:FindFirstChild('Particles') and particlelocation.Particles or 
		Instance.new('Model',particlelocation)
		ParticlesModel.Name = 'Particles';
        local partcolor,lightcolor = BrickColor.new(color),BrickColor.new(color2).Color;
        local bf = Lighting.AtmospherePack:WaitForChild("DustFloat");
        local Dust = Lighting.AtmospherePack:WaitForChild("DustParticle");
        local parts = {};
        local pointlight = nil
		local function CutParts()
			for _,v in pairs(parts) do 
				v:Destroy()
			end
		end
                for i = 1, partcount do 
                        local newpart = Dust:clone()
                        newpart.Transparency = parttrans;
                        pointlight = newpart:WaitForChild('PointLight');
                        if healthimpact ~= 0 then
                                newpart.Touched:connect(function(hit)
                                        if not hit.Parent:FindFirstChild('Humanoid') then return end
                                        hit.Parent.Humanoid:TakeDamage(healthimpact);
                                end)
                        end
                        if flicker:sub(1,4):lower() == 'true' then 
                                local r1,r2 = flicker:match('%((%d+),(%d+)%)');
                                local r1,r2 = tonumber(r1),tonumber(r2);
                                cr(cc(function()
                                        while(wait(1/20)) do 
                                                pointlight.Range = mr(r1,r2);
                                        end
                                end))
                        end
                        if addobjects:sub(1,5):lower() ~= 'false' then
                                for class,section in addobjects:gmatch('%s*(.-)%[(.-)%]%s*') do
                                        print('\tNewClass: '..class,section);
                                        local exists = {pcall(function()return Instance.new(class) end)}
                                        if  type(exists[2]) ~= 'string' then
                                                local newobject = Instance.new(class,newpart);
                                                for property,value in section:gmatch('(.-)=(.-),') do 
                                                        print(property,value)
                                                        local propertyexists = {pcall(function()return newobject[property]end)};
                                                        if type(propertyexists[2]) ~= 'string' then
                                                                if value == 'true' then
                                                                        newobject[property] = true;
                                                                elseif value == 'false' then
                                                                        newobject[property] = false;
                                                                else
                                                                        newobject[property] = loadstring([=[return ]=]..value)();
                                                                end
                                                        else print('\tUNABLE TO FIND PROPERTY OF: '..property)
                                                        end
                                                end
                                        else
                                                print('\tUNABLE TO CREATE INSTANCE '..class);
                                        end
                                end 
                        end 
                        if newpart:FindFirstChild('RocketPropulsion') then
                                newpart.CanCollide = true;
                                local rocket = newpart.RocketPropulsion;
                                rocket:Fire()
                                rocket.ReachedTarget:connect(function()
                                        if not rocket.Target.Parent:FindFirstChild('Humanoid') then return end
                                        local human = rocket.Target.Parent.Humanoid;
                                        human.Sit = true; human:TakeDamage(healthimpact);
                                        rocket:Destroy();
                                end)
                        end
                        newpart.BrickColor = partcolor;
                        newpart.Mesh.Scale = Vector3.new(meshx,meshy,meshz)
                        newpart.Position = p.Position
                        newpart.Anchored = false;
                        newpart.Parent = ParticlesModel;
                        pointlight.Range = range;
                        pointlight.Color = lightcolor
                        newpart.Name = 'NewDust'
                        bf:Clone().Parent = newpart;
                        bf.P = 1000;
                        parts[#parts+1] = newpart;
                end
                cr(cc(function() wait(0)
                        for _,v in pairs(parts) do wait(0) pcall(function() v.DustFloat.P = transitionpower; end) end                
                end))
        moving.Value= true;
		moving.Changed:connect(function()
			if moving.Value == false then CutParts() end
		end)
        while(moving.Value == true) do
                for _,v in pairs(parts) do
                        bf = v:FindFirstChild('DustFloat') and v.DustFloat or Instance.new('BodyPosition');
                        bf.position = p.Position +
                        Vector3.new(mr(x,xx),mr(y,yy),mr(z,zz));
                end
                wait(transition);
        end
    	CutParts();
print('Stopped')
return 'Stopped'
end
CreateEffects = function(OptionalStopBoolean,part,particlelocation,msg)
                if msg:match('.-/.-/.-/.-/.-/.-/.-/.-/.-/.-/.-/.-') then
                local a,duration,flicker,AddObjects,color,color2,range,healthimpact,
                meshx,meshy,meshz,partcount,parttrans,trans,transp,b,c,d,e,f,g,h = 
                msg:match(
                '^(.-)/.-:(.-)/.-:(.-)/.-:(.-)/.-:(.-)/.-:(.-)/.-:(.-)/.-:(.-)/.-:(.-)/.-:(.-)/.-:(.-)/.-:(.-)/.-:(.-)/.-:(.-)/.-:(.-)/.-:(.-)/.-:(.-)/.-:(.-)/.-:(.-)/.-:(.-)/.-:(.+)'
                )
                local tim,type = duration:match('(%d+)%s*(%a+)');
                local duration = type == 'seconds' and tim or 60*tim;
                cr(cc(function()Particles(OptionalStopBoolean,
                part,particlelocation,duration,flicker,AddObjects,color,color2,range,healthimpact,meshx,meshy,meshz,
                partcount,parttrans,trans,transp,b,c,d,e,f,g
                )
				end))
        end
end

local function DisconnectAll(...)
local tables = {...};
	for _,v in pairs(tables) do 
		for i,vv in pairs(v) do 
			print('Disconnected: '..type(vv)) vv:disconnect();
		end
	end
end
local HideUI = function()
		ActionBar.Visible = true;
		Background.Visible = false;
		Buffs.Visible = true;
		PartyGui.Visible = true;
		Main.Visible = true;
		DisconnectAll(enterevents,clickevents,leaveevents);
		BG.BackgroundTransparency = 0;
		MagicUIShowing = false;
		for _,v in pairs(MagicUI:GetChildren()) do  if v ~= BG then v.Visible = false end end
		cam.CameraSubject = human
		cam.CameraType = "Custom"
		pcall(function() cam.MagicUIModel:Destroy() end)
		for i = 1, 10 do wait(0)
			BG.BackgroundTransparency = BG.BackgroundTransparency + .1;
		end
		BG.BackgroundTransparency = 1;
		--Player.CameraMode = "LockFirstPerson"	
end
local function MagicUIPlay(SettingKeyBind,showing)
	if MagicUIDebounce then return end
	Description.Text = SettingKeyBind == true and ' CLICK A SPELL TO ASSIGN A KEYBIND TO IT' or '';
	MagicUIDebounce = true;
	if showing == true then 
		HideUI()
	elseif showing == false then
		ActionBar.Visible = false;
		Background.Visible = false;
		Buffs.Visible = false;
		PartyGui.Visible = false;
		Main.Visible = false;
		BG.BackgroundTransparency = 1;
		for i = 1, 10 do wait(0)
			BG.BackgroundTransparency = BG.BackgroundTransparency - .1;
		end
		wait(1)
		BG.BackgroundTransparency = 1
		MagicUIShowing = true;
		for _,v in pairs(MagicUI:GetChildren()) do v.Visible = true; end
		local Model = CameraComps.MagicUIModel:clone();
		local cf = Model.CamPart.CFrame;
		local region = Model.ParticleRegion;
		local campart = CameraComps.CamPart:clone();
		cam.CameraType = "Scriptable"
		campart.CFrame = cf;
		cam.CameraSubject = campart
		cam.CoordinateFrame = campart.CFrame
		cam.Focus = campart.CFrame
		Model.Parent,campart.Parent = cam,cam;
		local Name,School,ManaCost = Panel.Names,Panel.School,Panel.ManaCost;
		local animating = {};
			local cutanimation = function(stopbool,v,school,manacost) print('Cutting Animation')
				stopbool.Value = not stopbool.Value;
				v.TextTransparency = .4;
				school.TextTransparency = .4;
				manacost.TextTransparency = .4;
				v.BackgroundTransparency = 1;
				school.BackgroundTransparency = 1;
				manacost.BackgroundTransparency = 1;
			end
		for _,v in pairs(Name:GetChildren()) do
			local stopbool = Instance.new('BoolValue')
			local name = v.Name;
			local school,manacost = School[name],ManaCost[name];
			enterevents[v] = v.MouseEnter:connect(function() 
				if clicked then return end
				print('MouseEnter');
				Description.Text = SettingKeyBind == true and ' THIS WILL BE SET TO KEYBIND: '..CurrentlyAssigning..' '..DescriptionLibrary[name];
				v.TextTransparency = 0;
				school.TextTransparency = 0;
				manacost.TextTransparency = 0;
				v.BackgroundTransparency = .8;
				school.BackgroundTransparency = .8;
				manacost.BackgroundTransparency = .8;
				local spellinfo = SpellLibrary[name]:gsub('PartTransparency:%s*(.-)%s*/','PartTransparency: 0/');
				CreateEffects(stopbool,region,cam,spellinfo);
			end)
			clickevents[v] = v.MouseButton1Click:connect(function()
				clicked = true;
				if SettingKeyBind == true then
					KeyBinds[CurrentlyAssigning] = v.Name;
					HideUI();
					cutanimation(stopbool,v,school,manacost)
				else
					HideUI();
					cutanimation(stopbool,v,school,manacost)
					CreateEffects(nil,human.Parent.Torso,Workspace,SpellLibrary[name]);
				end
				clicked = nil;
			end)
			leaveevents[v] = v.MouseLeave:connect(function()Description.Text = '';cutanimation(stopbool,v,school,manacost) end)
		end
		wait(3)
	end
	MagicUIDebounce = nil;
end

-- Event handling


local key_down = mouse.KeyDown:connect(function(key) print(key)
	if key == 'm' then MagicUIPlay(false,MagicUIShowing);
	elseif KeyBinds[key] then moving.Value = false; CreateEffects(nil,human.Parent.Torso,Workspace,SpellLibrary[KeyBinds[key]]);
	end
end)
for _,v in pairs(ActionBarChildren) do if not v:isA('ImageButton') then return end
	local KeySelected = v.MouseButton1Click:connect(function()
		CurrentlyAssigning = v.Name;
		MagicUIPlay(true,MagicUIShowing);
	end)
end
