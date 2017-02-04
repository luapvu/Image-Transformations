addpath(genpath('functions'));
addpath(genpath('../Images'));

crop = readImg('cropMugshot.jpg');
output1 = phi_transform(crop, 45, [0,0]);
output2 = phi_transform(crop, 90, [100,100]);
output3 = phi_transform(crop, 180, [-30,-30]);
writeImg(output1, 'output1.jpg');
writeImg(output2, 'output2.jpg');
writeImg(output3, 'output3.jpg');