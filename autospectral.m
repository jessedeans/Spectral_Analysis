function [ vFreqout, vPmagout, vTimeout ] = Unit3( vData, vTime, sIndex)
%Unit3 - Autospectral Analysis - Blackman-Tukey and wavelet autospectral analysis
%   Detailed explanation goes here

%Interpolate Data
vTi = linspace(min(vTime),max(vTime),length(vTime)); %Querry cooridinates 
vDataInterp = interp1(vTime,vData,vTi);
    
%Detrend Data
vDetrend = detrend(vDataInterp);

switch sIndex
   
    case 'Blackman-Tukey'

        %Powerspectrum
        infft = 2^nextpow2(length(vDetrend));
        [Pxx,f] = periodogram(vDetrend,[],infft,(1/mean(diff(vTi))));

        %Plot Data and detrmine y lims
        vmax = max(Pxx);
        vmin = vmax/100;
        plot (f,Pxx), grid
        xlabel('Frequency')
        ylabel('Power')
        ylim([vmin vmax])
        title ('Auto-Spectrum')

        %Outputs
        vFreqout = f;
        vPmagout = Pxx;
        vTimeout = vTi;
    
    case 'wavelet'
        %wavelet transform
        scales = 1 :1000;
        coefs = cwt( vDetrend, scales, 'morl');
        f = scal2frq(scales, 'morl', 3);
     
        %Cut and and determine lims
        mabscoefs = abs(coefs);
        dMaxVal = max(max(mabscoefs));
        mBigEnough = coefs>=(dMaxVal/10); %logical matrix
        vSum = sum(mBigEnough, 2);
        iEl = find(vSum,1,'first');
        
        %plot
        contour (vTi, f, mabscoefs, 'Linestyle', 'none', 'LineColor', [0 0 0], 'Fill', 'on')
        xlabel('Time')
        ylabel ('Frequency')
        ylim([0, f(iEl)])
        title ('Wavelet Power Spectrum')
        
        %outputs
        vFreqout = f;
        vPmagout = coefs;
        vTimeout = vTi;
     
        
end



end

