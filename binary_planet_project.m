clear all
close all

% SI units
G = 6.6743e-11;
Msun = 1.989e30;
AU = 1.496e11;

% Simulation length and time resolution
nperiods = 20;
steps_per_period = 2000;

% System A
m1A = 0.5*Msun;
m2A = 0.5*Msun;
rmaxA = 1.0*AU;
rminA = 1.0*AU;
abinA = (rmaxA + rminA)/2;

% System B
m1B = 0.8*Msun;
m2B = 0.2*Msun;
rmaxB = 1.0*AU;
rminB = 1.0*AU;
abinB = (rmaxB + rminB)/2;

% System C
m1C = 0.5*Msun;
m2C = 0.5*Msun;
rmaxC = 1.5*AU;
rminC = 0.5*AU;
abinC = (rmaxC + rminC)/2;

% Base simulation for System A
baseA = simulate_binary_planet(m1A,m2A,rmaxA,rminA, ...
    3*abinA,1.0,G,nperiods,steps_per_period);

% Figure 1: star paths and center of mass for System A
figure(1)
plot(baseA.x1/AU,baseA.y1/AU,'b','linewidth',1.2)
hold on
plot(baseA.x2/AU,baseA.y2/AU,'r','linewidth',1.2)
plot(baseA.xcm/AU,baseA.ycm/AU,'k--','linewidth',1.2)
plot(0,0,'ko','markerfacecolor','k')
axis equal
xlabel('x (AU)')
ylabel('y (AU)')
title('System A star trajectories')
legend('Star 1','Star 2','Center of mass','Origin','location','best')
grid on
print('figure1_systemA_star_trajectories.png','-dpng','-r150')

% Figure 2: binary energy for System A
figure(2)
plot(baseA.t/baseA.Tbin,baseA.Ebin,'b','linewidth',1.2)
xlabel('time / T_{bin}')
ylabel('binary energy (J)')
title('System A binary energy')
grid on
print('figure2_systemA_binary_energy.png','-dpng','-r150')

% Figure 3: speed-factor comparison for System A
speed_factors = [0.8 1.0 1.2];
figure(3)
hold on
for k = 1:length(speed_factors)
    sim = simulate_binary_planet(m1A,m2A,rmaxA,rminA, ...
        3*abinA,speed_factors(k),G,nperiods,steps_per_period);
    plot(sim.xp/AU,sim.yp/AU,'linewidth',1.0)
end
plot(0,0,'ko','markerfacecolor','k')
axis equal
xlabel('x (AU)')
ylabel('y (AU)')
title('System A planet paths: R_0 = 3a_{bin}')
legend('speed factor = 0.8','speed factor = 1.0', ...
    'speed factor = 1.2','Origin','location','best')
grid on
print('figure3_systemA_speed_factor_paths.png','-dpng','-r150')

% Figure 4: initial-distance comparison for System A
Rratios = [2.5 3 5];
figure(4)
hold on
for k = 1:length(Rratios)
    sim = simulate_binary_planet(m1A,m2A,rmaxA,rminA, ...
        Rratios(k)*abinA,1.0,G,nperiods,steps_per_period);
    plot(sim.xp/AU,sim.yp/AU,'linewidth',1.0)
end
plot(0,0,'ko','markerfacecolor','k')
axis equal
xlabel('x (AU)')
ylabel('y (AU)')
title('System A planet paths: speed factor = 1')
legend('R_0/a_{bin} = 2.5','R_0/a_{bin} = 3', ...
    'R_0/a_{bin} = 5','Origin','location','best')
grid on
print('figure4_systemA_initial_distance_paths.png','-dpng','-r150')

% Figure 5: compare System A and System B
baseB = simulate_binary_planet(m1B,m2B,rmaxB,rminB, ...
    3*abinB,1.0,G,nperiods,steps_per_period);
distanceA = sqrt((baseA.xp-baseA.xcm).^2 + (baseA.yp-baseA.ycm).^2);
distanceB = sqrt((baseB.xp-baseB.xcm).^2 + (baseB.yp-baseB.ycm).^2);
figure(5)
plot(baseA.t/baseA.Tbin,distanceA/AU,'b','linewidth',1.2)
hold on
plot(baseB.t/baseB.Tbin,distanceB/AU,'r','linewidth',1.2)
xlabel('time / T_{bin}')
ylabel('planet distance from center of mass (AU)')
title('Planet distance: System A and System B')
legend('System A','System B','location','best')
grid on
print('figure5_systemA_systemB_distance.png','-dpng','-r150')

