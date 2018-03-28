function Pout = ringFind2(I,verbose)
%based on my ridge finder
MINBRANCHSZ =5;
BLURSZ = 1;
BLCKSZ= 50;
if ~exist('verbose','var')
    verbose=false;
end

I=double(I);
I = (I-min(I(:)))./(max(I(:))-min(I(:)));
%background subtract the image
background = imopen(I,strel('disk',15));
I = I-background;


%find ridges in the image
[r] = ridgefilter(I);

%normalize to avoid bugs in matlab defn of double image
r= (r-min(r(:)))/(max(r(:))-min(r(:)));
rb= imgaussfilt(r, BLURSZ);
%segment the ridges image
level = graythresh(rb);
BW0 = im2bw(rb,level);

%keep only the largest object
BW = bwareafilt(BW0,1,'largest');

%normalize to avoid bugs in matlab defn of double image
r= (r-min(r(:)))/(max(r(:))-min(r(:)));
rb= imgaussfilt(r, BLURSZ);
%segment the ridges image
level = graythresh(rb);
BW = im2bw(rb,level);

%then skeletonize
ringThin =bwmorph(BW,'skel',Inf);
%remove small branches
ringThin = bwmorph(ringThin, 'spur', MINBRANCHSZ);
%remove isolated points post skeletonize
ringThin = bwmorph(ringThin, 'clean');

%get convex hull of the skeleton
[ring_y,ring_x] = find(ringThin==1);
k = convhull(ring_x,ring_y);
ringHull = [ring_x(k),ring_y(k)];
x0=ringHull(:,1);
y0=ringHull(:,2);


Options=struct;
Options.alpha=0.1;
Options.beta=0.1;
Options.gamma=1;
Options.kappa=4;
Options.ITER=500;
Options.sigma1=1;
Options.verbose=false;
try
    [x,y] = snakeLineXu(x0,y0,r,Options);
    Pout = [x,y];
catch ME
    %figure;
    %imagesc(r);
    %hold all;
    %plot(x0,y0);
    %keyboard
    error('Snake fitting failed');
end


if verbose
    figure;
    hold off;
    imagesc(I)
    hold on;
    plot(x,y,'k-');
    figure;
    hold off;
    imagesc(r)
    hold on;
    plot(x,y,'k-');
    pause(.5);
end
    
