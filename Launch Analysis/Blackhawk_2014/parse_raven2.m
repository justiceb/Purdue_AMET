function [ data_out ] = parse_raven2( filename )

fid = fopen(filename,'r');
text = textscan(fid,'%s','delimiter','\n');  % Read strings delimited
text = text{1};

n1 = 0;
n2 = 0;
n3 = 0;
for n = 1:1:length(text)
    line = strread(text{n},'%s','delimiter','\t');
    switch line{1}
    case 'X'
        n1 = n1 + 1;
        hz400.t(n1) = (n1-1)*(1/400);
        hz400.X(n1) = str2double(line{2});
    case 'Y'
        n2 = n2 + 1;
        hz200.t(n2) = (n2-1)*(1/200);
        hz200.Y(n2) = str2double(line{2});
    case 'T'
        n3 = n3 + 1;
        hz20.t(n3) = (n3-1)*(1/20);
        hz20.T(n3) = str2double(line{2});
    case 'P'
        hz20.P(n3) = str2double(line{2});
    end
end

data_out.hz400 = hz400;
data_out.hz200 = hz200;
data_out.hz20 = hz20;
end

