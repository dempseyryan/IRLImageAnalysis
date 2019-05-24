function [H,s,ang,t,R] = IRL_TformToSRT(H)
%Convert a 3-by-3 affine transform to a scale-rotation-translation
%transform.
%  [H,S,ANG,T,R] = IRL_TformToSRT(H) returns the scale, rotation, and
%  translation parameters, and the reconstituted transform H.
%  Scale modification by Scott - based on cvexTformToSRT

% Extract rotation and translation submatrices
R = H(1:2,1:2);
t = H(3, 1:2);
% Compute theta from mean of stable arctangents
ang = mean([atan2(R(2),R(1)) atan2(-R(3),R(4))]);
% Compute scale from mean of two stable mean calculations
s = mean(R([1 4])/cos(ang))    ;     
if (s>=1.001) %%%SCOTT CODE: Keep the scale from being pushed too far, helps to reduce error
    s = 1.001
elseif (s<=0.999)
        s = 0.999
end
% Reconstitute transform
R = [cos(ang) -sin(ang); sin(ang) cos(ang)];
H = [[s*R; t], [0 0 1]'];

