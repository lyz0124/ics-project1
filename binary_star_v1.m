global G n mm mp xx;

G = 6.6743e-11; % m^3*kg^-1*s^-2
n = 3;

mm = 1e30; % Reference of mass, kg
mp = 1e24;
xx = 1e8; % Reference of distance, m

%% 2D Case
function generate_2d(ii, jj, kk)
    global G mm mp xx;
    name = string(ii) + string(jj) + string(kk);
    switch ii
        case 1 % circular orbit, equal mass
            m0 = mm;
            r = xx;
            v0 = sqrt(G*m0/4/r);
            alpha = sqrt(G*m0/(4*r^3));

            m = [m0 m0 mp];
            x = [r 0 0; -r 0 0; r 0 0];
            v = [0 v0 0; 0 -v0 0; 0 v0 0];
            T = 2*pi/alpha;
        case 2 % circular orbit, unequal mass
            mRatio = 1.5;
            m1 = mm * 2 * mRatio / (mRatio + 1);
            m2 = mm * 2 * 1 / (mRatio + 1);
            r1 = xx * 2 * 1 / (mRatio + 1);
            r2 = xx * 2 * mRatio / (mRatio + 1);
            v1 = sqrt(G*m2*r1)/(r1+r2);
            v2 = sqrt(G*m1*r2)/(r1+r2);
            alpha = sqrt(G*m2/r1)/(r1+r2);

            m = [m1 m2 mp];
            x = [r1 0 0; -r2 0 0; r1 0 0];
            v = [0 v1 0; 0 -v2 0; 0 v1 0];
            T = 2*pi/alpha;
        case 3 % elliptical orbit, unequal mass
            mRatio = 1.5;
            m1 = mm * 2 * mRatio / (mRatio + 1);
            m2 = mm * 2 * 1 / (mRatio + 1);
            abRatio = 2.5;
            a = xx * 2 * abRatio / (abRatio + 1);
            b = xx * 2 * 1 / (abRatio + 1);
            r1a = a * 2 * 1 / (mRatio + 1);
            r2a = a * 2 * mRatio / (mRatio + 1);
            v1a = sqrt(2*G)*m2*b/sqrt((m1+m2)*a*b*(a+b));
            v2a = sqrt(2*G)*m1*b/sqrt((m1+m2)*a*b*(a+b));

            m = [m1 m2 mp];
            x = [r1a 0 0; -r2a 0 0; r1a 0 0];
            v = [0 v1a 0; 0 -v2a 0; 0 v1a 0];
            T = 2* pi * sqrt((a+b)^3) / sqrt(2*G*(m1+m2)); 
            % Does not know what's wrong with the calculation of T, that it
            % does not run a whole cycle (period), so multiplying 2 at the beginning
    end

    switch jj
        case 1
        case 2
            v(3,:) = v(3,:) * (-1); % reverse direction
    end

    switch kk
        case 1
            x(3,:) = x(3,:) * 1.3;
        case 2
            x(3,:) = x(3,:) * 2;
        case 3
            x(3,:) = x(3,:) * 5;
    end

    binary_star(m, x, v, T, name, 2); % Finally call the function
end 

for ii = [1 2 3]
    for jj = [1 2] 
        for kk = [1 2 3]
            generate_2d(ii, jj, kk);
        end
    end
end


function binary_star(m, x, v, T, name, dim)
global G n xx; % function workspace is separate from the script's, so re-declare

clockmax = 5 * 1000;
dt = T/1000;

clf;              % clear the previous plot so each run starts fresh
plot3(0,0,0);
hold on;
axis equal;
border = 5*xx;
axis([-border,border,-border,border,-border,border]);
axis manual;
view(dim);
grid on;

h1 = plot3(0,0,0, 'ro'); % handle for m1
h2 = plot3(0,0,0, 'go'); % handle for m2
hp = plot3(0,0,0, 'bo'); % handle for m3 (planet)

h1t = plot3(0,0,0, 'r-'); % trail for m1
h2t = plot3(0,0,0, 'g-'); % trail for m2
hpt = plot3(0,0,0, 'b-', 'LineWidth', 1); % trail for m3 (planet)

tsave = zeros(clockmax,1); % time history
xsave = zeros(clockmax,n,3); % position history
vsave = zeros(clockmax,n,3); % position history

for clock = 1:clockmax
    % pause(0.5);
    for i=1:(n-1)
        for j=(i+1):n
            r = norm(x(i,:) - x(j,:));
            v(i,:) = v(i,:) + G*m(j)/r^3 *dt* (x(j,:) - x(i,:));
            v(j,:) = v(j,:) + G*m(i)/r^3 *dt* (x(i,:) - x(j,:));
        end
    end

    for i=1:n
        x(i,:) = x(i,:) + dt * v(i,:);
    end

    tsave(clock) = clock*dt; % record time
    xsave(clock,:,:) = x; % record positions
    vsave(clock,:,:) = v; % record positions

    set(h1, 'XData', x(1,1), 'YData', x(1,2), 'ZData', x(1,3));
    set(h2, 'XData', x(2,1), 'YData', x(2,2), 'ZData', x(2,3));
    set(hp, 'XData', x(3,1), 'YData', x(3,2), 'ZData', x(3,3));

    set(h1t, 'XData', xsave(1:clock,1,1), 'YData', xsave(1:clock,1,2), 'ZData', xsave(1:clock,1,3));
    set(h2t, 'XData', xsave(1:clock,2,1), 'YData', xsave(1:clock,2,2), 'ZData', xsave(1:clock,2,3));
    set(hpt, 'XData', xsave(1:clock,3,1), 'YData', xsave(1:clock,3,2), 'ZData', xsave(1:clock,3,3));
    % drawnow;
end

title(name);
saveas(gcf, "figures/v1/" + name + ".png");

end