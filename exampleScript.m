pixSzNm =64;
widthNm = 250;
scaleFactor = 1;
%f = dir('*.tif');
f = dir('DATA ftsz sam1 hilo4593 3pc 1s em150 reg-trans ring6.tif');
for ii = 1:numel(f)
    fname = f(ii).name;
    fname
    try 
        ringDynamicsAnalysisWide(fname,pixSzNm,widthNm,scaleFactor)
    catch ME
        display(getReport(ME));
    end
end

