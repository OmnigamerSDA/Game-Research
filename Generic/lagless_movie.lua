--Lagless Playback
filename = forms.openfile()
if( filename ~= nil) then
	file = io.open(filename,"rb");
end

console.writeline(filename);

myTable = {["P1 A"]= "False",["P1 B"]= "False",["P1 Down"]= "False",["P1 L"]= "False",["P1 Left"]= "False",["P1 R"]= "False",["P1 Right"]= "False",["P1 Select"]= "False",["P1 Start"]= "False",["P1 Up"]= "False",["P1 X"]= "False",["P1 Y"]= "False",["P2 A"]= "False",["P2 B"]= "False",["P2 Down"]= "False",["P2 L"]= "False",["P2 Left"]= "False",["P2 R"]= "False",["P2 Right"]= "False",["P2 Select"]= "False",["P2 Start"]= "False",["P2 Up"]= "False",["P2 X"]= "False",["P2 Y"]= "False",["Power"]= "True",["Reset"]= "False"}

count = 0;
input1 = 0;
input2 = 0;

local function grabInput()
	if(file ~= nil) then
			
		if(count==0) then
			input1 = string.byte(file:read(1),1);
			input2 = string.byte(file:read(1),1);
			
			if(input2 ~= nil) then
			
				if(bit.band(input1,0x10)==0)then
					myTable["P1 Up"] = "True";
				else
					myTable["P1 Up"] = "False";
				end;
				
				if(bit.band(input1,0x20)==0)then
					myTable["P1 Down"] = "True";
				else
					myTable["P1 Down"] = "False";
				end;
				
				if(bit.band(input1,0x40)==0)then
					myTable["P1 Left"] = "True";
				else
					myTable["P1 Left"] = "False";
				end;
				
				if(bit.band(input1,0x80)==0)then
					myTable["P1 Right"] = "True";
				else
					myTable["P1 Right"] = "False";
				end;
				
				if(bit.band(input2,0x01)==0)then
					myTable["P1 A"] = "True";
				else
					myTable["P1 A"] = "False";
				end;
				
				if(bit.band(input1,0x01)==0)then
					myTable["P1 B"] = "True";
				else
					myTable["P1 B"] = "False";
				end;
				
				if(bit.band(input1,0x02)==0)then
					myTable["P1 Y"] = "True";
				else
					myTable["P1 Y"] = "False";
				end;
				
				if(bit.band(input2,0x02)==0)then
					myTable["P1 X"] = "True";
				else
					myTable["P1 X"] = "False";
				end;
				
				if(bit.band(input2,0x04)==0)then
					myTable["P1 L"] = "True";
				else
					myTable["P1 L"] = "False";
				end;
				
				if(bit.band(input2,0x08)==0)then
					myTable["P1 R"] = "True";
				else
					myTable["P1 R"] = "False";
				end;
				
				if(bit.band(input1,0x08)==0)then
					myTable["P1 Start"] = "True";
				else
					myTable["P1 Start"] = "False";
				end;
				
				if(bit.band(input1,0x04)==0)then
					myTable["P1 Select"] = "True";
				else
					myTable["P1 Select"] = "False";
				end;
				
				if(bit.band(input2,0x80)==0)then
					file:close();
					file = nil;
				end;
			else
				console.writeline("Reached end of file");
				file:close();
				file = nil;
				
			end;
		end;
		count = count + 1;
		
		if(count >=32) then
			count = 0;
		end;
		--console.writeline(myTable);
		--console.writeline(count);
		
		joypad.set(myTable);
		
	end;
end




myTable = {["P1 A"]= "False",["P1 B"]= "False",["P1 Down"]= "False",["P1 L"]= "False",["P1 Left"]= "False",["P1 R"]= "False",["P1 Right"]= "False",["P1 Select"]= "False",["P1 Start"]= "False",["P1 Up"]= "False",["P1 X"]= "False",["P1 Y"]= "False",["P2 A"]= "False",["P2 B"]= "False",["P2 Down"]= "False",["P2 L"]= "False",["P2 Left"]= "False",["P2 R"]= "False",["P2 Right"]= "False",["P2 Select"]= "False",["P2 Start"]= "False",["P2 Up"]= "False",["P2 X"]= "False",["P2 Y"]= "False",["Power"]= "True",["Reset"]= "False"}

joypad.set(myTable);

emu.frameadvance()

myTable = {["P1 A"]= "False",["P1 B"]= "False",["P1 Down"]= "False",["P1 L"]= "False",["P1 Left"]= "False",["P1 R"]= "False",["P1 Right"]= "False",["P1 Select"]= "False",["P1 Start"]= "False",["P1 Up"]= "False",["P1 X"]= "False",["P1 Y"]= "False",["P2 A"]= "False",["P2 B"]= "False",["P2 Down"]= "False",["P2 L"]= "False",["P2 Left"]= "False",["P2 R"]= "False",["P2 Right"]= "False",["P2 Select"]= "False",["P2 Start"]= "False",["P2 Up"]= "False",["P2 X"]= "False",["P2 Y"]= "False",["Power"]= "False",["Reset"]= "False"}

event.oninputpoll(grabInput);


while true do
	emu.frameadvance()
end

