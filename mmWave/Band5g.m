classdef Band5g
    properties
        Name = [];
        Fc = 0;
        Mu = 0;

        SCS = 0;
        N_RB_A = 0;
        N_RB_G = 0;
        N_RB_T = 0;

        BW_A = 0;
        BW_G = 0;
        BW_T = 0;

        N_Slot_Frame = 0;
        N_Symb_Frame = 0;

        T_Ofdm = 0;
        T_Slot = 0;

        c = 3e8;
        PL_Offset_dB = 0;
        PL_Freq_dB = 0;

        % Noise figure: 5 wide, 10 medium, 13 local
        Thermal_Noise_Density_dBm = -174 + 10;
        Thermal_Noise_dBm = 0;

    end
    methods
        % Constructor
        function obj = Band5g(Name, Fc, Mu, N_RB_A, N_RB_G)
            obj.Name = Name;
            obj.Fc = Fc;
            obj.Mu = Mu;

            obj.SCS = (obj.Mu+1)*15e3;
            obj.N_RB_A = N_RB_A;
            obj.N_RB_G = N_RB_G;
            obj.N_RB_T = obj.N_RB_A + obj.N_RB_G;

            obj.BW_A = obj.N_RB_A * obj.SCS * 12;
            obj.BW_G = obj.N_RB_G * obj.SCS * 12;
            obj.BW_T = obj.N_RB_T * obj.SCS * 12;

            obj.PL_Offset_dB = 20*log10(4*pi/obj.c);
            obj.PL_Freq_dB = 20*log10(obj.Fc);
            obj.Thermal_Noise_dBm = 10*log10(obj.BW_A) + obj.Thermal_Noise_Density_dBm;

            obj.N_Slot_Frame = 10 * 2^Mu;
            obj.N_Symb_Frame = 14 * obj.N_Slot_Frame;

            obj.T_Slot = 1e-2 / obj.N_Slot_Frame;
            obj.T_Ofdm = 1e-2 / obj.N_Symb_Frame;

        end

        % Print the information of the object
        function DisplayInfo(obj)
            fprintf('Info for %s\n', obj.Name)
            fprintf('SCS = %d Hz \n', obj.SCS)
            fprintf('Bandwidth for Data is = %d KHz \n', obj.BW_A / 1e3 )
            fprintf('Bandwidth for Guard is = %d KHz \n', obj.BW_G / 1e3 )
            fprintf('Bandwidth for All is = %d KHz \n', obj.BW_T / 1e3 )
            fprintf('Slot period is = %d \n', obj.T_Slot)
            fprintf('Symbol period is = %d \n', obj.T_Ofdm)
            fprintf('Num symb per frame is = %d \n', obj.N_Symb_Frame)
            fprintf('Thermal noise due to the BW_A is = %4.2f \n', obj.Thermal_Noise_dBm)
            fprintf('PL due to the offset is = %4.2f \n', obj.PL_Offset_dB)
            fprintf('PL due to carrier frequency is = %4.2f \n', obj.PL_Freq_dB)
            fprintf('-------------------------------------- \n')
        end
        
        % Compute the number of resources blocks
        function Nrb = ComputeNrb(obj,N_frame,N_RB_NA)
            Nrb = ( obj.N_RB_A - N_RB_NA ) * obj.N_Symb_Frame * N_frame;
        end

        % Compute the path loss
        function PL_dB = ComputePl(obj,dist)
            if isnan(dist) == true
                PL_dB = obj.PL_Offset_dB + obj.PL_Freq_dB;
            else
                PL_dB = obj.PL_Offset_dB + obj.PL_Freq_dB + 20*log10(dist);
            end
        end

    end
end