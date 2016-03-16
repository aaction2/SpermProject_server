% demo file
% 
% nickkouk, 20160113

% call the watchDogDir wait for changes from python, then run analysis
% using the default file

[changed, changes_in, changes_out] = watchDogDir('./videos_in/ready/');

if changed
    countingSperms
end