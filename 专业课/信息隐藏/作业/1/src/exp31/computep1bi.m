function p1bi = computep1bi(headr, headc, image)
    p1bi = 0;
    for i = 1 : 10
        for j = 1: 10
            % 白像素所占的比例
            if image(headr + i - 1, headc + j - 1) == 1
                p1bi = p1bi + 1;
            end
        end
    end
end

