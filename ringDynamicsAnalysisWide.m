function ringDynamicsAnalysisWide(fname,pixSzNm,widthNm,scaleFactor)
%extract circular kymograph, integrating over widthNM annulus thickness
if ~exist('scaleFactor','var')
    scaleFactor=1;
end

ringStack = imreadstack(fname);

[ringKymograph circ] = getRingKymographWide(ringStack,pixSzNm,widthNm);
ringKymograph = round(ringKymograph/scaleFactor);

%figure; imagesc(ringKymograph)
imWrapped = [ringKymograph,ringKymograph];
%figure;imagesc(imWrapped)


%figure;
%imagesc(ringStack(:,:,1))
%hold all;
%scatter(circ.coord(:,1),circ.coord(:,2),circ.coord(:,4)+1);

ringDiaStr = sprintf('_r%d',round(circ.r*pixSzNm*2));
[pathstr,name,ext] = fileparts(fname);
analysisDir = fullfile(pathstr,'analysed');
if ~exist(analysisDir,'dir')
    mkdir(analysisDir);
end
widthStr = sprintf('_wFit%d',round(widthNm));
fnameSave = [analysisDir,filesep(),name,ringDiaStr,widthStr,'.tif'];



k1 = cast(round(ringKymograph),'uint16');
imwrite(k1,[fnameSave(1:end-4),'_kymoRaw.tif']);
k2 = cast(round(imWrapped),'uint16');
imwrite(k2,[fnameSave(1:end-4),'_kymoRawWrap.tif']);
%save the image with the radius in the name
imwritestack(fnameSave, ringStack);


save([fnameSave(1:end-4),'_analysis.mat']);
