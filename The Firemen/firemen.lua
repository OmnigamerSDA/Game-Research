-- The Firemen Hitbox Viewer
-- Author: Omnigamer
-- 2/20/16

function draw_cross(x_pos,y_pos, color)
	gui.drawLine(x_pos-3,y_pos,x_pos+3,y_pos, color)
	gui.drawLine(x_pos,y_pos-3,x_pos,y_pos+3, color)
end

while true do

	camx = mainmemory.read_u16_le(0x0008A7) - 128;
	camy = mainmemory.read_u16_le(0x0008DB) - 128;
	
	hp = mainmemory.read_u8(0x0015C3)
	--gui.drawText(3,30,string.format("HP: %d",hp))

	memory.usememorydomain("CARTROM")
	
	--Pete Coords
	x_coord = mainmemory.read_u16_le(0x0008A7)
	y_coord = mainmemory.read_u16_le(0x0008DB)
	
	draw_cross(x_coord - camx,y_coord-camy, "blue");
	
	--gui.drawText(3,45,string.format("X: %X",x_coord))
	--gui.drawText(3,60,string.format("Y: %X",y_coord))
	
	
	--Danny Coords
	x_coord = mainmemory.read_u16_le(0x00091c)
	y_coord = mainmemory.read_u16_le(0x000920)
	
	draw_cross(x_coord - camx,y_coord-camy, "green");
	
	--Water hitboxes
	for i = 0x00,10 do
		
		ID = mainmemory.read_u16_le(0x0009D4+i*0x10);
		active = mainmemory.read_u16_le(0x0009D2+i*0x10);
		active2 = mainmemory.read_u16_le(0x0009c8+i*0x10);
		if((active ==0) and (active2 == 0)) then
		
			x_coord = mainmemory.read_u16_le(0x0009ca+i*0x10)
			y_coord = mainmemory.read_u16_le(0x0009cc+i*0x10)
			
			if(ID == 0) then 
				gui.drawRectangle(x_coord-camx-5,y_coord-camy-5,5*2, 5*2,"white")
			elseif(ID==1) then
				if(mainmemory.read_u16_le(0x0009D6+i*0x10)==1)then
					gui.drawRectangle(x_coord-camx-0xf,y_coord-camy-0xf,0xf*2, 0xf*2,"white")
				end
			end
			
		end
	end
	
	
	--Fire hitboxes
	for i = 0x00,0x0C do
		
		ID = mainmemory.read_u16_le(0x000BE9+i*0x20);
		HP = mainmemory.read_u16_le(0x000BFB+i*0x20)
		
		if((ID <0x8000) and (HP <0x8000)) then
		
			x_coord = mainmemory.read_u16_le(0x000BEB+i*0x20)
			y_coord = mainmemory.read_u16_le(0x000BEF+i*0x20)
			
			--gui.drawText(x_coord-camx,y_coord-20-camy,string.format("%d", HP));

			offset = mainmemory.read_u16_le(0x000BF9+i*0x20)*32;

			start_address = memory.read_u16_le(0x012ad5+ID*2)+offset+0x8000;
			
			hitbox_x = memory.read_u16_le(start_address+10);
			hitbox_y = memory.read_u16_le(start_address+12);

			gui.drawRectangle(x_coord-camx-hitbox_x,y_coord-camy-hitbox_y,hitbox_x*2, hitbox_y*2,"red")
		end
	end

	emu.frameadvance()
end