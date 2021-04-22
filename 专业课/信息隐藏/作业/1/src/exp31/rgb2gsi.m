function gsi_array = rgb2gsi(source_rgb_path, targeted_gsi_path)
    rgb_array = imread(source_rgb_path);
    
    % 计算阈值
    threshold = graythresh(rgb_array);
    gsi_array = im2bw(rgb_array, threshold);
    
    imwrite(gsi_array, targeted_gsi_path);
end

