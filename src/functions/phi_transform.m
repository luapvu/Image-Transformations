function [ output_img ] = phi_transform( img, rotation , trans)
%Function Transforms an image by rotating it and translating it in an x, y
%direction

%gathering image properties
[x,y,z]=size(img);
newX = x;
newY = y;
%Max size of image when rotated can only be 2*hypot of a quadrant of an
%image
hypot = ((newX/2)^2 + (newY/2)^2)^.5;
maxLength = ceil(2*hypot);


%I have designed my algorithm such that when rotating the image, the FOV
%will stay the same. I will do this by working on an arr2 which is about
%the size of twice the hypotenous of a quadrant of my image. 

%arr holds a matrix of arrays. Each cell will contain the image's x,y
%component and image value between 0 and 1
arr = cell(newY, newX);
arr2 = zeros(maxLength, maxLength);


%Since my algorithm will rotate around the center of a larger matrix, I
%will need to make my workspace at least 4 times larger than the size of my
%image. I will then be working in sub quadrants therefore I need to make
%sure I have the matrix length a factor of 8
for i = 1:8
    r = rem(maxLength,8);

    if r == 0
        i = 8;
    else 
        maxLength = maxLength + i;
    end
    
end

%Since i'll be rotating around the center, I need the below scaling factors
%of my larger matrix
maxLengthEighth = maxLength/8;
maxLengthHalf = maxLength/2;
maxLengthsevenEights = maxLength*(7/8); 
maxLengthUpperThreeEights = maxLength*(3/8); 

%my x' and y'
xVar = maxLengthEighth;
yVar = maxLengthEighth;


%I will be rotating around the center of a larger MxN matrix. Normally in
%matlab we would rotate around (0,0) however i've chosen to shift the image
%to rotate around the center of the image and (0,0) will be mapped to a
%point of (1/4M, 1/4N) Every 45 degrees I need to shift the image by x and
%y accordingly so that the image rotates around the center
if rotation > 360
rotSize = floor(rotation/360);
rotation = rotation - 360*rotSize;
end


if rotation <= 45
    xVar = maxLengthEighth + floor((rotation)*(maxLengthUpperThreeEights/45));
    yVar = maxLengthEighth - floor(rotation*(46/45));
end

if rotation > 45

    xVar = maxLengthHalf + floor((rotation-45)*(maxLengthUpperThreeEights/45));
    yVar = floor((rotation-45)*(46/45));
end

if rotation > 90
    xVar = maxLengthsevenEights + floor((rotation-90)*(maxLengthEighth/45));
    yVar = maxLengthEighth + floor((rotation-90)*(maxLengthUpperThreeEights/45));

end

if rotation > 135
    xVar = maxLength - floor((rotation-135)*(maxLengthEighth/45));
    yVar = maxLengthHalf + floor((rotation-135)*(maxLengthUpperThreeEights/45));

end

if rotation > 180
    xVar = maxLengthsevenEights - floor((rotation-180)*(maxLengthUpperThreeEights/45));
    yVar = maxLengthsevenEights + floor((rotation-180)*(maxLengthEighth/45));

end

if rotation > 225
    xVar = maxLengthHalf - floor((rotation-225)*(maxLengthUpperThreeEights/45));
    yVar = maxLength - floor((rotation-225)*(maxLengthEighth/45));

end

if rotation > 270
    xVar = maxLengthEighth - floor((rotation-270)*(maxLengthEighth/45));
    yVar = maxLengthsevenEights - floor((rotation-270)*(maxLengthUpperThreeEights/45));

end

if rotation > 315
    xVar = floor((rotation-315)*(maxLengthEighth/45));
    yVar = maxLengthHalf - floor((rotation-315)*(maxLengthUpperThreeEights/45));

end


%Derrived from lecture and main.m which controls my rotation
    theta = rotation;
    ct = cos(theta*pi/180); st = sin(theta*pi/180); 

for i = 1:newX
    for j = 1:newY
            
    FX = (i*ct - j* st); 
    FY = (i*st + j*ct);
    %This is where I translate my image and grab the image values at the
    %interpolated point
        arr{i,j} = [FX + trans(1) + trans(1), FY + trans(2) + trans(2), bilinearInterpolation(i,j,img)];
    end
end

%There is something wrong with my algorithm, I don't get enough samples and
%did not have time to fix it. I don't sample all the x1,x2 in my arr2 such
%that it covers the size of arr. Therefore missing a few samples. I tried
%taking the ceil and floor of my output values
for k = 1:newX
    for l = 1:newY
        x1 = floor(arr{k,l}(1)+xVar);
        y1 = floor(arr{k,l}(2)+yVar); 
        arr2(x1,y1) = arr{l,k}(3); 
        
        x2 = ceil(arr{k,l}(1)+xVar);
        y2 = ceil(arr{k,l}(2)+yVar); 
        arr2(x2,y2) = arr{l,k}(3); 
    end


end


output_img = arr2;
end

