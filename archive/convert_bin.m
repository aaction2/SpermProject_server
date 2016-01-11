function I_bin = convert_bin(I_gray, safety_pc)
% CONVERT_BIN converts the given picture to binary given the safety factor
% in percentage of the threshold value.

[hist_counts, hist_inds] = imhist(I_gray);
% find the intensity of the majority of pixels
[~, max_ind] = max(hist_counts);
bg_intensity = hist_inds(max_ind);


% binary image - 3
% using a color threshold
I_bin = I_gray > bg_intensity * (1 + safety_pc);
