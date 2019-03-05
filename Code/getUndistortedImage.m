function undistorted_J = getUndistortedImage(name,LUT)
    filename = strcat('..\Input\Oxford_dataset\stereo\centre\', name);
    I = imread(filename);
    J = demosaic(I,'gbrg');
    undistorted_J = UndistortImage(J, LUT);
end

