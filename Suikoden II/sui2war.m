function [] = sui2war(probs)

trials=100000;
success=0;

for i=1:trials
    myRand=rand(size(probs));
    
    if sum(probs>myRand)>=3
        success=success+1;
    end
end

disp(success/trials);