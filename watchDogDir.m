function [changed, changes_in, changes_out] = watchDogDir(dirpath, timeout)
% WATCHDOG_DIR watches if the contents of a specific directory have changed by checking
% its contents. If it does it returns with code 1 as well as two lists of changes 
% with regards to the initial contents. User can also specify an optional
% timeout parameter for the maximum time to wait until the function returns
%
% nickkouk, 20150112

% input validation - set the loop condition based on weather there is a
% timeout
if nargin == 2
    maxTime = timeInSecs() + timeout;
    condition = @(x) maxTime - timeInSecs();
else
    condition = @(x) true;
end

fid = 1;
fprintf(fid, 'Waiting for change in directory: %s\n', dirpath);
waitBetweenChecks = 0.5;

initDirConts = dir(dirpath);
initDirLength = length(initDirConts);
initDirNames = {initDirConts.name};

% Use call to the condition function
% fun definition varies based on the arguement list
while condition() 
    curDirConts = (dir(dirpath));
    curDirLength = length(curDirConts);
    
    % check against the initial value
    if curDirLength ~= initDirLength
        changed = true;
        
        curDirNames = {curDirConts.name};
        
        % setdiff - returns the values in A that are not in B!
        changes_in = setdiff(curDirNames, initDirNames);
        changes_out = setdiff(initDirNames, curDirNames);
        
        return;
        
    end
   
    % wait before checking again..
    pause(waitBetweenChecks);
end

% if reached timeout has passed - return false.
changed = false;
changes_in = {};
changes_out = {};
return;

end