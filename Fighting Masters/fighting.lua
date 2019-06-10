--Fighting Masters Hitbox Script
-- Author: Omnigamer
-- 10/21/16

function draw_cross(x_pos,y_pos, color)
	gui.drawLine(x_pos-3,y_pos,x_pos+3,y_pos, color)
	gui.drawLine(x_pos,y_pos-3,x_pos,y_pos+3, color)
end

--memory.usememorydomain("ROM")

function draw_hitbox(base_addr, color1, color2)
		
	pos_x = memory.read_s16_be(base_addr+0x3A) - 0x80;
	pos_y = memory.read_s16_be(base_addr+0x36)-0x80;
	
	if(pos_y>0x0C0) then
		pos_y = 0xC0;
	end;
	
	mycolor = color1;
	
	if(memory.read_s16_be(base_addr+0x1A)>0) then
		mycolor = color2;
	end;
	
	direction = mainmemory.read_u8(base_addr+0x4D);
	
	cor_y = memory.read_s16_be(base_addr+0xAC);
	
	hit_x = memory.read_s16_be(base_addr+0x22);
	hit_y = memory.read_s16_be(base_addr+0x20);
	
	if(direction ==1) then
		
		hit_x = 0 - hit_x;
		pos_x = pos_x - memory.read_s16_be(base_addr+0x1e);
	else
		pos_x = pos_x + memory.read_s16_be(base_addr+0x1e);
	end;
	pos_y =pos_y + memory.read_s16_be(base_addr+0x1c);
	--draw_cross(pos_x+off_x, pos_y-off_y, "green");
	--draw_cross(pos_x+off_x+hit_x, pos_y-off_y-hit_y, "red");
	gui.drawBox(pos_x - hit_x, pos_y+hit_y-cor_y, pos_x + hit_x, pos_y - hit_y-cor_y, mycolor);

end

function draw_hitbox2(base_addr, color)
	
	if(memory.read_s16_be(base_addr+0x24)~=0) then
		
		pos_x = memory.read_s16_be(base_addr+0x3A) - 0x80;
		pos_y = memory.read_s16_be(base_addr+0x36)-0x80;
		
		
		if(pos_y>0x0C0) then
			pos_y = 0xC0;
		end;
		
		direction = memory.read_u8(base_addr+0x4D);
		
		cor_y = memory.read_s16_be(base_addr+0xAC);
		
		off_x = memory.read_s16_be(base_addr+0x28);
		off_y = memory.read_s16_be(base_addr+0x26);
		
		hit_x = memory.read_s16_be(base_addr+0x2C);
		hit_y = memory.read_s16_be(base_addr+0x2A);
		
		if(direction ==1) then
			off_x = 0-off_x;
			hit_x = 0 - hit_x;
			--pos_x = pos_x - memory.read_s16_be(base_addr+0x1e);
		else
			--pos_x = pos_x + memory.read_s16_be(base_addr+0x1e);
		end;
		--pos_y =pos_y - memory.read_s16_be(base_addr+0x1c);
		
		--draw_cross(pos_x+off_x, pos_y-off_y, "green");
		--draw_cross(pos_x+off_x+hit_x, pos_y-off_y-hit_y, "red");
		gui.drawBox(pos_x - off_x-hit_x, pos_y+off_y+hit_y-cor_y, pos_x -off_x+ hit_x, pos_y - hit_y-cor_y+off_y, color);
	end

end

