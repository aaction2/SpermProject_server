clear all
close all
clc

[mat_overall, tracks] = multiObjectTrackingExp();

trackposition=sortrows(mat_overall,1);
disp(trackposition);

%number of objects that have been detected
k=size(trackposition);
numObjects=trackposition(k(1), 1);

%velocity of objects in pixels/frame
trackvel=zeros(k(1),3);
for i=1:k(1)-1
    trackvel(i,1)=trackposition(i,1);
    if trackposition(i,1)==trackposition(i+1,1)
        trackvel(i,2)=(trackposition(i+1,3)-trackposition(i,3))/(trackposition(i+1,2)-trackposition(i,2));
        trackvel(i,3)=(trackposition(i+1,4)-trackposition(i,4))/(trackposition(i+1,2)-trackposition(i,2));
    end
end

%data based on video and magnification
% [!] user-set video-variables
% build the video name
times_obj = 40; % options: 10, 20, 40
try_num = '1st'; % options: 1, 2
encoding = '.mp4';

[calib,f]=data(times_obj);

%velocity in micrometers/second
mtrackvel=zeros(k(1),4);
for i=1:k(1)
    mtrackvel(i,1)=trackvel(i,1);
    mtrackvel(i,2)=trackvel(i,2)*calib*f;
    mtrackvel(i,3)=trackvel(i,3)*calib*f;
    mtrackvel(i,4)=(mtrackvel(i,2)^2+mtrackvel(i,3)^2)^(1/2);
end

meanvelocity=zeros(numObjects,1);

j=1;
categoryA=0;    %>=25micrometer/second
categoryB=0;    %5-24micrometer/second
categoryC=0;    %<micrometer/second
for i=1:numObjects
    n=0;
    if j<=k(1) && mtrackvel(j,1)==0
        j=j+1;
    end
    while j<=k(1) && mtrackvel(j,1)==i 
        meanvelocity(i,1)=meanvelocity(i,1)+mtrackvel(j,4);
        j=j+1;
        n=n+1;
    end
    if n>=4                                         %necessery number of frames for calculations 
        meanvelocity(i)=meanvelocity(i)/(n-1);
        if meanvelocity(i)>=25
            categoryA=categoryA+1;
        elseif meanvelocity(i)<5
            categoryC=categoryC+1;
        else
            categoryB=categoryB+1;
        end
    else
        meanvelocity(i)=10000000;
    end
end

meanvelocity(meanvelocity(:)==10000000)=[];     %substract the objects whick appear for few frames
actualcountableobjects=size(meanvelocity);

%% Just for the research!!

%diagrams

object=1;       %for object 1
if object<=numObjects
    objectplot=zeros(k,3);
    i=1;
    j=1;
    while trackposition(i,1)<=object
        if trackposition(i,1)==object
            objectplot(j,1:2)=trackposition(i,3:4);
            objectplot(j,3)=(objectplot(j,1)^2+objectplot(j,2)^2)^(1/2);
            j=j+1;
        end
        i=i+1;
    end
end
object2=10;       %for object 1
if object2<=numObjects
    objectplot2=zeros(k,3);
    i=1;
    j=1;
    while trackposition(i,1)<=object2
        if trackposition(i,1)==object2
            objectplot2(j,1:2)=trackposition(i,3:4);
            objectplot2(j,3)=(objectplot2(j,1)^2+objectplot2(j,2)^2)^(1/2);
            j=j+1;
        end
        i=i+1;
    end
end  

plot(objectplot(:,1),objectplot(:,2),'*',objectplot2(:,1),objectplot2(:,2),'+')


