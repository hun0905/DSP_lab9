% resize image with input scale 
% input1---source image: I
% input2---resize scale
% output---resized image 

function I_res = resize(I, scale)

    % RGB channel
    R(:, :) = I(:, :, 1);
    G(:, :) = I(:, :, 2);
    B(:, :) = I(:, :, 3);

    % get height, width, channel of image
    [height, width, channel] = size(I);

    %% create new image
    % step1. calculate new width and height, if they are not integer, use
    % "ceil()" or "floor()" to help get the largest width and height.
    height_new = ceil(height*scale);
    width_new  = ceil(width*scale);

    % step2. initial r, g, b array for the new image
    R_res = uint8(zeros(height_new,width_new));
    G_res = uint8(zeros(height_new,width_new));
    B_res = uint8(zeros(height_new,width_new));

    %% backward warping using nearest-neighborhood interpolation
    % for each pixel on the resized image, find the correspond r, g, b value 
    % from the source image, and save to R_res, G_res, B_res.
    for y_new = 1 : height_new
        for x_new = 1 : width_new
            x_old=x_new/scale;
            y_old=y_new/scale;
            x1=floor(x_old);
            y1=floor(y_old);
            x2=ceil(x_old);
            y2=ceil(y_old);

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
                R_res(y_new, x_new)=R(y1,x1)*w1+R(y1,x2)*w2+R(y2,x2)*w3+R(y2,x1)*w4;
                G_res(y_new, x_new)=G(y1,x1)*w1+G(y1,x2)*w2+G(y2,x2)*w3+G(y2,x1)*w4;
                B_res(y_new, x_new)=B(y1,x1)*w1+B(y1,x2)*w2+B(y2,x2)*w3+B(y2,x1)*w4;
            else
                R_res(y_new, x_new) = 0;
                G_res(y_new, x_new) = 0;
                B_res(y_new, x_new) = 0;
            end
        end
    end
    % save R_rot, G_rot, B_rot to output image
    I_res(:, :, 1) = R_res;
    I_res(:, :, 2) = G_res;
    I_res(:, :, 3) = B_res;
end
