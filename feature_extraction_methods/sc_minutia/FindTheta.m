function theta = FindTheta(img, x, y, CN)
theta = -1;

if (CN == 1)
    % for ridge ending find the only other white pixel
    for i=1:8
        if (p(img, x, y, i) == 1)
            % found only other pixel decide which angle
            switch (i)
                case {1, 9}
                    theta = 0; % current interpretation of theta is in radian
                case 2
                    % theta = 45;
                    theta = pi / 4;
                case 3
                    % theta = 90;
                    theta = pi / 2;
                case 4
                    % theta = 135;
                    theta = 3 * pi / 4;
                case 5
                    % theta = 180;
                    theta = pi;
                case 6
                    % theta = 225;
                    theta = 5 * pi / 4;
                case 7
                    % theta = 270;
                    theta = 3 * pi / 2;
                case 8
                    % theta = 315;
                    theta = 7 * pi / 4;
            end % switch
        end % if Pxyi = 1
    end % for i
else 
    % ridge bijection, find single pixel on an axis
    %
    %    |   | 
    %    | O | *
    %    |   | *

    if (p(img, x, y, 1)  && ~(p(img, x, y, 2) && p(img, x, y, 8)) ) 
        theta = 0; % current interpretation of theta is in radian
    end


    %
    %  * | * | *
    %    | O | 
    %    |   | *

    if (p(img, x, y, 2) && ~(p(img, x, y, 1) && p(img, x, y, 8) && p(img, x, y, 3) && p(img, x, y, 4)))
        % theta = 45;
        theta = pi * 4;
    end

    %
    %  * | * |
    %    | O | 
    %    |   | 

    if (p(img, x, y, 3) && ~(p(img, x, y, 2) && p(img, x, y, 4)))
        % theta = 90;
        theta = pi / 2;
    end


    %
    %  * |   | *
    %  * | * | 
    %  * |   | 

    if (p(img, x, y, 4) && ~(p(img, x, y, 3) && p(img, x, y, 2) && p(img, x, y, 5) && p(img, x, y, 6)))
        % theta = 135;
        theta = 3 * pi / 4;
    end


    %
    %    |   | 
    %  * | O |
    %  * |   |

    if (p(img, x, y, 5) && ~(p(img, x, y, 4) && p(img, x, y, 6)))
        % theta = 180;
        theta = pi;
    end


    %
    %    |   |
    %    | O |
    %  * | * | *

    if (p(img, x, y, 6) && ~(p(img, x, y, 4) && p(img, x, y, 5) && p(img, x, y, 7) && p(img, x, y, 8)))
        % theta = 225;
        theta = 5 * pi / 4;
    end




    %
    %    |   |
    %    | O |
    %    | * | *

    if (p(img, x, y, 7) && ~(p(img, x, y, 6) && p(img, x, y, 8)))
        % theta = 270;
        theta = 3 * pi / 2;
    end


    %
    %    |   |
    %    | O | *
    %  * | * | *

    if (p(img, x, y, 8) && ~(p(img, x, y, 2) && p(img, x, y, 1) && p(img, x, y, 7) && p(img, x, y, 6)))
        % theta = 315;
        theta = 7 * pi / 4;
    end
end

