
clear items;
clear hexRNG;
iterations = 5000;
RNG = uint8(zeros(iterations+1,4));
%drop = 0;%uint8(zeros(iterations,2));
period = 0;
LUT = zeros(16, 16, 16, 16);

for i=1:iterations
      
    
    
    if(LUT(RNG(i,1)+1,RNG(i,2)+1,RNG(i,3)+1,RNG(i,4)+1)==0)
        LUT(RNG(i,1)+1,RNG(i,2)+1,RNG(i,3)+1,RNG(i,4)+1)=1;
    else
        %LUT = zeros(16, 16, 16, 16);
        period
        %RNG(i,:)
        %period=0;
        break;
    end;
    
    drop(i,:) = bitxor(uint8([RNG(i,2) RNG(i,3)]),uint8([15 15]));
    period=period+1;
    bosspattern(i) = bitand(drop(i,2),3);
    if(bitor(RNG(i,1:2),RNG(i,3:4))==[0 0])
        RNG(i+1,:) = uint8([1 0 1 0]);
        RNG(i+1,4) = drop(i,2) + RNG(i+1,4);
    else
        RNG(i+1,1) = RNG(i,3);
        RNG(i+1,2) = RNG(i,4);
        RNG(i+1,3) = RNG(i,3);
        RNG(i+1,4) = drop(i,2) + RNG(i,4);
    end;
    
    if(RNG(i+1,4)>15)
        RNG(i+1,3) = drop(i,1) + RNG(i+1,3)+1;
    else
        RNG(i+1,3) = drop(i,1) + RNG(i+1,3);
    end;
    RNG(i+1,:) = bitand(RNG(i+1,:),uint8([15 15 15 15]));
    
    itemval = bitor(bitshift(drop(i,1),4),drop(i,2));
    itemnum = drop_table(bitand(bitshift(itemval,-1),uint8(63))+1);
    if(itemnum==1)
        items{i} = '1up';
    elseif(itemnum==2)
        items{i} = 'Blue Flame';
    elseif(itemnum==3)
        items{i} = 'Red Flame';
    elseif(itemnum==4)
        items{i} = 'Kunai';
    elseif(itemnum==5)
        items{i} = 'Grenade';
    else
        items{i} = 'Bomb';
    end;
    
    hexRNG{i} = cat(1,dec2hex(RNG(i,:)));
end;

items = items';
hexRNG = hexRNG';