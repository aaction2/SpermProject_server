function [calib,f]=data(times_obj)

if times_obj==10
    calib=0.461;
elseif times_obj==20
    calib=0.226;
elseif times_obj==40
    calib=0.161;
end
 %calib=micro/pixel
 
 f=15;    %frames/second
 