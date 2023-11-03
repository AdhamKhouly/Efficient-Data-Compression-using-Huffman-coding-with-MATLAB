clc;
% open input file 
fid = fopen('Bonus.txt', 'rb');

% read the file in chunks (optimization hack)
chunk_size = 1024*1024; % 1 MB
text = uint8([]);
while ~feof(fid)
    chunk = fread(fid, chunk_size, 'uint8=>uint8');
    text = [text; chunk];
end

% close file
fclose(fid);

% calculate the probability of each symbol
[symbols, ~, idx] = unique(text);
counts = accumarray(idx, 1);
probabilities = counts / numel(text);

% design the Huffman code
[dict, avglen] = huffmandict(double(symbols), probabilities);

% encode with Huffman coding
encoded = huffmanenco(text, dict);

% determine size of Huffman file in bits
huffman_size = numel(encoded);

% convert text to binary and determine the size of the equal-length file in bits
binary_text = reshape(dec2bin(text, 8).', [], 1);
equal_length_size = numel(binary_text);

% find the entropy of the source
entropy = -sum(probabilities .* log2(probabilities));

% calculate the efficiencies of Huffman and equal length encoding
huffman_efficiency = entropy / avglen; 
equal_length_efficiency = entropy /(6*(sum(probabilities))); 


% print results on console
fprintf('Entropy of the source: %f bits/symbol\n', entropy);
fprintf('Efficiency of Huffman encoding: %f%% \n', huffman_efficiency*100);
fprintf('Efficiency of equal length encoding: %f%% \n', equal_length_efficiency*100);
fprintf('Huffman coded file size: %d bytes\n', ceil(huffman_size/8));
fprintf('Equal length coded file size: %d bytes\n', ceil(equal_length_size/8));
clear;