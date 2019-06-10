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
	camx = memory.read_u16_le(0x1E16)
	camy = memory.read_u16_le(0x1E18)
end

local function player()
	local sword = 0x19C0
	local x = memory.read_u16_le(0x19A4 + 2) - camx
	local y = memory.read_u16_le(0x19A4 + 4) - camy
	local xrad = memory.read_u8(0x019BA)
	local yrad = memory.read_u8(0x019BC)
	gui.drawBox(x-xrad,y-yrad,x+xrad,y+yrad,"#0000FF30","#0000FFFF")
	
	-- Player sword:
	if memory.readbyte(sword + 0xE) ~= 0 then
		x = memory.read_s16_le(sword + 2) - camx
		y = memory.read_s16_le(sword + 4) - camy
		xrad = memory.read_u8(sword + 0x16)
		yrad = memory.read_u8(sword + 0x18)
		gui.drawBox(x+xrad,y+yrad,x-xrad,y-yrad)
	end
	
	gui.text(x,y,"P")
end

local function objects()
	for i = 2,31,1 do
		local obase = memory.read_u16_le(0x83136E + (i * 2))
		local otype = memory.read_u16_le(obase)
		if obase ~= 0 then
			if memory.read_u8(obase + 0x0E) and memory.read_u16_le(obase) ~= 01 then
				local x = memory.read_u16_le(obase + 2) - camx
				local y = memory.read_u16_le(obase + 4) - camy
				local xrad = memory.read_u8(obase + 0x16)
				local yrad = memory.read_u8(obase + 0x18)
				
				gui.drawBox(x+xrad,y+yrad,x-xrad,y-yrad,"#FF000030","#FF0000FF")
				--gui.text(x,y,"E" .. i .. "/" .. hex(obase) .. "/" .. hex(memory.read_u16_le(obase)))
				
			end
		end
	end

	local pjbase
	--projectiles
	for i = 0,31, 1 do
		pjbase = 0x1BD4 + (0x12 * i)
		local pj_type = memory.read_u8(pjbase)
		local pj_xrad = 0
		local pj_yrad = 0 
		if pj_type > 0 then
			local pj_x = memory.read_u16_le(pjbase + 2) - camx
			local pj_y = memory.read_u16_le(pjbase + 4) - camy
			
			if pj_type == 0x81 then
				pj_xrad = 4
				pj_yrad = 4
				gui.drawBox(pj_x+pj_xrad,pj_y+pj_yrad,pj_x-pj_xrad,pj_y-pj_yrad,"#FF000030","#FF0000FF")
			elseif pj_type == 1 then -- Player's bullets
				pj_xrad = 4
				pj_yrad = 4
				gui.drawBox(pj_x+pj_xrad,pj_y+pj_yrad,pj_x-pj_xrad,pj_y-pj_yrad)
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