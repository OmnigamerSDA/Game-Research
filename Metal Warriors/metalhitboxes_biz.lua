local camx
local camy
local HPDISPLAY = true

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

memory.usememorydomain("BUS")

local function camera()
	camx = mainmemory.read_u16_le(0x1E16)
	camy = mainmemory.read_u16_le(0x1E18)
end

local function player()
	local sword = 0x19C0
	local x = mainmemory.read_u16_le(0x19A4 + 2) - camx
	local y = mainmemory.read_u16_le(0x19A4 + 4) - camy
	local xrad = mainmemory.read_u8(0x019BA)
	local yrad = mainmemory.read_u8(0x019BC)
	gui.drawBox(x+xrad,y+yrad,x-xrad,y-yrad,0xFF0000FF,0x300000FF) -- blue
	
	-- Player sword:
	if mainmemory.read_u8(sword + 0xE) ~= 0 then
		x = mainmemory.read_u16_le(sword + 2) - camx
		y = mainmemory.read_u16_le(sword + 4) - camy
		xrad = mainmemory.read_u8(sword + 0x16)
		yrad = mainmemory.read_u8(sword + 0x18)
		gui.drawBox(x+xrad,y+yrad,x-xrad,y-yrad,0xFFFFFFFF,0x30FFFFFF) -- white
	end
end

local function findhp(base)
	local offset = mainmemory.read_u8(base + 0xC)
	local ptr = memory.read_u16_le(0x838010 + offset)
	local hp = mainmemory.read_u16_le(ptr + 0x22)
	return hp
end

local function objects()
	for i = 2,31,1 do
		local obase = mainmemory.read_u16_le(0x136E + (i * 2))
		local otype = mainmemory.read_u16_le(obase)

		if obase ~= 0 then
			if mainmemory.read_u8(obase + 0x0E) ~= 0 and mainmemory.read_u16_le(obase) ~= 01 and obase ~= 0x19A4 then
				local x = mainmemory.read_u16_le(obase + 2) - camx
				local y = mainmemory.read_u16_le(obase + 4) - camy
				local xrad = mainmemory.read_u8(obase + 0x16)
				local yrad = mainmemory.read_u8(obase + 0x18)
				gui.drawBox(x+xrad,y+yrad,x-xrad,y-yrad,0xFFFF0000,0x30FF0000)
				if HPDISPLAY == true then
					local hp = findhp(obase)
					gui.text(x,y,"HP:" .. hp)
				end
			end
		end
	end

	local pjbase
	--projectiles
	for i = 0,31, 1 do
		pjbase = 0x1BD4 + (0x12 * i)
		local pj_type = mainmemory.read_u8(pjbase)
		local pj_xrad = 0
		local pj_yrad = 0 
		if pj_type > 0 then
			local pj_x = mainmemory.read_u16_le(pjbase + 2) - camx
			local pj_y = mainmemory.read_u16_le(pjbase + 4) - camy
			
			if pj_type == 0x81 or pj_type == 1 then
				pj_xrad = 4
				pj_yrad = 4
				gui.drawBox(pj_x+pj_xrad,pj_y+pj_yrad,pj_x-pj_xrad,pj_y-pj_yrad,0xFFFF0000,0x30FF0000) -- red
			else
				pj_xrad = mainmemory.read_u8(pjbase + 0x16)
				pj_yrad = mainmemory.read_u8(pjbase + 0x18)
				gui.drawBox(pj_x+pj_xrad,pj_y+pj_yrad,pj_x-pj_xrad,pj_y-pj_yrad,0xFFFFFFFF,0x30FFFFFF) -- white
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