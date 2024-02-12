clc;
clear;
close all;

% Constants - Propagation
Gamma = 3;
Dref10 = 10;

% Distance from BS to RIS
Dbsris = 5:20;

% Number of multiple beams
N_BS_beams = 2; % 2 FSS per sector
% Additional attenuation of the multiple beams
L_BS_beams = 10*log10(N_BS_beams);

% Constants - BS
Ptx_dBm = 20;
DdB = 32;
L_att = 10;
PIRE_dBm = Ptx_dBm + DdB - L_att;

% Constants - RIS
DrdB = [8; 15; 18.16; 25.35; 38.05]; 
Refle_dB = 10;

% 5 bands
N_Bands = 5;
BandObj = cell(N_Bands,1);
BandObj{1} = Band5g('f_{s} = 800 MHz, B_{s} = 5 MHz', 800e6, 0, 24, 4);
BandObj{2} = Band5g('f_{s} = 1.8 GHz, B_{s} = 10 MHz', 1.8e9, 0, 52, 4);
BandObj{3} = Band5g('f_{s} = 2.6 GHz, B_{s} = 15 MHz', 2.6e9, 1, 38, 4);
BandObj{4} = Band5g('f_{s} = 6 GHz, B_{s} = 20 MHz', 6e9, 1, 52, 4);
BandObj{5} = Band5g('f_{m} = 26 GHz, B_{m} = 200 MHz', 26e9, 3, 264, 14);

Thermal_Noise_dBm = zeros(N_Bands,1);
PL_Ref = zeros(N_Bands,1);
for ib = 1:N_Bands
    % Read
    Band = BandObj{ib};
    % Display
    Band.DisplayInfo()
    % Collect thermal noise
    Thermal_Noise_dBm(ib) = Band.Thermal_Noise_dBm;
    % Reference attenuation
    PL_Ref(ib) = Band.ComputePl(Dref10);
end
Thermal_Noise_dBm
PL_Ref

% Allocation
dm = zeros(length(Dbsris),N_Bands);
PL = zeros(length(Dbsris),N_Bands);

% Reference distance
PL_DistR_dB = PIRE_dBm - Thermal_Noise_dBm(end) - PL_Ref(end);
PL(:,end) = PL_DistR_dB;
dm(:,end) = 10.^(PL_DistR_dB/(10*Gamma)) .* Dref10;

% Common part: BS-RIS
Common = (PIRE_dBm-L_BS_beams) + DrdB(end) - Refle_dB + 5;

for ib = 1:N_Bands-1
    for it = 1:length(Dbsris)  
        % PL from BS-RIS B3
        PL_BsRis = BandObj{end}.ComputePl(Dbsris(it));

        % Computation
        PL_Dist_dB = Common + DrdB(ib) - Thermal_Noise_dBm(ib) - PL_Ref(ib) - PL_BsRis;
        PL(it,ib) = PL_Dist_dB;
        dm(it,ib) = 10.^(PL_Dist_dB/(10*Gamma)) * Dref10;

    end
end
legendlist{1} = BandObj{end}.Name;
legendlist{2} = BandObj{1}.Name;
legendlist{3} = BandObj{2}.Name;
legendlist{4} = BandObj{3}.Name;
legendlist{5} = BandObj{4}.Name;

figure
plot(Dbsris,dm(:,end), 'k', 'LineWidth', 2)
hold on
plot(Dbsris,dm(:,1), 's-', 'LineWidth', 2)
plot(Dbsris,dm(:,2), 'o-', 'LineWidth', 2)
plot(Dbsris,dm(:,3), 'd-', 'LineWidth', 2)
plot(Dbsris,dm(:,4), 'p-', 'LineWidth', 2)

hold off
grid minor
xlabel('d_{bf} [m]')
ylabel('r_{s} [m]')
legend(legendlist)
offset_vertical = 0.12;
offset_horizontal = 0.1;
set(gca,'position',[offset_horizontal offset_vertical 0.98-offset_horizontal 0.99-offset_vertical],'units','normalized')


save lf10.mat Dbsris dm BandObj