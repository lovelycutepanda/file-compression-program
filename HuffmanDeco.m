function HuffmanDeco(name)
    position = find(name == '.');
    for i=1:position-1
        newname(i) = name(i);
    end
    n1 = [newname '.mat'];
    if (~exist(n1,'file'))
        fprintf(['Cannot find file \"' n1 '\".\n']);
        return;
    end
    n2 = [newname '_enco.txt'];
    if (~exist(n2,'file'))
        fprintf(['Cannot find file \"' n2 '\".\n']);
        return;
    end
    fid = fopen(n2,'rt');
    text = fscanf(fid,'%c',[1, inf]);
    fclose(fid);
    load(newname);
    [row col] = size(code);
    for i=1:length(character)
        j = 1;
        while (j<=col)
            if (code(i,j)~='0' && code(i,j)~='1')
                break;
            end
            j = j+1;
        end
        len(i) = j-1;
    end
    bot = min(len);
    top = max(len);
    a = text(1)-'0';
    newtext = '';
    for i=2:length(text)-1
        str1 = Decode(text(i));
        newtext = [newtext str1]
    end
    if (a==0)
        str1 = Decode(text(end));
        newtext = [newtext str1]
    else
        str1 = Decode(text(end));
        for j=1:a
            newtext(8*(length(text)-1)+j) = str1(j)
        end
    end
    k = 1;
    str = '';
    while k<=length(newtext)
        found = false;
        for j=bot:top
            v = find(len == j);
            for i=1:length(v)
                found = true;
                for a=1:j
                    if (code(v(i),a)~=text(k+a-1))
                        found = false;
                        break;
                    end
                end
                if found
                    str = [str character(v(i))];
                    k = k+j;
                    break;
                end
            end
            if found
                break;
            end
        end
    end
    n3 = [newname '_deco.txt'];
    fid1 = fopen(n3,'w');
    fwrite(fid1,str);
    fclose(fid1);
end

function str = Decode(c)
    str = '';
    val = uint8(c);
    for i=1:8
        a = mod(val,2);
        str = [str num2str(a)];
        val = (val-a)/2;
    end
end