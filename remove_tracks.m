

% % remove traj less than mdis
% mdis=8;
% ID=tracks(:,4);
% ind=find(ID~=circshift(ID,-1));
% dis=ind-circshift([0;ind(1:end-1)],-1);
% ii=find(dis>mdis);



for i=1:max(tracks(:,4))
   id=find(tracks(:,4)==i)<mdis; 
   if (length(id)<mdis)
       tracks(id,:)=[];
   end
    
end


