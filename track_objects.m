function traj=track_objects(mov,radius,threshold,diameter,maxdis)
k=1;
pre_im=get_objects(mov,k,radius,threshold,diameter);
pre_s = regionprops(pre_im,'Centroid','FilledArea');
pre_traj=set_struct_object(pre_s,k,true);
traj=pre_traj;
for k=2:40%length(mov)
    k
    curr_im=get_objects(mov,k,radius,threshold,diameter);    
    curr_s = regionprops(curr_im,'Centroid','FilledArea');
    curr_traj=set_struct_object(curr_s,k,false);
    [pre_traj,curr_traj]=update_index(pre_traj,curr_traj,maxdis);
    pre_ind=cat(1,pre_traj.index);
    curr_ind=cat(1,curr_traj.index);    
    ind=intersect(pre_ind,curr_ind)'; 
    ind_left=setxor(curr_ind',ind);
    
    ind_traj=cat(1,traj.index);
    for ii=1:length(ind)
        i=ind(ii);
        k1=get_object_index(traj,i);
        k2=get_object_index(curr_traj,i);        
        traj(k1).time=[traj(k1).time,curr_traj(k2).time];
        traj(k1).position=[traj(k1).position;curr_traj(k2).position];
        traj(k1).velocity=[traj(k1).velocity;curr_traj(k2).velocity];
    end
    
    for ii=1:length(ind_left)
        i=ind_left(ii);
        k2=get_object_index(curr_traj,i);   
        traj=[traj,curr_traj(k2)];
    end
    
    
    pre_traj=curr_traj;
end

% remove those not moving



