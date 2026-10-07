function [m, x, v] = config(index)
%   m : 3 x 1  (kg)
%   x : 3 x 3  (m)
%   v : 3 x 3  (m/s)

switch index
    case 1
        m = [1.0e30 1.0e30 5e24]; % kg
        x = [-1.0e8 0 0; 1.0e8 0 0; 0 0 0]; % meters
        v = [0 -3e5 0; 0 3e5 0; 0.01*3e5 0 3e5]; % m/s

    case 2
        m = [1.0e30 1.0e30 0]; % kg
        x = [-1.0e8 0 0; 1.0e8 0 0; 0 0 0]; % meters
        v = [0 -3e5 0; 0 3e5 0; 0 0 3e5]; % m/s

    % case 3 % "gear"
    %     m = [1 1 1];
    %     x = [0.335476 -0.243208 0
    %          0.0100217 0.363104 0
    %          0.0309787 0.423035 0];
    %     v = [1.04784 0.817404 0
    %          -0.847201 -0.235749 0
    %          -0.200637 -0.581655 0];

    otherwise
        error('config: 未知的 index = %d', index);
end
end
