memory.usememorydomain("CARTROM")

while true do
	
	room = mainmemory.read_u16_le(0x05AA);
	obj_base = memory.read_u16_le(0x01B6EB+room);
	my_x = mainmemory.read_u16_le(0x1034);
	my_y = mainmemory.read_u16_le(0x1036);
	
	cam_x = mainmemory.read_u16_le(0x080A);
	cam_y = mainmemory.read_u16_le(0x080E);
	
	gui.drawText(10,10,string.format("%X, %X",my_x/16,my_y/16));
	
	if (room<0x300) then --get rid of garbage from pre-battle
		for i=0,30,1 do
			obj_x = memory.read_u8(obj_base+0x010000);
			
			if(obj_x==0xFF) then
				break;
			end;
			
			obj_y = memory.read_u8(obj_base+0x010001);
			
			obj_ID = memory.read_u16_le(obj_base+0x010003);
			
			status = memory.read_s16_le(obj_base+0x010005)
			
			if (status==0) then --This is weird stuff
				flags = memory.read_u8(obj_base+0x010002)+0x500;
			else
				flags = status;
			end;
			
			flags = bit.band(flags,0x07FF);
			low_bits = bit.band(flags,0x07);
			high_bits = flags/8;
			
			flagcheck = memory.read_u8(0x00dc1e+low_bits); --select which bit to test
			active = bit.band(flagcheck,mainmemory.read_u8(0x730+high_bits)); --Grab corresponding story/chest flag byte
			
			gui.drawText(10,25+10*i,string.format("%2X,%2X : %X",obj_x,obj_y,obj_ID));
			
			pos_x = obj_x*16-cam_x; --Calculate on-screen position
			pos_y = obj_y*16-cam_y;

			gui.drawText(pos_x,pos_y,string.format("%X",obj_ID));

			if (status==0) then
				if (active==0) then
					gui.drawBox(pos_x,pos_y,pos_x+16,pos_y+16,"red") --unlocked, active
				else
					gui.drawBox(pos_x,pos_y,pos_x+16,pos_y+16,"blue") --unlocked, inactive
				end;
			else
				if (active==0) then
					gui.drawBox(pos_x,pos_y,pos_x+16,pos_y+16,"purple") --locked, and inactive
				else
					gui.drawBox(pos_x,pos_y,pos_x+16,pos_y+16,"green") --locked, and active??
				end;
			end;
			
			obj_base = obj_base + 7; --Move on to next item in the list
		end		
	end
	
	
	
	for i=0,20,2 do
		enemy_base = mainmemory.read_u16_le(0x0402+i);
	
		if (enemy_base==0) then
			break;
		end
		
		enemy_x = mainmemory.read_u16_le(enemy_base);
		enemy_y = mainmemory.read_u16_le(enemy_base+2);
		
		formation = mainmemory.read_u8(0x1000A+enemy_base); -- is actually direction
		
		if (formation~=0) then 
			gui.drawText(enemy_x-cam_x-8,enemy_y-cam_y,string.format("%X",formation));
		end;
	end
	
	emu.frameadvance()
end