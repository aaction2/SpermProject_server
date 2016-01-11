function chunks_out = split_image(img, nrows, ncols)
% SPLIT_IMAGE splits the image into nrows (vertical partitions) and ncols
% (horizontal partitions)
% can be used to deal with the removal of the background in non-uniform
% illumination situations

% nrows = 2;
% ncols = 2;

[xsize, ysize] = size(img);
xchunk = fix(xsize / nrows);
ychunk = fix(ysize / ncols);

x_range = 1:xchunk:xsize;
y_range = 1:ychunk:ysize;

% build the chunks w/ the subimages
chunks = cell(nrows, ncols);
for yi = 1:length(y_range) - 1
    for xi = 1:length(x_range) - 1    
        
        chunks{xi, yi} = img(x_range(xi):x_range(xi+1), ...
                                 y_range(yi):y_range(yi+1));
    end
    % for the last row
    chunks{end, yi} = img(x_range(end-1):x_range(end), ...
                          y_range(yi):y_range(yi+1));
end
% for the last column
for xi = 1:length(x_range) - 1
    chunks{xi, end} = img(x_range(xi):x_range(xi+1),...
                          y_range(end-1):y_range(end));
end
% for the last (SE) element
chunks{end, end} = img(x_range(end-1):x_range(end), ...
                       y_range(end-1):y_range(end));

chunks_out = chunks;