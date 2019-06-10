-- The Firemen Hitbox Viewer
-- Author: Omnigamer
-- 2/20/16

function draw_cross(x_pos,y_pos, color)
	gui.drawLine(x_pos-3,y_pos,x_pos+3,y_pos, color)
	gui.drawLine(x_pos,y_pos-3,x_pos,y_pos+3, color)
end

while true do


	hp = mainmemory.read_u8(0x001976)
	gui.drawText(35,30,string.format("%d",hp))

	emu.frameadvance()
end