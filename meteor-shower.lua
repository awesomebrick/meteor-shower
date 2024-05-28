-- ----------------------------------------
-- meteor shower: lights, 
--         building and fading
-- 0.0.0 @brick
-- (link here)
-- lots of unimplemented
-- features for now.
--
-- test and display grid LEDs
--
-- all modes:
-- -k2: next lighting mode
-- -e3: brightness scaling
--
-- individual: 
-- -e2 cycles through grid's keys
-- 
-- press: 
-- -pressing buttons on grid will 
-- make them light up. 
-- -k3 enables toggle mode
--
-- pattern:
-- -press k3 to cycle through 
-- different patterns on the grid
-- (not implemented yet.)
--
-- shower:
-- -meteor shower mode. 
-- -currently, just randomly sets 
-- each led's brightness. 
--
-- plasma:
-- - @tehn's plasma script. 
-- k3 cycles through functions.


g = grid.connect()


key1 = false
key2 = false
key3 = false
time = 0.00
t = 0
mode = 1
--brightness = 0

light_modes = {'individual', 'press', 'pattern', 'shower', 'plasma'}

lightmode = 'individual'


-- add parameters for modulation
params:add_separator('meteor-shower')

params:add{
    id = 'mode',
    name = 'mode',
    type = 'option',
    options = light_modes,
    default = 1,
    action = function(value)
        mode = value
        lightmode = light_modes[value]
        g:all(0)
    end
}

params:add{
    id = 'brightness',
    name = 'brightness level',
    type = 'number',
    min = 0,
    max = 15,
    default = 5
}

params:add_separator("modes")

params:add_separator("individual-lights")

params:add{
    id = 'curr_led',
    name = 'selected led',
    type = 'number',
    min = 0,
    max = g.cols * g.rows
}

params:add_separator("keypress")

ToggleLight = false
--lastPressed = (0,0)
params:add{
    id = "lightToggle",
    name = "toggle mode",
    type = 'binary',
    default = 0,
    action = function(value)
        ToggleLight = not ToggleLight
    end
}

--params and setup for plasma mode
params:add_separator("plasma")

abs = math.abs
floor = math.floor
sin = math.sin
cos = math.cos
sqrt = math.sqrt

func = {
	function(x,y) return abs(floor(16*(sin(x/a + t*c) + cos(y/b + t*d))))%16 end, -- @tehn
	function(x,y) return abs(floor(16*(sin(x/y)*a + t*b)))%16 end, -- @tehn
	function(x,y) return abs(floor(16*(sin(sin(t*a)*c + (t*b) + sqrt(y*y*(y*c) + x*(x/d))))))%16 end, -- @mei
	function(x,y) return abs(floor(16*(sin(x/a + t*c) + cos(y/b + t*d) + (sin(x/a)/c))))%16 end, -- @jasonw22
	function(x,y) return abs(floor(16*(sin(x/a + t*c) + cos(y/b + (sin(x/a)*c) + (cos(y/b - t)*c*2 + cos(x/b+y/(a/2)+t*c*2))))))%16 end, -- @jasonw22
}
f = 1
p = {}
t = 0
time = 0.02
a = 3.0
b = 5.0
c = 1.0
d = 1.1

params:add{
	id = 'function',
	name = 'function',
	type = 'number',
	min = 1,
	max = #func,
	default = 1,
	action = function(value)
		f = value
	end
}
params:add{
	id = 'time',
	name = 'time',
	type = 'control',
	controlspec = controlspec.new(-1, 1, 'lin', 0, 0.02),
	action = function(value)
		time = value
	end
}
params:add{
	id = 'a',
	name = 'a',
	type = 'control',
	controlspec = controlspec.new(-10, 10, 'lin', 0, 3.0),
	action = function(value)
		a = value
	end
}
params:add{
	id = 'b',
	name = 'b',
	type = 'control',
	controlspec = controlspec.new(-10, 10, 'lin', 0, 5.0),
	action = function(value)
		b = value
	end
}
params:add{
	id = 'c',
	name = 'c',
	type = 'control',
	controlspec = controlspec.new(-10, 10, 'lin', 0, 1.0),
	action = function(value)
		c = value
	end
}
params:add{
	id = 'd',
	name = 'd',
	type = 'control',
	controlspec = controlspec.new(-10, 10, 'lin', 0, 1.1),
	action = function(value)
		d = value
	end
}


