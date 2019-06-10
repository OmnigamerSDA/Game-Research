-- SWAT Kats Helper Script
-- Author: Omnigamer
-- 9/29/17

function draw_cross(x_pos,y_pos, color)
	gui.drawLine(x_pos-3,y_pos,x_pos+3,y_pos, color)
	gui.drawLine(x_pos,y_pos-3,x_pos,y_pos+3, color)
end

while true do

	camx = mainmemory.read_s16_le(0x001759);
	camy = mainmemory.read_s16_le(0x00175B);
	
	
	memory.usememorydomain("CARTROM")
	
	--Pete Coords
	x_coord = mainmemory.read_s16_le(0x001A09)
	y_coord = mainmemory.read_s16_le(0x001A0D)
	
	draw_cross(x_coord - camx,y_coord-camy, "blue");
	
	x_off = mainmemory.read_s16_le(0x001A3A)
	y_off = mainmemory.read_s16_le(0x001A3E)
	x_box = mainmemory.read_s16_le(0x001A3C)
	y_box = mainmemory.read_s16_le(0x001A40)
	
	gui.drawRectangle(x_coord-camx+x_off,y_coord-camy+y_off,x_box, y_box,"blue")
	
	--gui.drawText(3,45,string.format("X: %X",x_coord))
	--gui.drawText(3,60,string.format("Y: %X",y_coord))
	
	gui.drawText(3,45,string.format("HP: %d",mainmemory.read_u16_le(0x1A36)))
	gui.drawText(3,60,string.format("XP: %d",mainmemory.read_u16_le(0x1A38)))
	--gui.drawText(3,75,string.format("ST: %d",mainmemory.read_u16_le(0x1A28)))
	
	gametype = mainmemory.read_u16_le(0x0055)
	
	-- if(gametype == 0x11) then
		-- camx = camx-0x80;
		-- camy = camy-0x70;
	-- end
	
	for i = 0x00,0x4F do
		
		base = mainmemory.read_u16_le(0x001BA9+i*0x02);
		
		if(base~= 0xFFFF) then
			
			x_coord = mainmemory.read_s16_le(0x00019+base)
			y_coord = mainmemory.read_s16_le(0x0001D+base)
			--gui.drawText(x_coord-camx-10,y_coord-camy+16,string.format("%X",i))
			--gui.drawText(x_coord-camx-10,y_coord-camy+29,string.format("%X",base))
			
			x_off = mainmemory.read_s16_le(0x0003c +base)
			y_off = mainmemory.read_s16_le(0x0003e +base)
			x_box = mainmemory.read_s16_le(0x00040 +base)
			y_box = mainmemory.read_s16_le(0x00042 +base)
			
			--48 - damage
			-- if(gametype == 0x11) then
					-- x_off = -8;
					-- y_off = -8;
					-- x_box = 0x10;
					-- y_box = 0x10;
				-- else
				--4C: EXP
			
			if(i>=0x40) then --player attacks
				gui.drawRectangle(x_coord-camx+x_off,y_coord-camy+y_off,x_box, y_box,"green")
			elseif(i>=0x30) then --Projectiles & Hazards
				gui.drawRectangle(x_coord-camx+x_off,y_coord-camy+y_off,x_box, y_box,"purple")
				
			elseif(i>=0x20) then --enemies
				HP= mainmemory.read_s16_le(0x0046+base)
				if(HP>=0) then
					gui.drawText(x_coord-camx-10,y_coord-camy-10,string.format("%d",HP))
					gui.drawText(x_coord-camx-10,y_coord-camy,string.format("%d",mainmemory.read_u16_le(0x004C+base)))
					--gui.drawText(x_coord-camx-10,y_coord-camy+3,string.format("%d",mainmemory.read_u16_le(0x004A+base)))
					gui.drawRectangle(x_coord-camx+x_off,y_coord-camy+y_off,x_box, y_box,"red")
				end
			elseif(i>=0x10) then --Hazards
				gui.drawRectangle(x_coord-camx+x_off,y_coord-camy+y_off,x_box, y_box,"purple")
				 HP= mainmemory.read_s16_le(0x0046+base)
				 gui.drawText(x_coord-camx-10,y_coord-camy-10,string.format("%d",HP))
					 --gui.drawText(x_coord-camx-10,y_coord-camy+3,string.format("%d",mainmemory.read_u16_le(0x004A+base)))
			else --Misc effects
				--gui.drawRectangle(x_coord-camx+x_off,y_coord-camy+y_off,x_box, y_box,"white")
			end
		end
	end
	
	if(mainmemory.read_s16_le(0x009600)~=0) then
	
		base = 0x9600
		x_coord = mainmemory.read_s16_le(0x0006+base)
		y_coord = mainmemory.read_s16_le(0x000a+base)
			--gui.drawText(x_coord-camx-10,y_coord-camy+16,string.format("%X",i))
		--gui.drawText(x_coord-camx-10,y_coord-camy+29,string.format("%X",base))
			
		
		x_box = mainmemory.read_s16_le(0x0004 +base)
		y_box = mainmemory.read_s16_le(0x0008 +base)
	
	gui.drawRectangle(x_coord-camx-16,y_coord-camy-16,x_box*2, y_box*2,"white")
	end
	
	
	-- --Fire hitboxes
	-- for i = 0x00,0x0C do
		
		-- ID = mainmemory.read_u16_le(0x000BE9+i*0x20);
		-- HP = mainmemory.read_u16_le(0x000BFB+i*0x20)
		
		-- if((ID <0x8000) and (HP <0x8000)) then
		
			-- x_coord = mainmemory.read_u16_le(0x000BEB+i*0x20)
			-- y_coord = mainmemory.read_u16_le(0x000BEF+i*0x20)
			
			-- gui.drawText(x_coord-camx,y_coord-20-camy,string.format("%d", HP));

			-- offset = mainmemory.read_u16_le(0x000BF9+i*0x20)*32;

			-- start_address = memory.read_u16_le(0x012ad5+ID*2)+offset+0x8000;
			
			-- hitbox_x = memory.read_u16_le(start_address+10);
			-- hitbox_y = memory.read_u16_le(start_address+12);

			-- gui.drawRectangle(x_coord-camx-hitbox_x,y_coord-camy-hitbox_y,hitbox_x*2, hitbox_y*2,"red")
		-- end
	-- end

	emu.frameadvance()
end