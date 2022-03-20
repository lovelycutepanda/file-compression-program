<h2>File compression program using Huffman’s algorithm</h2>


<h3>1. Introduction</h3>
Huffman's algorithm is a lossless data compression algorithm with use of binary tree. This algorithm has been proven effective and is suitable for general use. In this project, I use matlab to implement this algorithm and test its efficiency in terms of storage space reduced.


<h3>2. User manual</h3>
The main program is named “main.m”. There are two functions inside the program. The first function is compression using Huffman’s algorithm and the second function is decoding the compressed file. 

To use the first function, simply type in 1 (or any other number) and then input the text file to be compressed. The function will show the total number of bits before encoding, total number of bits after encoding and percentage of size compressed. It will also store the dictionary for characters and the corresponding code (in .m format), as well as the whole file after converted to codes (renamed by adding _enco after the name). Note that the code file only shows the optimal code for reference but not the actual compressed file. Also note that file input should be in 8-bit characters, for example .txt files.

To use the second function, type in 2 and then input the original file name (file name without ‘_enco’). The function will then look up for the dictionary (in .m format) as well as the code file (the one with _enco after the name), and then decode it and return the actual text file (renamed by adding _deco after the name). 


<h3>3. Method</h3>
For the encoding function in the program, it counts the frequency of each character in the file and generates a frequency table. After that, it sorts the characters in frequency and convert each character into a tree with node equals character and value equals frequency. The elements are placed in a priority queue conceptually.

Next, we apply Huffman’s algorithm as follows:
Step 1: generate a tree from the first two trees in the priority queue, with value equal the sum of values of the two trees.
Step 2: Place the tree back into proper position
These steps are repeated until there is only one tree left in the queue. 

In practice, I simply use an array to represent the queue and the tree. In the array, there are two parts: the first part is the original array of frequency sorted in order, while the second part is empty storage spaces for placing joined trees. Then, each time I combine two trees, the new tree will be placed in the leftmost empty storage space. Hence the array is sorted in order in both parts and we only need to compare the leftmost element in both parts. 

Now, we pick two smallest elements in this queue. The new storage space contains the sum of the two elements, and the original elements will be changed to a number which contains the index of the new storage space and a digit 0 or 1, representing the left subtree and right subtree respectively. By repeating this process we obtain an array of elements which store the information of parents and whether they are left or right subtree. 

In the final tree, we denote 0 as left subtree and 1 as right subtree. Then, every character is assigned a unique pattern of 0 and 1. Therefore we convert the character array into one single array of 0 and 1 by converting each character into its corresponding pattern. The final pattern of bits will be much shorter than the original text converted to bits, hence there will be storage space saved by Huffman’s algorithm.

For the decoding function, I simply use the dictionary to compare the codes. Once there is a match, I can get the original character since there is no children for the lowest node. 


<h3>4. Results</h3>
Huffman algorithm is especially effective when the file contains a lot of repeated characters. Therefore, it is expected that the efficiency will be higher for a long text file, while the efficiency is low or even negative for a short text file. 

In order to test the efficiency, I used matlab to generate 4 random text files (random_generator.m). For simplicity, I assume that a text file contains only alphabets (both small and capital) and numbers. The original file size is obtained directly using dir function. Number of bits after encoding is estimated by length of final code + number of characters in frequency table + sum of each individual code, since the dictionary for the code should also be put in the encoded file for decoding. However, the actual size of the encoded file may differ slightly due to other issues.

In order to show that it is indeed a lossless data compression method, I also tried decoding the encoded files and it turns out that if there is no special character, the decoding function can return the original text file. Since the original file can be obtained by an individual function, I can say that there is not any loss in data.

Here, I also compared with WinZip to show its efficiency.

Sample 1: 100 random characters
Total number of bits before encoding: 800
Total number of bits after encoding: 1276
Percentage of size compressed: -59.50%
Total number of bits after WinZip: 1400

Sample 2: 1000 random characters
Total number of bits before encoding: 8000
Total number of bits after encoding: 6837
Percentage of size compressed: 14.54%
Total number of bits after WinZip: 7056

Sample 3: 10000 random characters
Total number of bits before encoding: 80000
Total number of bits after encoding: 60700
Percentage of size compressed: 24.13%
Total number of bits after WinZip: 62744

Sample 4: 100000 random characters
Total number of bits before encoding: 800000
Total number of bits after encoding: 599182
Percentage of size compressed: 25.10%
Total number of bits after WinZip: 616680

In practice, characters in a text are usually not randomly generated. In fact, some characters are less frequently used (for example ‘x’, ‘z’, etc). In such cases, Huffman’s algorithm is expected to be even more powerful. Here, I found some text files and try to compress them.

Sample 5: the project information project.pdf copied to txt file (around 3400 characters)
Total number of bits before encoding: 27944
Total number of bits after encoding: 17665
Percentage of size compressed: 36.78% 
Total number of bits after WinZip: 13784

Sample 6: Jerry Ho’s report copied to txt file with all unreadable characters removed (around 4200 characters)
Total number of bits before encoding: 34088
Total number of bits after encoding: 20625
Percentage of size compressed: 39.49%
Total number of bits after WinZip: 15216

Sample 7: my own essay copied to txt file (around 9000 characters)
Total number of bits before encoding: 71176
Total number of bits after encoding: 40936
Percentage of size compressed: 42.49%
Total number of bits after WinZip: 27272

Sample 8: an online essay on Herd Immunity copied to txt file (link: Herd Immunity: Understanding COVID-19 - ScienceDirect) (around 24000 characters)
Total number of bits before encoding: 190152
Total number of bits after encoding: 109419
Percentage of size compressed: 42.46%
Total number of bits after WinZip: 65080

By comparing the compression ratio of these samples with those randomly generated samples, we can see that compression ratio is higher when some characters have higher frequencies and some have lower.

Therefore, the compression ratio is bigger for larger text files and less variety of characters as expected. Note that in some samples, Huffman’s algorithm even outperforms WinZip in terms of storage space compressed. It shows how powerful Huffman’s algorithm is. (Of course, WinZip uses algorithm stronger than solely Huffman’s algorithm, hence it compresses space better than my implementation in most cases.)


<h3>5. Limitations</h3>
Theoretically, Huffman’s algorithm can be used to compress any file types through suitable conversion. However, due to my lack in data conversion knowledge, I am unable to actually write a file after obtaining the string. Hence, I can only write a file that contains the conceptual bits but which are in fact stored in bytes practically, so the size of the output file is much larger than original text file.

Also, only a few types of file inputs are supported, since I cannot guarantee how much bit for each character is supported in other file extensions. This problem also arises when I try decoding function, for instance characters that are not in ASCII table cannot be converted. Hence I have to limit the input such that it contains only ASCII characters.
