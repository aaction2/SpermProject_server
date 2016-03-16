function workspace_cd(gen_path)
% WORKSPACE_CD changes the current MATLAB folder to the specified 
% Gives explanatory messages when the cd fails.


try 
    curpath = pwd;
    if ~strcmp(curpath, gen_path(1:end-1))
        msg = sprintf(['Changing to imageAnalysis folder:\n\t', ...
            '%s'], gen_path); print_msg(msg);        
        cd(gen_path);
    else 
        % path is the same. print cur folder.
        msg = sprintf('Current folder: \n\t%s', curpath); fprintf(msg);
    end
catch ME
    % if path is not found give appropriate message to user so that he can
    % change it by himslef.
    if (strcmp(ME.identifier, 'MATLAB:cd:NonExistentDirectory'))
        % change of folder not successful. Do it manually
        msg = sprintf(['change of folder failed.\n', ...
            'Please change manually to the imageAnalysis subfolder of the project repository']);
        fprintf(msg);
    else
        msg = sprintf('Unidentified error. Check the code.'); fprintf(msg);
    end
        
end