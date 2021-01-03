input=imread('racing-blur.png');


figure,imshow(input);
title('Input Image');

% Get size
dimX = size(input,1);
dimY = size(input,2);

% Convert pixel type to float
[f, revertclass] = tofloat(input);

% Determine good padding for Fourier transform
PQ = paddedsize(size(input));

% Fourier tranform of padded input image
F = fft2(f,PQ(1),PQ(2));
F = fftshift(F);
figure,imshow(log(1+abs((F))), []);

% -------------------------------------------------------------------------

%
% Creating Frequency filter and apply - High pass filter
%

%
% ToDo
p2 = floor(dimX);     % P/2
q2 = floor(dimY);     % Q/2
D0 = 200;              % cutoff freq.
tn = 2; tn = 2 * tn;  % two n, 2n
k = 50;               % boosting weight

for u=1:PQ(1)
    for v=1:PQ(2)
        D = sqrt((u-p2)^2 + (v-q2)^2);  % D(u, v)
        H = 1 / (1+(D/D0)^tn);          % H(u, v)
        Hhp = 1 - H;                    % Highpass Filters
        F(u, v) = (1+k*Hhp) * F(u, v);
        %F(u, v) = Hhp*F(u, v);
    end
end

%
G = F;

% -------------------------------------------------------------------------

% Inverse Fourier Transform
G = ifftshift(G);
g = ifft2(G);

% Revert back to input pixel type
g = revertclass(g);

% Crop the image to undo padding
g = g(1:dimX, 1:dimY);

figure,imshow(g, []);
title('Result Image');