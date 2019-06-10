--Actraiser 2

--------------
---TOGGLES----
--------------
local cheat = false
local enemy_hit = true
local environment = false
local showspeed = true
local player = true
local pmagic = true
------------------
---END TOGGLES----
------------------

---------------
----GLOBALS----
---------------

local box_active = 0x04
local facing = 0x08
local ux = 0x00
local uy = 0x02
local camx = 0x540
local camy = 0x544
local plife = 0x91D
local magic = 0x921
local xoffpointer = 0x7f1018
local yoffpointer = 0x7f101a 
local xradpointer = 0x7f101c
local yradpointer = 0x7f101e
local objstart = 0x1000
local sx = 0
local sy = 0
local timer = 0x94C

-------------------
----END GLOBALS----
-------------------

local function draw_objects()

	local x
	local y
	local cx = memory.readword(camx)
	local cy = memory.readword(camy)
	local base
	local dir
	local oend = 96
	
	nextobj = memory.readword(0x7E0078);
	myX = 10;
	myY=40;
	myInc = 10;
	
	for j=0,9,1 do
		gui.text(myX,myY+(myInc*j),string.format("%d:  %d",j,memory.readbyte(0x7F2016 + memory.readword(0x7E0000+nextobj+2*j))));
	end
	
	for i = 0,oend,1 do
	
		base = objstart + (i * 0x30)
		
		if i == 0 then
			base = objstart
		end
	
			x = memory.readword(base+ux) - cx
			y = memory.readword(base+uy) - cy
			
				xoff = memory.readbytesigned(xoffpointer+base)
				yoff = memory.readbytesigned(yoffpointer+base) 
				xrad = memory.readbyte(xradpointer+base) 
				yrad = memory.readbyte(yradpointer+base)
				dir = memory.readbyte(base+0x09)
				
				if dir == 0x20 then
					xoff = (xoff * -1)
					xrad = (xrad * -1)
					xrad = xrad +1
					yrad = yrad -1
				else
					xrad = xrad -1
					yrad = yrad -1
				end
			
			if player == true then
			
				if base == 0x1030 then 
					
					sx = x-16
					sy = y-60
					--Speed value
					
				if showspeed == true then
					memory.registerexec(0x80AC2D,1,function()
						if memory.readbytesigned(0x7f3030) ~= 0 then
							gui.text(sx,sy,"X SPD: " .. memory.readbytesigned(0x7f3030))
						else
							gui.text(sx,sy,"X SPD: ")
						end
						if memory.readbytesigned(0x7f3032) ~= 0 then
							gui.text(sx,sy-8,"Y SPD: " .. memory.readbytesigned(0x7f3032))
						else
							gui.text(sx,sy-8,"Y SPD: ")
						end
					end)
				end
					
					-- Attack box
					gui.box(x-xoff,y+yoff,x-xoff-xrad,y+yoff+yrad,"#FFFFFF30","#FFFFFFFF")
					xrad = memory.readbyte(0x7f1014+base)
					yrad = memory.readbyte(0x7f1016+base)
					
					--Vulnerability box
					
					if bit.band(memory.readword(base+0x04),0x040) == 0 then
						gui.box(x-xrad,y,x+xrad,y-yrad,"#0000FF30","0000FFFF")			
						--gui.text(x-20,y-5,string.format("%X",base)) --Debugging
					end
					
				end
				
				--Player Magic
				
			if pmagic == true then
			
				if bit.band(memory.readword(base+0x04),0x0040) ~= 0 and bit.band(memory.readword(base+0x04),0x0180) == 0 and bit.band(memory.readword(base+0x06),0x0040) == 0 and bit.band(memory.readword(base+0x06),0x4000) == 0 then	
					
					if xrad ~= 8 and yrad ~= 40 then  -- Minor work around
						gui.box(x-xoff,y+yoff,x-xoff-xrad,y+yoff+yrad,"#FFFFFF30","#FFFFFFFF")
						gui.text(x-20,y-5,string.format("%d",memory.readbyte(0x7F2016+base)))
					end
					
				end
				
			end
				
			end
				
			--Enemy Projectile
			if bit.band(memory.readword(base+0x04),0x4000) == 0 and bit.band(memory.readword(base+0x04),0x0100) == 0 and bit.band(memory.readword(base+0x04),0x8000) == 0 and bit.band(memory.readword(base+0x06),0x0004) ~= 0 and bit.band(memory.readword(base+0x04),0x0180) == 0 then			
				gui.box(x-xoff,y+yoff,x-xoff-xrad,y+yoff+yrad,"#FFC30020","#FFC300FF")
				--gui.text(x-20,y-5,string.format("%X",base))-- Debugging
			end
			
			-- Enemy boxes
			if enemy_hit == true then
				--Enemy attack box
				if bit.band(memory.readword(base+0x04),0x4000) == 0 and bit.band(memory.readword(base+0x04),0xC000) == 0 and bit.band(memory.readword(base+0x04),0x0040) == 0 and bit.band(memory.readword(base+0x04),0x0100) == 0 and base ~= 0x1030 then
					gui.box(x-xoff,y+yoff,x-xoff-xrad,y+yoff+yrad,"#FF000040","#FF0000FF")
					--gui.text(x-20,y-5,string.format("%X",base)) --Debugging
				end
				
				-- Enemy Vulnerability box
				if bit.band(memory.readword(base+0x04),0x0970) == 0 and bit.band(memory.readword(base+0x04),0xC000) == 0 then -- boss?
					xrad = memory.readbyte(0x7f1014+base)
					yrad = memory.readbyte(0x7f1016+base)
					
					gui.box(x-xrad,y,x+xrad,y-yrad,"#0000FF20","0000FFFF")
					--gui.text(x-20,y-5,string.format("%X",base)) --Debugging
				end	
			end
			
			--Environmental objects
			if environment == true then
				if bit.band(memory.readword(base+0x04),0x4000) == 0 and bit.band(memory.readword(base+0x04),0xC000) == 0 and bit.band(memory.readword(base+0x04),0x0040) ~= 0 and bit.band(memory.readword(base+0x04),0x0100) == 0 and bit.band(memory.readword(base+0x06),0x0004) == 0 then
					gui.box(x-xrad,y,x+xrad,y-yrad,"#00FF0020","00FF00FF")
				end
			end
		--end
		
	end
	
end

local function cheats()
	memory.writebyte(plife,15)
	memory.writeword(timer,33333) --timer
	memory.writebyte(magic,8)
end

gui.register(function()
	draw_objects()
	if cheat == true then
		cheats()
	end
end)