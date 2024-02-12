clc;
clear;
close all;

c = 3e8;

%%  Planar Array for 26 GHz
element_one = 2.^(1:5);

DesignedFc = 26e9;
OperatedFc = DesignedFc;
lambda = c / DesignedFc;
elem_dist = ones(1,2) * lambda/2; 
angs = [0;0];

myBw = zeros(length(element_one),1);
myDir = zeros(length(element_one),1);
for ifc = 1:length(element_one)
    % Select the size
    elem_size = ones(1,2) * element_one(ifc);
    % Build the array
    myArray = phased.URA(elem_size, elem_dist);
    % viewArray(myArray)

    % Radiation pattern
    [myBw(ifc),~] = beamwidth(myArray,OperatedFc);
    % figure(ifc)
    % pattern(myArray,OperatedFc(ifc))

    % Compute directivity
    myDir(ifc) = directivity(myArray,OperatedFc,angs);
end


BS.Fc = OperatedFc;
BS.Bw = myBw;
BS.Dir = myDir;


% BS Bw     59.86   26.28   12.78   6.36    3.18
% BS Dir    7.1     13.51   19.74   25.89   31.99

