% clear all
% clc
% close all

% Initial conditions
   y0 = 0.001;      % Initial value of y in m
   dy0 = 0;     % Initial value of dy/dt
   dc0=2000;    %initial value of c
   Y0 = [y0; dy0;dc0];
 
%    Y0 = [y0; dy0];
   % Time span
   tspan = [0 15];  % Integrate from time 0 to 10

   % % % % % % % 
   endpoints=600;
   % % % % % % % 
   
   % Parameters
    m = 135; %mass in 80 kg
    m = 95; %mass in 40 kg
    
%    k = 150*10^3; %stiffness in N/m
   
%   k=((5-2)*1000)/((30+20)*0.001); % for 3 bar
%   k=(((5+6)/2-(2+3.5)/2)*1000)/((30+20)*0.001); % for 4 bar
    k =63.75*1000;% for 4 bar
    
%  k =4.75*1000;


   syspar(1) = m; % mass in kg
   syspar(2) = k; % stiffness in N/m
   xi = 0.15; % damping ratio

   
syspar(3) = 2*m*sqrt(k/m); % damping coefficient value Ns/m here d_r=1,  5.8673e+03
%  syspar(3)= 25000;% we make it 0 to first find natural frequency=3

d_r=.8; %actually 2 damping coeffients in pr damper . although if only one wn ,but 2 d_r gives 2 res_peaks 
syspar(3) = d_r*2*m*sqrt(k/m);
% % as k increaesse wn increases, hence wr also decreses . i,e shift to left
load('seat_height_functions.mat');
load('air_spring_functions.mat');

%  syspar(3) will be now calculated based on stiffness_curves inside dynamics ;

nominal_pressure=4;% in bars for 80 kg
nominal_pressure=3;% in bars for 40 kg

% % % % % % % % % % % % % % % % % % % 
   
syspar(3) = 3438; % c1: compression, low velocity (Ns/m)
syspar(4) = 20372; % c2: compression, high velocity (Ns/m)
syspar(5) = 1337; % c3: extension, low velocity (Ns/m)
syspar(6) = 17475; % c4: extension, high velocity (Ns/m)
syspar(7) = 0.079; % v_bp: breakpoint velocity (m/s)

% % % % % % % % % % % % % % % % % % % % % 
  
   excpar(2) = 0.015;% excitation amplitude in m

    input_freq = [0.1:0.05:5];
%    amplification = zeros(size(input_freq));
        
%    for mm=1:1:length(input_freq)
%    
%        excpar(1) = input_freq(mm); % excitation frequency in Hz
%        % Solve the ODE system
%        [t, Y] = ode45(@(t,Y) sdoffun(t, Y, syspar,excpar,f_l_as, f_zeta, f_l_d, f_beta), tspan, Y0);
% 
%        num_of_tpoints = length(t);
% 
%    %return
%        
%        % Post processing of output variables
%        
%        absdisp = Y(:,1) + excpar(2)*sin(2*pi*excpar(1)*t); % absolute disp
%        absacc = -(2*pi*excpar(1))^2*absdisp; % not quite true for the transient phase
%     
%        %Input Acceleration
%        excit = (2*pi*excpar(1))^2*excpar(2);
%        input_acc = excit*sin(2*pi*excpar(1)*t);
%     
%        % figure;
%        % plot(t, absacc, 'b', t, input_acc, 'r-')
%        % xlabel('Time (s)')
% 
%     
%        amplification(mm) = max(abs(absacc(num_of_tpoints-100:end)))/max(abs(input_acc(num_of_tpoints-100:end)));
 
%    end
pool = gcp; % Get the current parallel pool
addAttachedFiles(pool, {'sdoffun.m', 'seat_height_functions.mat', 'air_spring_functions.mat'});
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
F_fun_local = F_interp_fun;
% % Parallel loop over frequencies
parfor mm = 1:length(input_freq)
    % Create a local copy of excpar to avoid classification issues
    excpar_local = excpar;
    excpar_local(1) = input_freq(mm); % excitation frequency in Hz


    options = odeset('RelTol', 1e-3, 'AbsTol', 1e-6); % Tighter tolerances
    % Solve the ODE system
    [t, Y] = ode45(@(t,Y) sdoffun(t, Y, syspar, excpar_local,f_l_as, f_zeta, f_l_d, f_beta,F_fun_local,nominal_pressure,f_lddh,f_lssh,f_aah), tspan, Y0,options);
 
    num_of_tpoints = length(t);
    endpoints = min(600, num_of_tpoints - 1); % Prevent negative indexing
 
    % Post processing of output variables
    absdisp = Y(:,1) + excpar_local(2)*sin(2*pi*excpar_local(1)*t); % absolute disp
    absacc = -(2*pi*excpar_local(1))^2*absdisp; % not quite true for the transient phase
     
    % Input Acceleration
    excit = (2*pi*excpar_local(1))^2*excpar_local(2);
    input_acc = excit*sin(2*pi*excpar_local(1)*t);
     
 
    % Compute amplification for steady-state response
    amplification(mm) = max(abs(absacc(num_of_tpoints-endpoints:end)))/max(abs(input_acc(num_of_tpoints-endpoints:end)));
end
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
figure;
plot(input_freq, amplification, '.', 'LineWidth', 2, 'Color', 'r');
xlabel('Input Frequency (Hz)');
ylabel('Amplification (a2/a1)');
legend('MRD');
%    hold on
   
% % delete(gcp('nocreate')); % Closes the current pool
% % parpool('local', 10); % Starts a pool with 10 workers
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 


