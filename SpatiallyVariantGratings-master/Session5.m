%% MESH & PLOT SVL LATTICE 

% INITIALIZE MATLAB 
clear; 
clc; 
close all; 

% OPEN FIGURE WINDOW 
figure('Color', 'w', 'Units', 'normalized', 'Outerposition', [0 0 1 1]); 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LOAD DATA FROM FILE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load('SVLATTICE2D.mat');
SVLS = 1-SVLS;

% RECALCULATE GRID
[Nx, Ny] = size(SVLS);
dx = dx2; 
dy = dy2; 
Sx = Nx*dx; 
Sy = Ny*dy; 
xa = [1:Nx]*dx; 
ya = [1:Ny]*dy; 



% SHOW LATTICE
subplot(131); 
hh = imagesc(xa, ya, SVLS'); 
h = get(hh, 'Parent'); 
set(h, 'YDir', 'normal'); 
colormap(jet); 
axis equal tight; 
title('BINARY LATTICE', 'FontSize', 14); 
drawnow; 



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% REDUCE RESOLUTION OF LATTICE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% LOWER RESOLUTION GRID

Nx2 = 100; 
Ny2 = round(Nx2*(Sy/Sx)); 

xa2 = linspace(xa(1), xa(Nx), Nx2); 
ya2 = linspace(ya(1), ya(Ny), Ny2); 

dx2 = xa2(2) - xa2(1); 
dy2 = ya2(2) - ya2(1);

% INTERPOLATE TO LOW RESOLUTION
SVL = svlblur(SVLS, [Nx, Ny]./[Nx2 Ny2]); 
SVL = interp2(ya,xa', SVL, ya2, xa2'); 


% SHOW REDUCED LATTICE
subplot(132); 
hh = imagesc(xa, ya, SVL'); 
h = get(hh, 'Parent'); 
set(h, 'YDir', 'normal'); 
colormap(jet); 
axis equal tight; 
title('REDUCED BINARY LATTICE', 'FontSize', 14); 
drawnow; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% MESH REDUCE RESOLUTION OF LATTICE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% STACK SVL 
SVL          = rot90(fliplr(SVL)); 
SVL(:, :, 2) = SVL;


% GENERATE MESH USIING ISOCAPS

[F, V] = isocaps(xa2, ya2, [0, 1], SVL, 0.5, 'zmin'); 

% SHOW REDUCED LATTICE
subplot(133);
c =[ .5 .5 .8]; 
hh = patch('Faces', F, 'Vertices', V, 'FaceColor', c);  
h = get(hh, 'Parent'); 
set(h, 'YDir', 'normal');
colormap(jet); 
axis equal tight; 
title('MESH BINARY LATTICE', 'FontSize', 14); 
drawnow; 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SAVE LATTICE.STL FILE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
svlcad('svlattice2D.stl', F, V); 
