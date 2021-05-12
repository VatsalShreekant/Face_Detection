function [box_final_val,confidence_final_val,scaling_final_val] = non_Maximum_Supression(num_of_box_values,num_of_confidence_values,num_of_scale_values)
    if isempty(num_of_box_values)
        box_final_val = [];confidence_final_val=[];scaling_final_val = [];
        return;
    end    
    size_of_box_val = size(num_of_box_values,1);
    box_fin_values  = []; box_temp_values = [];
    confidence_fin_values = []; confidence_temp_values = [];
    scale_fin_values  = []; scale_temp_values = [];
    for i=1:size_of_box_val
        if isempty(num_of_box_values)
            break;
        end        
        initial_box = num_of_box_values(1,:); num_of_box_values(1,:) = [];
        box_temp_values = initial_box;
        initial_box_area = initial_box(3)-initial_box(1);
        initial_box_area = initial_box_area + 1;
        initial_box_area = initial_box_area .*(initial_box(4)-initial_box(2)+1);        
        initial_confidence = num_of_confidence_values(1); num_of_confidence_values(1) = [];
        confidence_temp_values = initial_confidence;
        initial_scale = num_of_scale_values(1); num_of_scale_values(1) = [];
        scale_temp_values = initial_scale;        
        initial_box_dim_max_1 = max(initial_box(1),num_of_box_values(:,1));
        initial_box_dim_max_2 = max(initial_box(2),num_of_box_values(:,2));
        initial_box_dim_min_3 = min(initial_box(3),num_of_box_values(:,3));
        initial_box_dim_min_4 = min(initial_box(4),num_of_box_values(:,4));        
        box_initial = [initial_box_dim_max_1 initial_box_dim_max_2 ... 
                       initial_box_dim_min_3 initial_box_dim_min_4];                   
        width_val = box_initial(:,3) - box_initial(:,1);
        width_val = width_val + 1;
        height_val = box_initial(:,4) - box_initial(:,2);
        height_val = height_val + 1;
        total_area = width_val .* height_val;
        num_of_box_values_3_m = num_of_box_values(:,3)-num_of_box_values(:,1);
        num_of_box_values_3_m = num_of_box_values_3_m + 1;
        num_of_box_values_4_m = num_of_box_values(:,4)-num_of_box_values(:,2);
        num_of_box_values_4_m = num_of_box_values_4_m + 1;
        area_box = initial_box_area + (num_of_box_values_3_m.*num_of_box_values_4_m);
        area_box = area_box - total_area;
        area_value_temp = 0.1 ./ 2;
        area_per_box = total_area./area_box; ind_rand = find(area_per_box>area_value_temp);
        ind_box = [initial_box; num_of_box_values(ind_rand,:)]; num_of_box_values(ind_rand,:) = [];        
        ind_confidence = [initial_confidence; num_of_confidence_values(ind_rand)];
        num_of_confidence_values(ind_rand) = [];
        rand_scale_val = [initial_scale; num_of_scale_values(ind_rand)]; num_of_scale_values(ind_rand) = [];        
        max_ind_confidence =  max(ind_confidence(:));  max_ind = find(ind_confidence == max_ind_confidence);
        box_val_updated = ind_box(max_ind,:); confidence_val_updated = ind_confidence(max_ind); scale_val_updated = rand_scale_val(max_ind);        
        box_fin_values  = [box_fin_values ; box_val_updated]; confidence_fin_values  = [confidence_fin_values ; confidence_val_updated];
        scale_fin_values  = [scale_fin_values ; scale_val_updated];    
    end
    box_final_val = box_fin_values;confidence_final_val = confidence_fin_values;scaling_final_val = scale_fin_values;
end