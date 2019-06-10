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
RNG_ADDR = 0x00052C;
COND_ADDR = 0x000046;

-- Control values; number of frames to advance and how many times to test
NUM_FRAMES = 1;
NUM_ITER = 1000;

-- Sets the RNG to val; assumes a 16-bit RNG
function set_RNG(val)
	mainmemory.write_u16_le(RNG_ADDR,val);
end

-- Function that checks whether the condition and reports whatever information
-- you are trying to track from it.
function check_cond()

	cond = mainmemory.read_u16_le(COND_ADDR);
	
	myVal = hex2dec(cond);
	
	
	-- Logs the min, max, and average damage.
	if(myVal> maxVal) then
		maxVal = myVal;
	elseif(myVal<minVal) then
		minVal = myVal;
	end
	
	mySum = mySum + myVal;
	
end

-- Function that converts a hex listing of a base 10 value (damage) back to base 10.
function hex2dec(val)
	
	nibble1 = bit.band(val,0x000F);
	nibble2 = bit.band(bit.rshift(val,4),0x000F);
	nibble3 = bit.band(bit.rshift(val,8),0x000F);
	nibble4 = bit.band(bit.rshift(val,12),0x000F);
	
	return nibble1+nibble2*10+nibble3*100+nibble4*1000;
	
end

-- Advances the set number of frames. May need to be done when the RNG value is used
-- but the testable action is some number of frames away. Defaults to 1.
function advance_frames(val)
	for i=0,val,1 do
		emu.frameadvance();
	end
end

-- Sets up the save states
savestate.save("test_state");
savestate.load("test_state");

emu.limitframerate(false);

-- Initialize some variables
mycount = 0;
maxVal = 0;
minVal = 999;
mySum = 0;
	
-- Main testing loop
for i=0,NUM_ITER,1 do
	-- Grab a random value to set the RNG to; adjust size as necessary
	myrand = math.random(0,0xFFFF);
	set_RNG(myrand);
	
	-- Report various things that you're looking for on-screen
	gui.drawText(30,30,string.format("ITER:   %d",i));
	gui.drawText(30,45,string.format("MAX:    %d",maxVal));
	gui.drawText(30,60,string.format("MIN:    %d",minVal))
	gui.drawText(30,75,string.format("AVG:    %.2f",(mySum/i)));
	
	
	advance_frames(NUM_FRAMES);
	check_cond();
	savestate.load("test_state");
	final = i;
end
	
emu.limitframerate(true);
	
-- After the processing is done, just leave the information on-screen
while true do
		gui.drawText(30,30,string.format("ITER:   %d",final));
		gui.drawText(30,45,string.format("MAX:    %d",maxVal));
		gui.drawText(30,60,string.format("MIN:    %d",minVal))
		gui.drawText(30,75,string.format("AVG:    %.2f",(mySum/final)));

	emu.frameadvance();
end
