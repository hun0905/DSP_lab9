
function I_rot = ForwardWarpingRotate(I, radius)

    % RGB channel
    R(:, :) = I(:, :, 1);
    G(:, :) = I(:, :, 2);
    B(:, :) = I(:, :, 3);
    

    % get height, width, channel of image
    [height, width, channel] = size(I);

    %% create new image
    % step1. record image vertices, and use rotation matrix to get new vertices.
    matrix = [cos(radius) -sin(radius) ; sin(radius) cos(radius)];
    vertex = zeros(2,height,width);
    [y,x]=ndgrid(0:height-1,0:width-1);
    vertex(1,:,:)=x;
    vertex(2,:,:)=y;
    vertex_new=matrix*reshape(vertex,[2,height*width]);
    vertex_new = reshape(vertex_new,[2,height,width]);

    x_min = min(vertex_new(1,:,:),[],'all');
    y_min = min(vertex_new(2,:,:),[],'all');
    x_max = max(vertex_new(1,:,:),[],'all');
    y_max = max(vertex_new(2,:,:),[],'all');
    x_shift = abs(x_min);
    y_shift = abs(y_min);

    %% backward warping using bilinear interpolation
    % for each pixel on the rotation image, find the correspond r, g, b value 
    % from the source image, and save to R_rot, G_rot, B_rot.
    for y = 1 : height
        for x = 1 : width

            % step5. shift the new pixel (y_new, x_new) back, and rotate -radius
            % degree to get (y_old, x_old)
            %%% ...
            
            matrix = [cos(radius) -sin(radius) ; sin(radius) cos(radius)];
            temp =[x-1;y-1];
            temp=matrix*temp;
            x_new=round(temp(1)+x_shift)+1;
            y_new=round(temp(2)+y_shift)+1;
            R_rot(y_new, x_new) = R(y,x);
            G_rot(y_new, x_new) = G(y,x);
            B_rot(y_new, x_new) = B(y,x);
        end
    end
    I_rot(:, :, 1) = R_rot;
    I_rot(:, :, 2) = G_rot;
    I_rot(:, :, 3) = B_rot;
end
