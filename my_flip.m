% input1---source image: I
% input2---flip direction: type (0: horizontal, 1: vertical, 2: both)
% output---flipped image: I_flip

function I_flip = my_flip(I, type)

    % RGB channel
    R = I(:, :, 1);
    G = I(:, :, 2);
    B = I(:, :, 3);

    % get height, width, channel of image
    [height, width, channel] = size(I);

    % initial r, g, b array for flipped image using zeros()
    R_flip = zeros(height, width, 'uint8'); 
    G_flip = zeros(height, width, 'uint8');
    B_flip = zeros(height, width, 'uint8');

    %%  horizontal flipping
    if type == 0
        %%% your code here %%%
        R_flip=flip(R,2);
        G_flip=flip(G,2);
        B_flip=flip(B,2);
        % assign pixels from R, G, B to R_flip, G_flip, B_flip
    end


    %% vertical flipping
    if type == 1
        %%% your code here %%%
        R_flip=flip(R);
        G_flip=flip(G);
        B_flip=flip(B);
        % assign pixels from R, G, B to R_flip, G_flip, B_flip
    end

    %% flip both
    if type == 2
        %%% your code here %%%
        R_flip=flip(flip(R),2);
        G_flip=flip(flip(G),2);
        B_flip=flip(flip(B),2);
        % assign pixels from R, G, B to R_flip, G_flip, B_flip
    end
    
    % save R_flip, G_flip, B_flip to output image
    I_flip(:, :, 1) = R_flip;
    I_flip(:, :, 2) = G_flip;
    I_flip(:, :, 3) = B_flip;
end

