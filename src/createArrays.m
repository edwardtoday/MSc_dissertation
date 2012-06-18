function result = createArrays(nArrays, arraySize, datatype)
%CREATEARRAYS
% This creates an cell array which does NOT require contiguous memory.
% To use it:
%   myArray = createArrays(requiredNumberOfArrays, [x y], 'single');
% To access the elements:
%   myArray{1}{2,3} = 10;
%   myArray{1} = zeros(500, 800, 'single');
    result = cell(1, nArrays);
    for i = 1 : nArrays
        result{i} = zeros(arraySize, datatype);
    end
end

