while true do
	
	camx = mainmemory.read_u16_le(0x0011E8)
	camy = mainmemory.read_u16_le(0x0011EA)
	
	textX=30
	textY=50
	
	--Secondary address space used for hitbox calculations... addr stored in enemy struct 0x02?
	player_addr = mainmemory.read_u16_le(0x000060)
	init_addr = mainmemory.read_u16_le(0x0011e4)
	
	hit_addr = mainmemory.read_u16_le(init_addr+0x02)
	
	player_x = mainmemory.read_u16_le(player_addr+0x11)
	player_y = mainmemory.read_u16_le(player_addr+0x15)
	
	
	
	
	while(hit_addr~=0x0000) do
	
	top = mainmemory.read_u16_le(hit_addr+0x04) 
	left = mainmemory.read_u16_le(hit_addr+0x02) 
	bot = mainmemory.read_u16_le(hit_addr+0x08) 
	right = mainmemory.read_u16_le(hit_addr+0x06) 
	
	
	
					
	--gui.drawPixel(player_x-camx, player_y-camy,"blue")
	gui.drawBox(left-camx,top-camy, right-camx,bot-camy,"red")
	
	init_addr = init_addr + 0x04
	hit_addr = mainmemory.read_u16_le(init_addr+0x02)
	
	end
	
	--gui.drawText(textX, textY,string.format("%X %X",top, bot))
	--gui.drawText(textX, textY+10,string.format("%X %X",left, right))
	--gui.drawText(textX, textY+20,string.format("%X %X",player_x, player_y))
	
	--gui.drawPixel(mainmemory.read_u16_le(0x04c8)-camx,mainmemory.read_u16_le(0x04cc)-camy,"white")
	--gui.drawText(player_x-camx, player_y-camy,string.format("%X",player_addr))
	
	--gui.drawText(player_x-camx, player_y-camy+10,string.format("%X %X",top-player_y, bot-player_y))
	--gui.drawText(player_x-camx, player_y-camy+20,string.format("%X",player_hit_addr))
	
	--init_addr = mainmemory.read_u16_le(0x00005C)
	
	memory.usememorydomain("CARTROM")
	
	-- for i = 0,0x7f,1 do
	
		-- player_hit_addr = player_hit_addr +(0x0a*i)
	
		-- top = mainmemory.read_u16_le(player_hit_addr+0x04) 
		-- left = mainmemory.read_u16_le(player_hit_addr+0x02) 
		-- bot = mainmemory.read_u16_le(player_hit_addr+0x08) 
		-- right = mainmemory.read_u16_le(player_hit_addr+0x06)
		
		-- gui.drawBox(left-camx,top-camy, right-camx,bot-camy,"red")
		
	-- end
	
	emu.frameadvance()
end