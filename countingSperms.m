%% Initialization actions
clear all;
close all
clc;

%% Folder actions
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

% where to write debugging/output
% fid = 1;
global fid
t = num2str(timeInSecs());
debugFilePath = ['.', filesep, 'results_out', filesep, 'pending', filesep];
debugFile = ['results_', t, '.txt'];
fid = fopen([debugFilePath, debugFile], 'w');

        
% FLAGS
% set them accordingly
fVideoPlayer = true; % write to output video files?
fVideoWriter = false; % play the videos?

% VIDEO VARIABLES

lpath2videos = ['LaboratorySession_20151221', filesep, 'videos', filesep];
gpath2videos = [gen_path, lpath2videos];

% not currently used options
times_obj_opts = [10, 20, 40];
try_num_opts = {'1st', '2nd'}; % 1st or 2nd try?

% add the whole video folder to the path
addpath(gpath2videos);

% [!] user-set video-variables
% build the video name
times_obj = 40; % options: 10, 20, 40
try_num = '1st'; % options: 1, 2
encoding = '.mp4';
% final path
video_name = [int2str(times_obj), 'x_', try_num, encoding];

%%% MAIN ACTIONS

%% Video Input - Output 

msg = sprintf('Inputted Video: \n\t%s', video_name); print_msg(msg);
videoReader = vision.VideoFileReader(video_name);

msg = sprintf('Creating the videoPlayers...'); print_msg(msg);
videoPlayer = vision.VideoPlayer;
fgPlayer = vision.VideoPlayer;

if fVideoWriter
    msg = sprintf('Creating the videoWriters...'); print_msg(msg);
    videoWriter = vision.VideoFileWriter('output_video.avi', ...
        'FrameRate', 15);
    fgWriter = vision.VideoFileWriter('output_fg.avi', ...
        'FrameRate', 15);
    
% compress the writers as well
videoWriter.VideoCompressor = 'MJPEG Compressor';
fgWriter.VideoCompressor = 'MJPEG Compressor';

end
%% Create Foreground Detector  (Background Subtraction)
frames4learning = 40;

msg = sprintf('Creating the ForegrdoundDetector object...'); print_msg(msg);
foregroundDetector = vision.ForegroundDetector('NumGaussians', 3, ...
                                    'AdaptLearningRate', true, ...
                                    'NumTrainingFrames', frames4learning);

%% Run on first n frames to learn background
msg = sprintf(['Learning the background using %d frames...\n', ...
               'Frames  Progress: 0/%d'], frames4learning, frames4learning); 
fprintf(msg);

% total frames counter 
totFrames = 0;
for i = 1:frames4learning
    videoFrame = step(videoReader);
    foreground = step(foregroundDetector,videoFrame);
    
    totFrames = totFrames + 1;
    
    % fancy textual progress bar.
    if i <= 10
        msg = sprintf('\b\b\b\b%d/%d', i, frames4learning);
    else
        msg = sprintf('\b\b\b\b\b%d/%d', i, frames4learning);
    end
    fprintf(msg);
end
fprintf('\n');
% display last played frame and foreground image
figure;
imshow(videoFrame);
title('Input Frame');
figure;
imshow(foreground);
title('Foreground');

%% Perform morphology to clean up foreground 
%  todo - render the morphological algorithm used.

msg = sprintf('Implementing morphological operation to clean up foreground');
print_msg(msg);

% determined using the ImageMorphology application
minBlobSize = 60;
connectivity = 4;
cleanForeground = bwareaopen(foreground, minBlobSize, connectivity);

figure(3);
% Display original foreground
subplot(1,2,1);imshow(foreground);title('Original Foreground');
% Display foreground after morphology
subplot(1,2,2);imshow(cleanForeground);title('Clean Foreground');

%% Create blob analysis object 
%Blob analysis object further filters the detected foreground by rejecting blobs which contain fewer
% than 150 pixels.
blobAnalysis = vision.BlobAnalysis('BoundingBoxOutputPort', true, ...
                                   'AreaOutputPort', false, ...
                                   'CentroidOutputPort', false, ...
                                   'MinimumBlobArea', minBlobSize, ...
                                   'MaximumCount', 1000);

%% Loop through video
numSperms_list = zeros(1000); % initialize list for increased comp. speed
frames2use = 10; % analyze frames2use frames in total
analFrames = 1; % analysisFrames counter initialization

msg = sprintf(['Counting sperms. This might take a few minutes...\n', ...
    'Frames Progress: 0/%d'], frames2use);
fprintf(msg);

while  ~isDone(videoReader) && analFrames < frames2use
    %Get the next frame
    videoFrame = step(videoReader);
    
    %Detect foreground pixels
    foreground = step(foregroundDetector,videoFrame);
    % Perform morphological filtering
    cleanForeground = bwareaopen(foreground, minBlobSize, connectivity);
    
    % Detect the connected components with the specified minimum area, and
    % compute their bounding boxes
    % todo - implement various step sizes (double/triple step)
    bbox = step(blobAnalysis, cleanForeground);
    
    % Draw bounding boxes around the detected cars
    result = insertShape(videoFrame, 'Rectangle', bbox, 'Color', 'green');
    % Display the number of cars found in the video frame
    numSperms = size(bbox, 1);
    
    result = insertText(result, [10 10], numSperms, 'BoxOpacity', 1, ...
        'FontSize', 14);
    
    % add to the list of numSperms
    numSperms_list(analFrames) = numSperms;
    
    if fVideoPlayer
        % Display output
        step(videoPlayer, result);
        step(fgPlayer,cleanForeground);
    end
    
    if fVideoWriter
        % write the rendered frame to the new video files
        step(videoWriter, result);
        step(fgWriter, cleanForeground);
    end
    
    % counters update
    totFrames = totFrames + 1;
    analFrames = analFrames + 1;
    
    % fancy textual progress bar.
    if analFrames <= 10
        msg = sprintf('\b\b\b\b%d/%d', analFrames, frames2use);
    else
        msg = sprintf('\b\b\b\b\b%d/%d', analFrames, frames2use);
    end
    fprintf(msg);
end
msg = sprintf('\nCounting completed successfully.'); print_msg(msg);


%% release video reader and writer
msg = sprintf('Releasing the Players/Readers.'); print_msg(msg);
release(videoReader);

if fVideoWriter
    release(videoWriter);
    release(fgWriter);
end

if fVideoPlayer
    release(videoPlayer);
    release(fgPlayer);
    delete(videoPlayer); % delete will cause the viewer to close
    delete(fgPlayer);
end

%% PostProcessing
% remove trailing zeros
numSperms_list = numSperms_list(numSperms_list>0);

meanSperms = round(mean(numSperms_list));
stdSperms = round(std(numSperms_list));

msg = sprintf(['Sperm analysis completed.\n', ...
    'Total number of sperms: %d +- %d'], meanSperms, stdSperms);
print_msg(msg, 'res');

% close the file descriptor
fclose(fid);
% move the file to the ready directory
dstPath = ['.', filesep, 'results_out', filesep, 'ready', filesep];
movefile([debugFilePath, debugFile], dstPath);