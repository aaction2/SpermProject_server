% 20151227, nickkouk
%

%% INITIALIZATION ACTIONS

clc;                % workspace
clearvars;          % variables
close all;          %figures
imtool close all;   

% CHANGE TO IMAGEANALYSIS FOLDER

% todo - test it on windows machines.
% decide which folder to go to, based on the machine
db2img_path = ['Dropbox', filesep, 'biomechanics_project', filesep, ...
    'Code', filesep, 'imageAnalysis', filesep];

% see https://www.mathworks.com/matlabcentral/newsreader/view_thread/149027
if ispc
    home = [getenv('HOMEDRIVE') getenv('HOMEPATH')];
else
    home = getenv('HOME');
end
gen_path = [home, filesep, db2img_path];
workspace_cd(gen_path)
        
        
% FLAGS

use_video = 0; % video / image flag.

% VIDEO VARIABLES

path2videos = ['LaboratorySession_20151221', filesep, 'videos', filesep];
% not currently used
times_obj_opts = [10, 20, 40];
try_num_opts = {'1st', '2nd'}; % 1st or 2nd try?

% [!] user-set video-variables
% build the video name
times_obj = 20; % options: 10, 20, 40
try_num = '2nd'; % options: 1, 2
encoding = '.mp4';
% final path
video_path = [path2videos, int2str(times_obj), 'x_', try_num, encoding];

% IMAGE VARIABLES

path2images = ['LaboratorySession_20151221', filesep, 'images', filesep];
image = '20x_sameillumination.png';
image_path = [path2images, image];

% background image
bg_image = '20x_background.png';
bg_image_path = [path2images, bg_image];

%%% MAIN ACTIONS

%% IMPORT IMAGE

if use_video == 1
    % VIDEO: parse a video frame
    msg = sprintf('Opening video: %s', video_path); print_msg(msg)
    video = VideoReader(video_path);
    frameindex = 5;
    I = read(video, frameindex);
elseif use_video == 0 % use image
    msg = sprintf('Opening image: %s', image_path); print_msg(msg)
    I = imread(image_path);
else
    msg = sprintf('Unknown option for reading in the data.'); print_msg(msg, 'err');
end

%% INITIAL SETUP

% original image - 1
orig_fig = figure();
hold on; title('Initial I.');
imshow(I)

% % removal of background
% I_back = imread(bg_image_path);
% I_wobg = imsubtract(I, I_back);
% wobg_fig = figure();
% hold on; title('Image wo background');
% imshow(I_wobg);

% grayscale image - 2
I_gray = rgb2gray(I);
gray_fig = figure()
hold on; title('Grayscale I.');
imshow(I_gray)

% inverted grayscale image - 3
% find the complementary of the image
% search for the "white spermos"
I_gray2 = 254 - I_gray;
grayinv_fig = figure();
hold on; title('Grayscale Inv. I.');
imshow(I_gray2);

% histogram of image gray2 - 4
% hist_fig = figure();
% title('Histogram - Inverted Gray');
% hold on;


%% PRE-PROCESSING
% reach the image to a point that its processing is applicable

% todo - split the image into subimages
% use mat2cell


safety_pc = 0.4;
% 
% % CONVERT I_GRAY TO I_BIN
% I_bin = convert_bin(I_gray, 0.2);
% figure(4)
% hold on; title('Binary I.');
% imshow(I_bin)

% CONVERT I_GRAY2 TO I_BIN2
I_bin2 = convert_bin(I_gray2, safety_pc);

%% PROCESSING

% fill the holes inside the spermos
I_bin2 = imfill(I_bin2, 'holes');

bin2_fig = figure();
hold on; title('Binary Inv. I.');
imshow(I_bin2)

% FILTER NON-SPERMOS OUT

% remove small objects - not considered as main spermo bodies.
% detailed procedure - bwarea NOT used

cc = bwconncomp(I_bin2);
cc_props = regionprops(cc,'all');

labelcc = labelmatrix(cc);

body_thres = 50;
area_filter = find([cc_props.Area] >= body_thres);
I_bin2 = ismember(labelcc, area_filter);

% % eccentricity filter doesn't work that much..
% ecc_filter = find([cc_props.Eccentricity] >= 0.10);
% I_bin2 = ismember(labelcc, ecc_filter);
% 
% % convert to rgb to visualize this.
% tmp = rgb2gray(label2rgb(I_bin2));
% I_bin2 = im2bw(tmp, graythresh(tmp));
% 
lbin2_fig = figure(); 
hold on; title('BW I Inv. - Small objects removed');
imshow(I_bin2);



%% POST-PROCESSING


%% EXITING ACTIONS


