function [secs_out] = timeInSecs()
% TIMEINSECS returns the current time of the day in seconds.

% experimenting with time
timestr = datestr(now, 'HH:MM:SS');

% convert time to seconds
timestr_cell = strsplit(timestr, ':');

hours2s = str2double(timestr_cell{1}) * 60 * 60;
mins2s = str2double(timestr_cell{2}) * 60;
seconds = str2double(timestr_cell{3});

secs_out = hours2s + mins2s + seconds;

end