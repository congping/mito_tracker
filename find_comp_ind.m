function m=find_comp_ind(CC2,p1)
m=[];
for i=1:CC2.NumObjects
    p2=CC2.PixelIdxList{i};
    if ~isempty(intersect(p1,p2));
        m=i;
        break
    end
end