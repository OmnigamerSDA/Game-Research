while true do
	
	camx = mainmemory.read_u16_le(0x001337)
	camy = mainmemory.read_u16_le(0x00133D)
	
	textX=20
	textY=30
	
	hp = mainmemory.read_u8(0x00148E)
	--gui.drawText(textX,textY,string.format("HP:  %d",hp))
	psy = mainmemory.read_u8(0x00148C)
	--gui.drawText(textX,textY+7,string.format("PSY: %d",psy))
	speed = mainmemory.read_s16_le(0x00147C)
	--gui.drawText(textX,textY+14,string.format("SPD: %d",speed))
	--state = mainmemory.read_u16_le(0x000500)
	--gui.drawText(textX,textY+21,string.format("STATE: %4X",state))
	--animation = mainmemory.read_u16_le(0x000502)
	--gui.drawText(textX,textY+28,string.format("ANIME: %4X",animation))
	
	memory.usememorydomain("CARTROM")
	
	ID=mainmemory.read_u16_le(0x000502) --Player hitbox
	hitbox_index = bit.band(memory.read_u16_le(0x03db11+ID),0x00FF)
	
	if hitbox_index<0xF0 then
		hitbox_index=bit.lshift(hitbox_index,2)
		hitbox_x = memory.read_s8(0x03de11 + hitbox_index) --$2E
		hitbox_y = memory.read_s8(0x03de13 + hitbox_index) --$30
		tempVal = 0
	else
		hitbox_index = bit.lshift(bit.band(hitbox_index,0x0F),2)
		
		tempVal = memory.read_u16_le(0x03deff+hitbox_index)
		hitbox_index = bit.lshift(memory.read_u16_le(0x03defd+hitbox_index),2)
	
		hitbox_x = memory.read_s8(0x03de11 + hitbox_index) --$2E
		hitbox_y = memory.read_s8(0x03de13 + hitbox_index) --$30
	end
	
	x_coord = mainmemory.read_u16_le(0x000509)
	y_coord = mainmemory.read_u16_le(0x000506)
	
	y_offset = mainmemory.read_s16_le(0x00050C)--mainmemory.read_u16_le(0x000506) --$2C; Vertical hitbox/offset?
	
	trueY = bit.band(bit.band(y_offset-y_coord,0xFFFF)+tempVal,0xFFFF)
	
	--$34: enemy x hitbox
	--$32: enemy + player hitbox
	
	gui.drawRectangle(x_coord-camx-hitbox_x,bit.band(trueY-camy,0xFFFF)-hitbox_y,hitbox_x*2, hitbox_y,"blue")
	
	
	ID=mainmemory.read_u16_le(0x000502) --Player sword attacks
	hitbox_index = bit.lshift(bit.band(memory.read_u16_le(0x03df0d+ID),0x00FF),3)
	temp_2C = memory.read_u16_le(0x03e011 + hitbox_index) --$2C
	x_offset = memory.read_s16_le(0x03e00D + hitbox_index)
	
	hitbox_x = memory.read_u16_le(0x03e00F + hitbox_index) --$2E
	hitbox_y = memory.read_u16_le(0x03e013 + hitbox_index) --$30
	
	x_coord = mainmemory.read_u16_le(0x000509)
	y_coord = mainmemory.read_u16_le(0x000506)
	
	y_offset = mainmemory.read_u16_le(0x00050C)--mainmemory.read_u16_le(0x000546+i*40) --$2C; Vertical offset?
	
	if bit.band(mainmemory.read_u8(0x000504),0x20) > 0 then
		gui.drawRectangle(x_coord-x_offset-camx-hitbox_x,bit.band(y_offset-y_coord + temp_2C-camy,0xFFFF)-hitbox_y,hitbox_x*2, hitbox_y,"white")
		--gui.drawPixel(x_coord-x_offset-camx,bit.band(y_offset-y_coord-camy,0xFFFF), "red")
	else
		gui.drawRectangle(x_offset+x_coord-camx-hitbox_x,bit.band(y_offset-y_coord + temp_2C-camy,0xFFFF)-hitbox_y,hitbox_x*2, hitbox_y,"white")
		--gui.drawPixel(x_offset+x_coord-camx,bit.band(y_offset-y_coord-camy,0xFFFF), "red")
	end

		
		--gui.drawText(textX,textY+21,string.format("X: %4X - %4X = %4X : %4X",x_coord,camx,x_coord-camx, hitbox_x))
		--gui.drawText(textX,textY+28,string.format("Y: %4X - %4X - %4X = %4X : %4X",y_offset,y_coord,camy,bit.band(y_offset-y_coord-camy,0xFFFF),hitbox_y))
		--gui.drawPixel(x_coord-camx,bit.band(y_offset-y_coord-camy,0xFFFF), "white")
		--gui.drawText(textX,textY+35,string.format("ID: %4X : %4X",mainmemory.read_u16_le(0x000502),bit.band(memory.read_u16_le(0x03db11+ID),0x00FF)))
	
	for i = 0,5,1 do --enemy hitboxes
		if bit.band(mainmemory.read_u16_le(0x000580+(i*0x40)),0x0001)>0 then
			ID=mainmemory.read_u16_le(0x000582+(i*0x40))
			hitbox_index = bit.lshift(bit.band(memory.read_u16_le(0x03db11+ID),0x00FF),2)
			hitbox_x = memory.read_s8(0x03de11 + hitbox_index) --$32
			hitbox_y = memory.read_s8(0x03de13 + hitbox_index) --$34
			
			x_coord = mainmemory.read_u16_le(0x000589 + (i*0x40))
			y_coord = mainmemory.read_u16_le(0x000586 + (i*0x40))
			
			y_offset = mainmemory.read_u16_le(0x00058C+(i*0x40))--mainmemory.read_u16_le(0x000546+i*0x40) --$2C; Vertical offset?
			
			gui.drawRectangle(x_coord-camx-hitbox_x,bit.band(y_offset-y_coord-camy,0xFFFF)-hitbox_y,hitbox_x*2, hitbox_y,"red")
			enemy_HP = mainmemory.read_s8(0x0005AC+(i*0x40))
			
			if enemy_HP>0 then
				--gui.drawText(x_coord-camx-5,bit.band(y_offset-y_coord-camy,0xFFFF)-hitbox_y-6,string.format("HP: %d",enemy_HP+1))
			end
			--gui.drawPixel(x_coord-camx,bit.band(y_offset-y_coord-camy,0xFFFF), "blue")
	
		end
	end
	
	for i = 0,15,1 do --enemy projectiles
		if bit.band(mainmemory.read_u16_le(0x000700+(i*0x20)),0x0001)>0 then
			ID=mainmemory.read_u16_le(0x000702+(i*0x20))
			hitbox_index = bit.lshift(bit.band(memory.read_u16_le(0x03db11+ID),0x00FF),2)
			hitbox_x = memory.read_s8(0x03de11 + hitbox_index) --$32
			hitbox_y = memory.read_s8(0x03de13 + hitbox_index) --$34
			
			x_coord = mainmemory.read_u16_le(0x000709 + (i*0x20))
			y_coord = mainmemory.read_u16_le(0x000706 + (i*0x20))
			
			y_offset = mainmemory.read_u16_le(0x00070C+(i*0x20))--mainmemory.read_u16_le(0x000546+i*0x40) --$2C; Vertical offset?
			
			gui.drawRectangle(x_coord-camx-hitbox_x,bit.band(y_offset-y_coord-camy,0xFFFF)-hitbox_y,hitbox_x*2, hitbox_y,"purple")
			--gui.drawPixel(x_coord-camx,bit.band(y_offset-y_coord-camy,0xFFFF), "blue")
	
		end
	end
	
	
	for i = 0,7,1 do --player projectiles
		if bit.band(mainmemory.read_u16_le(0x000900+(i*0x20)),0x0001)>0 then
			ID=mainmemory.read_u16_le(0x000902+(i*0x20))
			hitbox_index = bit.lshift(bit.band(memory.read_u16_le(0x03db11+ID),0x00FF),2)
			hitbox_x = memory.read_s8(0x03de11 + hitbox_index) --$2E
			hitbox_y = memory.read_s8(0x03de13 + hitbox_index) --$30
			
			x_coord = mainmemory.read_u16_le(0x000909 + (i*0x20))
			y_coord = mainmemory.read_u16_le(0x000906 + (i*0x20))
			
			y_offset = mainmemory.read_u16_le(0x00090C+(i*0x20))--mainmemory.read_u16_le(0x000546+i*40) --$2C; Vertical offset?
			
			--y_offset-y_coord = $2C
			
			gui.drawRectangle(x_coord-camx-hitbox_x,bit.band(y_offset-y_coord-camy,0xFFFF)-hitbox_y,hitbox_x*2, hitbox_y,"green")
			--gui.drawPixel(x_coord-camx,bit.band(y_offset-y_coord-camy,0xFFFF), "green")
	
		end
	end
	
	--for other hitboxes, start at $9E0 and decrement by #$20 7 times, checking if value set. $13C2 is counter.
	--Repeat for $8E0, except now F times. Last checked is $700.
	--Then for $6C0, subtract #$40 instead, 5 times. Last checked address is $580.
	
	emu.frameadvance()
end