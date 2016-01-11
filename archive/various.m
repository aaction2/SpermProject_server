% archive code - various

%% Can be used when detecting bacteria.
% % detect the spermatozoa - findcircles
% lim_l = 5;
% lim_h = 20;
% [centers, radii] = imfindcircles(I_gray, [lim_l lim_h], ...
%                     'ObjectPolarity','dark', 'Sensitivity',0.8);
% h = viscircles(centers, radii);