
function mov=readTifMovie(fname)
tic
mov=struct('cdata',[]);
% % if isempty(filename)
% %             disp('User pressed cancel')
% % else
%             info = imfinfo(fname);
%             nFrames = numel(info);
%  for i=1:nFrames
%     temp= imread(fname, i, 'Info', info); 
%     mov(i).cdata =temp;
%  end

%end

InfoImage=imfinfo(fname);
%mImage=InfoImage(1).Width;
%nImage=InfoImage(1).Height;
NumberImages=length(InfoImage);
%FinalImage=zeros(nImage,mImage,NumberImages,'uint16');
 
TifLink = Tiff(fname, 'r');
for i=1:NumberImages
   TifLink.setDirectory(i);
   %FinalImage(:,:,i)=
   mov(i).cdata=TifLink.read();
end
TifLink.close();

%% not working due to update of tifflib in matlab
% FileTif=fname;
% InfoImage=imfinfo(FileTif);
% mImage=InfoImage(1).Width;
% nImage=InfoImage(1).Height;
% NumberImages=length(InfoImage);
% FinalImage=zeros(nImage,mImage,NumberImages,'uint16');
% FileID = tifflib('open',FileTif,'r');
% rps = tifflib('getField',FileID,Tiff.TagID.RowsPerStrip);
%  
% for i=1:NumberImages
%    tifflib('setDirectory',FileID,i);
%    % Go through each strip of data.
%    rps = min(rps,nImage);
%    for r = 1:rps:nImage
%       row_inds = r:min(nImage,r+rps-1);
%       stripNum = tifflib('computeStrip',FileID,r);
%       FinalImage(row_inds,:,i) = tifflib('readEncodedStrip',FileID,stripNum);
%    end
% end
% tifflib('close',FileID);

% 
% tsStack = TIFFStack(fname);
% nFrames=size(tsStack,3);
% for i=1:nFrames
%     if length(size(tsStack))==4
%     mov(i).cdata=squeeze(tsStack(:,:,i,:));
%     elseif length(size(tsStack))==3
%         mov(i).cdata=tsStack(:,:,i);
%     end
% end
toc