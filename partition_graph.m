function groups=partition_graph(A, part_idx, indices, N)
    deg = sum(A, 1);
    deg = transpose(deg);
    D = diag(deg);
    L = D - A;
    if size(L, 1) == 0
        groups = sparse(zeros(N, 1));
        return
    end

    if size(L, 1) == 1
        groups = sparse(zeros(N, 1));
        groups(indices) = part_idx;
        return;
    end
    % Retrieve eigenvalue using sparse solver
    n = size(L, 1);
    [V,D] = eigs(L, 2,'smallestreal');
    fidle_value = D(2, 2);
    fidle_vector = V(:, 2);
    if fidle_value <= 1e-8
        group1 = (fidle_vector > 1e-8);
        group2 = (fidle_vector <= 1e-8);
        A1 = A(group1, group1);
        A2 = A(group2, group2);
        group1_ret = partition_graph(A1, part_idx * 2 - 1, indices(group1), N);
        group2_ret = partition_graph(A2, part_idx * 2, indices(group2), N);
        groups = group1_ret + group2_ret;
        return;
    else
        groups = sparse(zeros(N, 1));
        groups(indices) = part_idx;
        return;
    end
end