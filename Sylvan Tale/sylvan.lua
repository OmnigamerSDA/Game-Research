-- Sylvan Tale Helper Script
-- Author: Omnigamer
-- 6/18/16

function draw_cross(x_pos,y_pos, color)
	gui.drawLine(x_pos-3,y_pos,x_pos+3,y_pos, color)
	gui.drawLine(x_pos,y_pos-3,x_pos,y_pos+3, color)
end

memory.usememorydomain("ROM")

function draw_hitbox(myX,myY, base_addr, color)
	hit_addr = mainmemory.read_u8(base_addr)*4 + 0xAE22 + 0x4C000;
		
	hit_l = memory.read_s8(hit_addr)
	hit_r = memory.read_s8(hit_addr+1)
	hit_u = memory.read_s8(hit_addr+2)
	hit_d = memory.read_s8(hit_addr+3)
	
	gui.drawBox(myX + hit_l, myY + hit_u, myX + hit_r + hit_l, myY + hit_d+ hit_u, color);

end

function draw_hitbox2(myX,myY, base, color)
	hit_addr = base*4 + 0xAE22 + 0x4C000;
		
	hit_l = memory.read_s8(hit_addr)
	hit_r = memory.read_s8(hit_addr+1)
	hit_u = memory.read_s8(hit_addr+2)
	hit_d = memory.read_s8(hit_addr+3)
	
	gui.drawBox(myX + hit_l, myY + hit_u, myX + hit_r + hit_l, myY + hit_d+ hit_u, color);

end

while true do
		
		--0x4 = hurtbox offset
		--0x5 = hitbox offset
		
		--RNG = mainmemory.read_u16_le(0x0000AA);
		--gui.drawText(0,23,string.format("RNG: %4X",RNG))
		--Coordinates
		cam_x = mainmemory.read_u16_le(0x00085A);
		cam_y = mainmemory.read_u16_le(0x00085D);
		
		pos_x =mainmemory.read_u16_le(0x000293);
		pos_y =mainmemory.read_u16_le(0x000290);
		
		myX = pos_x -cam_x;
		myY = pos_y - cam_y;
		
		player_HP = mainmemory.read_u8(0x00A5);
		
		anim_ID = mainmemory.read_u16_le(0x000280);
		direction = mainmemory.read_u8(0x000A7);
		draw_hitbox(myX,myY,0x284,"blue");
		
		if(anim_ID == 0x393B) then
			draw_hitbox2(myX,myY,0x0C+direction,"green");
		elseif(anim_ID == 0x34d8) then
			draw_hitbox2(myX,myY,0x06+direction,"green");
		elseif(anim_ID == 0x446B) then
			draw_hitbox2(myX,myY,0x10,"green");
		else
			draw_hitbox(myX,myY,0x285,"green");
		end
		
		gui.drawText(2,116,string.format("%d", player_HP));

		--draw_cross(myX, myY, "white");
		
	for i = 0,0x1A do
		base = 0x02b0
		
		alive = mainmemory.read_u8(base+(i*0x30)+0x00);
		
		
		if(alive~=0x00)then
		
			enemy_HP = mainmemory.read_u8(base+(i*0x30)+0x22);
			
			pos_x = mainmemory.read_u16_le(base+(i*0x30)+0x13);
			pos_y = mainmemory.read_u16_le(base+(i*0x30)+0x10);
			
			myX = pos_x -cam_x;
			myY = pos_y - cam_y;
			
			--draw_cross(myX, myY, "red");
			
			draw_hitbox(myX,myY,base+(i*0x30)+0x5,"purple");
			draw_hitbox(myX,myY,base+(i*0x30)+0x4,"red");
		
			if(enemy_HP ~= 0) then
				gui.drawText(myX+7,myY-10,string.format("%d", enemy_HP));
			end
			--gui.drawText(myX+7,myY,string.format("%X", mainmemory.read_u16_le(base+(i*0x30)+0x00)));
			--gui.drawText(myX+7,myY+10,string.format("%X", pos_y));
			--gui.drawText(x2-10,y2-30,string.format("X2: %X", x2));
			--gui.drawText(x2-10,y2-20,string.format("Y2: %X", y2));
		
			--gui.drawText(pos_x,210,string.format("%d", i));
			--gui.drawBox(x1,y1,x2, y2,"red");
		end
	end
		
	emu.frameadvance()
end































