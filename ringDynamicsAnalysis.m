function ringDynamicsAnalysis(fname,pixSzNm)
%extract circular kymograph, integrating over single pixel thickness

ringStack = imreadstack(fname);

[ringKymograph circ] = getRingKymograph(ringStack,pixSzNm);

%figure; imagesc(ringKymograph)
imWrapped = [ringKymograph,ringKymograph];
%figure;imagesc(imWrapped)


%figure;
%imagesc(ringStack(:,:,1))
%hold all;
%scatter(circ.coord(:,1),circ.coord(:,2),circ.coord(:,4)+1);

ringDiaStr = sprintf('_%d',round(circ.r*pixSzNm*2));
[pathstr,name,ext] = fileparts(fname);
analysisDir = fullfile(pathstr,'analysed');
if ~exist(analysisDir,'dir')
    mkdir(analysisDir);
end

fnameSave = [analysisDir,filesep(),name,ringDiaStr,'.tif'];



k1 = cast(round(ringKymograph),'uint16');
imwrite(k1,[fnameSave(1:end-4),'_kymoRaw.tif']);
k2 = cast(round(imWrapped),'uint16');
imwrite(k2,[fnameSave(1:end-4),'_kymoRawWrap.tif']);
%save the image with the radius in the name
imwritestack(fnameSave, ringStack);

save([fnameSave(1:end-4),'_analysis.mat']);
