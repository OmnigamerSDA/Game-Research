mycount = 0;
count2 = 0;

function set_RNG(val)
	mainmemory.write_u16_le(0x00052c,val);
end

function check_cond()
	--0x1BB51A Kiba in Kiba Battle
	--Knight 1 0x1BE14E
	--Archer 1 0x1BE0D6
	--Slot 2 HP 0x145c32
	--Enemy 1 HP 0x145CAE
	--6P boss 0x145e9e
	--Golem 0x195e9e
	--Encounters 0x1ffad7, 2 if encounter ready
	--Battle State 0x008680
	cond = mainmemory.read_u16_le(0x001332);
	
	if(cond ~= 0x208) then
		mycount = mycount+1;
	--elseif(cond == 2) then
		--count2 = count2+1; 1229545
	end;
	
end

function advance_frames(val)
	for i=0,val,1 do
		emu.frameadvance();
	end
end
--while true do

	savestate.save("test_state2");
	savestate.load("test_state2");
	emu.limitframerate(false);
	mycount = 0;
	count2 = 0;
	
	for i=0,0x2000,1 do
		myrand = math.random(0,0xFFFF);
		set_RNG(myrand);
		gui.drawText(30,30,string.format("ITER:    %d",i));
		gui.drawText(30,45,string.format("COUNT:   %d",mycount));
		gui.drawText(30,60,string.format("RATE:    %.2f%%",(mycount/i)*100));
		--gui.text(30,60,string.format("CNT2:  %d",count2));
		advance_frames(1);
		--emu.frameadvance();
		check_cond();
		savestate.load("test_state2");
		final = i;
	end
	
	emu.limitframerate(true);
	

	while true do
	gui.drawText(30,30,string.format("ITER:     %d",final));
	gui.drawText(30,45,string.format("COUNT:    %d",mycount));
	gui.drawText(30,60,string.format("RATE:     %.2f%%",(mycount/final)*100));
	--gui.text(30,60,string.format("CNT2:  %d",count2));
	emu.frameadvance();
	end
--end