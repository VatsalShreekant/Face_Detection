function [missed_conf_val,zeros_of_scale] = confidence_miss(im,num_of_scale_values,cellSize,w,b)
    num_of_scale_valnScales = numel(num_of_scale_values);
    size_of_im = size(im);
    [im_x im_y im_z] = size(im);
    zeros_of_scale = zeros(num_of_scale_valnScales,2);    
    im_x_ceil_val_temp = im_x/cellSize;
    im_x_ceil_val = ceil(im_x_ceil_val_temp);
    im_y_ceil_val_temp = im_y/cellSize;
    im_y_ceil_val = ceil(im_y_ceil_val_temp);    
    confidence_multi_val_ones = ones((im_x_ceil_val*im_y_ceil_val),num_of_scale_valnScales);    
    missed_conf_val = -Inf .* confidence_multi_val_ones;    
    loop_scale=1;
    for loop_scale=1:num_of_scale_valnScales
        num_scaling = num_of_scale_values(loop_scale);
        revised_img_x_scale = im_x .* num_scaling;
        revised_img_y_scale = im_y .* num_scaling;
        final_im = imresize(im,[revised_img_x_scale revised_img_y_scale]);
        img_final_mean = mean(final_im(:));
        img_final_st_dev = std(final_im(:));
        final_im_temp = final_im - img_final_mean;
        final_im = (final_im_temp)./img_final_st_dev;
        feats = vl_hog(final_im,cellSize);
        [rows,cols,~] = size(feats);
        confidence_reshape = zeros(rows,cols);
        zeros_of_scale(loop_scale,:) = [rows cols];
        for r=1:rows-5
            for c=1:cols-5
                im_box_val = feats(r:r+5,c:c+5,:);
                im_box_val = im_box_val(:);
                img_score_num = w'*im_box_val;
                img_score_num = img_score_num + b; confidence_reshape(r,c) = img_score_num;
            end
        end
        missed_conf_val_size_1 = size(confidence_reshape,1);
        missed_conf_val_size_1 = missed_conf_val_size_1 .* size(confidence_reshape,2);
        missed_conf_val(1:missed_conf_val_size_1,loop_scale)=confidence_reshape(:);
    end
end