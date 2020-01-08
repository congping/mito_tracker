function Im_obj=get_objects(mov,k,radius,threshold,diameter,channel)
im=mov(k).cdata(:,:,channel);% red channel
im2=medfilt2(im,[radius,radius]);
Im_obj=im2>threshold;
%se = strel('disk',diameter);

%stats = regionprops(im2>0,'MinorAxisLength','MajorAxisLength','PixelIdxList','Image');
%Im=zeros(size(im2));
% for i=1:length(stats)
%     if stats(i).MajorAxisLength>1.3*
% end

%Im_obj=imerode(im2>0,se);

% %remove small tracked object
% stats = regionprops(Im_obj,'MinorAxisLength','BoundingBox');
% a=cat(1,stats.MinorAxisLength);
% ind=find(a<diameter);
% for i=1:length(ind)
%     j=ind(i);
%     w=stats(j).BoundingBox;
%     Im_obj(ceil(w(2)):ceil(w(2))+w(4)-1,ceil(w(1)):ceil(w(1))+w(3)-1)=zeros(w(4),w(3));
% end


