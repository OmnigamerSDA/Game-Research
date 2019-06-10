

table1 = 0x08D554;
table2 = 0x08D7CA;

file = io.open("robo_test2.txt","w");
io.output(file);

memory.usememorydomain("CARTROM");

for i = 0,0xD1 do
	drop1 = memory.read_u16_le(table1+i*3);
	index2 = memory.read_u8(table1+i*3+2);
	drop2 = memory.read_u16_le(table2+index2);
	drop3 = memory.read_u16_le(table2+index2+2);
	io.write(string.format("%X,%X,%X,%X\n",i,drop1,drop2,drop3));
end
io.close(file);