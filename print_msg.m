function [] = print_msg(msg, type0msg)
% PRINT_MSG prints a message in a compact way. Used to print all messages
% in the same format

dashes = repmat('=', 1, 69);
if nargin == 1
    % nothing here yet.
elseif nargin == 2
    if strcmp(type0msg, 'res')
        msg = [sprintf('\n'), msg, sprintf('\n'), dashes];
    else
        msg = ['[', upper(type0msg), '] ', msg];
    end
end

fprintf('%s\n', msg)


end