G = 10e-7;

m = [1 1];
x = [-1 0 0; 1 0 0];
v=sqrt(2*G*m(1)/2);
u = [0 -v 0; 0 v 0];
n = 2;

clockmax = 1000;
t = 10000;
dt = t/clockmax;


plot3(0,0,0);
hold on;
axis equal;
a = 10;
axis([-a,a,-a,a,-a,a]);
axis manual;
grid on;

ha = plot3(0,0,0, 'ro');
hb = plot3(0,0,0, 'bo');

for clock = 1:clockmax
    % pause(0.1);
    for i=1:(n-1)
        for j=(i+1):n
            r = norm(x(i,:) - x(j,:));
            u(i,:) = u(i,:) + G*m(j)/r^3 *dt* (x(j,:) - x(i,:));
            u(j,:) = u(j,:) + G*m(i)/r^3 *dt* (x(i,:) - x(j,:));
        end
    end

    for i=1:n
        x(i,:) = x(i,:) + dt * u(i,:);
    end

    set(ha, 'XData', x(1,1), 'YData', x(1,2), 'ZData', x(1,3));
    set(hb, 'XData', x(2,1), 'YData', x(2,2), 'ZData', x(2,3));
    drawnow;
end
