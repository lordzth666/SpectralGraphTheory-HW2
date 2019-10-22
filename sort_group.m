function sorted_groups = sort_group(groups)
    [out, idx] = sort(groups);
    m = size(out, 1);
    sorted_groups = zeros(m, 1);
    id = 1;
    for i=1:length(out)-1
        sorted_groups(idx(i)) = id;
        if out(i+1) ~= out(i)
            id = id + 1;
        end
    end
    sorted_groups(idx(m)) = id;
end