% % Additional code to add displacement subplots for specific frequencies
% figure;
% freqs_to_plot = [0.4,.5, 0.6, 0.8,1, 1.2, 1.7, 2];
% freqs_to_plot = [ 1.2, 2];
% for mm = 1:length(freqs_to_plot)
%     excpar_local = excpar;
%     excpar_local(1) = freqs_to_plot(mm); % Set specific excitation frequency
%     
% %     Solve the ODE system with tightened ode45 settings
%     options = odeset('RelTol', 1e-6, 'AbsTol', 1e-8); % Tighter tolerances
%     [t, Y] = ode45(@(t,Y) sdoffun(t, Y, syspar, excpar_local, f_l_as, f_zeta, f_l_d, f_beta, F_fun_local, nominal_pressure,f_lddh,f_lssh,f_aah), tspan, Y0, options);
% % f_l_as(Y(:,1)*1000+90) % SPRING LENGTH
% %     Create subplot
% %     subplot(4, 2, mm); % 4 rows, 2 columns for 8 subplots
% %     plot(t,Y(:,1)*1000+ (excpar_local(2)*sin(2*pi*excpar_local(1)*t))*1000 , 'b-', 'LineWidth', 1.5); % Plot displacement (y1) vs. time
% %     xlabel('Time (s)');
% %     ylabel('SEAT_ABSOLUTE_Displacement (m)');
% %     title(['SEAT_Displacement at ', num2str(freqs_to_plot(mm)), ' Hz']);
% %     grid on;
% for i=1:length(Y(:,1))  
%      c1 = syspar(3); % Compression, low velocity
%      c2 = syspar(4); % Compression, high velocity
%      c3 = syspar(5); % Extension, low velocity
%      c4 = syspar(6); % Extension, high velocity
%      v_bp=syspar(7); 
%     
%      v_d=.2669*1000*Y(i,2);
%      
%     if v_d < 0 % velocity Compression
%          if abs(v_d) < v_bp % Low velocity
%              c = c1;
%          else % High velocity
%              c = c2;
%          end
%      else                   %  velocity  Extension (vd >= 0)
%          if abs(v_d )< v_bp % Low velocity
%              c = c3;
%          else % High velocity
%              c = c4;
%          end
%          
%     end 
%     prdamper_force(i)=c*v_d; 
%   
% % end
%       subplot(1, 2, mm); % 4 rows, 2 columns for 8 subplots
%     plot(Y(:,2)*1000, prdamper_force*.001 , 'b-', 'LineWidth', 1.5); % Plot displacement (y1) vs. time
%     xlabel('rel VEL (mm/s)');
%     ylabel('prdamper force(kN)');
 
% end
    
    
%     c=50000;    
%      st_hight =Y(i,1) * 1000 + 90;     
%      v_s=f_lssh(st_hight)*Y(i,2);     
%      c_force= v_s*c;
%                      
% nom_curve_deflcn=0;  % assuming centre at 76.6
% nom_s_force=F_interp_fun{nominal_pressure}(nom_curve_deflcn);
% s_force=F_interp_fun{nominal_pressure}(-(f_l_as(st_hight)-f_l_as(90)));
% eff_s_force=-(s_force-nom_s_force)*1000; % in newtons
% % k =63.75;% for 4 bar     
% % eff_s_force=  k *(f_l_as(st_hight)-f_l_as(90));% hey length here is in mm . so basically it 1000 times larger tahn the si uniits
% 
% spring_force(i)=(c_force+eff_s_force)/1000;% in kilo-newtons
% end


% for i=1:length(Y(:,1))
% 
%      c=50000;    
%      st_hight =Y(i,1) * 1000 + 90;     
%      v_s=f_lssh(st_hight)*Y(i,2);     
%      c_force= v_s*c;
%                      
% nom_curve_deflcn=0;  % assuming centre at 76.6
% nom_s_force=F_interp_fun{nominal_pressure}(nom_curve_deflcn);
% s_force=F_interp_fun{nominal_pressure}(-(f_l_as(st_hight)-f_l_as(90)));
% eff_s_force=-(s_force-nom_s_force)*1000; % in newtons
% % k =63.75;% for 4 bar     
% % eff_s_force=  k *(f_l_as(st_hight)-f_l_as(90));% hey length here is in mm . so basically it 1000 times larger tahn the si uniits
% 
% spring_force(i)=(c_force+eff_s_force)/1000;% in kilo-newtons
% end
% 
%     % Create subplot
%     subplot(4, 2, mm); % 4 rows, 2 columns for 8 subplots
%     plot(Y(:,1)*1000 ,spring_force ,'b-', 'LineWidth', 1.5); % Plot displacement (y1) vs. time
%     xlabel('SEAT_Displacement(mm)');
%     ylabel(' force (kilo_newton)');
%     title(['net spring force at ', num2str(freqs_to_plot(mm)), ' Hz']);
%     grid on
% 
% 
% end

 
% % Adjust layout to prevent overlap
% sgtitle('Displacement vs. Time for Different Input Frequencies', 'FontSize', 14); % Overall title for all subplots
 
% sgtitle(['Auxiliary spring damping = ', num2str(c)]);% Overall title for all subplots
 

% % Plot v_d history
% figure;
% plot(t_history, v_d_history, 'b.-');
% xlabel('Time (s)');
% ylabel('Damper Velocity (m/s)');
% title('Damper Velocity Over Time');
% grid on;

% 	2.555409844401535
% 0	3.0247709823912574
% 3.0247709823912574-2.555409844401535
% 
% ans =
% 
%     0.4694% for 3 bar
% 
% 	4.485007225444305
% 0	5.032595219765649
% 5.032595219765649-4.485007225444305
% 
% ans =
% 
%     0.5476 % for 5 bar
% % %so for 4 bar 
% % (0.4694+ 0.5476)/2
% % 
% % ans =
% % 
% %     0.5085  % for 4 bar at .4 hertz
