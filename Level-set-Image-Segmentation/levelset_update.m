function phi_out = levelset_update(phi_in, g, c, timestep)
phi_out = phi_in;

%
% ToDo
%

timestep = 0.6;

[dPhi_x, dPhi_y] = gra(phi_in);
dPhi = sqrt(dPhi_x.^2 + dPhi_y.^2 + 1.0e-8.^2);

%
dPhi_x = dPhi_x ./ dPhi;
dPhi_y = dPhi_y ./ dPhi;

[phix_x, temp] = gra(dPhi_x);
[temp, phiy_y] = gra(dPhi_y);

kappa = (phix_x + phiy_y);

% use second derivative
% temp = (dPhi_x + dPhi_y) ./ dPhi;
% 
% [a, b] = gra(temp);
% 
% kappa = (a + b);

%dPhi = .....; % mag(grad(phi))

%kappa = .......; % curvature

smoothness = g.*kappa.*dPhi;
expand = c*g.*dPhi;

phi_out = phi_out + timestep*(expand + smoothness);
end

function [grax, gray] = gra(input)
[rows,cols] = size(input);
grax = zeros(rows, cols);   % gradient of x
gray = zeros(rows, cols);   % gradient of y
temp = zeros(rows+2, cols+2);
temp(2:rows+1, 2:cols+1) = input;

% central diff
for i = 2:rows+1
    for j = 2:cols+1
        grax(i-1, j-1) = (temp(i, j+1) - temp(i, j-1)) / 2;
    end
end

for i = 2:rows+1
    for j = 2:cols+1
        gray(i-1, j-1) = (temp(i+1, j) - temp(i-1, j)) / 2;
    end
end

end