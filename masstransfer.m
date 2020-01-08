function v=masstransfer(E1,E2)
%v=[vertical + i* horizontal]
if size(E1)~=size(E2)
    display('two subimages are not of the same size!')
else
    X1=centermass(E1);
    X2=centermass(E2);
    v=X2-X1;

end

function X=centermass(E)
X=0;
for k=1:size(E,1)
for l=1:size(E,2)
X=X+E(k,l)*(k+l*1i);
end
end
X=X./sum(E(:));
