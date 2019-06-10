-- RNG Brute Force Script
-- Author: Omnigamer
-- Instructions:
-- 
-- Fill in the information below according to what you want to test.
-- At the very minimum, you need an address for the RNG and a condition that you want to check.
-- In an emulator, start the script 2 frames before the RNG is checked and the condition you're watching changes.
-- Adapt the condition and tracking according to what you are trying to find out.
-- You will also potentially need to change the RNG function to suit the target game.

-- Addresses
RNG_ADDR = 0x109960;

	
-- After the processing is done, just leave the information on-screen
while true do
	RNG = mainmemory.read_u16_le(RNG_ADDR);
	hours = mainmemory.read_u16_le(0x06AA52);
	minutes = mainmemory.read_u16_le(0x06AA54);
	seconds = mainmemory.read_u16_le(0x06AA56);
	frames = mainmemory.read_u16_le(0x10D704);
	
	steps = mainmemory.read_u16_le(0x2566E);

	gui.drawText(40,50,string.format("RNG:       %X   ",RNG),null,null,20);
	gui.drawText(40,30,string.format("IGT:    %d:%d:%d.%d ",hours,minutes,seconds,frames),null,null,20);
	gui.drawText(40,70,string.format("STP:       %d   ",steps),null,null,20);
	emu.frameadvance();
end
