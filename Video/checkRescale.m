function [scaledDwn, scaledUp] = checkRescale(H, dwn, up)
%{
this function just counts how many times a resize was necessary 
in TformSRT.  Definitely a way to do this in the other function without 
having to pretty much do everything twice but I'm not sure how to do so 
when the output is already an array and very important so yeah.
basically, you input what the values are already and itll add one to
whichever it applies to.  When called inside a loop it works fine
%}
R = H(1:2,1:2);
scaledDwn = dwn; scaledUp = up;
ang = mean([atan2(R(2),R(1)) atan2(-R(3),R(4))]);
% Compute scale from mean of two stable mean calculations
s = mean(R([1 4])/cos(ang));     
if (s>=1.001) %%%SCOTT CODE: Keep the scale from being pushed too far, helps to reduce error
    scaledDwn = scaledDwn + 1;
elseif (s<=0.999)
        scaledUp = scaledUp + 1;
end

end

