choice = input('Please choose if you want to encode or decode a file (1 for encode, 2 for decode): ');
name = input('Please input the file name: ','s');
if (~exist(name,'file'))
    fprintf(['Cannot find file \"' name '\".\n']);
    return;
end
if (choice == 2)
    HuffmanDeco(name);
else
    HuffmanEnco(name)
end
