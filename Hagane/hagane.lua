-- Hagane Helper Script
-- Author: Omnigamer
-- 6/18/16

function draw_cross(x_pos,y_pos, color)
	gui.drawLine(x_pos-3,y_pos,x_pos+3,y_pos, color)
	gui.drawLine(x_pos,y_pos-3,x_pos,y_pos+3, color)
end

memory.usememorydomain("CARTROM")

while true do
		
		RNG = mainmemory.read_u16_le(0x0000AA);
		gui.drawText(0,23,string.format("RNG: %4X",RNG))
		--Coordinates
		cam_x = mainmemory.read_u16_le(0x0007A8);
		cam_y = mainmemory.read_u16_le(0x0007AE);
		
		pos_x =mainmemory.read_u16_le(0x000910);
		pos_y =mainmemory.read_u16_le(0x000912);
		
		draw_cross(pos_x, pos_y, "white");
		
		x_off = mainmemory.read_s16_le(0x00092C);
		y_off = mainmemory.read_s16_le(0x00092e);
		
		x_box = mainmemory.read_u8(0x000930);
		y_box = mainmemory.read_u8(0x000931);
		
		gui.drawRectangle(pos_x + x_off,pos_y+y_off,x_box,y_box,"white")
		
		for i = 0,0x20,1 do
		--gui.drawBox(x_coord + hitbox_x1,y_coord+hitbox_y1,x_coord+hitbox_x2, y_coord+ hitbox_y2,"white")
		ID = mainmemory.read_u16_le(0x1000+i*0x80);
		
		if(ID~=0x00)then
		
			off_x = mainmemory.read_u16_le(0x1000+ i*0x80+0x1a);
			pos_x = mainmemory.read_u16_le(0x1000+ i*0x80+0x10);
			x_box = mainmemory.read_u8(0x1000+ i*0x80+0x1e);
			
			off_y = mainmemory.read_u16_le(0x1000+ i*0x80+0x1c);
			pos_y = mainmemory.read_u16_le(0x1000+ i*0x80+0x12);
			y_box = mainmemory.read_u8(0x1000+ i*0x80+0x1f);
			
			--x1 = mainmemory.read_u16_le(i)-0x4000;
			
			x1 = off_x + pos_x;
			x2 = x1+x_box;
			y1 = off_y+pos_y;
			y2 = y1+y_box;
		
			--draw_cross(x1, y1, "red");
			--draw_cross(x2, y2, "green");
		
			--gui.drawText(x2-10,y2-50,string.format("X1: %X", x1));
			--gui.drawText(x2-10,y2-40,string.format("Y1: %X", y1));
			--gui.drawText(x2-10,y2-30,string.format("X2: %X", x2));
			--gui.drawText(x2-10,y2-20,string.format("Y2: %X", y2));
		
			--gui.drawText(pos_x,210,string.format("%d", i));
			gui.drawBox(x1,y1,x2, y2,"red");
end
		end
			
			--THIS HP ADDRESS IS ACCURATE FOR HAGANE
			--HP = mainmemory.read_u8(i+0x514)
			
			--gui.drawText(x_coord-10,y_coord-20,string.format("%X", i-0x112c));
			--gui.drawText(x_coord-10,y_coord+10,string.format("%d", HP));

	emu.frameadvance()
end