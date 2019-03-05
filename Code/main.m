clear
close all

srcFiles = dir('..\Input\Oxford_dataset\stereo\centre\*.png');  % the folder in which ur images exists

[fx, fy, cx, cy, G_camera_image, LUT] = ReadCameraModel('..\Input\Oxford_dataset\stereo\centre', '..\Input\Oxford_dataset\model');

% Calibration matrix of the camera
K = [fx, 0,  cx;
    0, fy, cy;
    0, 0,  1];

Ro=[1 0 0;0 1 0;0 0 1];
To = [0 0 0];
T_previous = [0;0;0];

figure, hold on

% The first 20 images are ignored due to bad lightings
for ii=20:3872
    undistorted_I1 = getUndistortedImage(srcFiles(ii).name, LUT);
    undistorted_I2 = getUndistortedImage(srcFiles(ii+1).name, LUT);
    
    % Feature extraction
    I1 = rgb2gray(undistorted_I1);
    points1 = detectSURFFeatures(I1);
    
    I2 = rgb2gray(undistorted_I2);
    points2 = detectSURFFeatures(I2);
    
    [f1,vpts1] = extractFeatures(I1,points1);
    [f2,vpts2] = extractFeatures(I2,points2);
    
    % Matching features between images
    indexPairs = matchFeatures(f1,f2) ;
    matchedPoints1 = vpts1(indexPairs(:,1));
    matchedPoints2 = vpts2(indexPairs(:,2));
    
    % Essential matrix Computation
    E = findEssentialMatrix(matchedPoints1, matchedPoints2, K);
    [R,T] = findTandR(E);
    
    % Cumilative Rotation calculation to find position of points
    Ro = R*Ro;
    To = To + T'*Ro;
    
    % Ploting the points
    plot([T_previous(1),To(1)], [T_previous(2),To(2)]);
    T_previous=To;
    drawnow
    disp(['Processing image:',int2str(ii)])
end
hold off