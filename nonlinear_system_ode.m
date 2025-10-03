function dY = sdoffun(t, Y, syspar, excpar, f_l_as, f_zeta, f_l_d, f_beta,F_interp_fun,nominal_pressure,f_lddh,f_lssh,f_aah)
     % Input: sdoffun(t, Y, syspar, excpar_local,f_l_as, f_zeta, f_l_d, f_beta,F_interp_fun,nominal_pressure)
     %   t: time (not used in this example, but required by ode45)
     %   Y: vector [y1; y2] (state variables)
     %   syspar : mass, damping and stiffness parameters
     %   excpar: frequency and amplitude of excitation
     % Output:
     %   dY: vector [dy1/dt; dy2/dt] (derivatives of state variables)
     % {nominal_pressure} is an integr from 1 t0 7    
     y1 = Y(1);
     y2 = Y(2);
      y3 = Y(3); % DAMPING VAlue
%      f_l_as(90)
% ans =   76.6261
% % % as k increaesse wn increases, hence wr also decreses . i,e shift to left


     st_hight = y1 * 1000 + 90;
     
     ls = (f_l_as(st_hight)) * 0.001;
     sp_angle = (f_zeta(st_hight)) * pi / 180;
     
     ld = (f_l_d(st_hight)) * 0.001;
     dp_angle = (f_beta(st_hight)) * pi / 180;
     
     excit = (2 * pi * excpar(1))^2 * excpar(2);
     
% %  syspar(3)=F_interp_fun{nominal_pressure}();
% % 
% deflcn=f_l_as(st_hight)-f_l_as(90);% standard in mm about 76.62mm
% transfrm_curve_deflcn=(f_l_as(st_hight)-115);%from curve
% nom_curve_deflcn=115-(f_l_as(90);
% nom_curve_deflcn=deflcn-transfrm_curve_deflcn;
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
nom_curve_deflcn=0;  % assuming centre at 115 instead of 76.6
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
nom_s_force=F_interp_fun{nominal_pressure}(nom_curve_deflcn);
% % s_force=F_interp_fun{nominal_pressure}(-(f_l_as(st_hight)-115));%wrong 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
s_force=F_interp_fun{nominal_pressure}(-(f_l_as(st_hight)-f_l_as(90)));
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
eff_s_force=(s_force-nom_s_force)*1000; % in newtons
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% linear spring
% k =36.75;% for 4 bar 

 k =30.2;% for 3 bar 

eff_s_force= - k *(f_l_as(st_hight)-f_l_as(90));% hey length here is in mm . so basically it 1000 times larger tahn the si uniits

v_s=f_lssh(st_hight)*1000*y2;
v_s=v_s/1000;

% c_aux=3450;% for 80
c_aux=3200;% for 40
s_aux_f=c_aux*v_s;
%  s_aux_f=0;

% Initialize output vector
     dY = zeros(2, 1);
%       syspar(2) = 0.1715*10^6;% at 4 bar

%       dY = [y2;
%            -(syspar(3)/syspar(1)) * y2 - (syspar(2)/syspar(1)) * (ls -  (f_l_as(90)) * 0.001) * sin(sp_angle) + excit * sin(2 * pi * excpar(1) * t)];

% dY = [      y2;
%            -(syspar(3)/syspar(1)) * y2 - (-eff_s_force/syspar(1))  * sin(sp_angle) + excit * sin(2 * pi * excpar(1) * t)];
 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

% persistent ld_prev ;
% persistent t_prev ;
% 
% % (209.8-161.5)/181
% % 
% % ans =
% % 
% %     0.2669

% if isempty(ld_prev)
%     v_d = 0;
% else
%     dt = t - t_prev;
%     v_d = (ld - ld_prev) / dt;
%     v_d=y2*1000*.2669;
% % v_d = y2*sin(dp_angle)-xb_dot*cos(dp_angle) ;   
%     end

% end
   
   
%      c1 = syspar(3); % Compression, low velocity
%      c2 = syspar(4); % Compression, high velocity
%      c3 = syspar(5); % Extension, low velocity
%      c4 = syspar(6); % Extension, high velocity
%      v_bp=syspar(7); % Breakpoint velocity
%    
   
% %      v_d=.2669*1000*y2; % in mm/sec

    v_d=y2*1000*f_lddh(st_hight);% in mm/sec

% % v_d=.2669*y2;% in si units

v_d=v_d/1000;% in si units

% % % pr damper
%      % Select damping coefficient based on displacement and velocity
%      if v_d < 0 % velocity Compression
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
%      end  
% 
% 
%  prdamper_force=c*v_d;
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% 
%  dY = [      y2;
%            -(prdamper_force/syspar(1)) * sin(dp_angle)  - ((-eff_s_force+s_aux_f)/syspar(1))  * sin(sp_angle) + excit * sin(2 * pi * excpar(1) * t)];

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % mr damper

% sh_control
d_att_l= 222;%in mm
alpha_dot=f_aah(st_hight)*1000*y2; % in si units (rad/sec)
% zs_dot_rel=(d_att_l*alpha_dot)/1000;% in si units 
zs_dot_rel=(d_att_l*alpha_dot)/1000;% in si units 

zs_dot= zs_dot_rel +[(2 * pi * excpar(1)) * excpar(2)* cos(2 * pi * excpar(1) * t)]*sin( dp_angle);

z_def_dot=f_lddh(st_hight)*y2;

Csky=4000;
Cnom=2000;
Cmax=25000;
if (zs_dot*z_def_dot)<0
     
    c=Cnom;
     
else c=(Csky*zs_dot)/z_def_dot;
if c>Cmax
    c=Cmax;
end %%this saturation is important . taht might be the reason why it wasnt coming

end
% % 
% % mrdamper_force =  c*z_def_dot;
% % 
% % % mrdamper_force =  c*zs_dot;
% % % 
% % % 
% % % if (zs_dot*z_def_dot)<0
% % %      
% % %     mrdamper_force = Cnom*z_def_dot;
% % %      
% % % else
% % %     mrdamper_force =(Csky*zs_dot);
% % %     
% % % end
% % 
% % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% %  
% % %  dY = [      y2;
% % %            -(mrdamper_force/syspar(1)) * sin(dp_angle)  - ((-eff_s_force+s_aux_f)/syspar(1))  * sin(sp_angle) + excit * sin(2 * pi * excpar(1) * t)];
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % %MRD with bandwidth
bandwidth=30;%  hertz is actuator response 30 times in a sec
dY = [      y2;
           -(y3*z_def_dot/syspar(1)) * sin(dp_angle)  - ((-eff_s_force+s_aux_f)/syspar(1))  * sin(sp_angle) + excit * sin(2 * pi * excpar(1) * t);
           bandwidth*(c-y3);];


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

% componentwise spring testing
% dY = [      y2;
%             - ((-eff_s_force+s_aux_f)/syspar(1))  + excit * sin(2 * pi * excpar(1) * t)];
%        

% ld_prev = ld;
% t_prev = t; 
% % % % % % % % % % % % % % % % % % % % % % %

end

