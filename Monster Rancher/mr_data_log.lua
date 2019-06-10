mycount = 0;
count2 = 0;
lifefile = io.open("life.txt","w");
powfile = io.open("pow.txt","w");
deffile = io.open("def.txt","w");
skifile = io.open("ski.txt","w");
spdfile = io.open("spd.txt","w");
intfile = io.open("int.txt","w");
gutsfile = io.open("guts.txt","w");
natfile = io.open("nat.txt","w");


function set_RNG(val)
	mainmemory.write_u16_le(0xEAFF0,val);
end
function set_RNG2(val)
	mainmemory.write_u16_le(0xEAFF2,val);
end

function check_cond()

	life = mainmemory.read_u16_le(0xE7F9A);
	power = mainmemory.read_u16_le(0xE7F9E);
	def = mainmemory.read_u16_le(0xE7FA0);
	ski = mainmemory.read_u16_le(0xE7FA2);
	spd = mainmemory.read_u16_le(0xE7FA6);
	int = mainmemory.read_u16_le(0xE7FA8);
	guts = mainmemory.read_u16_le(0xE7FA4);
	nat = mainmemory.read_u16_le(0xB88A7);
	gui.drawText(30,45,string.format("COUNT:   %d",power));
	io.output(lifefile);
	io.write(string.format("%d,",life));
	io.output(powfile);
	io.write(string.format("%d,",power));
	io.output(deffile);
	io.write(string.format("%d,",def));
	io.output(skifile);
	io.write(string.format("%d,",ski));
	io.output(spdfile);
	io.write(string.format("%d,",spd));
	io.output(intfile);
	io.write(string.format("%d,",int));
	 io.output(gutsfile);
	 io.write(string.format("%d,",guts));
	 io.output(natfile);
	 io.write(string.format("%d,",nat));
	
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
	
	for j=0,11 do
		
		for i=0,11 do
			--myrand = math.random(0,0xFFFF);
			set_RNG(j);
			set_RNG2(i);
			gui.drawText(30,30,string.format("ITER:    %d",i+j*11));
			--gui.drawText(30,45,string.format("COUNT:   %d",mycount));
			--gui.drawText(30,60,string.format("RATE:    %.2f%%",(mycount/i)*100));
			--gui.text(30,60,string.format("CNT2:  %d",count2));
			advance_frames(1);
			--emu.frameadvance();
			check_cond();
			savestate.load("test_state2");
			--final = i;
		
		end
		-- --myrand = math.random(0,0xFFFF);
		-- set_RNG(j);
		-- gui.drawText(30,30,string.format("ITER:    %d",j));
		-- --gui.drawText(30,45,string.format("COUNT:   %d",mycount));
		-- --gui.drawText(30,60,string.format("RATE:    %.2f%%",(mycount/i)*100));
		-- --gui.text(30,60,string.format("CNT2:  %d",count2));
		-- advance_frames(1);
		-- --emu.frameadvance();
		-- check_cond();
		-- savestate.load("test_state2");
		-- --final = i;
		
	end
	
	
	
	io.close(lifefile);
	io.close(powfile);
	io.close(deffile);
	io.close(skifile);
	io.close(spdfile);
	io.close(intfile);
	io.close(gutsfile);
	io.close(natfile);
	emu.limitframerate(true);
	
	--for i=0,0x100,1 do
	--gui.drawText(30,30,string.format("ITER:     %d",final));
	--gui.drawText(30,45,string.format("COUNT:    %d",mycount));
	--gui.drawText(30,60,string.format("RATE:     %.2f%%",(mycount/final)*100));
	--gui.text(30,60,string.format("CNT2:  %d",count2));
	--emu.frameadvance();
	--end
--end