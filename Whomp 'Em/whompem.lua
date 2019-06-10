while true do
	
	--camx = mainmemory.read_u16_le(0x001337)
	--camy = mainmemory.read_u16_le(0x00133D)
	
	textX=20
	textY=30
	
	hp = mainmemory.read_u8(0x0035)
	gui.drawText(textX,textY,string.format("HP:  %d",hp))
	--psy = mainmemory.read_u8(0x00148C)
	--gui.text(textX,textY+7,string.format("PSY: %d",psy))
	speed = mainmemory.read_s8(0x005e)
	gui.drawText(textX,textY+7,string.format("SPD: %d",speed))
	--gui.drawText(textX,textY+14,string.format("7B: %d",mainmemory.read_u8(0x007C)))
	--gui.drawText(textX,textY+21,string.format("79: %d",mainmemory.read_u8(0x007A)))
	--state = mainmemory.read_u16_le(0x000500)
	--gui.text(textX,textY+21,string.format("STATE: %4X",state))
	--animation = mainmemory.read_u16_le(0x000502)
	--gui.text(textX,textY+28,string.format("ANIME: %4X",animation))
	
	memory.usememorydomain("PRG ROM")
	
	x_coord = mainmemory.read_u8(0x005D)
	y_coord = mainmemory.read_u8(0x005B)
	
	--gui.drawRectangle(x_coord-camx-hitbox_x,bit.band(trueY-camy,0xFFFF)-hitbox_y,hitbox_x*2, hitbox_y,"blue")
	if mainmemory.read_u8(0x00E7)==0x7E then
		gui.drawBox(x_coord+0x06,y_coord+0x08,x_coord+0x0C+0x06,y_coord+0x20,"blue")
	else
		gui.drawBox(x_coord+0x06,y_coord,x_coord+0x0C+0x06,y_coord+0x1F,"blue")
	end
	--Height is definitely 1F, adds 6 to width? stores in $0001
	--May still be 0x11

	enemy_offset = mainmemory.read_u16_le(0x0057)+0x00c000
	
	--Enemy info bank: 0001 6000
	--Order: x_pos = x_pos - $61
	--y_pos = y_pos + $60
	
	weap_x = mainmemory.read_u8(0x007A)
	weap_width = mainmemory.read_u8(0x007C)
	weap_y = mainmemory.read_u8(0x0079)
	weap_height = mainmemory.read_u8(0x007B)
	
	gui.drawBox(weap_x-weap_width,weap_y-weap_height,weap_x+weap_width,weap_y+weap_height,"white")
	
	for i = 0x10,0x90,0x10 do
		if mainmemory.read_u8(0x500+i)>0 then
			ID=mainmemory.read_u8(0x500+i)
			
			index = bit.band(mainmemory.read_u8(0x50A+i),0xF0)
			x_pos = mainmemory.read_u8(0x507+i)
			y_pos = mainmemory.read_u8(0x505+i)
			HP = mainmemory.read_u8(0x509+i)
			
			if index==0xF0 then
			
				tag = mainmemory.read_u8(0x501+i)
				
				--Item differences:
				--09 = potion
				--08 = gourd
				--0A = spear
				--07 = small heart
				--00 = big heart
				--CC = hidden
				--06 = spear tip
				--02 = invincibility
				if tag >= 0x06 then
					
					val1 = 0x08 --55
					val2 = 0x02 --56
					val3 = 0x0F --65
					val4 = 0x05 --66
					
				else
					
					val1 = 0x00 --55
					val2 = 0x02 --56
					val3 = 0x0E --65
					val4 = 0x0D --66
					
					--Originally 01, 01, 0F, 0E
					
				end
				
			
			elseif ID==0x65 then
			
				val1 = 0x14 --55
				val2 = 0x00 --56
				val3 = 0x2B --65
				val4 = 0x1B --66
			
			else
			
				val1 = memory.read_u8(enemy_offset+index+0x08) --55
				val2 = memory.read_u8(enemy_offset+index+0x09) --56
				val3 = memory.read_u8(enemy_offset+index+0x0A) --65
				val4 = memory.read_u8(enemy_offset+index+0x0B) --66
			
			end
			--gui.drawBox(x_pos,y_pos,x_pos+0x11,y_pos+0x11,"red")
			gui.drawBox(x_pos+val2,y_pos+val1,x_pos+val2+val4,y_pos+val1+val3,"purple")
			--gui.drawBox(x_pos,y_pos,x_pos+val4,y_pos+val3,"green")
			
			--gui.drawText(x_pos,y_pos,string.format("%X",mainmemory.read_u8(0x501+i)))
			gui.drawText(x_pos,y_pos-7,string.format("%d",HP))
			--gui.text(x_pos,y_pos+14,string.format("65: %d",val3))
			--gui.text(x_pos,y_pos+21,string.format("66: %d",val4))
			
			--gui.drawPixel(x_pos,y_pos,"red")
			--gui.drawPixel(x_pos,y_pos+val1,"purple")
			--gui.drawPixel(x_pos,y_pos+val1+0x11,"green")
			--gui.drawPixel(x_pos+val2-0x11,y_pos,"red")
			--gui.drawPixel(x_pos+val2-0x11,y_pos+val1,"purple")
			--gui.drawPixel(x_pos+val2-0x11,y_pos+val1+0x11,"green")
			
			
		end
	end
	
	if mainmemory.read_u8(0x002E)==0x03 then

			
			index = bit.band(mainmemory.read_u8(0x50A),0xF0)
			x_pos = mainmemory.read_u8(0x507)
			y_pos = mainmemory.read_u8(0x505)
			HP = mainmemory.read_u8(0x0040)
			

				
			

				--val1 = 0x14 --55
				--val2 = 0x00 --56
				--val3 = 0x2B --65
				--val4 = 0x1B --66
				
				val1 = mainmemory.read_u8(0x55) --55
				val2 = mainmemory.read_u8(0x56) --56
				val3 = mainmemory.read_u8(0x65) --65
				val4 = mainmemory.read_u8(0x66) --66


			gui.drawBox(x_pos+val2,y_pos,x_pos+val2+val4,y_pos+val3,"purple")

			
			gui.drawText(x_pos,y_pos,string.format("%X",mainmemory.read_u8(0x501)))
			gui.drawText(x_pos,y_pos+7,string.format("%d",HP))
	end
	

	emu.frameadvance()
end