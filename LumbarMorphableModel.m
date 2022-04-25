
% Choices of variables are:
%   Classifications
%       - 'DiscBulge': y = 0 is no disc herniation, y = 1 is disc herniation
%       - 'Spondylolisthesis': y = 0 is no spondylolisthesis, y = 1 is spondylolisthesis
%       - 'Female': Sex. y = 0 is male, y = 1 is female.
%   Age
%       - 'ApproxAge': observed range for y is 30-90
%   Measurements
%       - 'meanCanalDepth': observed range for y is 13.0- 20.4 mm
%       - 'meanCanalWidth': observed range for y is 21.5 - 31.8 mm
%       - 'meanDiscHeight': observed range for y is  3.1 - 11.4 mm
%       - 'meanDiscWedge':  observed range for y is  0.4 - 11.6 deg
%       - 'meanFacetAngle': observed range for y is 27.6 - 85.8 deg
%       - 'meanVBdepth':    observed range for y is 29.5 - 42.0 mm
%       - 'meanVBheight':   observed range for y is 23.5 - 32.4 mm
%       - 'meanVBwidth':    observed range for y is 39.4 - 58.8 mm
%       - 'meanVBwedge':    observed range for y is -3.5 - 8.7 deg

% Author: A Clouthier
% Source: https://github.com/aclouthier/morphable-lumbar-model


%% Create a model with a certain characteristic or measurement
% This will create a single mesh representing the chosen value of y for the
% variable. 
% Note that values outside of the observed range can be used, but may
% produce unpredicable results, especially if they are well outside of the 
% observed range.

% --------------------------------------- %
% --- Input parameters and directories -- %
% --------------------------------------- %
% Enter the variable and y-value of interest. Options are listed above.
var = 'Spondylolisthesis';
y = 1;

% Set local directories:
% Directory containing csv files for the statistical shape models
ssmdir = 'C:\Users\aclouthi\OneDrive - University of Ottawa\Documents\Projects\2Dto3D\Lumbar\Manuscript\code\SSM';
% Directory to write .stl to
outdir = 'C:\Users\aclouthi\OneDrive - University of Ottawa\Documents\Projects\2Dto3D\Lumbar\Manuscript\code\';

% --------------------------------------- %
% ------------ Generate mesh ------------ %
% --------------------------------------- %
% This is the code to geneerate the mesh. 

% Mean mesh
cns = dlmread(fullfile(ssmdir,'meanMesh_faces.csv'));
pts_mean = dlmread(fullfile(ssmdir,'meanMesh_vertices.csv'));

% Import SSM
YL = dlmread(fullfile(ssmdir,[var '_YL.csv']));
XL = dlmread(fullfile(ssmdir,[var '_XL.csv']));
ystats = dlmread(fullfile(ssmdir,[var '_y.csv'])); % [mean min max]

% Create mesh
s = (y-ystats(1))./norm(YL)^2; % score for selected value of y
pts = reshape(pts_mean',1,[]) + s.*YL*XL'; 
pts = reshape(pts,3,[])';

stlwrite(fullfile(outdir,[var '_' num2str(y) '.stl']),cns,pts);

%% Create an animation
% Generate a series of .stl files that can be opened in Paraview and 
% viewed as an animation morphing the geometry across the range of observed
% values for y. 

% --------------------------------------- %
% --- Input parameters and directories -- %
% --------------------------------------- %

var = 'meanVBwedge';

% Directory containing csv files for the statistical shape models
ssmdir = 'C:\Users\aclouthi\OneDrive - University of Ottawa\Documents\Projects\2Dto3D\Lumbar\Manuscript\code\SSM';
% Directory to write folder containing multiple stl files for animation
outdir = 'C:\Users\aclouthi\OneDrive - University of Ottawa\Documents\Projects\2Dto3D\Lumbar\Manuscript\code\';

if ~exist(fullfile(outdir,'animation'),'dir')
    mkdir(fullfile(outdir,'animation'))
end

% --------------------------------------- %
% ----------- Generate meshes ----------- %
% --------------------------------------- %

% Mean mesh
cns = dlmread(fullfile(ssmdir,'meanMesh_faces.csv'));
pts_mean = dlmread(fullfile(ssmdir,'meanMesh_vertices.csv'));

% Import SSM
YL = dlmread(fullfile(ssmdir,[var '_YL.csv']));
XL = dlmread(fullfile(ssmdir,[var '_XL.csv']));
ystats = dlmread(fullfile(ssmdir,[var '_y.csv'])); % [mean min max]

% Write meshes morphing from min(y) to max(y) and back to min(y)
k = 1;
for y = [linspace(ystats(2),ystats(3),20) linspace(ystats(3),ystats(2),20)]
   
    s = (y-ystats(1))./norm(YL)^2; 
    pts = reshape(pts_mean',1,[]) + s.*YL*XL';
    pts = reshape(pts,3,[])';
    
    stlwrite(fullfile(outdir,'animation',['morphableModel_' num2str(k) '.stl']),cns,pts);
    
    k = k+1;
end