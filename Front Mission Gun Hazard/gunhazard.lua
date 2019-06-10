-- FM: Gun Hazard Helper Script
-- Author: Omnigamer
-- 3/9/16

function draw_cross(x_pos,y_pos, color)
	gui.drawLine(x_pos-3,y_pos,x_pos+3,y_pos, color)
	gui.drawLine(x_pos,y_pos-3,x_pos,y_pos+3, color)
end

display_toggle = true;
wait = 0;
memory.usememorydomain("CARTROM")

while true do

	inputs = input.get();
	if(wait>0) then
		wait = wait -1;
	end

	--Press D to toggle the display between % and raw Exp values
	if(inputs["D"] ~= nil and wait == 0) then
		display_toggle = not display_toggle;
		wait = 20;
	end

	if(mainmemory.read_u8(0x0114) ~= 0) then
		
		--Offset for current special weapon
		alt_num = mainmemory.read_u8(0x1c9c);
		
		--IDs for weapon types
		prime = 2*mainmemory.read_u8(0x00754E)
		alt = 2*mainmemory.read_u8(0x00754F + alt_num)
		ver = 2*mainmemory.read_u8(0x007548)
		mech = 2*mainmemory.read_u8(0x00753d)
		--xp = mainmemory.read_u32_le(0x001BBB)
		
		--Coordinates
		cam_x = mainmemory.read_u16_le(0x000089);
		cam_y = mainmemory.read_u16_le(0x00008B);
		x_coord = mainmemory.read_u16_le(0xE00+0x16)
		y_coord = mainmemory.read_u16_le(0xE00+0x1A)
		
		x_spd = mainmemory.read_u16_le(0xE00+0x0d)
		y_spd = mainmemory.read_u16_le(0xE00+0x11)
		
		gui.drawText(5,195,string.format("SPDX:%4X",x_spd));
		gui.drawText(180,195,string.format("SPDY:%4X",y_spd));
		gui.drawText(5,210,string.format("POSX:%4X",cam_x*0x1+x_coord));
		gui.drawText(180,210,string.format("POSY:%4X",cam_y*0x1+y_coord));
		
		if(display_toggle == false) then
			gui.drawText(0,23,string.format("GUN:%X",mainmemory.read_u16_le(prime + 0x73c6)))
			gui.drawText(65,23,string.format("ALT:%X",mainmemory.read_u16_le(alt + 0x7402)))
			gui.drawText(130,23,string.format("MEC:%X",mainmemory.read_u16_le(mech + 0x74ac)))
			gui.drawText(195,23,string.format("VER:%X",mainmemory.read_u16_le(ver + 0x74B6)))
		else
			--temp secondary variables
			gun = mainmemory.read_u16_le(prime + 0x73c6);
			new_alt = mainmemory.read_u16_le(alt + 0x7402);
			mec = mainmemory.read_u16_le(mech + 0x74ac)
			new_ver = mainmemory.read_u16_le(ver + 0x74b6)
				
			--Special formatting rules for %s
			if(gun >= 0xD666) then
				gui.drawText(0,23,string.format("GUN:120%%"))
			elseif( gun >= 0x8000) then
				gui.drawText(0,23,string.format("GUN:100%%"))
			else
				gui.drawText(0,23,string.format("GUN:%3.1f",gun/0x8000*100))
			end
			
			if(new_alt >= 0xD666) then
				gui.drawText(65,23,string.format("ALT:120%%"))
			elseif( new_alt >= 0x8000) then
				gui.drawText(65,23,string.format("ALT:100%%"))
			else
				gui.drawText(65,23,string.format("ALT:%3.1f",new_alt/0x8000*100))
			end
			
			if(mec >= 0xD666) then
				gui.drawText(130,23,string.format("MEC:120%%"))
			elseif( mec >= 0x8000) then
				gui.drawText(130,23,string.format("MEC:100%%"))
			else
				gui.drawText(130,23,string.format("MEC:%3.1f",mec/0x8000*100))
			end		
			
			if(new_ver >= 0xD666) then
				gui.drawText(195,23,string.format("VER:120%%"))
			elseif( new_ver >= 0x8000) then
				gui.drawText(195,23,string.format("VER:100%%"))
			else
				gui.drawText(195,23,string.format("VER:%3.1f",new_ver/0x8000*100))
			end	
		end
		
		for i = 0x08c0,0x09c0,0x40 do -- Your shots
			
			active = mainmemory.read_u8(i);
			if((active ~=0)) then
			
				x_coord = mainmemory.read_u16_le(i+0x16)
				y_coord = mainmemory.read_u16_le(i+0x1a)
				
				hitbox_addr = mainmemory.read_u16_le(i+0x20)
				
				hitbox_x = memory.read_s16_le(hitbox_addr+1+0x20000);
				hitbox_x2 = memory.read_s16_le(hitbox_addr+3+0x20000);
				hitbox_y = memory.read_s16_le(hitbox_addr+5+0x20000);
				hitbox_y2 = memory.read_s16_le(hitbox_addr+7+0x20000);
				
				if(bit.band(mainmemory.read_u8(i+0xb),0x40)~=0) then
					hitbox_x = 0 - (hitbox_x + hitbox_x2+1);
				end
				
				gui.drawRectangle(x_coord + hitbox_x,y_coord + hitbox_y,hitbox_x2, hitbox_y2,"white")
				
				draw_cross(x_coord,y_coord, "white");

				HP = mainmemory.read_u16_le(i+0x24)
				
				--gui.drawText(x_coord-10,y_coord-20,string.format("%X", i));
				gui.drawText(x_coord-10,y_coord+10,string.format("%d", HP));
				
			end
		end
		
		for i = 0x0a00,0x0b80,0x40 do -- Your alt shots
			
			active = mainmemory.read_u8(i);
			if((active ~=0)) then
			
				x_coord = mainmemory.read_u16_le(i+0x16)
				y_coord = mainmemory.read_u16_le(i+0x1a)
				
				draw_cross(x_coord,y_coord, "white");
				
				hitbox_addr = mainmemory.read_u16_le(i+0x20)
				
				hitbox_x = memory.read_s16_le(hitbox_addr+1+0x20000);
				hitbox_x2 = memory.read_s16_le(hitbox_addr+3+0x20000);
				hitbox_y = memory.read_s16_le(hitbox_addr+5+0x20000);
				hitbox_y2 = memory.read_s16_le(hitbox_addr+7+0x20000);
				
				if(bit.band(mainmemory.read_u8(i+0xb),0x40)~=0) then
					hitbox_x = 0 - (hitbox_x + hitbox_x2+1);
				end
				
				gui.drawRectangle(x_coord + hitbox_x,y_coord + hitbox_y,hitbox_x2, hitbox_y2,"white")
				
				HP = mainmemory.read_u16_le(i+0x24)
				
				--gui.drawText(x_coord-10,y_coord-20,string.format("%X", i));
				gui.drawText(x_coord-10,y_coord+10,string.format("%d", HP));
				
			end
		end
		
		for i = 0x0bc0,0x0dc0,0x40 do -- Enemy shots
			
			active = mainmemory.read_u8(i);
			if((active ~=0)) then
			
				x_coord = mainmemory.read_u16_le(i+0x16)
				y_coord = mainmemory.read_u16_le(i+0x1a)
				
				draw_cross(x_coord,y_coord, "purple");
				
				hitbox_addr = mainmemory.read_u16_le(i+0x20)
				
				hitbox_x = memory.read_s16_le(hitbox_addr+1+0x20000);
				hitbox_x2 = memory.read_s16_le(hitbox_addr+3+0x20000);
				hitbox_y = memory.read_s16_le(hitbox_addr+5+0x20000);
				hitbox_y2 = memory.read_s16_le(hitbox_addr+7+0x20000);
				
				if(bit.band(mainmemory.read_u8(i+0xb),0x40)~=0) then
					hitbox_x = 0 - (hitbox_x + hitbox_x2+1);
				end
				
				gui.drawRectangle(x_coord + hitbox_x,y_coord + hitbox_y,hitbox_x2, hitbox_y2,"purple")
				
				HP = mainmemory.read_u16_le(i+0x24)
				
				--gui.drawText(x_coord-10,y_coord-20,string.format("%X", i));
				gui.drawText(x_coord-10,y_coord+10,string.format("%d", HP));
				
			end
		end
		
		for i = 0x0e00,0x0e40,0x40 do -- Your mech/pilot
			
			active = mainmemory.read_u8(i);
			if((active ~=0)) then
			
				x_coord = mainmemory.read_u16_le(i+0x16)
				y_coord = mainmemory.read_u16_le(i+0x1a)
				
				draw_cross(x_coord,y_coord, "blue");
				
				hitbox_addr = mainmemory.read_u16_le(i+0x20)
				
				hitbox_x = memory.read_s16_le(hitbox_addr+1+0x20000);
				hitbox_x2 = memory.read_s16_le(hitbox_addr+3+0x20000);
				hitbox_y = memory.read_s16_le(hitbox_addr+5+0x20000);
				hitbox_y2 = memory.read_s16_le(hitbox_addr+7+0x20000);
				
				if(bit.band(mainmemory.read_u8(i+0xb),0x40)~=0) then
					hitbox_x = 0 - (hitbox_x + hitbox_x2+1);
				end
				
				gui.drawRectangle(x_coord + hitbox_x,y_coord + hitbox_y,hitbox_x2, hitbox_y2,"blue")
				
				HP = mainmemory.read_u16_le(i+0x24)
				
				--gui.drawText(x_coord-10,y_coord-20,string.format("%X", i));
				gui.drawText(x_coord-10,y_coord+10,string.format("%d", HP));
				
			end
		end
		
			for i = 0x0e80,0x0f00,0x40 do -- Allies
			
			active = mainmemory.read_u8(i);
			if((active ~=0)) then
			
				x_coord = mainmemory.read_u16_le(i+0x16)
				y_coord = mainmemory.read_u16_le(i+0x1a)
				
				draw_cross(x_coord,y_coord, "green");
				
				hitbox_addr = mainmemory.read_u16_le(i+0x20)
				
				hitbox_x = memory.read_s16_le(hitbox_addr+1+0x20000);
				hitbox_x2 = memory.read_s16_le(hitbox_addr+3+0x20000);
				hitbox_y = memory.read_s16_le(hitbox_addr+5+0x20000);
				hitbox_y2 = memory.read_s16_le(hitbox_addr+7+0x20000);
				
				if(bit.band(mainmemory.read_u8(i+0xb),0x40)~=0) then
					hitbox_x = 0 - (hitbox_x + hitbox_x2+1);
				end
				
				gui.drawRectangle(x_coord + hitbox_x,y_coord + hitbox_y,hitbox_x2, hitbox_y2,"green")
				
				HP = mainmemory.read_u16_le(i+0x24)
				
				--gui.drawText(x_coord-10,y_coord-20,string.format("%X", i));
				gui.drawText(x_coord-10,y_coord+10,string.format("%d", HP));
				
			end
		end
		
		for i = 0x0f40,0x10C0,0x40 do -- Enemies
			
			active = mainmemory.read_u8(i);
			if((active ~=0)) then
			
				x_coord = mainmemory.read_u16_le(i+0x16)
				y_coord = mainmemory.read_u16_le(i+0x1a)
				
				draw_cross(x_coord,y_coord, "red");
				
				hitbox_addr = mainmemory.read_u16_le(i+0x20)
				
				hitbox_x = memory.read_s16_le(hitbox_addr+1+0x20000);
				hitbox_x2 = memory.read_s16_le(hitbox_addr+3+0x20000);
				hitbox_y = memory.read_s16_le(hitbox_addr+5+0x20000);
				hitbox_y2 = memory.read_s16_le(hitbox_addr+7+0x20000);
				
				if(bit.band(mainmemory.read_u8(i+0xb),0x40)~=0) then
					hitbox_x = 0 - (hitbox_x + hitbox_x2+1);
				end
				
				gui.drawRectangle(x_coord + hitbox_x,y_coord + hitbox_y,hitbox_x2, hitbox_y2,"red")
				
				HP = mainmemory.read_u16_le(i+0x24)
				
				--gui.drawText(x_coord-10,y_coord-20,string.format("%X", i));
				gui.drawText(x_coord-10,y_coord+10,string.format("%d", HP));
				
			end
		end
		
		for i = 0x1100,0x1180,0x40 do --Props/turrets
			
			active = mainmemory.read_u8(i);
			if((active ~=0)) then
			
				x_coord = mainmemory.read_u16_le(i+0x16)
				y_coord = mainmemory.read_u16_le(i+0x1a)
				
				draw_cross(x_coord,y_coord, "yellow");
				
				hitbox_addr = mainmemory.read_u16_le(i+0x20)
				
				hitbox_x = memory.read_s16_le(hitbox_addr+1+0x20000);
				hitbox_x2 = memory.read_s16_le(hitbox_addr+3+0x20000);
				hitbox_y = memory.read_s16_le(hitbox_addr+5+0x20000);
				hitbox_y2 = memory.read_s16_le(hitbox_addr+7+0x20000);
				
				if(bit.band(mainmemory.read_u8(i+0xb),0x40)~=0) then
					hitbox_x = 0 - (hitbox_x + hitbox_x2+1);
				end
				
				gui.drawRectangle(x_coord + hitbox_x,y_coord + hitbox_y,hitbox_x2, hitbox_y2,"yellow")
				
				HP = mainmemory.read_u16_le(i+0x24)
				
				gui.drawText(x_coord-10,y_coord-20,string.format("%X", i));
				gui.drawText(x_coord-10,y_coord+10,string.format("%d", HP));
				
			end
		end
		
		for i = 0x11c0,0x1440,0x40 do --Misc stuff, loading zones
			
			active = mainmemory.read_u8(i);
			if((active ~=0)) then
			
				x_coord = mainmemory.read_u16_le(i+0x16)
				y_coord = mainmemory.read_u16_le(i+0x1a)
				
				draw_cross(x_coord,y_coord, "black");
				
				hitbox_addr = mainmemory.read_u16_le(i+0x20)
				
				hitbox_x = memory.read_s16_le(hitbox_addr+1+0x20000);
				hitbox_x2 = memory.read_s16_le(hitbox_addr+3+0x20000);
				hitbox_y = memory.read_s16_le(hitbox_addr+5+0x20000);
				hitbox_y2 = memory.read_s16_le(hitbox_addr+7+0x20000);
				
				if(bit.band(mainmemory.read_u8(i+0xb),0x40)~=0) then
					hitbox_x = 0 - (hitbox_x + hitbox_x2+1);
				end
				
				gui.drawRectangle(x_coord + hitbox_x,y_coord + hitbox_y,hitbox_x2, hitbox_y2,"black")
				
				--HP = mainmemory.read_u16_le(i+0x24)
				
				gui.drawText(x_coord-10,y_coord-20,string.format("%X", i));
				--gui.drawText(x_coord-10,y_coord+10,string.format("%d", HP));
				
			end
		end
	end

	emu.frameadvance()
end