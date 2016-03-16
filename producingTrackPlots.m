% nickkouk
% The following module plots selectively some tracks of the spermatozoa.
% It was used during the final presentation of the project.
%
% getting the graphs in a pretty fashion

% FLAGS
cleanup = false;
runSpermTracker = false;

% CLEANUP ACTIONS
if cleanup
    clear all;
    close all;
    clc;
end

if runSpermTracker
    % run spermTracker again.
    [mat_overall, tracks] = spermTracker();
end

% general vars for plotting
fontsize = 14;
fontsize_text = 12;
linewidth = 0.2;
markersize = 5;
colors_ar = {'g', 'r', 'b', 'c', 'k', 'y'};
mstyles_ar = {'--', '-.', ':', 'o-'};
style_ar = allcomb(mstyles_ar, colors_ar);
style_ar = strcat(style_ar(:, 1), style_ar(:, 2));


trackNum = 33; % which biscuit to show? ;)
condition = trackposition(:,1) == trackNum;
% filter out all but the trackNum sperms
specificTrack = trackposition(condition, :);

% plot every "every" points
every = 4;
fig_name = ['sperm_track', num2str(trackNum)]; % name to save the file

% graph related stuff
fig = figure(1);
hold on; grid off;

axis([xmin-dx, xmax + dx, ymin-dy, ymax+dy])

% add a spare column of 0s for the index
specificTrack = [specificTrack, zeros(length(specificTrack), 1)];
for row_i = 1:length(specificTrack)
    % fill the spare column
    specificTrack(row_i, 5) = row_i;
end
xs = specificTrack(:, 3);
ys = specificTrack(:, 4);
% filter all except the ones that are shown with text labels as well
condition = ~logical(mod(specificTrack(:, 5), every));
xs = xs(condition);
ys = ys(condition);
plot(xs, ys, style, 'linewidth', linewidth);

str_i = 1;
% for all the points that its centroid has passed
for row_i=1:length(specificTrack)
    if ~mod(row_i, every)
        row = specificTrack(row_i, :);
        p = row(3:4);
        
        % pick a color - watch out for the length of the cell array
        style_idx = mod(1, length(style_ar)); % todo change the 1.
        style = style_ar{style_idx};
        
%         plot(p1(1), p1(2), style, 'LineWidth', linewidth);
        text(double(p(1)), double(p(2)), num2str(str_i),...
            'fontsize', fontsize_text, ...
            'edgecolor', 'k', ...
            'margin', 1);
%         plot(double(p(1)), double(p(2)), style, 'markersize', markersize);
        str_i = str_i + 1;
        hold on;

    end
end


% render the graph
xlabel('X', 'FontSize', fontsize);
ylabel('Y', 'FontSize', fontsize);
title('Spermatozoa tracks','FontSize', fontsize+2);

% save the graphs
path_to_plots = ['..', filesep, '..', filesep, 'Presentation', filesep, ...
    'images', filesep, 'imageAnalysis', filesep];
fprintf('Saving the plots...\n\t %s\n', path_to_plots);
% .eps form (change it to .png if you want to.)
% print(gcf, '-depsc2',[path_to_plots, fig_name]);
print(gcf, '-dpng',[path_to_plots, fig_name]);
saveas(gcf, [path_to_plots, fig_name], 'fig');


