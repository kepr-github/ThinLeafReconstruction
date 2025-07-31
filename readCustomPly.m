function [pc, customData] = readCustomPly(filename)
%READCUSTOMPLY Read point cloud data from a PLY file with custom properties.
%   [pc, customData] = readCustomPly(filename) reads the specified ASCII PLY
%   file and returns a MATLAB pointCloud object PC containing the locations
%   and any colour/normal information if present. Additional vertex
%   properties that are not recognised by the pointCloud class are returned
%   in the structure customData. Only ASCII formatted PLY files are
%   supported by this simple reader.
%
%   Example:
%       [pc, data] = readCustomPly('scan.ply');
%       OBJ = surfFromPC(pc);
%
%   See also pcread, surfFromPC

fid = fopen(filename, 'r');
if fid == -1
    error('Failed to open %s', filename);
end

cleanup = onCleanup(@() fclose(fid));

line = fgetl(fid);
if ~ischar(line) || ~startsWith(strtrim(line), 'ply')
    error('File is not a valid PLY: %s', filename);
end

line = fgetl(fid);
if ~contains(line, 'ascii')
    error('Only ASCII PLY files are supported');
end

numVerts = 0;
properties = {};
types = {};
while true
    line = fgetl(fid);
    if ~ischar(line)
        error('Unexpected end of header');
    end
    tokens = strsplit(strtrim(line));
    if strcmp(tokens{1}, 'element') && strcmp(tokens{2}, 'vertex')
        numVerts = str2double(tokens{3});
    elseif strcmp(tokens{1}, 'property')
        types{end+1} = tokens{2}; %#ok<AGROW>
        properties{end+1} = tokens{3}; %#ok<AGROW>
    elseif strcmp(tokens{1}, 'end_header')
        break;
    end
end

fmt = repmat('%f', 1, numel(properties));
vertData = textscan(fid, fmt, numVerts);
vertData = cell2mat(vertData);

% Extract common properties if present
idxX = find(strcmp(properties, 'x'));
idxY = find(strcmp(properties, 'y'));
idxZ = find(strcmp(properties, 'z'));
xyz = vertData(:, [idxX idxY idxZ]);

pc = pointCloud(xyz);
customData = struct();

idxR = find(strcmp(properties, 'red'));
idxG = find(strcmp(properties, 'green'));
idxB = find(strcmp(properties, 'blue'));
if ~isempty(idxR) && ~isempty(idxG) && ~isempty(idxB)
    pc.Color = uint8(vertData(:, [idxR idxG idxB]));
end

idxNx = find(strcmp(properties, 'nx'));
idxNy = find(strcmp(properties, 'ny'));
idxNz = find(strcmp(properties, 'nz'));
if ~isempty(idxNx) && ~isempty(idxNy) && ~isempty(idxNz)
    pc.Normal = vertData(:, [idxNx idxNy idxNz]);
end

standardIdx = unique([idxX idxY idxZ idxR idxG idxB idxNx idxNy idxNz]);
extraIdx = setdiff(1:numel(properties), standardIdx);
for k = extraIdx
    pname = matlab.lang.makeValidName(properties{k});
    customData.(pname) = vertData(:, k);
end
end
