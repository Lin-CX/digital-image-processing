%
% Skeleton code for COSE490 Fall 2020 Assignment 3
%
% Won-Ki Jeong (wkjeong@korea.ac.kr)
%

clear all;
close all;

%
% Loading input image
%
Img=imread('coins-small.bmp');
Img=double(Img(:,:,1));

%
% Parameter setting
%
dt = 0.8;  % time step
c = 1.0;  % weight for expanding term
niter = 400;


%
% Initializing distance field phi
%
% Inner region : -1, Outer region : +1, Contour : 0
%
[numRows,numCols] = size(Img);
phi=ones(size(Img));
phi(10:numRows-10, 10:numCols-10)=-1;

%
% Compute g (edge indicator, computed only once)
%

% ToDO ------------------------
% Gaussian smoothing
sigma = 1.5;
Gweights = fspecial('gaussian', [3,3], sigma);
I = Img;
for i = 1: numRows
    for j = 1: numCols
        if i~=1 && j~=1 && i~=numRows && j~=numCols
            temp = Img(i-1:i+1, j-1:j+1);
            I(i, j)=sum(sum(temp .* Gweights));
        end
    end
end
p = 2.0;

% gradient of I
gra_x = zeros(numRows, numCols);   % gradient of x
gra_y = zeros(numRows, numCols);   % gradient of y
temp = zeros(numRows+2, numCols+2);
temp(2:numRows+1, 2:numCols+1) = I;
% central diff.
for i = 2:numRows+1
    for j = 2:numCols+1
        gra_x(i-1, j-1) = (temp(i, j+1) - temp(i, j-1)) / 2;
    end
end
for i = 2:numRows+1
    for j = 2:numCols+1
        gra_y(i-1, j-1) = (temp(i+1, j) - temp(i-1, j)) / 2;
    end
end
gradient_I = sqrt(gra_x.^2 + gra_y.^2);

g = 1 ./ (1+(gradient_I.^p));

% -----------------------------

%
% Level set iteration
%
for n=1:niter
    
    %
    % Level set update function
    %
    phi = levelset_update(phi, g, c, dt);    

    %
    % Display current level set once every k iterations
    %
    k = 10;
    if mod(n,k)==0
        figure(1);
        imagesc(Img,[0, 255]); axis off; axis equal; colormap(gray); hold on; contour(phi, [0,0], 'r');
        str=['Iteration : ', num2str(n)];
        title(str);
        
    end
end


%
% Output result
%
figure(1);
imagesc(Img,[0, 255]); axis off; axis equal; colormap(gray); hold on;  contour(phi, [0,0], 'r');
str=['Final level set after ', num2str(niter), ' iterations'];
title(str);

