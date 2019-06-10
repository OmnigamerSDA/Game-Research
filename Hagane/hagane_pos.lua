XCAM = 0x7E0768;
YCAM = 0x7E076A;
XPOS = 0x7E0910;
YPOS = 0x7E0912;

textX = 20;
textY = 60;
textStep = 15;

--while true do --BizHawk
function on_paint() --lsnes
	--lsnes syntax
	xcam = memory.readword(XCAM);
	ycam = memory.readword(YCAM);
	xpos = memory.readword(XPOS);
	ypos = memory.readword(YPOS);
	
	--bizhawk syntax
	--xcam = mainmemory.read_u16_le(XCAM);
	--ycam = mainmemory.read_u16_le(YCAM);
	--xpos = mainmemory.read_u16_le(XPOS);
	--ypos = mainmemory.read_u16_le(YPOS);

	
	gui.text(textX, textY, string.format("X:  %d",xpos+xcam));
	gui.text(textX, textY+textStep, string.format("Y:  %d",ypos+ycam));
	--emu.frameadvance(); --BizHawk
end