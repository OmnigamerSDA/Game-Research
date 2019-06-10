-- PARAMETERS

local END_OF_VBLANK = 0x82C3
local END_OF_GAME_LOOP = 0x8075
-- location in ROM space, e.g. $0082C3 = 0x2C3

-------------

local V_TOP = 1
local V_BOTTOM = 38
local H_LEFT = 22
local H_RIGHT = 62

local vv, vh = -20, -30
local gv, gh = -20, -30
local lag = 0
function get_vblank_scan()
	lag = lag + 1
	vh = math.floor(emu.getregister("H"))
	vv = emu.getregister("V")
end
--memory.registerexec("ROM",END_OF_VBLANK,get_vblank_scan) 
--event.onmemoryexecute
memory.usememorydomain("System Bus")

event.onmemoryexecute(get_vblank_scan,END_OF_VBLANK)--,nil,"CARTROM")--,NULL,"ROM") 
function get_game_scan()
	lag = 0
	gv = emu.getregister("V")
	gh = math.floor(emu.getregister("H"))
end
event.onmemoryexecute(get_game_scan,END_OF_GAME_LOOP)--,nil,"CARTROM")--,NULL,"ROM") 

client.SetGameExtraPadding(2*H_LEFT,2*V_TOP,2*H_RIGHT,2*V_BOTTOM)

while true do
	--gui.top_gap(2*V_TOP)
	--gui.left_gap(2*H_LEFT)
	--gui.right_gap(2*H_RIGHT)
	--gui.bottom_gap(2*V_BOTTOM)
	
	
	
	if lag ~= 0 then
		gui.drawRectangle(2*(0-H_LEFT),2*(0-V_TOP),2*340,2*263,0x6000FF00,0x6000FF00)
	else
		if gv < 0xE1 then
			gui.drawRectangle(2*(0-H_LEFT),2*(0xE1-V_TOP),2*340,2*38,0x6000FF00,0x6000FF00)
			gui.drawRectangle(2*(0-H_LEFT),2*(0-V_TOP),2*340,2*gv,0x6000FF00,0x6000FF00)
			gui.drawRectangle(2*(0-H_LEFT),2*(gv-V_TOP),2*(math.floor(gh/4)),2*1,0x6000FF00,0x6000FF00)
		else
			gui.drawRectangle(2*(0-H_LEFT),2*(0xE1-V_TOP),2*340,2*(gv-0xE1),0x6000FF00,0x6000FF00)
			gui.drawRectangle(2*(0-H_LEFT),2*(gv-V_TOP),2*(math.floor(gh/4)),2*1,0x6000FF00,0x6000FF00)
		end
	end
	
	if vv < 0xE1 then
		gui.drawRectangle(2*(0-H_LEFT),2*(0xE1-V_TOP),2*340,2*38,0x60FF0000,0x60FF0000)
		gui.drawRectangle(2*(0-H_LEFT),2*(0-V_TOP),2*340,2*vv,0x60FF0000,0x60FF0000)
		gui.drawRectangle(2*(0-H_LEFT),2*(vv-V_TOP),2*(math.floor(vh/4)),2*1,0x60FF0000,0x60FF0000)
	else
		gui.drawRectangle(2*(0-H_LEFT),2*(0xE1-V_TOP),2*340,2*(vv-0xE1),0x60FF0000,0x60FF0000)
		gui.drawRectangle(2*(0-H_LEFT),2*(vv-V_TOP),2*(math.floor(vh/4)),2*1,0x60FF0000,0x60FF0000)
	end
	
	gui.drawText(10,10,"lag: " .. lag)
	gui.drawText(10,30,"game: (" .. gv .. "," .. gh .. ")")
	gui.drawText(10,50,"vblank: (" .. vv .. "," .. vh .. ")")
	
	emu.frameadvance();
end
--gui.repaint()