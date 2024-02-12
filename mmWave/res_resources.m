clc;
clear;
close all;

% Number of resources for different resource allocation

% 3 bands
N_Bands = 3;
BandObj = cell(N_Bands,1);
BandObj{1} = Band5g('f_{s} = 800 MHz, B_{s} = 5 MHz', 800e6, 0, 24, 4);
BandObj{2} = Band5g('f_{s} = 6 GHz, B_{s} = 10 MHz', 6e9, 1, 24, 4);
BandObj{3} = Band5g('f_{m} = 26 GHz, B_{m} = 200 MHz', 26e9, 3, 264, 14);

BandObj{1}.DisplayInfo()
BandObj{2}.DisplayInfo()
BandObj{3}.DisplayInfo()


NumToT = 20;
NumB1 = 1;

% Reference case
frame = zeros(N_Bands,4);
frame(1,1) = BandObj{1}.ComputeNrb(NumToT,0);
frame(2,1) = BandObj{2}.ComputeNrb(NumToT,0);
frame(3,1) = BandObj{3}.ComputeNrb(NumToT,0);

% Sequential case
frame(1,2) = BandObj{1}.ComputeNrb(NumB1,0);
frame(2,2) = BandObj{2}.ComputeNrb(NumB1,0);
frame(3,2) = BandObj{3}.ComputeNrb(NumToT-2*NumB1,0);

% Parallel 3
frame(1,3) = BandObj{1}.ComputeNrb(NumToT,0);
N_RB_NA2 = BandObj{1}.N_RB_A * BandObj{1}.SCS / BandObj{2}.SCS;
frame(2,3) = BandObj{2}.ComputeNrb(NumToT,N_RB_NA2);
N_RB_NA3 = BandObj{2}.N_RB_A * BandObj{2}.SCS / BandObj{3}.SCS;
frame(3,3) = BandObj{3}.ComputeNrb(NumToT,N_RB_NA3);




frame = [frame; sum(frame,1)]

100 * frame / frame(4,1)




