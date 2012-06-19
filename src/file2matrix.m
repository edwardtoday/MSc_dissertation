function matdata = file2matrix( filename, x, y )
%FILE2MATRIX
%   Read binary palmprint sample, return a matrix
    datfile = fopen(filename);
    matdata = fread(datfile, [x,y], 'single');
    fclose(datfile);
end

