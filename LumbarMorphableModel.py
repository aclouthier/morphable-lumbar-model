# -*- coding: utf-8 -*-
"""

 Choices of variables are:
   Classifications
       - 'DiscBulge': y = 0 is no disc herniation, y = 1 is disc herniation
       - 'Spondylolisthesis': y = 0 is no spondylolisthesis, y = 1 is spondylolisthesis
       - 'Female': Sex. y = 0 is male, y = 1 is female.
   Age
       - 'ApproxAge': observed range for y is 30-90
   Measurements
       - 'meanCanalDepth': observed range for y is 13.0- 20.4 mm
       - 'meanCanalWidth': observed range for y is 21.5 - 31.8 mm
       - 'meanDiscHeight': observed range for y is  3.1 - 11.4 mm
       - 'meanDiscWedge':  observed range for y is  0.4 - 11.6 deg
       - 'meanFacetAngle': observed range for y is 27.6 - 85.8 deg
       - 'meanVBdepth':    observed range for y is 29.5 - 42.0 mm
       - 'meanVBheight':   observed range for y is 23.5 - 32.4 mm
       - 'meanVBwidth':    observed range for y is 39.4 - 58.8 mm
       - 'meanVBwedge':    observed range for y is -3.5 - 8.7 deg

 Author: A Clouthier
 Source: https://github.com/aclouthier/morphable-lumbar-model
"""

import numpy as np
from stl import mesh
import os



def createSpine(var,y,ssm_dir,fname):
    '''
    Generate simulated marker trajectories to use for training the machine learning-
    based marker labelling algorithm. Trajectories are generated based on the defined 
    OpenSim (https://simtk.org/projects/opensim) marker set using body kinematics
    for up to 100 participants performing a series of athletic movements.

    Parameters
    ----------
    var : string
        Variable of interest. Options are: 'DiscBulge','Spondylolisthesis',
        'Female','ApproxAge','meanCanalDepth','meanCanalWidth','meanDiscHeight',
        'meanDiscWedge','meanFacetAngle','meanVBdepth','meanVBheight','meanVBwidth'
        'meanVBwedge'
    y : float
        Desired value of y. The observed ranges for each variable are listed above.
    ssm_dir : string
        Path to the directory containing the statistical shape model .csv files.
    fname : string
        Full file path for the .stl file to be written.

    Returns
    -------
    spine : numpy-stl Mesh object
        The generated mesh in numpy-stl format.
    '''
    # Import mean mesh
    cns = np.genfromtxt(os.path.join(ssm_dir,'meanMesh_faces.csv'),delimiter=',',dtype=int)
    cns = cns - 1
    pts_mean = np.genfromtxt(os.path.join(ssm_dir,'meanMesh_vertices.csv'),delimiter=',')
    # Import SSM
    YL = np.genfromtxt(os.path.join(ssm_dir,var + '_YL.csv'),delimiter=',')
    XL = np.genfromtxt(os.path.join(ssm_dir,var + '_XL.csv'),delimiter=',')
    ystats = np.genfromtxt(os.path.join(ssm_dir,var + '_y.csv'),delimiter=',') # [mean,min,max]
    
    # Create mesh
    s = (y-ystats[0])/np.linalg.norm(YL)**2 # score for the selected value of y
    pts = np.reshape(pts_mean,(1,-1)) + s*np.matmul(YL,XL.transpose())
    pts = np.reshape(pts,(-1,3))
    # Format for numpy-stl
    spine = mesh.Mesh(np.zeros(cns.shape[0],dtype=mesh.Mesh.dtype))
    for i, f in enumerate(cns):
        for j in range(3):
            spine.vectors[i][j] = pts[f[j],:]
    
    spine.save(fname)
    
    return spine
    
#%% Create a spine with a specified parameter
# Example generating a male spine ('Female',y=0)

var = 'Female'
y = 0

ssm_dir = r'C:\Documents\lumbar-morphable-model\SSM'
out_dir = r'C:\Documents\lumbar-morphable-model\'
fname = os.path.join(out_dir, var + '_%.2f.stl' % y)

spine = createSpine(var,y,ssm_dir,fname)

#%% Create an animation
# Generates a series of .stl files that can be opened in Paraview to view an 
# animation where the geometry morphs across the specified range of y. 
# In this example, the mean facet angle is morphed across the observed range.

var = 'meanFacetAngle'
ssm_dir = r'C:\Documents\lumbar-morphable-model\SSM'
animation_dir = r'C:\Documents\lumbar-morphable-model\animation'

# [mean(y),min(y),max(y)]
ystats = np.genfromtxt(os.path.join(ssm_dir,var + '_y.csv'),delimiter=',')

# morph from min(y) to max(y) and back to min(y)
yrange = np.concatenate((np.linspace(ystats[1],ystats[2],num=20),np.linspace(ystats[2],ystats[1],num=20)))

i = 1
for y in yrange:
    createSpine(var,y,ssm_dir,os.path.join(animation_dir,var + '_%d.stl' % i))
    i = i+1


