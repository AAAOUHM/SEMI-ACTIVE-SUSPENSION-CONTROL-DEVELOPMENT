% % seat_ht 1 to 181

for j=0:1:180
    i=j+1;
    upperchanel=34;
    lowerchanel=30;
    diameter=(lowerchanel+upperchanel)/2;%32
    diametersum=diameter+2;
    ht_offset=diametersum;
    
    seat_ht(i)=j+ht_offset;
%     x_base=x_base0-

scr_lower=184.5;
scr_upper=159;

scissor_arm=scr_lower+scr_upper;%343.5;

alpha(i)=atan(seat_ht(i)/sqrt(scissor_arm^2-seat_ht(i)^2));

roller_offset=25.8;


x_base1=roller_offset+[scissor_arm*cos(alpha(i))];
x_base2=2*scr_lower*cos(alpha(i)); %both should be equal ideally
%   xbase(i)=(x_base1+x_base2)/2;
 
%  xbase(i)=x_base1;
  xbase(i)=x_base2;
 

%find d_att_l= sqrt(160^2+152^2)
% ans =   220.6898
% % % % % % % % % % % % % % % % % % % %  
% damper geometry

  a=23;
  d_att_l= 222;
  d=7;
  d_offset_x=1;
  d_offset_z=6.93;
  theta_d=120.4*pi/180;

delta=asin(a/d_att_l);
d_att_alpha(i)=delta+alpha(i);
d_att_ht(i)=d_att_l*sin(d_att_alpha(i));
d_ht(i)=d_att_ht(i)+d_offset_z;
l_d(i)=sqrt((d_att_l*cos(d_att_alpha(i))-xbase(i)+d*cos(theta_d))^2+(d_att_l*sin(d_att_alpha(i))+d*sin(theta_d))^2);
beta(i)=asin(d_ht(i)/l_d(i))*180/pi;
% % % % % % % % % % % % % % % % % % % % % % % % % % % 
% spring geometry

% asp_bracketcenter_al_scissor=109.84;
% sqrt(121.5^2-109.8^2)
% 
% ans =
% 
%    52.0212
asp_bracketcenter_al_scissor=52;
% % as_arms
r1=115.5;
r1_perpto_sciss=40;
r2lower=108;
% r2upper=111.5;
% upperang=22.7*pi/8;
r2=r2lower;
 lowerang=-1.5*pi/180;
epsilon=asin(r1_perpto_sciss/r1) ;
gamma= lowerang;

phi(i)=alpha(i)+gamma+epsilon;%OK

l_as(i)=sqrt(r1^2+r2^2-2*r1*r2*cos(phi(i)));%OK

phi1(i)=acos((r1^2+l_as(i)^2-r2^2)/(2*r1*l_as(i)));%ok

phi2(i)=acos((r2^2+l_as(i)^2-r1^2)/(2*r2*l_as(i)));

as_axis_angle_horz(i)=phi2(i);

zeta(i)=as_axis_angle_horz(i)*180/pi+gamma*180/pi;

% % % % % % % % % % % % % % % % % % % % % % % % % % % 
% beta(i)=atan(d_ht(i)/sqrt(l_d(i)^2-d_ht(i)^2));
% fas=1; % air spring force
% fas_v=fas*cos(alpha);

% fd=2; %damper force
% fd_v=fd*sin(beta);
% % % % % % % % % % % % % % % % % 
% airspring
end

% % % % % % % % % % % % % % % % % % % % % 
 
kk=1:1:181;
% % % % %spring % % % % % % % % % % % % % % %  

subplot(121)
 
 plot(kk,l_as(kk), 'LineWidth', 2);title('spring length');
  xlabel('seat height(mm)');
 ylabel('spring length(mm)');
 hold on 
 plot(kk,47.88+(kk-1)/181*(107.4-47.88), 'LineWidth', 2);
 grid on;
  legend('actual','linear approxmn')
 subplot(122)
 plot(kk,zeta(kk), 'LineWidth', 2);title('spring angle');
  hold on 
  plot(kk,85.1+(kk-1)/181*(63.37-85.1), 'LineWidth', 2);
  xlabel('seat height(mm)');
  ylabel('spring angle with horizontal(degrees)');
   grid on;
    legend('actual','linear approxmn')

 % % % % % % % % % damper% % % % % % % % % % % % % % 
 
 figure;
 subplot(121)
 plot(kk,l_d(kk), 'LineWidth', 2);title('damper length');
  xlabel('seat height(mm)');
 ylabel('damper length(mm)');
 hold on 
 plot(kk,161.5+(kk-1)/181*(209.8-161.5), 'LineWidth', 2);
  grid on;
   legend('actual','linear approxmn')
 subplot(122)
 plot(kk,beta(kk), 'LineWidth', 2);title('damper angle');
 xlabel('seat height(mm)');
 ylabel('damper angle with horizontal(degrees)');
 hold on 
 plot(kk,18.66+(kk-1)/181*(50.76-18.66), 'LineWidth', 2);
 grid on;
  legend('actual','linear approxmn')
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %   
 figure 
%  subplot(121)

 plot(kk,alpha(kk)*180/pi, 'LineWidth', 2);title('scissor angle');
  xlabel('seat height(mm)');
 hold on 
 plot(kk,5.848+(kk-1)/181*(38.54-5.848), 'LineWidth', 2);
 legend('actual','linear approxmn')
 
 % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

