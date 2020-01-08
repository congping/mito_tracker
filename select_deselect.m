function  select_traj=select_deselect(tracks_1,boundary_1,select_traj,coordinates,k)  
     T=struct('traj',[],'boundary',[]);  
     ind1=find(tracks_1(:,3)==k);
     D1=pdist2(coordinates,tracks_1(ind1,1:2));
     d1=min(D1(:));
     i1=find(D1==d1); 
     if ~isempty(select_traj)
       ID = cat(1, select_traj.ID); 
     else
         ID=[];
     end
     Ind=find(ID==tracks_1(ind1(i1(1)),4));
    if isempty(Ind)
         ind=find(tracks_1(:,4)==tracks_1(ind1(i1(1)),4));
         T.traj=tracks_1(ind,:);
         if ~isempty(boundary_1)
             T.boundary=boundary_1(ind); 
         end
         T.ID=tracks_1(ind1(i1(1)),4);
         plot(tracks_1(ind,1),tracks_1(ind,2),'w')
         plot(tracks_1(ind1(i1(1)),1),tracks_1(ind1(i1(1)),2),'yo')
         if ~isempty(boundary_1)
             plot(boundary_1(ind1(i1)).boundary(:,2),boundary_1(ind1(i1)).boundary(:,1),'y.','MarkerSize',5)
         end                   
         select_traj=[select_traj;T];
    else % deselect
         select_traj(Ind)=[];
    end