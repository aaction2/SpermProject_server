function [changed] = watchDogFile(filepath)
% WATCHDOG_FILE watches over if a specific file has changed by checking the
% its timestamp. If it does it returns with code 1.

fid = 1;
fprintf(fid, 'Waiting for change in file: %s\n', filepath);
waitBetweenChecks = 0.5;

fprops = dir(filepath);
lastChangedDate = fprops.datenum;

while true
    % http://www.mathworks.com/matlabcentral/answers/60358-how-to-read-the-timestamp-of-file
    fprops = dir(filepath);
    curDate = fprops.datenum;
    
    if curDate > lastChangedDate
        fprintf(fid, 'File changed! Continuing code execution\n');
        changed = 1;
        return;
    end
    pause(waitBetweenChecks)
end

end