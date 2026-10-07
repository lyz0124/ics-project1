%% Binary stars and a planet: explicit simulation and plots for the screenshot cases
% Run this script in MATLAB R2016b or newer. No toolbox is required.
% Units: G = 1, total stellar mass = 1, binary semimajor axis = 1.
% The planet is a massless test particle. All stars rotate counterclockwise.
clear; close all; clc;
T = 2*pi;
planetSpeedFactor = 1;  % adjustable initial speed; no speed scan

% Folder where all output plots are saved.
outDir = fullfile('figures','v3');
if ~exist(outDir,'dir')
    mkdir(outDir);
end

% [m1, m2, maximum separation a, minimum separation b]
binaries = [0.5 0.5 1.0 1.0; ...   % equal-mass circular
            0.8 0.2 1.0 1.0; ...   % unequal-mass circular
            0.8 0.2 1.4 0.6];      % unequal-mass elliptical
names = {'Equal-mass circular', 'Unequal-mass circular', ...
         'Unequal-mass elliptical'};

%% 1. Plot the three binary orbits (without showing the planet)
figure('Name','Binary orbits','Color','w');
for k = 1:3
    [~, Y] = simulate(binaries(k,:), [6 0 0], [0 1/sqrt(6) 0], T);
    subplot(1,3,k);
    plot(Y(:,1),Y(:,2),'r', Y(:,4),Y(:,5),'b'); hold on;
    plot(0,0,'ko','MarkerFaceColor','k');
    axis equal; grid on; xlabel('x'); ylabel('y'); title(names{k});
    legend('Star 1','Star 2','Center of mass','Location','best');
end
savefig(gcf, fullfile(outDir,'binary_orbits.fig'));
saveas(gcf, fullfile(outDir,'binary_orbits.png'));

%% 2. Planar planet: 3 binaries x 2 directions x 3 distances
R = [2.5 4 6];
distanceNames = {'Close','Medium','Far'};
directionNames = {'Prograde','Retrograde'};
for k = 1:3
    figure('Name',names{k},'Color','w');
    for d = 1:2
        direction = 3 - 2*d;        % +1: same direction; -1: opposite
        for j = 1:3
            r0 = [R(j) 0 0];
            v0 = [0 direction*planetSpeedFactor/sqrt(R(j)) 0];
            [~, Y] = simulate(binaries(k,:), r0, v0, 20*T);
            subplot(2,3,(d-1)*3+j);
            plot(Y(:,1),Y(:,2),'r', Y(:,4),Y(:,5),'b', ...
                 Y(:,7),Y(:,8),'g');
            axis equal; grid on; xlabel('x'); ylabel('y');
            title([directionNames{d}, ' - ', distanceNames{j}]);
        end
    end
    fileStem = ['planar_' regexprep(lower(names{k}),'\W+','_')];
    savefig(gcf, fullfile(outDir,[fileStem '.fig']));
    saveas(gcf, fullfile(outDir,[fileStem '.png']));
end

%% 3. Spatial planet: elliptical binary only
% Equal masses make the z axis a symmetry axis for pure vertical motion.
binary3D = [0.5 0.5 1.4 0.6];
r0 = [0 0 0.3];
vz = 0.2; epsilon = 0.002;          % epsilon << vz
velocities = [0       0       vz; ...  % vertical
              epsilon 0       vz; ...  % small x component
              0       epsilon vz; ...  % small y component
              0.1     0.1     vz];     % general xyz velocity
labels = {'Vertical', 'Small x velocity', 'Small y velocity', ...
          'General xyz velocity'};
figure('Name','3D: elliptical binary','Color','w');
for k = 1:4
    [t, Y] = simulate(binary3D, r0, velocities(k,:), 2*T);
    subplot(2,2,k);
    plot3(Y(:,1),Y(:,2),Y(:,3),'r'); hold on;
    plot3(Y(:,4),Y(:,5),Y(:,6),'b');
    plot3(Y(:,7),Y(:,8),Y(:,9),'g');
    axis equal; grid on; view(3);
    xlabel('x'); ylabel('y'); zlabel('z'); title(labels{k});
    if k == 1, verticalTime = t; verticalZ = Y(:,9); end
end
savefig(gcf, fullfile(outDir,'spatial_elliptical_binary.fig'));
saveas(gcf, fullfile(outDir,'spatial_elliptical_binary.png'));

%% 4. Vertical oscillation from the pure-vertical case above
figure('Name','Vertical oscillation','Color','w');
plot(verticalTime/T, verticalZ, 'b', 'LineWidth',1.2);
grid on; xlabel('t / T'); ylabel('z');
title('Vertical oscillation: v(0) = (0, 0, 0.2)');
savefig(gcf, fullfile(outDir,'vertical_oscillation.fig'));
saveas(gcf, fullfile(outDir,'vertical_oscillation.png'));

%% Original numerical simulation: explicit time stepping
% Symplectic Euler: compute forces, update velocities, then positions.
% This function performs the integration itself; it does not call ode45.
function [t, Y] = simulate(binary, r0, v0, duration)
    G = 1;
    m1 = binary(1); m2 = binary(2);
    a = binary(3); b = binary(4); M = m1 + m2;

    % 1. Design the binary orbit from the screenshot's formulas.
    u = sqrt(2*G/(M*a*b*(a+b)));
    r1 = [-m2*a/M, 0, 0];
    r2 = [ m1*a/M, 0, 0];
    v1 = [0, -m2*b*u, 0];
    v2 = [0,  m1*b*u, 0];
    rp = r0; vp = v0;

    % 2. Set the time step and allocate trajectory storage.
    A = (a+b)/2;
    binaryPeriod = 2*pi*sqrt(A^3/(G*M));
    stepsPerPeriod = 2000;
    dt = binaryPeriod/stepsPerPeriod;
    nSteps = ceil(duration/dt);
    dt = duration/nSteps;
    t = (0:nSteps)'*dt;
    % Columns: r1, r2, rp, v1, v2, vp (x, y, z for each).
    Y = zeros(nSteps+1,18);
    Y(1,:) = [r1, r2, rp, v1, v2, vp];

    % 3. Original simulation loop: calculate gravity at every time step.
    for n = 1:nSteps
        d12 = r2-r1;
        d1p = r1-rp;
        d2p = r2-rp;

        % Prevent integration through a point-mass singularity.
        if min(norm(d1p),norm(d2p)) < 0.02
            t = t(1:n); Y = Y(1:n,:);
            return;
        end

        acceleration1 =  G*m2*d12/norm(d12)^3;
        acceleration2 = -G*m1*d12/norm(d12)^3;
        accelerationP = G*m1*d1p/norm(d1p)^3 ...
                      + G*m2*d2p/norm(d2p)^3;

        % 4. Update velocities using the current accelerations.
        v1 = v1 + acceleration1*dt;
        v2 = v2 + acceleration2*dt;
        vp = vp + accelerationP*dt;

        % 5. Update positions using the new velocities.
        r1 = r1 + v1*dt;
        r2 = r2 + v2*dt;
        rp = rp + vp*dt;

        % 6. Save all positions and velocities for plot / plot3.
        Y(n+1,:) = [r1, r2, rp, v1, v2, vp];
    end
end
