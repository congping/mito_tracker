function SS=largestConnectComponent_new(SS,minsize,n)
CC = bwconncomp(SS,n);
numPixels = cellfun(@numel,CC.PixelIdxList);

if isempty(minsize)
[biggest,idx] = max(numPixels);
    for i=1:length(numPixels)
    if i~=idx
        SS(CC.PixelIdxList{i}) = 0;
    end
   end
else
    A=zeros(size(SS));
    for i=1:length(numPixels)
    if numPixels(i)<minsize
        SS(CC.PixelIdxList{i}) = 0;
        A(CC.PixelIdxList{i}) = 1;
    end
    end
end