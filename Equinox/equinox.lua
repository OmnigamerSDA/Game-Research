-- Equinox Helper Script
-- Author: Omnigamer
-- 10/2/16


while true do

	x_pos = memory.readword(0x0010e0);
	y_pos = memory.readword(0x0010e6);
	z_pos = memory.readword(0x0010EA);
	
	gui.text(20,30, string.format("X: %X", x_pos));
	gui.text(20,40, string.format("Y: %X", y_pos));
	gui.text(20,50, string.format("Z: %X", z_pos));

	emu.frameadvance()
end