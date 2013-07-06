--Particle Engine 


local Players = game:GetService('Players')
local Lighting = game:GetService('Lighting');
local CameraComps = Lighting.CameraComps;
local Player = Players.LocalPlayer;
local human = Player.Character.Humanoid;
local PlayerGui = Player.PlayerGui;
local MagicUI = PlayerGui:WaitForChild('Magic');
local MagicUIShowing = false;
local mouse = Player:GetMouse();
local moving = Instance.new('BoolValue')
moving.Value = false;
local mr = math.random;
local cam = Workspace.CurrentCamera;
local string_to_boolean = {['true']=true,['false']=false};
local cr = coroutine.resume;
local cc = coroutine.create;
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
        TransitionTimeToFullPower: 1/
        FullPower: 1000/
        RandomX1: 0/
        RandomX2: 0/
        RandomY1: 3/
        RandomY2: 6/
        RandomZ1: 0/
        RandomZ2: 0
]=]
}
local function Particles(OptionalStopBoolean,
        p,particlelocation,duration,flicker,addobjects,color,color2,range,healthimpact,
        meshx,meshy,meshz,partcount,parttrans,transition,
        transitionpower,x,xx,y,yy,z,zz
)		
        print(p,particlelocation,duration,flicker,addobjects,color,color2,range,healthimpact,meshx,meshy,meshz,partcount,parttrans,transition,transitionpower,x,xx,y,yy,z,zz);
		moving.Value = false;
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
        while(moving) do
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


local function MagicUIPlay(showing)
	if MagicUIDebounce then return end
	MagicUIDebounce = true;
	if showing == true then 
		MagicUIShowing = false;
		for _,v in pairs(MagicUI:GetChildren()) do v.Visible = false end
		cam.CameraSubject = human
		cam.CameraType = "Custom"
		--Player.CameraMode = "LockFirstPerson"	
		pcall(function() cam.MagicUIModel:Destroy() end)
	elseif showing == false then
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
		local Panel = MagicUI.Panel;
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
			local enter = v.MouseEnter:connect(function() 
				v.TextTransparency = 0;
				school.TextTransparency = 0;
				manacost.TextTransparency = 0;
				v.BackgroundTransparency = .8;
				school.BackgroundTransparency = .8;
				manacost.BackgroundTransparency = .8;
				local spellinfo = SpellLibrary[name]:gsub('PartTransparency:%s*(.-)%s*/','PartTransparency: 0/');
				CreateEffects(stopbool,region,cam,spellinfo);
				print('Not Animating')
			end)
			local leave = v.MouseLeave:connect(function()cutanimation(stopbool,v,school,manacost) end)
		end
		wait(3)
	end
	MagicUIDebounce = nil;
end

local key_down = mouse.KeyDown:connect(function(key)
	if key == 'm' then MagicUIPlay(MagicUIShowing);
	end
end)
