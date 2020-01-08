function M=convertTracks(tracks)
s=unique(tracks(:,4));%ID
for i=1:length(s)
    ind=find(tracks(:,4)==s(i));
    M((i-1)*3+1:i*3,1:length(ind))=tracks(ind,1:3)';
end