function draw_grabs(base_addr,color1,color2)
	
	mycolor = color1;
	grabs = true;
	anim = memory.read_s16_be(base_addr+0x16);
	
	if(anim>=0x18) then
		if(anim<=0x30) then
			mycolor = color2;
		elseif(anim == 0x80 or anim == 0x84) then
			grabs = true;
			gui.drawText(2+(base_addr-0x200)/1.1,35,string.format("%d", memory.read_u8(base_addr+0x55)));
		else
			grabs = false;
		end;
	
	end;
	
	if(grabs==true) then
			
		pos_x = memory.read_s16_be(base_addr+0x3A) - 0x80;
		pos_y = memory.read_s16_be(base_addr+0x36)-0x80;
		
		
		if(pos_y>0x0C0) then
			pos_y = 0xC0;
		end;
		
		direction = memory.read_u8(base_addr+0x4D);
		
		--cor_y = memory.read_s16_be(base_addr+0xAC);
		
		hit_x = 0x10;
		hit_y = 0x20;
		
		off_y = 0x10; -- Just for looks
		
		--if(direction ==1) then
			--off_x = 0-off_x;
			--hit_x = 0 - hit_x;
			--pos_x = pos_x - memory.read_s16_be(base_addr+0x1e);
		--else
			--pos_x = pos_x + memory.read_s16_be(base_addr+0x1e);
		--end;
		--pos_y =pos_y - memory.read_s16_be(base_addr+0x1c);
		
		--draw_cross(pos_x+off_x, pos_y-off_y, "green");
		--draw_cross(pos_x+off_x+hit_x, pos_y-off_y-hit_y, "red");
		gui.drawBox(pos_x -hit_x, pos_y-off_y, pos_x + hit_x, pos_y - hit_y-off_y, mycolor);

	end;
end;

function hitboxes(base_addr)
	
	if(memory.read_s16_be(base_addr+0x24)~=0) then
		
		pos_x = memory.read_s16_be(base_addr+0x3A) - 0x80;
		pos_y = memory.read_s16_be(base_addr+0x36)-0x80;
		
		
		if(pos_y>0x0C0) then
			pos_y = 0xC0;
		end;
		
		direction = memory.read_u8(base_addr+0x4D);
		
		cor_y = memory.read_s16_be(base_addr+0xAC);
		
		off_x = memory.read_s16_be(base_addr+0x28);
		off_y = memory.read_s16_be(base_addr+0x26);
		
		hit_x = memory.read_s16_be(base_addr+0x2C);
		hit_y = memory.read_s16_be(base_addr+0x2A);
		
		if(direction ==1) then
			off_x = 0-off_x;
			hit_x = 0 - hit_x;
			--pos_x = pos_x - memory.read_s16_be(base_addr+0x1e);
		else
			--pos_x = pos_x + memory.read_s16_be(base_addr+0x1e);
		end;
		--pos_y =pos_y - memory.read_s16_be(base_addr+0x1c);
		
		--draw_cross(pos_x+off_x, pos_y-off_y, "green");
		--draw_cross(pos_x+off_x+hit_x, pos_y-off_y-hit_y, "red");
		--gui.drawBox(pos_x - off_x-hit_x, pos_y+off_y+hit_y-cor_y, pos_x -off_x+ hit_x, pos_y - hit_y-cor_y+off_y, color);
		
		gui.drawText(2,50,string.format("OFF: %d", 0-off_x));
		gui.drawText(2,65,string.format("HIT: %d", hit_x));
		gui.drawText(2,80,string.format("TOT: %d", hit_x-off_x));
	end

end

while true do
		
		--0x4 = hurtbox offset
		--0x5 = hitbox offset
		
		--RNG = mainmemory.read_u16_le(0x0000AA);
		--gui.drawText(0,23,string.format("RNG: %4X",RNG))
		--Coordinates
		
		cam_x = 0x80;
		cam_y = 0x80;
		
		pos_x =mainmemory.read_u16_be(0x00023a) - cam_x;
		pos_y =mainmemory.read_u16_be(0x000236) - cam_y;
		
		player1_HP = mainmemory.read_u16_be(0x00280);
		player2_HP = mainmemory.read_u16_be(0x00380);
		
		--anim_ID = mainmemory.read_u16_le(0x000280);
		direction = mainmemory.read_u8(0x0024c);
		draw_hitbox(0x200,"blue","purple");
		draw_hitbox2(0x200,"red");
		
		draw_hitbox(0x300,"blue","purple");
		draw_hitbox2(0x300,"red");
		
		draw_grabs(0x200,"green","lightgreen");
		draw_grabs(0x300,"green","lightgreen");
		
		gui.drawText(2,20,string.format("%d", player1_HP));
		gui.drawText(218,20,string.format("%d", player2_HP));

		--draw_cross(pos_x, pos_y, "white");
		hitboxes(0x200);
	
		
	emu.frameadvance()
end















