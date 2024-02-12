clc;
clear;
close all;

% Computation of the delay overhead

% Number of beams used in the evaluation for each numerology
N_beams = [4; 8; 64];

% Periods: slot, OFDM and SSB
T_Slot = [1; 0.5; 0.125] * 1e-3;
T_Ofdm = T_Slot / 14;
T_ssb = 4*T_Ofdm;

% Targetted Speed
Wb = [53.36; 6.88; 3.18] / 2;

% Distance
dist = 260;

% Additional factor
fac = 3/2;

% Delays in ms
Delays = 0:5:50;

%% Common part
% Propagation time
T_prop = dist / 3e8;
% Sweeping time
T_sweep = N_beams .* T_ssb;
% Computation time
T_comp = 1e-3;


%% FS-RIS
% Max angular speed rad/s
T_elap2 = T_sweep;
T_elap2(1) = T_elap2(1) * fac + + 2*T_prop;
T_elap2(2) = T_elap2(2) + T_Ofdm(1) + 2*T_prop;
T_elap2(3) = T_elap2(3) + T_Ofdm(2) + 2*T_prop;

Tcs2 = cumsum(T_elap2);
ang_speed_max2 = Wb ./  Tcs2;
ang_speed_max3 = repmat(ang_speed_max2, [1 length(Delays)]);

Tcs3 = repmat(Tcs2, [1 length(Delays)]);

% Allocate
Tcs1 = zeros(3, length(Delays));
ang_speed_max1 = zeros(3, length(Delays));
% loop
for id = 1:length(Delays)
    % Overhead delay
    T_delay = Delays(id) * ones(2,1) * 1e-3;
    
    %% CoMP
    % Max angular speed rad/s
    T_elap1 = fac*T_sweep + 2*T_prop;
    T_elap1(2:end) = T_elap1(2:end) + T_delay;
    Tcs1(:,id) = cumsum(T_elap1);
    ang_speed_max1(:,id) = Wb ./  Tcs1(:,id);
end

Tc10 = 20e-3;

Tcs1(Tcs1>Tc10) = Tc10;

eta10_2 = 1 - Tcs1 ./ Tc10;
eta10_3 = 1 - Tcs3 ./ Tc10;

legendlist{1} = 'CoMP - 1 micro-BS and 1 macro-BS';
legendlist{2} = 'CoMP - 1 micro-BS and 2 macro-BS';
legendlist{3} = 'Proposed - 1 micro-BS and 1 FS-RIS';
legendlist{4} = 'Proposed - 1 micro-BS and 2 FS-RIS';


figure
plot(Delays,eta10_2(2,:), 'x-', 'LineWidth', 2)
hold on
plot(Delays,eta10_2(3,:), '+--', 'LineWidth', 2)
plot(Delays,eta10_3(2,:), 'o-', 'LineWidth', 2)
plot(Delays,eta10_3(3,:), 's--', 'LineWidth', 2)
hold off
xlabel('Delay: T_{d} [ms]');
ylabel('Efficiency ratio: \eta');
legend(legendlist, 'Location', 'southeast');
grid minor
% axis([5 14.5 1e-4 1.1])
offset_vertical = 0.12;
offset_horizontal = 0.1;
set(gca,'position',[offset_horizontal offset_vertical 0.98-offset_horizontal 0.99-offset_vertical],'units','normalized')

figure
plot(Delays,ang_speed_max1(2,:)/1e3, 'x-', 'LineWidth', 2)
hold on
plot(Delays,ang_speed_max1(3,:)/1e3, '+--', 'LineWidth', 2)
plot(Delays,ang_speed_max3(2,:)/1e3, 'o-', 'LineWidth', 2)
plot(Delays,ang_speed_max3(3,:)/1e3, 's--', 'LineWidth', 2)
hold off
xlabel('Delay: T_{d} [ms]');
ylabel('Maximum angular speed: w_{max} [krad/s]');
legend(legendlist);
grid minor
% axis([5 14.5 1e-4 1.1])
offset_vertical = 0.12;
offset_horizontal = 0.1;
set(gca,'position',[offset_horizontal offset_vertical 0.98-offset_horizontal 0.99-offset_vertical],'units','normalized')





