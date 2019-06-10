local camx
local camy

function findbit(p) 
	return 2 ^ (p - 1)
end

function hasbit(x, p) 
	return x % (p + p) >= p 
end

local function hex(val)
	val = string.format("%X",val)
	if string.len(val) == 1 then
		val = "0" .. val
	end
	return val
end

local function camera()
	camx = memory.readword(0x1E16)
	camy = memory.readword(0x1E18)
end

local function player()
	local sword = 0x19C0
	local x = memory.readword(0x19A4 + 2) - camx
	local y = memory.readword(0x19A4 + 4) - camy
	local xrad = memory.readbyte(0x019BA)
	local yrad = memory.readbyte(0x019BC)
	gui.box(x+xrad,y+yrad,x-xrad,y-yrad,"#0000FF30","#0000FFFF")
	
	-- Player sword:
	if memory.readbyte(sword + 0xE) ~= 0 then
		x = memory.readword(sword + 2) - camx
		y = memory.readword(sword + 4) - camy
		xrad = memory.readbyte(sword + 0x16)
		yrad = memory.readbyte(sword + 0x18)
		gui.box(x+xrad,y+yrad,x-xrad,y-yrad)
	end
	
	gui.text(x,y,"P")
end

local function objects()
	for i = 2,31,1 do
		local obase = memory.readword(0x83136E + (i * 2))
		local otype = memory.readword(obase)
		if obase ~= 0 then
			if memory.readbyte(obase + 0x0E) and memory.readword(obase) ~= 01 then
				local x = memory.readword(obase + 2) - camx
				local y = memory.readword(obase + 4) - camy
				local xrad = memory.readbyte(obase + 0x16)
				local yrad = memory.readbyte(obase + 0x18)
				
				gui.box(x+xrad,y+yrad,x-xrad,y-yrad,"#FF000030","#FF0000FF")
				--gui.text(x,y,"E" .. i .. "/" .. hex(obase) .. "/" .. hex(memory.readword(obase)))
				
			end
		end
	end

	local pjbase
	--projectiles
	for i = 0,31, 1 do
		pjbase = 0x1BD4 + (0x12 * i)
		local pj_type = memory.readbyte(pjbase)
		local pj_xrad = 0
		local pj_yrad = 0 
		if pj_type > 0 then
			local pj_x = memory.readword(pjbase + 2) - camx
			local pj_y = memory.readword(pjbase + 4) - camy
			
			if pj_type == 0x81 then
				pj_xrad = 4
				pj_yrad = 4
				gui.box(pj_x+pj_xrad,pj_y+pj_yrad,pj_x-pj_xrad,pj_y-pj_yrad,"#FF000030","#FF0000FF")
			elseif pj_type == 1 then -- Player's bullets
				pj_xrad = 4
				pj_yrad = 4
				gui.box(pj_x+pj_xrad,pj_y+pj_yrad,pj_x-pj_xrad,pj_y-pj_yrad)
			end
		end
	end
	
end

while true do
	camera()
	player()
	objects()
	emu.frameadvance()
end