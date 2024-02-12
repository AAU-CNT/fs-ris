clc;
clear;
close all;

% Compute the delay according to the sector size.

% Different values of sector size in degrees
AngSectorA = 60:30:360;

% Size of the beam width
Wb = [53.36; 6.88; 3.18];

% Computation of number of codebooks required in 26 GHz
Nb_sectorA = ceil( AngSectorA ./ Wb );
% Computation of number of codebooks required in other fc
Nbeams6g26g = ceil( Wb(2) / Wb(3) );
Nbeams800m6g = ceil( Wb(1) / Wb(2) );
Nbeams800m26g = ceil( Wb(1) / Wb(3) );

% Computation of number of codebooks with combined numerology
Nb_sectorA_26 = Nb_sectorA(2,:) + Nbeams6g26g;
Nb_sectorA_28 = Nb_sectorA(1,:) + Nbeams800m26g;
Nb_sectorA_3 = Nb_sectorA(1,:) + Nbeams6g26g + Nbeams6g26g;


%% Plotting
myList = {'Ref: BS at f_{m} = 26 GHz', 
            'BS + 1 FS-RIS at f_{s} = 800 MHz',
            'BS + 1 FS-RIS at f_{s} = 6 GHz',
            'BS + 2 FS-RISs at f_{s} = 800 MHz and 6 GHz'};

figure
plot(AngSectorA,Nb_sectorA(3,:),'-*','LineWidth',2)
hold on
plot(AngSectorA,Nb_sectorA_28,'--<','LineWidth',2)
plot(AngSectorA,Nb_sectorA_26,'-.>','LineWidth',2)
plot(AngSectorA,Nb_sectorA_3,'-.^','LineWidth',2)
hold off

xlabel('Angle of the sector: \Delta \phi_{c} [degrees]');
ylabel('Number of total used codewords: N_{c}');
legend(myList,'Location','northwest')   
grid minor
offset_vertical = 0.12;
offset_horizontal = 0.1;
set(gca,'position',[offset_horizontal offset_vertical 0.98-offset_horizontal 0.99-offset_vertical],'units','normalized')
xlim([min(AngSectorA) max(AngSectorA)])
