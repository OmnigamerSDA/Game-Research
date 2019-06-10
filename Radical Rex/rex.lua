while true do
	
	camx = mainmemory.read_u16_le(0x0011E8)
	camy = mainmemory.read_u16_le(0x0011EA)
	
	textX=30
	textY=50
	
	--Secondary address space used for hitbox calculations... addr stored in enemy struct 0x02?
	
	player_addr = mainmemory.read_u16_le(0x000060)
	
	player_hit_addr = mainmemory.read_u16_le(0x0011e6)
	
	top = mainmemory.read_u16_le(player_hit_addr+0x04) 
	left = mainmemory.read_u16_le(player_hit_addr+0x02) 
	bot = mainmemory.read_u16_le(player_hit_addr+0x08) 
	right = mainmemory.read_u16_le(player_hit_addr+0x06) 
	
	player_x = mainmemory.read_u16_le(player_addr+0x11)
	player_y = mainmemory.read_u16_le(player_addr+0x15)
					
	gui.drawPixel(player_x-camx, player_y-camy,"blue")
	--gui.drawBox(left-camx,top-camy, right-camx,bot-camy,"blue")
	
	--gui.drawPixel(mainmemory.read_u16_le(0x04c8)-camx,mainmemory.read_u16_le(0x04cc)-camy,"white")
	--gui.drawText(player_x-camx, player_y-camy,string.format("%X",player_addr))
	gui.drawText(player_x-camx, player_y-camy,string.format("%X",mainmemory.read_u16_le(player_addr+0x18)))
	--gui.drawText(player_x-camx, player_y-camy+10,string.format("%X %X",top-player_y, bot-player_y))
	--gui.drawText(player_x-camx, player_y-camy+20,string.format("%X",player_hit_addr))
	
	init_addr = mainmemory.read_u16_le(0x00005C)
	
	memory.usememorydomain("CARTROM")
	
	-- for i = 0,0x7f,1 do
	
		-- player_hit_addr = player_hit_addr +(0x0a*i)
	
		-- top = mainmemory.read_u16_le(player_hit_addr+0x04) 
		-- left = mainmemory.read_u16_le(player_hit_addr+0x02) 
		-- bot = mainmemory.read_u16_le(player_hit_addr+0x08) 
		-- right = mainmemory.read_u16_le(player_hit_addr+0x06)
		
		-- gui.drawBox(left-camx,top-camy, right-camx,bot-camy,"red")
		
	-- end
	
	while (init_addr~=0x0000) do
		ID = mainmemory.read_u16_le(init_addr+0x04)
		
		pos_x = mainmemory.read_u16_le(init_addr+0x11)
		pos_y = mainmemory.read_u16_le(init_addr+0x15)
		
		if bit.band(ID,0x2000)>0 then
		
			info_addr = mainmemory.read_u16_le(init_addr+0x22)
		
			if info_addr>0x0000 then
				hit_addr = memory.read_u16_le(info_addr+0x01000d)
			
				if hit_addr>0x00 then
				
					set0 = bit.bxor(mainmemory.read_u16_le(init_addr+0x26),mainmemory.read_u16_le(init_addr+0x08))
					--turnaround = bit.band(mainmemory.read_u8(init_addr+0x09),0x40)
					set1 = memory.read_u8(hit_addr+0x010000) --0x08  x left offset
					set2 = memory.read_u8(hit_addr+0x010001) --0x09  y high offset
					set3 = memory.read_u8(hit_addr+0x010002) --0x0a  x hitbox
					set4 = memory.read_u8(hit_addr+0x010003) --0x0b  y hitbox
					
					--if bit.check(set2,bit.band(set0,0xFF))==0 then
						--newVal1 = set2 - 0x0080 + set4 + pos_y
						--else
						--newVal1 = set2 - 0x0080 + set4 + pos_y
						--end
					offset_x = set1 - 0x80
					offset_y = set2 - 0x80
					
					--if bit.band(set0,0x8000)>0 then -- jumping
					
					--end
					
					if bit.band(set0,0x4000)>0 then --turned around
						--offset_x = bit.bxor(set1,0xFFFF) + 0x80
						--hit_x = bit.bxor(set1,0xFFFF) + 0x0080
						--set3 = bit.bxor(set3,0xFFFF)
						gui.drawBox(pos_x-camx-offset_x-set3,pos_y-camy+offset_y,pos_x-camx-offset_x, pos_y-camy+offset_y+set4,"red")
					else
						gui.drawBox(pos_x-camx+offset_x,pos_y-camy+offset_y,pos_x-camx+set3+offset_x, pos_y-camy+offset_y+set4,"red")
					end
					--else
						--hit_x = set1 - 0x0080
						--gui.drawBox(pos_x-camx+offset_x,pos_y-camy+offset_y,pos_x-camx+set3+offset_x, pos_y-camy+offset_y+set4,"red")
						
					--end	
				
					--gui.drawPixel(newVal2-camx, newVal1-camy,"green") --enemy or misc
					gui.drawPixel(pos_x-camx, pos_y-camy,"red")
					
					
					
					
					--gui.drawText(pos_x-camx, pos_y-camy,string.format("%X",init_addr))
					--gui.drawText(pos_x-camx, pos_y-camy+10,string.format("%X",offset_y))
					--gui.drawText(pos_x-camx, pos_y-camy+20,string.format("%X",set3))
					--gui.drawText(pos_x-camx, pos_y-camy+30,string.format("%X",set4))
					
					--gui.drawBox(pos_x-camx+hit_x,pos_y-camy+offset_y,pos_x-camx+set3+hit_x, pos_y-camy+offset_y+set4,"red")
				else
				
					hit_addr = memory.read_u16_le(info_addr+0x01000b)
					
					if(hit_addr>0x00) then
						set0 = bit.bxor(mainmemory.read_u16_le(init_addr+0x26),mainmemory.read_u16_le(init_addr+0x08))
					
						set1 = memory.read_u8(hit_addr+0x010000) --0x08  x left offset
						set2 = memory.read_u8(hit_addr+0x010001) --0x09  y high offset
						set3 = memory.read_u8(hit_addr+0x010002) --0x0a  x hitbox
						set4 = memory.read_u8(hit_addr+0x010003) --0x0b  y hitbox
						
						offset_x = set1 - 0x80
						offset_y = set2 - 0x80
					
						--gui.drawPixel(pos_x-camx, pos_y-camy,"blue") --Player or collected item
						--gui.drawBox(pos_x-camx+offset_x,pos_y-camy+offset_y,pos_x-camx+set3+offset_x, pos_y-camy+offset_y+set4,"blue")
					
						if bit.band(set0,0x4000)>0 then --turned around

							gui.drawBox(pos_x-camx-offset_x-set3,pos_y-camy+offset_y,pos_x-camx-offset_x, pos_y-camy+offset_y+set4,"blue")
						else
							gui.drawBox(pos_x-camx+offset_x,pos_y-camy+offset_y,pos_x-camx+set3+offset_x, pos_y-camy+offset_y+set4,"blue")
						end
						
						
					end
					
				end
			else
				gui.drawPixel(pos_x-camx, pos_y-camy,"white") --Birds??? Hitbox but no hurtbox...
			end
		
		else
		
			gui.drawPixel(pos_x-camx, pos_y-camy,"purple") --Non-interacting objects
		
		end
	
		init_addr = mainmemory.read_u16_le(init_addr)
	end
	
	emu.frameadvance()
end