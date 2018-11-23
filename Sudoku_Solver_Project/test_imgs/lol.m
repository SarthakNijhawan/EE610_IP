for i=1:10
    fid=fopen(strcat('data', num2str(i-1)),'r');
    [t,N]=fread(fid,[28 28], 'uchar');
    [t,N]=fread(fid,[28 28], 'uchar');
    [t,N]=fread(fid,[28 28], 'uchar');
    imwrite(t, strcat('testdig',num2str(i-1),'.jpg'));
end