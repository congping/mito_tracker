function tracks=joinTracks(tracks,ID1,ID2)
ind1=find(tracks(:,4)==ID1);
ind2=find(tracks(:,4)==ID2);

t1=tracks(ind1,3);
t2=tracks(ind2,3);

if isempty(intersect(t1,t2))
    tracks(ind1,4)=min(ID1,ID2);
    tracks(ind2,4)=min(ID1,ID2);
else
    display('there is overlap on time')
end