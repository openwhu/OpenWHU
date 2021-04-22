function M = ungold(M,seed)

[m,n] = size(M);
rng(seed);
R = randi(1000,m,n);
for i=1:m
    for j=1:n
        M(i,j) = M(i,j) * 10000;
        M(i,j) = bitxor(int32(M(i,j)),R(i,j));
        M(i,j) = num_unexpand(M(i,j));
        M(i,j) = M(i,j)/10000;
    end
end
