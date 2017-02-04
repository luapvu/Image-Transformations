%Function to write an image and name the output
function [] = writeImg( input_img, filename ) %takes in an image, and specified name for output
matGrayImg = mat2gray(input_img);
grayUint8 = im2uint8(matGrayImg); %converts back to unsigned int8
imwrite(grayUint8, filename);
end

