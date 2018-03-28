function [ringKymograph, circleData] = getRingKymograph(ringStack,pixSzNm)
%extract circular kymograph, integrating over single pixel thickness

ringStack = double(ringStack);
ringStack_avg = mean(ringStack,3);

%fit snake to the avg image
verbose=false;
Pout = ringFind2(ringStack_avg,verbose);
%then fit a circle to the snake
[circ_z,circ_r] = fitCircle(Pout);
% calculate a single pixel of circumference and use that as the 
% spacing to sample the circle
theta_step = 1/circ_r;
% non clockwise non-top thetat really confusing
%define clockwise from twelve-o-clock
theta = 0:theta_step:2*pi;
%theta = pi/2:-theta_step:-3/2*pi;
distStep =cumsum([0,ones(1,numel(theta)-1)*abs(theta(2)-theta(1))]);
Pcirc = [circ_z(1)+circ_r*cos(theta(:)), circ_z(2)+circ_r*sin(theta(:)), theta(:), distStep(:)];

%%DEBUG
%figure;
%imagesc(ringStack_avg);
%hold all;
%plot(Pout(:,1),Pout(:,2));
%plot(Pcirc(:,1),Pcirc(:,2));

%use this to plot a profile for all frames (single pixel)
Options=struct;
ringProfile=[];
nFr = size(ringStack,3);
for ii = 1:nFr
    I = ringStack(:,:,ii);
    [ringIntensity] = getProfile(I,Pcirc);
    ringKymograph(ii,:) = ringIntensity(:)';
end

circleData.coord = Pcirc;
circleData.z = circ_z;
circleData.r = circ_r;

%------------------------------------------------------------------
function [profileIntensity] = getProfile(I,samplePts);

x = samplePts(:,1);
y= samplePts(:,2);
nPt = numel(x);

%for each point, get the intensity
[Xim,Yim] = meshgrid(1:size(I,2),1:size(I,1));
for ii = 1:nPt
    %interpolate the intensity to sub-pixel precision
    profileIntensity(ii) = interp2(Xim,Yim,I,x(ii),y(ii),'cubic');%should try to figure out how to calculate this with interpolation
end

