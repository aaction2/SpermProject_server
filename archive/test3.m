% testing3 
% print the eccentriticy in the center of the objects

figure(6)
clf;
imshow(I_bin2)

fontsize =  10;
hold on;
for i=1:numel(cc_props)
    thecenter = cc_props(i).Centroid;
    str1 = num2str(cc_props(i).Eccentricity, 3);
    text(thecenter(1), thecenter(2), str1, 'fontsize', fontsize, ...
         'HorizontalAlignment', 'center', ...
         'Color', 'blue');
end