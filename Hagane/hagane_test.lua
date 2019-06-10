-- Hagane Helper Script
-- Author: Omnigamer
-- 6/18/16

function draw_cross(x_pos,y_pos, color)
	gui.drawLine(x_pos-3,y_pos,x_pos+3,y_pos, color)
	gui.drawLine(x_pos,y_pos-3,x_pos,y_pos+3, color)
end

memory.usememorydomain("CARTROM")

while true do
		
		cam_x = mainmemory.read_u16_le(0x0007A8);
		cam_y = mainmemory.read_u16_le(0x0007AE);
		
		pos_x =mainmemory.read_u16_le(0x000910);
		pos_y =mainmemory.read_u16_le(0x000912);
		
		draw_cross(pos_x, pos_y, "white");
		
		gui.drawText(pos_x-10,pos_y+10,string.format("%d", cam_x-pos_x));
			
			--THIS HP ADDRESS IS ACCURATE FOR HAGANE
			--HP = mainmemory.read_u8(i+0x514)
			
			--gui.drawText(x_coord-10,y_coord-20,string.format("%X", i-0x112c));
			--gui.drawText(x_coord-10,y_coord+10,string.format("%d", HP));

	emu.frameadvance()
end