% Figure 6: compare System A and System C
baseC = simulate_binary_planet(m1C,m2C,rmaxC,rminC, ...
    3*abinC,1.0,G,nperiods,steps_per_period);
distanceC = sqrt((baseC.xp-baseC.xcm).^2 + (baseC.yp-baseC.ycm).^2);
figure(6)
plot(baseA.t/baseA.Tbin,distanceA/AU,'b','linewidth',1.2)
hold on
plot(baseC.t/baseC.Tbin,distanceC/AU,'r','linewidth',1.2)
xlabel('time / T_{bin}')
ylabel('planet distance from center of mass (AU)')
title('Planet distance: System A and System C')
legend('System A','System C','location','best')
grid on
print('figure6_systemA_systemC_distance.png','-dpng','-r150')

% Finite-time parameter sweep
Rratios = [2 2.5 3 4 5];
speed_factors = [0.7 0.85 1.0 1.15 1.3];
m1list = [m1A m1B m1C];
m2list = [m2A m2B m2C];
rmaxlist = [rmaxA rmaxB rmaxC];
rminlist = [rminA rminB rminC];
classification = zeros(length(speed_factors),length(Rratios),3);

for system_number = 1:3
    abin = (rmaxlist(system_number) + rminlist(system_number))/2;
    for j = 1:length(speed_factors)
        for i = 1:length(Rratios)
            sim = simulate_binary_planet(m1list(system_number), ...
                m2list(system_number),rmaxlist(system_number), ...
                rminlist(system_number),Rratios(i)*abin, ...
                speed_factors(j),G,nperiods,steps_per_period);
            d1 = sqrt((sim.xp-sim.x1).^2 + (sim.yp-sim.y1).^2);
            d2 = sqrt((sim.xp-sim.x2).^2 + (sim.yp-sim.y2).^2);
            dcm = sqrt((sim.xp-sim.xcm).^2 + (sim.yp-sim.ycm).^2);

            if min([d1 d2]) < 0.05*abin
                classification(j,i,system_number) = 2;
            elseif max(dcm) > 10*abin
                classification(j,i,system_number) = 3;
            else
                classification(j,i,system_number) = 1;
            end
        end
    end
end

% Figure 7: finite-time classifications
figure(7)
colormap([0.3 0.7 0.3; 0.9 0.5 0.2; 0.8 0.2 0.2])
system_names = {'A','B','C'};
for system_number = 1:3
    subplot(1,3,system_number)
    imagesc(Rratios,speed_factors,classification(:,:,system_number))
    set(gca,'YDir','normal')
    caxis([0.5 3.5])
    xlabel('R_0 / a_{bin}')
    ylabel('speed factor')
    title(['System ' system_names{system_number}])
    h = colorbar;
    set(h,'YTick',[1 2 3], ...
        'YTickLabel',{'bounded','close','escape'})
end
print('figure7_finite_time_classification.png','-dpng','-r150')

% Simple checks for the System A binary motion
cm_error = max(sqrt(baseA.xcm.^2 + baseA.ycm.^2))/AU;
energy_change = max(abs((baseA.Ebin-baseA.Ebin(1))/baseA.Ebin(1)));
fprintf('System A maximum center of mass distance: %.3e AU\n',cm_error)
fprintf('System A maximum relative binary energy change: %.3e\n',energy_change)


