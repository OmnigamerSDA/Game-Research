function draw_cross(x_pos,y_pos, color)
	gui.drawLine(x_pos-3,y_pos,x_pos+3,y_pos, color)
	gui.drawLine(x_pos,y_pos-3,x_pos,y_pos+3, color)
end

while true do
	
	camx = mainmemory.read_u16_le(0x00173C)
	camy = mainmemory.read_u16_le(0x001744)
	
	textX=20
	textY=30
	
	hp = mainmemory.read_u8(0x001858)
	gui.text(textX,textY,string.format("HP:  %d",hp))

	
	memory.usememorydomain("CARTROM")
	
	x_coord = mainmemory.read_u16_le(0x000CF6)
	y_coord = mainmemory.read_u16_le(0x000D2E)
	
	--draw_cross(x_coord - camx,y_coord-camy, "blue");
	
	--2 = player
	--4 = partner
	--6 = guardian
	--A = partner projectile
	--16 = aura blade projectile
	--24-34 = enemies and items
	
	--c4c = next enemy ID?
	
	--for i = 0x00,0x64,2 do
		
	--	x_coord = mainmemory.read_u16_le(0x000CF4+i)
	--	y_coord = mainmemory.read_u16_le(0x000d2c+i)
		
	--	gui.drawText(x_coord-camx,y_coord-7-camy,string.format("%X", i));
		
	--	draw_cross(x_coord - camx,y_coord-camy, "red");
	--end
	
	--103c: base for HP addresses?
	--118c: object status? bits for 5 set if active. 1 = can interact, 4 = enemy
	
	next_ID = 0x02;
	
	while next_ID ~= 0xFF do
		
		x_coord = mainmemory.read_u16_le(0x000CF4+next_ID)
		y_coord = mainmemory.read_u16_le(0x000d2c+next_ID)
		
		status = bit.band(mainmemory.read_u16_le(0x00118c+next_ID),0x0005);
		
		if(next_ID == 0x02) then
			--gui.drawEllipse(x_coord-camx-0x10,y_coord-camy-0x10,0x20,0x20,"blue");
			gui.drawRectangle(x_coord-camx-0x08,y_coord-camy-0x08,0x10,0x10,"blue");

			
		end
		
		if(status~=0) then
		
			enemy_HP = mainmemory.read_u8(0x00103c+next_ID)
			
			--gui.drawText(x_coord-camx,y_coord-10-camy,string.format("%X", next_ID));
			if next_ID ~= 2 then
				gui.drawText(x_coord-camx,y_coord-camy,string.format("%d", enemy_HP));
			end
			
			--gui.drawRectangle(x_coord-camx-0x08,y_coord-camy-0x08,0x10,0x10,"red");
			
			draw_cross(x_coord - camx,y_coord-camy, "red");
		end
		
		next_ID = mainmemory.read_u8(0x000C4c+next_ID)
	end
	
	emu.frameadvance()
end