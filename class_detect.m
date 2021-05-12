%% Group members:
% John Tiglao, 500751493
% Vatsal Shreekant, 500771363

%% 
run('C:/Users/guest_admin/Downloads/vlfeat-0.9.21-bin.tar/vlfeat-0.9.21-bin/vlfeat-0.9.21/toolbox/vl_setup');
load('train_feats.mat');
load('valid_feats.mat');
imageDir = 'test_images';
imageList = dir(sprintf('%s/*.jpg',imageDir));
nImages = length(imageList);
bboxes = zeros(0,4); bboxes_detect = []; 
num_of_confidence_values = zeros(0,1); confidences_detect = [];
image_names = cell(0,1); image_names_detect = [];
cellSize = 6;
dim = 36;
scale_val = [0.5 0.75  1 1.25 1.5]; %changed
scale_val = fliplr(scale_val)';
num_scales = numel(scale_val);


for i=1:nImages
   rand_scale_val = [];
    sliding_window_num = []; bboxes_t = []; confidences_t = []; image_names_t = [];
    dims_feat_val = zeros(num_scales,2);
    % load and show the image
    im = im2single(rgb2gray(imread('class.jpg')));
    imshow(im);
    hold on;
    
    [im_x, im_y, im_z] = size(im);
    
    im_x_ceil_val_temp = im_x/cellSize;
    im_x_ceil_val = ceil(im_x_ceil_val_temp);
    im_x_ceil_val = im_x_ceil_val-5;    
    im_y_ceil_val_temp = im_y/cellSize;
    im_y_ceil_val = ceil(im_y_ceil_val_temp);
    im_y_ceil_val = im_y_ceil_val-5;
    
    confidence_multi_val_ones = ones((im_x_ceil_val*im_y_ceil_val),num_scales);
    confidence_multi_val = -Inf .* confidence_multi_val_ones;
    [confidence_multi_val,dims_feat_val] = confidence_miss(im,scale_val,cellSize,w,b);

    [~,indices] = sort(confidence_multi_val(:,:),'descend');
    indices_val = size(confidence_multi_val,1);
    
    temp_val = 35;
    if indices_val > temp_val
        indices = indices(1:temp_val,:); indices_val = temp_val;
    end
    
    sliding_window_num = [sliding_window_num; indices_val];
    loop_scale=1;
    loop_indices=1;
    for loop_scale=1 : num_scales
        num_scaling = scale_val(loop_scale);
        for loop_indices=1 : indices_val
            %Convert linear indices to subscripts
            matrix_size = [dims_feat_val(loop_scale,1) dims_feat_val(loop_scale,2)];
            linear_indices = indices(loop_indices,loop_scale);
            [rows_val,columns_val] = ind2sub(matrix_size,linear_indices);
            scaled_col_mult_cellSize = (columns_val*cellSize)./num_scaling;
            scaled_row_mult_cellSize = (rows_val*cellSize)./num_scaling;
            scaled_col_pl_cellSize_mult_cellSize = ((columns_val+cellSize-1)*cellSize)./num_scaling;
            scaled_row_pl_cellSize_mult_cellSize = ((rows_val+cellSize-1)*cellSize)./num_scaling;
            
            bbox = [ scaled_col_mult_cellSize scaled_row_mult_cellSize scaled_col_pl_cellSize_mult_cellSize scaled_row_pl_cellSize_mult_cellSize];
            dims_val_product = dims_feat_val(loop_scale,1)*dims_feat_val(loop_scale,2);
            confidence_vector_to_be_reshaped = confidence_multi_val(1:dims_val_product,loop_scale);
            confidence_vector_size = dims_feat_val(loop_scale,:);
            confidence_reshape = reshape(confidence_vector_to_be_reshaped,confidence_vector_size);
            
            confidence_reshape_matrix = confidence_reshape(rows_val,columns_val);
            image_name = {imageList(i).name};
            
            plot_rectangle = [bbox(1), bbox(2); ...
                bbox(1), bbox(4); ...
                bbox(3), bbox(4); ...
                bbox(3), bbox(2); ...
                bbox(1), bbox(2)];

            bboxes_t = [bboxes_t; bbox]; bboxes = [bboxes; bbox];
            confidences_t = [confidences_t; confidence_reshape_matrix]; num_of_confidence_values = [num_of_confidence_values; confidence_reshape_matrix];
            image_names_t = [image_names_t; image_name]; image_names = [image_names; image_name];
            rand_scale_val = [rand_scale_val; num_scaling];
        end
    end
   
    (bboxes(:,4)-bboxes(:,2)).*(bboxes(:,3)-bboxes(:,1)); % can this be removed?
 
    
    %r_0 = r_0+1; % can this be removed?
    
    bboxes_temp = [];
    confidences_temp = [];
    image_names_temp = [];
       
    box_val = bboxes_t;
    score_val = confidences_t;
    scale_value = rand_scale_val;
    %ks = [];
    [box_final_val,confidence_final_val,scaling_final_val] = non_Maximum_Supression(box_val,score_val,scale_value);
    
   box_final_val_size = size(box_final_val,1);
   ind_val = 1;
    for ind_val=1:box_final_val_size
        plot_rectangle = [box_final_val(ind_val,1), box_final_val(ind_val,2); box_final_val(ind_val,1), box_final_val(ind_val,4); ...
                          box_final_val(ind_val,3), box_final_val(ind_val,4); box_final_val(ind_val,3), box_final_val(ind_val,2); ...
                          box_final_val(ind_val,1), box_final_val(ind_val,2)];
        plot(plot_rectangle(:,1), plot_rectangle(:,2), 'g-');
    end
      pause;
      clf;



bboxes_detect = [bboxes_detect ; bboxes_temp];
confidences_detect = [confidences_detect ; confidences_temp];
image_names_detect = [image_names_detect ; image_names_temp];

fprintf('got preds for image %zeros_of_scale/%zeros_of_scale\loop_indices', i,nImages);
end


label_path = 'test_images_gt.txt';
[gt_ids, gt_bboxes, gt_isclaimed, tp, fp, duplicate_detections] = ...
    evaluate_detections_on_test(bboxes, num_of_confidence_values, image_names, label_path);