function result = simulate_binary_planet(m1,m2,rmax,rmin,R0,speed_factor,G,nperiods,steps_per_period)
    abin = (rmax + rmin)/2;
    M = m1 + m2;
    Tbin = 2*pi*sqrt(abin^3/(G*M));
    nsteps = nperiods*steps_per_period;
    dt = Tbin/steps_per_period;

    % Stars begin at maximum separation with center of mass at the origin.
    Va = sqrt((rmin/rmax)*2*G*M/(rmax+rmin));
    x1 = -m2/M*rmax;
    y1 = 0;
    u1 = 0;
    v1 = -m2/M*Va;
    x2 = m1/M*rmax;
    y2 = 0;
    u2 = 0;
    v2 = m1/M*Va;

    % Planet initial condition
    xp = R0;
    yp = 0;
    up = 0;
    vc = sqrt(G*M/R0);
    vp = speed_factor*vc;

    % Arrays for positions and velocities
    t = zeros(1,nsteps+1);
    x1save = zeros(1,nsteps+1);
    y1save = zeros(1,nsteps+1);
    u1save = zeros(1,nsteps+1);
    v1save = zeros(1,nsteps+1);
    x2save = zeros(1,nsteps+1);
    y2save = zeros(1,nsteps+1);
    u2save = zeros(1,nsteps+1);
    v2save = zeros(1,nsteps+1);
    xpsave = zeros(1,nsteps+1);
    ypsave = zeros(1,nsteps+1);
    upsave = zeros(1,nsteps+1);
    vpsave = zeros(1,nsteps+1);
    xcmsave = zeros(1,nsteps+1);
    ycmsave = zeros(1,nsteps+1);
    Ebin = zeros(1,nsteps+1);

    x1save(1) = x1;
    y1save(1) = y1;
    u1save(1) = u1;
    v1save(1) = v1;
    x2save(1) = x2;
    y2save(1) = y2;
    u2save(1) = u2;
    v2save(1) = v2;
    xpsave(1) = xp;
    ypsave(1) = yp;
    upsave(1) = up;
    vpsave(1) = vp;
    xcmsave(1) = (m1*x1 + m2*x2)/M;
    ycmsave(1) = (m1*y1 + m2*y2)/M;
    r12 = sqrt((x2-x1)^2 + (y2-y1)^2);
    Ebin(1) = 0.5*m1*(u1^2+v1^2) + 0.5*m2*(u2^2+v2^2) ...
        - G*m1*m2/r12;

    for clock = 1:nsteps
        r12 = sqrt((x2-x1)^2 + (y2-y1)^2);
        a1x = G*m2*(x2-x1)/r12^3;
        a1y = G*m2*(y2-y1)/r12^3;
        a2x = G*m1*(x1-x2)/r12^3;
        a2y = G*m1*(y1-y2)/r12^3;

        r1p = sqrt((x1-xp)^2 + (y1-yp)^2);
        r2p = sqrt((x2-xp)^2 + (y2-yp)^2);
        apx = G*m1*(x1-xp)/r1p^3 + G*m2*(x2-xp)/r2p^3;
        apy = G*m1*(y1-yp)/r1p^3 + G*m2*(y2-yp)/r2p^3;

        % Symplectic Euler update
        u1 = u1 + a1x*dt;
        v1 = v1 + a1y*dt;
        u2 = u2 + a2x*dt;
        v2 = v2 + a2y*dt;
        up = up + apx*dt;
        vp = vp + apy*dt;
        x1 = x1 + u1*dt;
        y1 = y1 + v1*dt;
        x2 = x2 + u2*dt;
        y2 = y2 + v2*dt;
        xp = xp + up*dt;
        yp = yp + vp*dt;

        t(clock+1) = clock*dt;
        x1save(clock+1) = x1;
        y1save(clock+1) = y1;
        u1save(clock+1) = u1;
        v1save(clock+1) = v1;
        x2save(clock+1) = x2;
        y2save(clock+1) = y2;
        u2save(clock+1) = u2;
        v2save(clock+1) = v2;
        xpsave(clock+1) = xp;
        ypsave(clock+1) = yp;
        upsave(clock+1) = up;
        vpsave(clock+1) = vp;
        xcmsave(clock+1) = (m1*x1 + m2*x2)/M;
        ycmsave(clock+1) = (m1*y1 + m2*y2)/M;
        r12 = sqrt((x2-x1)^2 + (y2-y1)^2);
        Ebin(clock+1) = 0.5*m1*(u1^2+v1^2) + 0.5*m2*(u2^2+v2^2) ...
            - G*m1*m2/r12;
    end

    result.t = t;
    result.Tbin = Tbin;
    result.abin = abin;
    result.x1 = x1save;
    result.y1 = y1save;
    result.u1 = u1save;
    result.v1 = v1save;
    result.x2 = x2save;
    result.y2 = y2save;
    result.u2 = u2save;
    result.v2 = v2save;
    result.xp = xpsave;
    result.yp = ypsave;
    result.up = upsave;
    result.vp = vpsave;
    result.xcm = xcmsave;
    result.ycm = ycmsave;
    result.Ebin = Ebin;
end
