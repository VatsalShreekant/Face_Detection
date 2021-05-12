function box_final_val = dim_sort(num_of_box_values,num_of_confidence_values,num_of_scale_values)
    if isempty(num_of_box_values)
        box_final_val = [];
        return;
    end
    
    bboxes_temp = initial_box_val;
    indices = 1;num_of_box_values(1,:) = [];
    initial_box_val = num_of_box_values(1,:);    
    num_of_confidence_values(1) = [];scales_temp = num_of_scale_values(1);    
    num_of_scale_values(1) = [];confidences_temp = num_of_confidence_values(1);   
    
    initial_n_num_max_box_val_1 = max(initial_box_val(1),num_of_box_values(:,1));
    initial_n_num_max_box_val_2 = max(initial_box_val(2),num_of_box_values(:,2));
    initial_n_num_min_box_val_3 = min(initial_box_val(3),num_of_box_values(:,3));
    initial_n_num_min_box_val_4 = min(initial_box_val(4),num_of_box_values(:,4));
    
    box_initial=[initial_n_num_max_box_val_1 initial_n_num_max_box_val_2 ...
        initial_n_num_min_box_val_3  initial_n_num_min_box_val_4];
    width_val = box_initial(:,3) - box_initial(:,1);
    width_val = width_val + 1;
    height_val = box_initial(:,4) - box_initial(:,2);
    height_val = height_val + 1;
    
    
    
    region_of_box = (initial_box_val(3) - initial_box_val(1));
    region_of_box = region_of_box .*(initial_box_val(4)-initial_box_val(2));
    total_area = (width_val .* height_val);
    
    total_region_of_box = (num_of_box_values(:,3)-num_of_box_values(:,1));
    total_region_of_box = total_region_of_box.*(num_of_box_values(:,4)-num_of_box_values(:,2));
    area_box = region_of_box + total_region_of_box;
    area_box = area_box - total_area;
    lamb_val = 0.01;
    area_per_box = total_area./area_box;
    indices_val_a = find(area_per_box > lamb_val);
    bboxes_temp_dim_2 = num_of_box_values(indices_val_a,:);
    bboxes_temp = [bboxes_temp;bboxes_temp_dim_2];    
    confidences_temp_dim_2 = num_of_confidence_values(indices_val_a); num_of_box_values(indices_val_a,:) = [];
    confidences_temp = [confidences_temp;confidences_temp_dim_2]; num_of_confidence_values(indices_val_a) = [];
    scales_temp_dim_2 = num_of_scale_values(indices_val_a);
    scales_temp = [scales_temp;scales_temp_dim_2]; num_of_scale_values(indices_val_a) = [];
    max_confidences_temp = max(confidences_temp);    
    big_indices_val = find(confidences_temp == max_confidences_temp);
    box_final_val = [bboxes_temp(big_indices_val,:); 
    dim_sort(num_of_box_values,num_of_confidence_values,num_of_scale_values)];

        
end