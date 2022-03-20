function HuffmanEnco(name) 
    fid = fopen(name,'rt');
    if (fid < 0)
        fprintf(['Cannot open file \"' s '\".\n']);
        return;
    end
    fullfile = fscanf(fid,'%c',[1, inf]);
    fclose(fid);
    frequency = FrequencyTable(fullfile);
    [character code len] = Encode(frequency);
    str = '';
    k = 1;
    for i=1:length(fullfile)
        index = find(character == fullfile(i));
        for j=1:len(index)
            str(k) = code(index,j);
            k = k+1;
        end
    end
    n = floor(length(str)/8);
    newstr = '';
    for i=1:n
        val = 0;
        for j=1:8
            val = val+(str(8*(i-1)+j)-'0')*2^(8-j);
        end
        newstr = [newstr char(val)];
    end
    a = length(str)-8*n;
    newstr = [num2str(a) newstr];
    if (a~=0)
        for i=1:a
            val = val+(str(8*n+i)-'0')*2^(8-i);
        end
        newstr = [newstr char(val)];
    end
    total = length(str)+sum(len)+length(character)*8;
    position = find(name == '.');
    for i=1:position-1
        newname(i) = name(i);
    end
    save(newname,'character','code','str')
    newname = [newname '_enco.txt'];
    fid1 = fopen(newname,'w');
    fwrite(fid1,newstr);
    fclose(fid1);
    fileinfo = dir(name);
    filesize = fileinfo.bytes*8;
    fprintf('Total number of bits before encoding: %d\n',filesize);
    fprintf('Total number of bits after encoding: %d\n',total);
    fprintf('Percentage of size compressed: %5.2f%%\n',100*(filesize-total)/filesize);
end

function frequency = FrequencyTable(data)
    k = 2;
    frequency(1,1) = double(data(1));
    frequency(1,2) = 1;
    for i=2:length(data)
        num = double(data(i));
        if (isempty(find(frequency(:,1) == num)));
            frequency(k,1) = num;
            frequency(k,2) = 1;
            k = k+1;
        else
            frequency(find(frequency(:,1) == num),2) = frequency(find(frequency(:,1) == num),2)+1;
        end
    end
    frequency = sortrows(frequency,2);
end

function [character code len] = Encode(frequency)
    [row col] = size(frequency);
    top = 2*row-1;
    value = zeros(top,1);
    for i=1:row
        value(i) = frequency(i,2);
    end
    j = 1;
    k = row+1;
    for i=row+1:top
        if ((value(k)~=0 && value(k)<value(j)) || j>row)
            num1 = value(k);
            value(k) = 10*i;
            k = k+1;
        else
            num1 = value(j);
            value(j) = 10*i;
            j = j+1;
        end
        if ((value(k)~=0 && value(k)<value(j)) || j>row)
            num2 = value(k);
            value(k) = 10*i+1;
            k = k+1;
        else
            num2 = value(j);
            value(j) = 10*i+1;
            j = j+1;
        end
        value(i) = num1+num2;
    end
    for i=1:row
        str = GetCode(i,value,top);
        for j=1:length(str)
            code(i,j) = str(j);
        end
        len(i) = length(str);
    end
    for i=1:row
        character(i) = char(frequency(i,1));
    end
    return
end

function str = GetCode(index,value,top)
    if (index == top)
        str = '';
        return;
    end
    if (mod(value(index),10) == 0)
        str1 = GetCode(value(index)/10,value,top);
        str = [str1 '0'];
    else
        str1 = GetCode((value(index)-1)/10,value,top);
        str = [str1 '1'];
    end
end
    