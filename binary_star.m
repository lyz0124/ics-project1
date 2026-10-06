G = 6.6743e-11; % m^3*kg^-1*s^-2

n = 3;
m = [1.0e30 1.0e30 0]; % kg
x = [-1.0e8 0 0; 1.0e8 0 0; 0 0 0]; % meters
u = 3e5; % m/s
v = [0 -u 0; 0 u 0; 0 0 0.3*u];

clockmax = 1e7;
t = 3e7; % seconds (3e7 = an earth year)
dt = t/clockmax;


plot3(0,0,0);
hold on;
axis equal;
border = 3e8;
axis([-border,border,-border,border,-border,border]);
axis manual;
view(2);
grid on;

h1 = plot3(0,0,0, 'ro'); % handle for m1
h2 = plot3(0,0,0, 'bo'); % handle for m2
hp = plot3(0,0,0, 'go'); % handle for m3 (planet)

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

    set(h1, 'XData', x(1,1), 'YData', x(1,2), 'ZData', x(1,3));
    set(h2, 'XData', x(2,1), 'YData', x(2,2), 'ZData', x(2,3));
    set(hp, 'XData', x(3,1), 'YData', x(2,2), 'ZData', x(3,3));
    drawnow;
end
