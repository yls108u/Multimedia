function hw2()
orig = imread('./pic/®ã¤ü­¸­¸.jpg');
test = im2double(orig);

% hsize 3, 7, 13
my_conv_hsize(test, 3);
my_conv_hsize(test, 7);
my_conv_hsize(test, 13);

% sigma 1, 30 100
my_conv_sigma(test, 1);
my_conv_sigma(test, 30);
my_conv_sigma(test, 100);

% unsharp mask
my_unsharp_mask(test);

% edge detection mask
my_edge_detection(test);

end

function my_conv_hsize(test, h)
G = fspecial('gaussian', [h h], 1);
test1 = padarray(test, [(h-1)/2 (h-1)/2], 0, 'both');
img = zeros(640, 640, 3);

for i = 1:640
    for j = 1:640
        for layer = 1:3
            value = sum( test1(i:i+h-1, j:j+h-1, layer) .* G(:,:), 'all');
            if(value > 1) 
                value = 1;
            end
            if(value < 0)
                value = 0;
            end
            img(i, j, layer) = value;
            %fprintf("%d\n",img(i, j, layer));
        end
    end
end

%psnr
[peaksnr, snr] = psnr(img, test);
fprintf('The PSNR in hsize %d value is %0.4f\n', h, peaksnr);

% imshow(img);
if(h == 3)
    file_name = './pic/a_1.jpg';
end
if(h == 7)
    file_name = './pic/a_2.jpg';
end
if(h == 13)
    file_name = './pic/a_3.jpg';
end
imwrite(img, file_name);
end

function my_conv_sigma(test, s)
G = fspecial('gaussian', [3 3], s);
test1 = padarray(test, [1 1], 0, 'both');
img = zeros(640, 640, 3);

for i = 1:640
    for j = 1:640
        for layer = 1:3
            value = sum( test1(i:i+2, j:j+2, layer) .* G(:,:), 'all');
            if(value > 1) 
                value = 1;
            end
            if(value < 0)
                value = 0;
            end
            img(i, j, layer) = value;
            %fprintf("%d\n",img(i, j, layer));
        end
    end
end

%psnr
[peaksnr, snr] = psnr(img, test);
fprintf('The PSNR in sigma %d value is %0.4f\n', s, peaksnr);

% imshow(img);
if(s == 1)
    file_name = './pic/b_1.jpg';
end
if(s == 30)
    file_name = './pic/b_2.jpg';
end
if(s == 100)
    file_name = './pic/b_3.jpg';
end
imwrite(img, file_name);
end

function my_unsharp_mask(test)
G = [0 -1 0; -1 5 -1; 0 -1 0];
test1 = padarray(test, [1 1], 0, 'both');
img = zeros(640, 640, 3);

for i = 1:640
    for j = 1:640
        for layer = 1:3
            value = sum( test1(i:i+2, j:j+2, layer) .* G(:,:), 'all');
            if(value > 1) 
                value = 1;
            end
            if(value < 0)
                value = 0;
            end
            img(i, j, layer) = value;
            %fprintf("%d\n",img(i, j, layer));
        end
    end
end

% imshow(img);
imwrite(img, './pic/d_unsharp.jpg');
end

function my_edge_detection(test)
G = [-1 -1 -1; -1 8 -1; -1 -1 -1];
test1 = padarray(test, [1 1], 0, 'both');
img = zeros(640, 640, 3);

for i = 1:640
    for j = 1:640
        for layer = 1:3
            value = sum( test1(i:i+2, j:j+2, layer) .* G(:,:), 'all');
            if(value > 1) 
                value = 1;
            end
            if(value < 0)
                value = 0;
            end
            img(i, j, layer) = value;
            %fprintf("%d\n",img(i, j, layer));
        end
    end
end

% imshow(img);
imwrite(img, './pic/d_edge.jpg');
end
