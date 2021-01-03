input=imread('cat-halftone.png');

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
D0k = [45, 45, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30];              % cutoff freq.
tn = 6; tn = 2 * tn;  % two n, 2n

% Coordinates of each notch
uk = [213, -213, 259, 0, 258, -258, 45, -45, 213, -213, 213, -213, 303, -303, 167];
vk = [319, 319, 0, 386, 386, 386, 318, 318, 68, 68, 454, 454, 319, 319, 0];
len = size(uk, 2);

for u=1:PQ(1)
    for v=1:PQ(2)
        for i=1:len
            Dk = sqrt((u-p2-uk(i))^2 + (v-q2-vk(i))^2);  % Dk(u, v)
            Dnk = sqrt((u-p2+uk(i))^2 + (v-q2+vk(i))^2);  % D-k(u, v)
            Hk = 1 / (1+(D0k(i)/Dk)^tn);          % Hk(u, v)
            Hnk = 1 / (1+(D0k(i)/Dnk)^tn);          % H-k(u, v)
            Hnr = Hk*Hnk;                    % Highpass Filters
            F(u, v) = Hnr*F(u, v);
            %F(u, v) = 1*F(u, v);
        end
        
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