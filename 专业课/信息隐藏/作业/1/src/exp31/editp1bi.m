function image = editp1bi(headr,  headc, image, pixel, count, randr, randc)
    c = 0;
    for i = 1 : 64
        if image(headr + randr(i), headc + randc(i)) == pixel
            % 八连接检测
            if image(headr + randr(i) - 1, headc + randc(i)) == ~pixel || ...
               image(headr + randr(i) + 1, headc + randc(i)) == ~pixel || ...
               image(headr + randr(i), headc + randc(i) - 1) == ~pixel || ...
               image(headr + randr(i), headc + randc(i) + 1) == ~pixel || ...
               image(headr + randr(i) - 1, headc + randc(i) - 1) == ~pixel || ...
               image(headr + randr(i) - 1, headc + randc(i) + 1) == ~pixel || ...
               image(headr + randr(i) + 1, headc + randc(i) - 1) == ~pixel || ...
               image(headr + randr(i) + 1, headc + randc(i) + 1) == ~pixel 
                
               % 讲要修改的块加上 0.01，这样能够避免边界扩散
               image(headr + randr(i) , headc + randc(i)) = ~pixel + 0.01;
               c = c + 1;
            end
        end
        if c == count
            return
        end
    end
    
    if c ~= count
        disp("warning! 参数选择不当，未能完全按要求修改本块信息。信息可能无法提取，建议重做");
    end
end
