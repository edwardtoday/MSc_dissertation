function matdata = file2matrix( filename )
%FILE2MATRIX
%   Read binary palmprint sample, return a matrix
    datfile = fopen(filename);
    matdata = zeros(768, 576, 'single');
    matdata = fread(datfile, [768,576], 'single');
    fclose(datfile);
end

