function M = gold(M,seed)

M = double(M);
[m,n] = size(M);
rng(seed);
R = randi(1000,m,n);

for i=1:m
    for j=1:n
        flag = numexpand(10000*M(i,j));
        M(i,j) = bitxor(flag,R(i,j));
        M(i,j) = M(i,j) / 10000;
    end
end
