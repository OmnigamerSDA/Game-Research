--Metal Warrior - SNES - Memory Addresses 

function mech() 
   pilot_H = memory.read_u16_le(0x019FA) 
   pilot_V = memory.read_u16_le(0x019FC) 
   pilot_RightLeft = memory.read_s8(0x0061A) 
   pilot_UpDown = memory.read_s8(0x00618) 
   pilot_Damage = memory.read_u8(0x00DA2) 
   mech_Empty = memory.read_u8(0x00422) 

--all of the above addresses fails sometimes 
--depending where you left the Mech (dynamic?) 

   on_Mech = memory.read_u8(0x00124) 
   mech_H = memory.read_u16_le(0x0010C) 
   mech_V = memory.read_u16_le(0x0010E) 
   damage_Level = memory.read_u8(0x0014E) 
   mech_Damage = memory.read_u8(0x00150) 
   bullet_Counter = memory.read_u8(0x0001C) 
   time_Left = memory.read_u16_le(0x00194) 
   mech_RightLeft = memory.read_s8(0x0011A) 
   mech_UpDown = memory.read_s8(0x00118) 

   if on_Mech == 0 then 
gui.text(10,20,"Mech's Hor. Speed: "..mech_UpDown) 
gui.text(10,25,"Mech's Ver. Speed: "..mech_RightLeft) 
gui.text(10,55,"Secondary Weapons: "..time_Left) 
gui.text(10,30,"Mech's H Position: "..mech_H) 
gui.text(10,35,"Mech's V Position: "..mech_V) 
gui.text(10,50,"Mech's Damage lv"..damage_Level..": "..mech_Damage) 
   else 
gui.text(10,20,"Pilot's Hor Speed: "..pilot_UpDown) 
gui.text(10,25,"Pilot's Ver Speed: "..pilot_RightLeft) 
gui.text(10,30,"Pilot's H Position: "..pilot_H) 
gui.text(10,35,"Pilot's V Position: "..pilot_V) 
gui.text(10,50,"Pilot's Damage: "..pilot_Damage) 
gui.text(10,55,"Mech's Damage: "..mech_Empty) 
   end 
end 

function enemies() 
enemy_HP = { 
enemy1 = memory.read_s16_le(0x00822), 
enemy2 = memory.read_s16_le(0x00622), 
enemy3 = memory.read_s16_le(0x00522), 
enemy4 = memory.read_s16_le(0x00422), 
enemy5 = memory.read_s16_le(0x00722), 
} 
   for k,v in pairs(enemy_HP) do 
      if v > 0 then 
if k == "enemy1" then enh,env,enn = 10,60,"1st Spawned Enemy: "..v; end 
if k == "enemy2" then enh,env,enn = 10,65,"2nd Spawned Enemy: "..v; end 
if k == "enemy3" then enh,env,enn = 10,70,"3rd Spawned Enemy: "..v; end 
if k == "enemy4" then enh,env,enn = 10,75,"4th Spawned Enemy: "..v; end 
if k == "enemy5" then enh,env,enn = 10,80,"5th Spawned Enemy: "..v; end 
gui.text(enh, env, enn) 
      end 
   end 
end 

function camera() 
   width = client.screenwidth() / 256 
   height = client.screenheight() / 224 
   top_Bound = memory.read_u16_le(0x01E18) 
   bottom_Bound = memory.read_u16_le(0x01E28) 
   left_Bound = memory.read_u16_le(0x01E66) 
   right_Bound = memory.read_u16_le(0x01E26) 
gui.text(10,40,"Camera H Position: "..left_Bound) 
gui.text(10,45,"Camera V Position: "..top_Bound) 
end 

while true do 
   mech() 
   enemies() 
   camera() 
   emu.frameadvance() 
end