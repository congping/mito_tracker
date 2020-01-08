function [tracks, boundary0]=detectObj_max(mov,channel, sigma, threshold, diameter,pixdis,componentsize,flagboundary,flagsco3)
G=fspecial('gaussian',[diameter,diameter],sigma);
%G = fspecial('log', diameter,sigma);
tracks=[];
boundary0=[];

for i=1:length(mov)
   image_array=double(mov(i).cdata(:,:,channel));       
   %res=medfilt2(image_array,[diameter,diameter]);
   res = conv2(image_array,G,'same');
%    res=-res;
%    res(res<0)=0;
    %res=largestConnectComponent(res>threshold,componentsize).*res;
    res=largestConnectComponent(res>mean(res(:))*threshold,componentsize).*res;
    stats=regionprops(res>threshold,'BoundingBox','Image','centroid','PixelIdxList');
    for j=1:length(stats)      
        A=zeros(size(res));
        A(stats(j).PixelIdxList)=res(stats(j).PixelIdxList);
        pks=pkfnd(A,threshold,pixdis);            

        if size(pks,1)==1
          tracks=[tracks;[pks,i]];
          if flagboundary
              Z=bwperim(A>0);
              [r,c]=find(Z>0);
              if flagsco3 
                  bou = struct('boundary',[r,c],'frame',i,'sco3',[]);
              else
                  bou = struct('boundary',[r,c],'frame',i);
              end
              boundary0=[boundary0,bou];
          end
        elseif size(pks,1)>1
            p=[];
            for jj=1:size(pks,1)
                p=[p;A(pks(jj,2),pks(jj,1))];
            end
            pks=[pks,p];
            if flagboundary
                Dis=1000.*ones(size(pks,1),size(pks,1));
                for jj=1:size(pks,1)
                    for kk=jj+1:size(pks,1)
                            Dis(jj,kk)=norm(pks(jj,1:2)-pks(kk,1:2));
                            Dis(kk,jj)=Dis(jj,kk);
                    end
                end
                x=1:size(A,2);
                y=zeros(size(x));
                for jj=1:size(pks,1) 
                    % find the nearest psk and set line segment
                    kk=find(Dis(jj,:)==min(Dis(jj,:)));
                    kk=kk(1);
                    d=A(pks(jj,2),pks(jj,1))/A(pks(kk,2),pks(kk,1)); 
                    m=(d.*pks(kk,1:2)+pks(jj,1:2))./(1+d);
                    y(jj,:)=-(pks(jj,1)-pks(kk,1))/(pks(jj,2)-pks(kk,2)).*(x-m(1))+m(2);
                end
                [r,c]=find(A>threshold);
            end
           for jj=1:size(pks,1)
             if flagboundary
                 Z1=A>0;
                 ind=[];
                 for kk=1:size(pks,1)
                     if y(kk,pks(jj,1))>pks(jj,2)
                         ind=[ind,find(r'>y(kk,c))];                     
                     else
                         ind=[ind,find(r'<y(kk,c))];
                     end
                 end
                 ind=unique(ind);
                 Ind=sub2ind(size(Z1),r(ind),c(ind));
                 Z1(Ind)=0;

                 BW=bwperim(Z1);
                 Z1=BW;%bwmorph(BW,'thin',Inf);
                 Z1(:,1)=0;
                 Z1(1,:)=0;
                 Z1(:,end)=0;
                 Z1(end,:)=0;
                 [r1,c1]=find(Z1>0);
                      if flagsco3 
                      bou = struct('boundary',[r1,c1],'frame',i,'sco3',[]);
                      else
                      bou = struct('boundary',[r1,c1],'frame',i);
                      end
                 boundary0=[boundary0,bou];
             end
             tracks=[tracks;[pks(jj,1),pks(jj,2),i]];
           end
       end  

    end
end