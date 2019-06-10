-- Hagane Helper Script
-- Author: Omnigamer
-- 6/18/16

myWhite = 0+65536*255+256*255+255;
myRed = 0+65536*255;
--myBlue = 0+65536*255+256*255+255;


function draw_cross(x_pos,y_pos, color)
	gui.crosshair(x_pos,y_pos,3,color);
end

function on_paint()
		
		RNG = memory.readword(0x7E00AA);
		gui.text(20,60,string.format("RNG: %4X",RNG))
		--Coordinates
		cam_x = memory.readword(0x7E07A8);
		cam_y = memory.readword(0x7E07AE);
		
		pos_x =memory.readword(0x7E0910);
		pos_y =memory.readword(0x7E0912);
		
		draw_cross(pos_x, pos_y, myWhite);
		
		x_off = memory.readsword(0x7E092C);
		y_off = memory.readsword(0x7E092e);
		
		x_box = memory.readbyte(0x7E0930);
		y_box = memory.readbyte(0x7E0931);
		
		gui.rectangle(pos_x + x_off,pos_y+y_off,x_box,y_box,1,myWhite)
		
		gui.text(20, 75, string.format("X:  %d",pos_x+cam_x));
		gui.text(20, 90, string.format("Y:  %d",pos_y+cam_y));
		
		for i = 0,0x20,1 do
		--gui.drawBox(x_coord + hitbox_x1,y_coord+hitbox_y1,x_coord+hitbox_x2, y_coord+ hitbox_y2,"white")
		ID = memory.readword(0x7E1000+i*0x80);
		
		if(ID~=0x00)then
		
			off_x = memory.readword(0x7E1000+ i*0x80+0x1a);
			pos_x = memory.readword(0x7E1000+ i*0x80+0x10);
			x_box = memory.readbyte(0x7E1000+ i*0x80+0x1e);
			
			off_y = memory.readword(0x7E1000+ i*0x80+0x1c);
			pos_y = memory.readword(0x7E1000+ i*0x80+0x12);
			y_box = memory.readbyte(0x7E1000+ i*0x80+0x1f);
			
			--x1 = memory.readword(i)-0x4000;
			
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
			gui.rectangle(x1,y1,x2-x1, y2-y1,1,myRed);
		end
		end
end