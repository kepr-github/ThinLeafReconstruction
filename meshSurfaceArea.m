function area = meshSurfaceArea(S)
%MESHSURFACEAREA Compute surface area of a triangular mesh.
%   AREA = MESHSURFACEAREA(S) returns the total area of the mesh described
%   by the structure S, which must contain fields 'faces' and 'vertices'
%   as produced by MATLAB functions such as `isosurface` or the provided
%   `aShapeSample` routine.
%
%   Example:
%       S = isosurface(X,Y,Z,V);
%       area = meshSurfaceArea(S);
%
%   See also isosurface, alphaShape

tri1 = S.vertices(S.faces(:,1),:);
tri2 = S.vertices(S.faces(:,2),:);
tri3 = S.vertices(S.faces(:,3),:);

crossProd = cross(tri2 - tri1, tri3 - tri1, 2);
triArea = 0.5 * vecnorm(crossProd, 2, 2);
area = sum(triArea);
end
