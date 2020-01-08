%% CLin 02/03/2016
%% track interpolation
function track_new=trackInteroplation(track)
track_new=[];
for i=1:max(track(:,4))
    ind= track(:,4)==i;
    A=track(ind,1:4);
    if A(end,3)-A(1,3)+1==size(A,1)
        track_new=[track_new;A];
    else
        t=A(1,3):A(end,3);
        vq2=interp1(A(:,3),A(:,2),t)';
        vq1=interp1(A(:,3),A(:,1),t)';
        
        A=[vq1,vq2,t',i.*ones(length(t),1)];
        track_new=[track_new;A];
    end
end