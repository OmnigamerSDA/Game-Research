while true do
	
	
	textX=20
	textY=50
	
	hp = mainmemory.read_u8(0x00009f)
	gui.text(textX,textY,string.format("HP:   %d",hp))
	psy = mainmemory.read_u8(0x0000A4)
	gui.text(textX,textY+15,string.format("CHG:  %d",psy))
	hspd = mainmemory.read_s8(0x000095)
	vspd = mainmemory.read_s8(0x000096)
	gui.text(textX,textY+30,string.format("HSPD: %d",hspd))
	gui.text(textX,textY+45,string.format("VSPD: %d",vspd))
	
	gui.text(textX,textY+70,string.format("RNG: %X",mainmemory.read_u16_le(0x00004A)))
	
	playerX = mainmemory.read_u8(0x00008B)
	playerY = mainmemory.read_u8(0x00008E)
	
	hitboxX = mainmemory.read_u8(0x0000aa)
	hitboxY = mainmemory.read_u8(0x0000ab)
	
	--gui.drawBox(playerX-(0x05),playerY-0x1C,playerX+(0x05), playerY,"blue")
	gui.drawBox(playerX-hitboxX,playerY-hitboxY,playerX+hitboxX, playerY,"blue")
	--gui.drawPixel(playerX,playerY, "green")
	
	
	for i = 0x27,0,-1 do --enemy hitboxes
		
		enemyX = mainmemory.read_u8(0x000748+i)
		enemyY = mainmemory.read_u8(0x0007e8+i)
		myType = mainmemory.read_u8(0x000680+i)
		
		if myType~=0 and myType~=0x02 and myType~=0x0a and myType~=0x03 then
		--if myType==0x40 then
		if mainmemory.read_u8(0x000a68+i)>1  then
			if mainmemory.read_u8(0x000770+i)==0 then
				if mainmemory.read_u8(0x000810+i)==0 then
					hitboxX = mainmemory.read_u8(0x0006d0+i)
					hitboxY = mainmemory.read_u8(0x0006f8+i)
				
					gui.drawBox(enemyX-(hitboxX),enemyY-hitboxY,enemyX+(hitboxX), enemyY,"red")
					--gui.drawPixel(enemyX,enemyY, "red")
					gui.drawText(enemyX,enemyY,string.format("%d",mainmemory.read_u8(0x000a68+i)))
					--gui.text(enemyX,enemyY+7,string.format("%x",mainmemory.read_u8(0x000680+i)))
					--gui.text(enemyX,enemyY+21,string.format("%x",hitboxY))
				end
			end
			else
			
			if mainmemory.read_u8(0x000770+i)==0 then
				if mainmemory.read_u8(0x000810+i)==0 then
					hitboxX = mainmemory.read_u8(0x0006d0+i)
					hitboxY = mainmemory.read_u8(0x0006f8+i)
				
					gui.drawBox(enemyX-(hitboxX),enemyY-hitboxY,enemyX+(hitboxX), enemyY,"red")
					--gui.drawPixel(enemyX,enemyY, "red")
					--gui.text(enemyX,enemyY,string.format("%d",mainmemory.read_u8(0x000888+i)))
					--gui.text(enemyX,enemyY+7,string.format("%x",mainmemory.read_u8(0x000680+i)))
					--gui.text(enemyX,enemyY+14,string.format("%x",hitboxX))
					--gui.text(enemyX,enemyY+21,string.format("%x",hitboxY))
				end
			end
			--end
		end
		end
		
		
	end
	
	for i = 0x0F,0,-1 do --Player Attacks
		
		locX = mainmemory.read_u8(0x000ae0+i)
		locY = mainmemory.read_u8(0x000b10+i)
		
		ID = mainmemory.read_u8(0x000a90+i)
		
		if ID~=0 and ID~=4 then
			if mainmemory.read_u8(0x000af0+i)==0 then
				if mainmemory.read_u8(0x000b20+i)==0 then
					hitboxX = mainmemory.read_u8(0x000ab0+i)
					hitboxY = mainmemory.read_u8(0x000ac0+i)
				
					gui.drawBox(locX-(hitboxX),locY-(hitboxY),locX+(hitboxX), locY+(hitboxY),"white")
					--gui.drawPixel(enemyX,enemyY, "red")
					--gui.text(locX,locY,string.format("%d",mainmemory.read_u8(0x000a90+i)))
					--gui.text(enemyX,enemyY+14,string.format("%x",hitboxX))
					--gui.text(enemyX,enemyY+21,string.format("%x",hitboxY))
				end
			end
		end
		
		
	end
	
	
	
	emu.frameadvance()
end