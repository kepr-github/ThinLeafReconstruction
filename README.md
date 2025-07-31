# ThinLeafReconstruction
MATLAB code for the article "Implicit reconstructions of thin leaf surfaces from large, noisy point clouds".

## Citing this work
If you use this code in your work, please cite the following paper:

Riley M. Whebell, Timothy J. Moroney, Ian W. Turner, Ravindra Pethiyagoda, Scott W. McCue,
Implicit reconstructions of thin leaf surfaces from large, noisy point clouds,
Applied Mathematical Modelling,
Volume 98,
2021,
Pages 416-434,
ISSN 0307-904X,
https://doi.org/10.1016/j.apm.2021.05.014.

## Dependencies
This source code is dependent on the following MATLAB toolboxes:
- Statistics and Machine Learning Toolbox,
- Partial Differential Equation Toolbox, and
- Computer Vision Toolbox.

## Parameters
The main parameters of interest and their effects are:
- Downsampling grid size: `downsampleParam`. Higher values will reduce runtime but also reduce reconstruction resolution.
- Smoothing parameter: `rho`. A higher value will yield a smoother (as defined by the thin plate penalty) surface reconstruction.
- Sampling resolution: `Ngrid` for marching cubes, or `Hmax` for marching tetrahedra. 
    - A higher value for `Ngrid` will result in a finer grid for marching cubes isosurfacing. 
    - A lower value for `Hmax` will result in a finer tetrahedral mesh for marching tetrahedra isosurfacing.

## Included scripts
- `sphereTest.m` will reconstruct one half of a sphere from 791 points, without denoising or downsampling. This should run in under a minute on a desktop computer.
- `main.m` will reconstruct a plant leaf from a heavily downsampled point cloud with 5516 points. This should run in under 10 minutes on a desktop computer. You may like to reduce the `downsampleParam` (say, to 0.5) for a finer reconstruction.

## Running the code
To execute the example scripts:
1. Open MATLAB and change the current folder to this repository or add it to the MATLAB path.
2. Run `sphereTest` or `main` from the MATLAB command window.
   - `sphereTest` reconstructs a hemisphere from a small sample point cloud.
   - `main` performs a reconstruction of a sample plant leaf.
3. Output figures and data will be written to a new folder under `saves/`.
4. The surface area of the reconstructed mesh can be computed using
   `meshSurfaceArea` on the returned structure. Both example scripts now
   print the area estimated from marching cubes and marching tetrahedra.

### Reading PLY files
Custom 3D point clouds stored in ASCII PLY format can be imported using the
`readCustomPly` function:

```matlab
[pc, extra] = readCustomPly('scan.ply');
OBJ = surfFromPC(pc);
```

Additional vertex attributes that are not recognised by the `pointCloud`
class are returned in the structure `extra` for further processing.
