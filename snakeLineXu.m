function [x,y] = snakeLineXu(x,y,I,varargin)

SNAKE_RES = 1;
REDRAW_ITER = 5;

Options=struct;
Options.alpha=0.1;
Options.beta=0.1;
Options.gamma=1;
Options.kappa=4;
Options.ITER=500;
Options.sigma1=1;%gaussian blur radius
Options.verbose = false;
if numel(varargin)==1
    if isfield(Options,'alpha')
        Options.alpha = varargin{1}.alpha;
    elseif isfield(Options,'beta')
        Options.beta = varargin{1}.beta;
    elseif isfield(Options,'gamma')
        Options.gamma = varargin{1}.gamma;
    elseif isfield(Options,'kappa')
        Options.kappa = varargin{1}.kappa;
    elseif isfield(Options,'ITER')
        Options.ITER = varargin{ii}.ITER;
    elseif isfield(Options,'sigma1')
        Options.sigma1 = varargin{1}.sigma1;
    elseif isfield(Options,'verbose')
        Options.sigma1 = varargin{1}.verbose;
    end
end

f0= imgaussfilt(I, Options.sigma1);
[px,py] = gradient(f0);

%initialize the snake
[x,y] = snakeinterp(x,y,2,0.5);

if Options.verbose
    %DEBUG
    hold off;
    imagesc(I);
    hold all;
end

nIter = round(Options.ITER/REDRAW_ITER);
for i=1:nIter
   [x,y] = snakedeform(x,y,Options.alpha,Options.beta,Options.gamma,Options.kappa,px,py,REDRAW_ITER);
   [x,y] = snakeinterp(x,y,2,0.5);
    if Options.verbose
       snakedisp(x,y,'r') 
       title(['Deformation in progress,  iter = ' num2str(i*REDRAW_ITER)])
       pause(0.5);
   end
end
