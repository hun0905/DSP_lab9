% shear image according to the shift pixels in both x and y axises
% input1---source image: I
% input2---shift pixel in x axis: sh_x (ex: -0.8)
% input3---shift pixel in y axis: sh_y (ex: 0.2)
% output---shear image: I_shear

function I_shear = shear(I, sh_x, sh_y)

    % RGB channel
    R(:, :) = I(:, :, 1);
    G(:, :) = I(:, :, 2);
    B(:, :) = I(:, :, 3);

    % get height, width, channel of image
    [height, width, channel] = size(I);

    %% create new image
    % step1. record image vertices, and use the transformation matrix to get new vertices.
    matrix = [1 sh_x; sh_y 1];
    R =  im2double(R);
    G =  im2double(G);
    B =  im2double(B);
    vertex = zeros(2,height,width);
    [y,x]=ndgrid(0:height-1,0:width-1);
    vertex(1,:,:)=x;
    vertex(2,:,:)=y;
    vertex_new=matrix*reshape(vertex,[2,height*width]);
    vertex_new = reshape(vertex_new,[2,height,width]);

    % step2. find min x, min y, max x, max y, use "min()" & "max()" function is ok
    %%% ... 
    x_min = min(vertex_new(1,:,:),[],'all');
    y_min = min(vertex_new(2,:,:),[],'all');
    x_max = max(vertex_new(1,:,:),[],'all');
    y_max = max(vertex_new(2,:,:),[],'all');
    % step3. consider how much to shift the image to the positive axis
    x_shift = abs(x_min);
    y_shift = abs(y_min);
    x_new=reshape(vertex_new(1,:,:),[height width])+x_shift;
    y_new=reshape(vertex_new(2,:,:),[height width])+y_shift;
    % step4. calculate new width and height, if they are not integer, use
    % "ceil()" & "floor()" to help get the largest width and height.
    width_new = ceil(x_max) - floor(x_min);
    height_new = ceil(y_max) - floor(y_min);

    % step5. initial r, g, b array for the new image
    R_shear =  zeros(height_new,width_new);
    G_shear =  zeros(height_new,width_new);
    B_shear =  zeros(height_new,width_new);

    %% backward warping using bilinear interpolation
    % for each pixel on the shear image, find the correspond r, g, b value 
    % from the source image, and save to R_shear, G_shear, B_shear.
    for y_new = 1 : height_new
        for x_new = 1 : width_new

            % step5. shift the new pixel (y_new, x_new) back, 
            % and reverse the shear transformation to get (y_old, x_old)
            %%% ...
            y=y_new-1-y_shift;
            x=x_new-1-x_shift;
            matrix = [1 sh_x; sh_y 1];
            temp =[x;y];
            temp=inv(matrix)*temp;
            x_old=temp(1)+1;
            y_old=temp(2)+1;
            % step6. use "ceil()" & "floor()" to get interpolation coordinates
            % x1, x2, y1, y2
            %%% ...
            x1=floor(x_old);
            y1=floor(y_old);
            x2=ceil(x_old);
            y2=ceil(y_old);
            % step7. if (y_old, x_old) is inside of the source image, 
            % calculate r, g, b by interpolation.
            % else if (y_old, x_old) is outside of the source image, set
            % r, g, b = 0 (black).
            if (x1 >= 1) && (x1 <= width) && (x2 >= 1) && (x2 <= width) && ...
                (y1 >= 1) && (y1 <= height)&& (y2 >= 1) && (y2 <= height)

                % step8. calculate weight wa, wb, notice that if x1 = x2 or y1 = y2,
                % function "wa = ()/(x1-x2)" will be fail. 
                % at this situation, you need to assign a value to wa directly.
                %%% ...
                if x1==x2
                    wa=1;
                else
                    wa=(x_old-x1)/(x2-x1);
                end
                if y1==y2
                    wb=1;
                else
                    wb=(y_old-y1)/(y2-y1);
                end
                % step9. calculate weight w1, w2, w3, w4. 
                %%% ...
                w1=(1-wa)*(1-wb);
                w2=wa*(1-wb);
                w3=wa*wb;
                w4=(1-wa)*wb;
                % step10. calculate r, g, b with 4 neighbor points and their weights
                %%% ...
                r=R(y1,x1)*w1+R(y1,x2)*w2+R(y2,x2)*w3+R(y2,x1)*w4;
                g=G(y1,x1)*w1+G(y1,x2)*w2+G(y2,x2)*w3+G(y2,x1)*w4;
                b=B(y1,x1)*w1+B(y1,x2)*w2+B(y2,x2)*w3+B(y2,x1)*w4;
            else
                r = 0;
                g = 0;
                b = 0;
            end
            R_shear(y_new, x_new) = r;
            G_shear(y_new, x_new) = g;
            B_shear(y_new, x_new) = b;
        end
    end

    % save R_shear, G_shear, B_shear to output image
    I_shear(:, :, 1) = R_shear;
    I_shear(:, :, 2) = G_shear;
    I_shear(:, :, 3) = B_shear;

end
