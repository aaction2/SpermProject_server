Sperm3000 - Server Side
=======================

The repository consists of the server side communication modules as well as the
Image Processing algorithms used to compute the specifications of a given sperm
sample video.

- The server-side communication is written in *Python* which receives a video of
the sample from the user. It first listens to a predefined Ip/port pair for
connections and after connection with the Java client receives a video. When it
is done it decodes the received file using base64 binary decoding, and places
the output mp4 file in a predefined directory (videos_in/ready/). It then
blocks for the imageProcessing algorithm to finish processing by continuously
checking for added files in another predefined directory (results_out/ready/).

- Due to its versatility and ease in writing boilerplate code, the initial
version of the image processing algorithm which is to run on the server is
coded in *MATLAB*. As with the Python server (after receiving the content) the MATLAB node blocks for modified content 
in the videos_in/ready/ directory (by running the watchDog_dir.m module). After
the video has been moved to the specified folder by the Python server, the
imageProcessing part calculates the sperm specifications both for the total
spermatozoa population of the sample and for its mobility. See the
countingSperms.m and multipleObjectTracking.m modules for their corresponding
implementations.

For more information on the project that the algorithm is used in or for
technical details on the processing algorithm visit the 
[project webpage](http://biotech-ntua.wikispaces.com/Project_20152016_Spermodiagram).
