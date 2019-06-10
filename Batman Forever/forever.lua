-- Batman Forever Helper Script
-- Author: Omnigamer
-- 5/30/16

function draw_cross(x_pos,y_pos, color)
	gui.drawLine(x_pos-3,y_pos,x_pos+3,y_pos, color)
	gui.drawLine(x_pos,y_pos-3,x_pos,y_pos+3, color)
end

display_toggle = true;
wait = 0;
memory.usememorydomain("CARTROM")

while true do
		
		--Coordinates
		cam_x = mainmemory.read_u16_le(0x0000B1);
		cam_y = mainmemory.read_u16_le(0x0000B5);
		
		for i = 0x112c,0x1144,0x02 do
			
			ID = mainmemory.read_u8(i-0xC0)
			
			att_ID = mainmemory.read_u8(i+0x380)
			
			increments = mainmemory.read_u8(i+0x3A0)+2
			
			reversed = bit.band(mainmemory.read_u8(i-0xE7),0x80) --80 set if facing right
			
			att_addr = memory.read_u16_le(0x1bfee1+ID*2)
			att_bank = memory.read_u8(0x1bfee3+ID*2)-0x80
			att_bank = att_bank *0x10000
			
			
			att_addr2 = memory.read_u16_le(att_bank + att_addr+att_ID)
			
			att_left = memory.read_s16_le(att_bank + att_addr2 + increments)
			att_down = memory.read_s16_le(att_bank + att_addr2 + increments+2)
			att_right = memory.read_s16_le(att_bank + att_addr2 + increments+4)
			att_up = memory.read_s16_le(att_bank + att_addr2 + increments+6)
			
			
			x_coord = mainmemory.read_u16_le(i)-cam_x
			y_coord = mainmemory.read_u16_le(i+0x40)-cam_y
			
			hitbox_x1 = mainmemory.read_s16_le(i+0x2A0) -- left, negative
			hitbox_y1 = mainmemory.read_s16_le(i+0x2C0) -- up, negative
			
			hitbox_x2 = mainmemory.read_s16_le(i+0x2E0) -- right
			hitbox_y2 = mainmemory.read_s16_le(i+0x300) -- down
			
			anim_ID = memory.read_u16_le(att_bank + att_addr2 + increments-2);
			
			if(reversed ==0) then
				temp1 = hitbox_x1
				temp2 = hitbox_x2
				temp3 = att_left
				temp4 = att_right
			
				hitbox_x1 = 0-temp2
				hitbox_x2 = 0-temp1
				att_left = 0-temp4
				att_right = 0-temp3
			end
				
			
			--gui.drawText(x_coord+10,y_coord-40,string.format("%X", att_addr));
			--gui.drawText(x_coord+10,y_coord-30,string.format("%X", att_bank));
			
			--gui.drawText(x_coord+10,y_coord-20,string.format("%X", att_addr2));
			--gui.drawText(x_coord+10,y_coord-10,string.format("%X", anim_ID));
			
			--gui.drawText(x_coord+10,y_coord-40,string.format("%X", att_addr2));
			
			gui.drawBox(x_coord + hitbox_x1,y_coord+hitbox_y1,x_coord+hitbox_x2, y_coord+ hitbox_y2,"white")
			
			if(anim_ID==0x8008 or anim_ID==0x8022) then
				gui.drawBox(x_coord + att_left,y_coord+att_down,x_coord+att_right, y_coord+ att_up,"red")
			end
			draw_cross(x_coord,y_coord, "white");

			HP = mainmemory.read_u8(i+0x200)
			
			--gui.drawText(x_coord-10,y_coord-20,string.format("%X", i-0x112c));
			--gui.drawText(x_coord-10,y_coord+10,string.format("%d", HP));
				
		end
		
		for i = 0x1146,0x114C,0x02 do
			
			ID = mainmemory.read_u8(i-0xC0)
			
			att_ID = mainmemory.read_u8(i+0x380)
			
			increments = mainmemory.read_u8(i+0x3A0)+2
			
			reversed = bit.band(mainmemory.read_u8(i-0xE7),0x80) --80 set if facing right
			
			att_addr = memory.read_u16_le(0x1bff51+ID*2)
			att_bank = memory.read_u8(0x1bff53+ID*2)-0x80
			att_bank = att_bank *0x10000
			
			
			att_addr2 = memory.read_u16_le(att_bank + att_addr+att_ID)
			
			att_left = memory.read_s16_le(att_bank + att_addr2 + increments)
			att_down = memory.read_s16_le(att_bank + att_addr2 + increments+2)
			att_right = memory.read_s16_le(att_bank + att_addr2 + increments+4)
			att_up = memory.read_s16_le(att_bank + att_addr2 + increments+6)
			
			
			x_coord = mainmemory.read_u16_le(i)-cam_x
			y_coord = mainmemory.read_u16_le(i+0x40)-cam_y
			
			hitbox_x1 = mainmemory.read_s16_le(i+0x2A0) -- left, negative
			hitbox_y1 = mainmemory.read_s16_le(i+0x2C0) -- up, negative
			
			hitbox_x2 = mainmemory.read_s16_le(i+0x2E0) -- right
			hitbox_y2 = mainmemory.read_s16_le(i+0x300) -- down
			
			anim_ID = memory.read_u16_le(att_bank + att_addr2 + increments-2);
			
			if(reversed ==0) then
				temp1 = hitbox_x1
				temp2 = hitbox_x2
				temp3 = att_left
				temp4 = att_right
			
				hitbox_x1 = 0-temp2
				hitbox_x2 = 0-temp1
				att_left = 0-temp4
				att_right = 0-temp3
			end
				
			
			--gui.drawText(x_coord+10,y_coord-40,string.format("%X", att_addr));
			--gui.drawText(x_coord+10,y_coord-30,string.format("%X", att_bank));
			
			--gui.drawText(x_coord+10,y_coord-20,string.format("%X", att_addr2));
			--gui.drawText(x_coord+10,y_coord-10,string.format("%X", anim_ID));
			
			--gui.drawText(x_coord+10,y_coord-40,string.format("%X", att_addr2));
			
			gui.drawBox(x_coord + hitbox_x1,y_coord+hitbox_y1,x_coord+hitbox_x2, y_coord+ hitbox_y2,"white")
			
			if(anim_ID==0x8008 or anim_ID==0x8022) then
				gui.drawBox(x_coord + att_left,y_coord+att_down,x_coord+att_right, y_coord+ att_up,"red")
			end
			draw_cross(x_coord,y_coord, "white");

			--HP = mainmemory.read_u8(i+0x200)
			
			--gui.drawText(x_coord-10,y_coord-20,string.format("%X", i-0x112c));
			--gui.drawText(x_coord-10,y_coord+10,string.format("%d", HP));
				
		end

	emu.frameadvance()
end