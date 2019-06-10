while true do
	
	camx = mainmemory.read_u16_le(0x000548)
	camy = mainmemory.read_u16_le(0x00054A)
	
	textX=30
	textY=50
	
	hp = mainmemory.read_u8(0x001F3A)
	--gui.text(textX,textY,string.format("HP:  %d",hp))
	diff = mainmemory.read_u8(0x001F0F)
	
	memory.usememorydomain("CARTROM")
	
	hitbox_left = mainmemory.read_u16_le(0x000270)
	hitbox_right = mainmemory.read_u16_le(0x000272)
	hitbox_up = mainmemory.read_u16_le(0x000274)
	hitbox_down = mainmemory.read_u16_le(0x000276)
	
	if(mainmemory.read_u8(0x000E1D)~=0xFF) then
		attack_right = mainmemory.read_u16_le(0x000280)
		attack_left = mainmemory.read_u16_le(0x000282)
		attack_up = mainmemory.read_u16_le(0x000284)
		attack_down = mainmemory.read_u16_le(0x000286)
	
		
			gui.drawBox(attack_left-camx,attack_up-camy,attack_right-camx, attack_down-camy,"green")
			
	end
	
	if(mainmemory.read_u8(0x000E1E)~=0x00) then
		gui.drawBox(hitbox_left-camx,hitbox_up-camy,hitbox_right-camx, hitbox_down-camy,"blue")
	else
		gui.drawBox(hitbox_left-camx,hitbox_up-camy,hitbox_right-camx, hitbox_down-camy,"white")
	end
	
	
	hitbox_left = mainmemory.read_u16_le(0x000278)
	hitbox_right = mainmemory.read_u16_le(0x00027A)
	hitbox_up = mainmemory.read_u16_le(0x00027C)
	hitbox_down = mainmemory.read_u16_le(0x00027E)
	
	if(mainmemory.read_u8(0x000E3D)~=0xFF) then
		attack_right = mainmemory.read_u16_le(0x000288)
		attack_left = mainmemory.read_u16_le(0x00028A)
		attack_up = mainmemory.read_u16_le(0x00028C)
		attack_down = mainmemory.read_u16_le(0x00028E)
	
		gui.drawBox(attack_left-camx,attack_up-camy,attack_right-camx, attack_down-camy,"green")
	end
	
	if(mainmemory.read_u8(0x000E3E)~=0x00) then
		gui.drawBox(hitbox_left-camx,hitbox_up-camy,hitbox_right-camx, hitbox_down-camy,"blue")
	else
		gui.drawBox(hitbox_left-camx,hitbox_up-camy,hitbox_right-camx, hitbox_down-camy,"white")
	end
	
	
	
	
	for i = 2,0x0F,1 do
		
		if(mainmemory.read_u8(0x000e00+(i*0x20))>0) then
		
		ID = mainmemory.read_u8(0x000e00+(i*0x20))*4
		
		NEWDC = mainmemory.read_u8(0x000e1c+(i*0x20))*4
		
		pos_x = mainmemory.read_u16_le(0x000e10+(i*0x20))
		pos_y = mainmemory.read_u16_le(0x000e12+(i*0x20))
		
		offset_x = memory.read_u8(0x038A00+NEWDC)
		length_x = memory.read_u8(0x038A01+NEWDC)
		offset_y = memory.read_u8(0x038A02+NEWDC)
		length_y = memory.read_u8(0x038A03+NEWDC)
		

		drop_offset = memory.read_u8(0x0091eb+ID)
		if(drop_offset >=0x04) then
			if(diff==0x00) then
				drop_sub = bit.rshift(drop_offset,1)
			elseif(diff==0x10) then
				drop_sub = drop_offset + bit.rshift(drop_offset,2)
			else
				drop_sub = drop_offset
			end
		else
			drop_sub = drop_offset
		end
		
		gui.drawPixel(pos_x-camx, pos_y-camy,"red")
		
		if(mainmemory.read_u8(0x000E0C+(i*0x20))==0) then
			mycolor = "red"
		else
			mycolor = "white"
		end
		
		if(bit.band(mainmemory.read_u8(0x000e07+(i*0x20)),0x40)~=0) then
			gui.drawBox(pos_x-camx+offset_x-length_x,pos_y-camy-offset_y,pos_x-camx+offset_x, pos_y-camy-offset_y+length_y,mycolor)
		else 
			gui.drawBox(pos_x-camx-offset_x+length_x,pos_y-camy-offset_y,pos_x-camx-offset_x, pos_y-camy-offset_y+length_y,mycolor)
		end
		
		damage = mainmemory.read_u8(0x000e14+(i*0x20))
		max_hp = mainmemory.read_u8(0x000e15+(i*0x20))
		
		drop_index = mainmemory.read_u8(0x000e17+(i*0x20))
		drop_count = mainmemory.read_u8(0x000d00+drop_index)
		drop_type = memory.read_u8(0x0091ec+ID)
		
		if(drop_type == 0x05) then
			if(mainmemory.read_u8(0x000e19)==0x01) then
				drop_color = "red" -- Bomb
			else
				drop_color = "green" -- Sword Up
			end
		elseif(drop_type == 0x01) then -- HP Up
			if(mainmemory.read_u8(0x000e19)==0x01) then
				drop_color = "purple" -- HP Up
			else
				drop_color = "green" -- Sword Up
			end
		elseif(drop_type == 0x03) then -- Big HP Up
			if(mainmemory.read_u8(0x000e19)==0x01) then
				drop_color = "blue" -- Big HP Up
			else
				drop_color = "green" -- Sword Up
			end
		elseif(drop_type == 0x07) then -- HP or bomb?
			if(bit.band(mainmemory.read_u8(0x00005c),0x01)==0) then
				drop_color = "purple" -- HP Up
			else
				drop_color = "red" -- Bomb
			end
		else
			drop_color = "white"
		end
		
		
		if(max_hp-damage < 128 and max_hp-damage ~= 0) then

			--gui.drawText(pos_x-camx, pos_y-camy,string.format("%d",max_hp-damage))
			
		end
		
		if(drop_sub<0x20 and drop_sub>0) then
			if(((drop_sub-(drop_count))%drop_sub)~=0) then
				--gui.drawText(pos_x-camx, pos_y-camy+10,string.format("%d",(drop_sub-(drop_count))%drop_sub),drop_color)
			else
				--gui.drawText(pos_x-camx, pos_y-camy+10,string.format("%d",(drop_sub)),drop_color)
			end
		end
		
		end
	end
	
	for i = 0,0x0f,1 do --was 7
		--if(i<8 and i>=0x0c) then
			ID = mainmemory.read_u8(0x000c00+(i*0x10))
			if(ID>0) then
			
				addr_offset = mainmemory.read_u8(0x000c0e+(i*0x10))*8
			
				pos_x = mainmemory.read_u16_le(0x000c05+(i*0x10))
				pos_y = mainmemory.read_u16_le(0x000c07+(i*0x10))
			
				offset_x = memory.read_u8(0x009045+addr_offset)
				length_x = memory.read_u8(0x009047+addr_offset)
				offset_y = memory.read_u8(0x009049+addr_offset)
				length_y = memory.read_u8(0x00904B+addr_offset)
			
				gui.drawBox(pos_x-camx+offset_x,pos_y-camy+offset_y,pos_x-camx+offset_x+length_x, pos_y-camy+offset_y+length_y,"purple")
				
				--gui.drawText(pos_x-camx, pos_y-camy,string.format("%d",mainmemory.read_u8(0x000c01+(i*0x10))))

			end
		--end
	end
	
	emu.frameadvance()
end