% Additional appended

% Create continuous function handles using interpolation

seat_height = 0:180; % Seat height in mm corresponding to kk=1:181
f_l_as = @(x) interp1(seat_height, l_as, x, 'pchip');
f_zeta = @(x) interp1(seat_height, zeta, x, 'pchip');
f_l_d = @(x) interp1(seat_height, l_d, x, 'pchip');
f_beta = @(x) interp1(seat_height, beta, x, 'pchip');
f_alpha = @(x) interp1(seat_height, alpha, x, 'pchip');

% % Generate fine seat height points for smooth plotting
% seat_height_fine = linspace(0, 180, 1000); % 1000 points for smooth curves
% l_as_fine = f_l_as(seat_height_fine);
% zeta_fine = f_zeta(seat_height_fine);
% l_d_fine = f_l_d(seat_height_fine);
% beta_fine = f_beta(seat_height_fine);

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % Replace original plots with continuous curves
% figure;
 
% % Spring Length
% subplot(2, 2, 1);
% plot(seat_height_fine, l_as_fine, 'b-', 'LineWidth', 2); hold on;
% plot(seat_height_fine, l_as_ref, 'r--', 'LineWidth', 2);
% title('Spring Length');
% xlabel('Seat Height (mm)');
% ylabel('Spring Length (mm)');
% legend('Calculated', 'Reference');
% grid on;
 
% % Spring Angle
% subplot(2, 2, 2);
% plot(seat_height_fine, zeta_fine, 'b-', 'LineWidth', 2); hold on;
% plot(seat_height_fine, zeta_ref, 'r--', 'LineWidth', 2);
% title('Spring Angle');
% xlabel('Seat Height (mm)');
% ylabel('Spring Angle with Horizontal (degrees)');
% legend('Calculated', 'Reference');
% grid on;
 
% % Damper Length
% subplot(2, 2, 3);
% plot(seat_height_fine, l_d_fine, 'b-', 'LineWidth', 2); hold on;
% plot(seat_height_fine, l_d_ref, 'r--', 'LineWidth', 2);
% title('Damper Length');
% xlabel('Seat Height (mm)');
% ylabel('Damper Length (mm)');
% legend('Calculated', 'Reference');
% grid on;
 
% % Damper Angle
% subplot(2, 2, 4);
% plot(seat_height_fine, beta_fine, 'b-', 'LineWidth', 2); hold on;
% plot(seat_height_fine, beta_ref, 'r--', 'LineWidth', 2);
% title('Damper Angle');
% xlabel('Seat Height (mm)');
% ylabel('Damper Angle with Horizontal (degrees)');
% legend('Calculated', 'Reference');
% grid on;

% Compute derivative of f_l_d using numerical differentiation
h = 0.01;  % Small step size for finite difference
f_lddh = @(x) (f_l_d(x + h) - f_l_d(x - h)) / (2 * h);  % Central difference formula

% Generate points for plotting the derivative
seat_height_plot = linspace(0, 180, 1000);
derivative_values = arrayfun(f_lddh, seat_height_plot);

% Plot the derivative
figure;
plot(seat_height_plot, derivative_values, 'r-', 'LineWidth', 2);
title('Derivative of Damper Length with respect to Seat Height');
xlabel('Seat Height (mm)');
ylabel('dl_d/dh (mm/mm)');
grid on;

% Compute derivative of f_l_as using numerical differentiation
f_lssh = @(x) (f_l_as(x + h) - f_l_as(x - h)) / (2 * h);  % Central difference formula

% Generate points for plotting the derivative
derivative_values_spring = arrayfun(f_lssh, seat_height_plot);

% Plot the derivative
figure;
plot(seat_height_plot, derivative_values_spring, 'b-', 'LineWidth', 2);
title('Derivative of Spring Length with respect to Seat Height');
xlabel('Seat Height (mm)');
ylabel('dl_as/dh (mm/mm)');
grid on;

% Compute derivative of f_alpha using numerical differentiation
f_aah = @(x) (f_alpha(x + h) - f_alpha(x - h)) / (2 * h);  % Central difference formula
% Generate points for plotting the derivative
derivative_values_alpha = arrayfun(f_aah, seat_height_plot);
% Plot the derivative
figure;
plot(seat_height_plot, derivative_values_alpha, 'g-', 'LineWidth', 2);
title('Derivative of Scissor Angle with respect to Seat Height');
xlabel('Seat Height (mm)');
ylabel('d?/dh (rad/mm)');
grid on;
% 
% % Save function handles for later use (updated to include f_aah)
% save('seat_height_functions.mat', 'f_l_as', 'f_zeta', 'f_l_d', 'f_beta', 'f_lddh','f_lssh', 'f_aah');
% % appended the derivative function
% Save function handles for later use
save('seat_height_functions.mat', 'f_l_as', 'f_zeta', 'f_l_d', 'f_beta', 'f_lddh','f_lssh','f_aah');

% % Example evaluation at a specific seat height
% example_height = 45.7;
% fprintf('At seat height %.2f mm:\n', example_height);
% fprintf('Spring Length: %.4f mm\n', f_l_as(example_height));
% fprintf('Spring Angle: %.4f degrees\n', f_zeta(example_height));
% fprintf('Damper Length: %.4f mm\n', f_l_d(example_height));
% fprintf('Damper Angle: %.4f degrees\n', f_beta(example_height));
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %  
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