function math.Clamp(val, min, max)
    if val < min then
		val = min
	elseif max < val then
		val = max
	end
	return val
end

function init()
    print("hello")
    process()
    redraw()
    clock.run(tick)

    --norns.enc.sens(1,8)   -- set the knob sensitivity
    --norns.enc.sens(2,4)
end

function tick()
	while true do
		t = t+(time*0.1)
		process()
		redraw()
		grid_redraw()
		clock.sleep(1/60)
	end
end

function process()

    if lightmode == "individual" then
        
    elseif lightmode == "press" then
        
    elseif lightmode == "pattern" then
        
    elseif lightmode == "shower" then
        
        
    elseif lightmode == "plasma" then
        --perform the plasma mode processing.
        for x=1,16 do
		    for y=1,16 do
		    	p[y*16+x] = func[f](x,y)
		    end
	    end
    end

end

function grid_redraw()
    g:refresh()
    
    if lightmode == "individual" then
        
        --first, clear the grid. make sure all is clean.
        g:all(0)
        -- then set the selected light to be on 
        g:led((params:get('curr_led')-1)%(g.cols)+1, ((params:get('curr_led')-1)//(g.cols))+1, params:get("brightness"))
        
    elseif lightmode == "press" then
        -- on key event, set that led to be on or off depending on up or down
        function g.key(x,y,z)
            g:led(x, y, params:get("brightness")*z)
        end
    
    elseif lightmode == "pattern" then
	    for y=1,16 do
	    	for x=1,16 do
	    	    --currently only the "all" pattern implemented
	    		g:led(x,y,params:get('brightness'))
	    	end
	    end
	
    elseif lightmode == "shower" then
        --idk??? figure this out later.
        for y = 1,16 do
            for x = 1,16 do
                --trying to do some funky stuff to get 0s more often... not working.
                g:led(x,y,math.Clamp((math.random(-500,15)%(params:get("brightness")+1)),0,15))
            end
        end
        
    elseif lightmode == "plasma" then
        for y=1,16 do
		    for x=1,16 do
	    		g:led(x,y,p[x+y*16]%(params:get('brightness') + 1)) -- kind of a messy way to implement scaling for the brightness? but fun results, so why not
	    	end
    	end
    end

    g:refresh()
end

function key(n, z)
    if n == 1 and z == 1 then
        
    elseif n == 2 and z == 1 then
        params:set('mode', (mode + 1)% (#light_modes+1))
        
    elseif n == 3 and z == 1 then
        if lightmode == "individual" then
            
        elseif lightmode == "press" then
        
        elseif lightmode == "pattern" then
        
        elseif lightmode == "shower" then
        
        elseif lightmode == "plasma" then
            params:set('function', (f+1)% #func)
        end
    end
end

function enc(n,delta)
	if n==1 then

	elseif n==2 then

		if lightmode == "individual" then
		    params:set("curr_led", params:get("curr_led") + delta)
		end
		
		
	elseif n==3 then
		params:set("brightness", params:get("brightness") + delta)
	end
end

function redraw()
    screen.clear()
    screen.level(15)
    
    --mode and brightness
    screen.move(10,10)
    screen.text("mode:")
    screen.move(50, 10)
    screen.text(lightmode)
    screen.move(10, 20)
    screen.text("level")
    screen.move(50, 20)
    screen.text(params:get("brightness"))
    
    --specific mode values
    if lightmode == "individual" then
        screen.move(10, 30)
        screen.text("LED: ")
        screen.move(60, 30)
        screen.text(params:get("curr_led"))
        
    elseif lightmode == "press" then
        
        
    elseif lightmode == "pattern" then
        
    elseif lightmode == "shower" then
        screen.move(10,35)
        screen.text("miracles unfolding overhead.")
        
    elseif lightmode == "plasma" then
        screen.move(10, 30)
        screen.text("function:")
        screen.move(60, 30)
        screen.text(params:get('function'))
    end

    
    
    
    --battery info
    screen.move(10,50)
    screen.text("battery")
    screen.move(60,50)
    screen.text(string.format(norns.battery_percent))
    screen.move(10,60)
    screen.text("drain")
    screen.move(60,60)
    screen.text(string.format("%smA",norns.battery_current))
    

    
    screen.update()
end