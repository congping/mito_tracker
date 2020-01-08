files=dir('*w1*.tif');

for i=1:length(files)
    fname=files(i).name;
    mov=readTifMovie(fname);
    str=strcat('mov_',fname(1:end-4),'.mat');
    save(str, mov)
end
