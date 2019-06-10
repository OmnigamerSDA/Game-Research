while true do
	
	camx = mainmemory.read_u16_le(0x000C00)
	camy = mainmemory.read_u16_le(0x000C02)
	
	textX=20
	textY=30
	
	player_pos_x=mainmemory.read_u8(0x00F1C1) --Player position
	player_pos_y=mainmemory.read_u8(0x00F101)
	
	stance=mainmemory.read_u8(0x00F281)
	punchstate=mainmemory.read_u8(0x00F281)--1 for regular punch, 2 for moving punch, 3 for crouch punch, 4 for air kick

	player_map_x = mainmemory.read_u8(0x00F201)
	player_map_y = mainmemory.read_u8(0x00F141)
	
	playerh=bit.bor(bit.lshift(bit.band(player_map_x,0x00FF),8),player_pos_x)
	playerv=bit.bor(bit.lshift(bit.band(player_map_y,0x00FF),8),player_pos_y)
	
	
	--Horizontal and Vertical positions
	
	--gui.drawText(textX,textY,string.format("H:  %d",player_pos_x))
	--gui.drawText(textX,textY+14,string.format("V:  %d",player_pos_y))
	
	
	--Wind Boss HP
	
	--wind_hp=mainmemory.read_u8(0x00F824)
	--gui.drawText(textX,textY+28,string.format("Wind:  %d",wind_hp))
	
	
	hitbox_x=0x08
	hitbox_y=0x10
	
	if stance==3 then
		--hitbox_x=0x18
		hitbox_y=hitbox_y
	elseif stance==2 then
		--hitbox_x=0x18
		hitbox_y=hitbox_y+6
	elseif stance==4 then
		--hitbox_x=0x18
		hitbox_y=hitbox_y+6
	elseif stance==7 then
		--hitbox_x=0x18
		--hitbox_y=0x22
	elseif stance==8 then
		--hitbox_x=0x18
		hitbox_y=0
	else
		--hitbox_x=0x18
		hitbox_y=hitbox_y+6
	end
	
	gui.drawBox(playerh-camx-hitbox_x,playerv-camy-(hitbox_y),playerh-camx+hitbox_x,playerv-camy+(hitbox_y),"blue")
	
	--enemy_x = mainmemory.read_u8(0x00F1E3)
	
	--enemy_x2 = mainmemory.read_u8(0x000F98)
	
	--hp = mainmemory.read_u8(0x00F801)
	--gui.drawText(textX,textY,string.format("HP:  %d",hp))
	--test_x = mainmemory.read_u8(0x000F9F)
	--gui.drawText(textX,textY+7,string.format("hit x: %x",test_x))
	--test_y = mainmemory.read_u8(0x000FA1)
	--gui.drawText(textX,textY+14,string.format("hit y: %x",test_y))
	--punch_y = mainmemory.read_u8(0x000FAF)
	--gui.drawText(textX,textY+21,string.format("punch y: %x",punch_y))
	--my_y = mainmemory.read_u8(0x000FAF)
	--my_x = mainmemory.read_u8(0x000FB1)
	--gui.drawText(textX,textY+28,string.format("atk x: %x",my_x))
	
	--gui.drawText(textX,textY+35,string.format("atk y: %x",my_y))
	
	
	memory.usememorydomain("CARTROM")
	
	RNG1 = mainmemory.read_u8(0x00009B)
	RNG2 = mainmemory.read_u8(0x00009C)
	
	--gui.drawText(textX,textY+21,string.format("RNG1: %x",RNG1))
	--gui.drawText(textX,textY+28,string.format("RNG2: %x",RNG2))
	
	for j = 0,48,1 do
		if bit.band(RNG1,0x80)>0 then
			rotatecarry = 1
		else
			rotatecarry=0
		end
	
		newRNG1= bit.band(bit.lshift(RNG1,1),0xFF)+RNG1
		if newRNG1>0xFF then
			carry = 1
			newRNG1=bit.band(newRNG1,0xFF)
		else
			carry=0
		end
		newRNG2=bit.band(bit.rol(RNG1,1)+rotatecarry+RNG2+RNG1+carry,0xFF)
		
		RNG1 = newRNG1
		RNG2 = newRNG2
		
		
	end
	
	--gui.drawText(textX,textY+35,string.format("newRNG1: %x",newRNG1))
	--gui.drawText(textX,textY+42,string.format("newRNG2: %x",newRNG2))
	
	myRNG=bit.band(bit.rshift(newRNG2,1),0x1F)
	counter=0
	while myRNG~=0x1F and counter<100 do
		counter=counter+1
		
		if bit.band(RNG1,0x80)>0 then
			rotatecarry = 1
		else
			rotatecarry=0
		end
	
		newRNG1= bit.band(bit.lshift(RNG1,1),0xFF)+RNG1
		if newRNG1>0xFF then
			carry = 1
			newRNG1=bit.band(newRNG1,0xFF)
		else
			carry=0
		end
		newRNG2=bit.band(bit.rol(RNG1,1)+rotatecarry+RNG2+RNG1+carry,0xFF)
		
		RNG1 = newRNG1
		RNG2 = newRNG2
		
		myRNG=bit.band(bit.rshift(newRNG2,1),0x1F)
	end
	

	--RNG Value
		
	--gui.drawText(textX,textY+10,string.format("RNG: %d",counter))
	
	for i = 0,63,1 do --enemy hitboxes
		if mainmemory.read_u8(0x00F000+i)>0 then
			
			--if mainmemory.read_u8(0x00F240+i)>=0x30 then
				
				--if mainmemory.read_u8(0x00F280+i)==0 then
					enemy_pos_x = mainmemory.read_u8(0x00F1c0+i)
					enemy_map_x = mainmemory.read_u8(0x00F200+i)
					
					enemy_x=bit.bor(bit.lshift(bit.band(enemy_map_x,0x00FF),8),enemy_pos_x)
					
					
					
					id = mainmemory.read_u8(0x00F240+i)
					enemy_pos_y = mainmemory.read_u8(0x00F100+i)
					enemy_map_y = mainmemory.read_u8(0x00F140+i)
					
					enemy_y=bit.bor(bit.lshift(bit.band(enemy_map_y,0x00FF),8),enemy_pos_y)

					--gui.drawLine(enemy_x-camx-3,enemy_y-camy,enemy_x-camx+3,enemy_y-camy, "white")
					--gui.drawLine(enemy_x-camx,enemy_y-camy-3,enemy_x-camx,enemy_y-camy+3, "white")
					--gui.drawText(enemy_x-camx-10,enemy_y-camy-12,string.format("%x",id))
					--gui.drawText(enemy_x-camx-10,enemy_y-camy-22,string.format("%x",i))
					--gui.drawText(enemy_x-camx-10,enemy_y-camy-32,string.format("%x",mainmemory.read_u8(0x00F280+i)))
					
					if i==2 then
						--normal punch
						if mainmemory.read_u8(0x000084)==0x04 then
							--airkick; numbers are fudged
							x_box = 0x0d
							y_box = 0x13
						else
							x_box = 0x0c
							y_box = 0x0c
						end
						gui.drawBox(enemy_x-camx-x_box,enemy_y-camy-y_box,enemy_x-camx+x_box,enemy_y-camy+y_box,"white")
					end
					
					if i==3 then
						
						if id==1 then
							--crescent
							x_box = 0x08
							y_box = 0x10
						elseif id==2 then
							--comet
							x_box = 0x10
							y_box = 0x18
						elseif id==3 then
							--lightning
							x_box = 0x10
							y_box = 0x80
						elseif id==4 then
							--timestop
							x_box = 0x00
							y_box = 0x00
						elseif id==5 then
							--starburst
							if mainmemory.read_u8(0x00F280+i)==1 then
								x_box = 0x08
								y_box = 0x08
							else
								x_box = 0x10
								y_box = 0x10
							end
						elseif id==6 then
							--Phoenix
							x_box = 0x18
							y_box = 0x18
						end
						
						gui.drawBox(enemy_x-camx-x_box,enemy_y-camy-y_box,enemy_x-camx+x_box,enemy_y-camy+y_box,"white")
					end
					
					if i>3 then
						if i<0x0b then
						
							if id==3 then
								--lightning
								x_box = 0x10
								y_box = 0x80
							elseif id==5 then
								--starburst
								if mainmemory.read_u8(0x00F280+i)==1 then
									x_box = 0x08
									y_box = 0x08
								else
									x_box = 0x10
									y_box = 0x10
								end
							end
							
							gui.drawBox(enemy_x-camx-x_box,enemy_y-camy-y_box,enemy_x-camx+x_box,enemy_y-camy+y_box,"white")
						end
					end
					
					if i==0x0e then
						--crescent
						x_box = 0x10
						y_box = 0x10
						gui.drawBox(enemy_x-camx-x_box,enemy_y-camy-y_box,enemy_x-camx+x_box,enemy_y-camy+y_box,"white")
					end
					
					x_box=0
					y_box=0
					
					mycolor="red"
					
					if id==0x30 then
						x_box = 0x10
						y_box = 0x18
					elseif id==0x31 then
						x_box = 0x10
						y_box = 0x10
					elseif id==0x32 then
						x_box = 0x08
						y_box = 0x0C
					elseif id==0x4a then
						x_box = 0x13
						y_box = 0x14
					elseif id==0x34 then
						x_box = 0x08
						y_box = 0x0c
					elseif id==0x38 then
						x_box = 0x10
						y_box = 0x14
					elseif id==0x39 then
						x_box = 0x18
						y_box = 0x14
					elseif id==0x4b then
						x_box = 0x13
						y_box = 0x1c
					elseif id==0x3a then
						x_box = 0x10
						y_box = 0x10
					elseif id==0x35 then
						x_box = 0x08
						y_box = 0x0c
					elseif id==0x33 then
						x_box = 0x14
						y_box = 0x18
					elseif id==0x36 then
						x_box = 0x10
						y_box = 0x10
					elseif id==0x37 then
						x_box = 0x10
						y_box = 0x10
					elseif id==0x48 then
						x_box = 0x18
						y_box = 0x1c
					elseif id==0x3c then
						x_box = 0x14
						y_box = 0x18
					elseif id==0x39 then
						x_box = 0x18
						y_box = 0x14
					elseif id==0x4c then
						x_box = 0x10
						y_box = 0x10
					elseif id==0x61 then
						x_box = 0x13
						y_box = 0x1c
					elseif id==0x40 then
						x_box = 0x13
						y_box = 0x14
					elseif id==0x3F then
						x_box = 0x13
						y_box = 0x0c
					elseif id==0x4F then
						x_box = 0x10
						y_box = 0x10
					elseif id==0x47 then
						x_box = 0x13
						y_box = 0x0c
					elseif id==0x4D then
						x_box = 0x13
						y_box = 0x1c
					elseif id==0x4e then
						x_box = 0x0b
						y_box = 0x0e
					elseif id==0x50 then
						x_box = 0x0b
						y_box = 0x0c
					elseif id==0x45 then
						x_box = 0x13
						y_box = 0x1c
					elseif id==0x44 then
						x_box = 0x0b
						y_box = 0x00
					elseif id==0x43 then
						x_box = 0x10
						y_box = 0x10
					elseif id==0x46 then
						x_box = 0x13
						y_box = 0x1c
					elseif id==0x7D then
						x_box = 0x20
						y_box = 0x20
					elseif id==0x7E then
						x_box = 0x0b
						y_box = 0x0c
					elseif id==0x67 then
						x_box = 0x18
						y_box = 0x1c
					elseif id==0x51 then
						x_box = 0x13
						y_box = 0x00
					elseif id==0x49 then
						x_box = 0x13
						y_box = 0x1c
					elseif id==0x6e then
						x_box = 0x10
						y_box = 0x0a
						mycolor="green"
					elseif id==0x6f then
						x_box = 0x10
						y_box = 0x0a
						mycolor="green"
					elseif id==0x89 then
						x_box = 0x46
						y_box = 0x0e
					elseif id==0x8d then
						x_box = 0x0b
						y_box = 0x14
					elseif id==0x8c then
						x_box = 0x0b
						y_box = 0x0c
					elseif id==0x8b then
						x_box = 0x0b
						y_box = 0x0c
					elseif id==0x8a then
						x_box = 0x10
						y_box = 0x10
						mycolor="purple"
					end
					
					
					gui.drawBox(enemy_x-camx-x_box,enemy_y-camy-y_box,enemy_x-camx+x_box,enemy_y-camy+y_box,mycolor)
				
				--end
			--end
		end
	end
	

	
	--gui.drawPixel(bit.band(playerh-camx, 0x00FF),bit.band(playerv-camy,0x00FF), "green")
	--gui.drawPixel(bit.band(enemy_x-camx, 0x00FF),bit.band(playerv-camy,0x00FF), "red")
	--gui.drawPixel(bit.band(enemy_x2-camx, 0x00FF),bit.band(playerv-camy,0x00FF), "yellow")
	
	emu.frameadvance()
end