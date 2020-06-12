function [ vFreqout, vPmagout, vTimeout] = Unit3_2( vTime1, vData1, vTime2, vData2)
%Unit3_2 Cross-spectrum and phase spectrum
%   Compares two time series and produces a corss-spectrum and phase
%   sepctrum plot.


%Determine differences 
vDiff1 = diff(vTime1);
vDiff2 = diff(vTime2);

dMean1 = mean(vDiff1);
dMean2 = mean(vDiff2);

SampPeriod = max(dMean1,dMean2);

%New Time
        T1min = min(vTime1);
        T2min = min(vTime2);
        iStartEl = max(T1min, T2min);
        T1max =  max(vTime1);
        T2max = max(vTime2);
        iEndEl = min(T1max, T2max);
        vTimeNew = iStartEl:SampPeriod:iEndEl;
%interpolate vTimes and vDatas
        vData1interp = interp1(vTime1,vData1,vTimeNew);
        vData2interp = interp1(vTime2,vData2,vTimeNew);
%detrend data
        vData1Detrend = detrend(vData1interp);
        vData2Detrend = detrend(vData2interp);
%cross-spectrum
        infft = 2^nextpow2(length(vData1Detrend));
        [Pxy,F] = cpsd(vData1Detrend,vData2Detrend,[],0,infft,1);
%phase spectrum
        phase = angle(Pxy);
%Plot
        subplot(2,1,1)
        plot(F,abs(Pxy)),grid
        xlabel('Frequency')
        ylabel('Power')
        title ('Cross-Spectrum')
        subplot (2,1,2)
        plot(F, phase), grid
        xlabel ('Freqeuncy')
        ylabel ('Phase Angle')
        title ('Phase Spectrum')
%outputs
        vFreqout = F;
        vPmagout = Pxy;
        vTimeout = vTimeNew;

end

