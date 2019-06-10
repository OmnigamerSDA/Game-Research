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
COND_ADDR = 0x145D71;--0x1BB43E; --0x1BB416;

-- Control values; number of frames to advance and how many times to test
NUM_FRAMES = 1;
NUM_ITER = 0x1000;

-- Sets the RNG to val; assumes a 16-bit RNG
function set_RNG(val)
	mainmemory.write_u16_le(RNG_ADDR,val);
end

function set_RNG2(val)
	mainmemory.write_u16_le(RNG_ADDR+2,val);
end

-- Function that checks whether the condition and reports whatever information
-- you are trying to track from it.
function check_cond()

	cond = mainmemory.read_u8(COND_ADDR);
	
	-- Adds a point when the condition happens
	if(cond ~= 0x00) then
		mycount = mycount+1;
	end;
	
end

-- Advances the set number of frames. May need to be done when the RNG value is used
-- but the testable action is some number of frames away. Defaults to 1.
function advance_frames(val)
	for i=0,val,1 do
		emu.frameadvance();
	end
end

-- Sets up the save states
savestate.save("test_state2");
savestate.load("test_state2");

emu.limitframerate(false);
	
-- Initialize some variables
mycount = 0;
	
-- Main testing loop
for i=0,NUM_ITER,1 do
	-- Grab a random value to set the RNG to; adjust size as necessary
	myrand = math.random(0,0x7FFF);
	set_RNG(myrand);
	--myrand = math.random(0,0xFFFF);
	--set_RNG2(myrand);
	
	-- Report various things that you're looking for on-screen
	gui.drawText(30,30,string.format("ITER:    %d",i));
	gui.drawText(30,45,string.format("COUNT:   %d",mycount));
	gui.drawText(30,60,string.format("RATE:    %.2f%%",(mycount/i)*100));
	
	
	advance_frames(1);
	check_cond();
	savestate.load("test_state2");
	final = i;
end
	
emu.limitframerate(true);
	
-- After the processing is done, just leave the information on-screen
while true do
	gui.drawText(30,30,string.format("ITER:     %d",final));
	gui.drawText(30,45,string.format("COUNT:    %d",mycount));
	gui.drawText(30,60,string.format("RATE:     %.2f%%",(mycount/final)*100));
	emu.frameadvance();
end
