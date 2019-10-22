function B_score = get_betweenness( k, Ak, flag ) 
% 
% Input
% =====
% k  : the order index of the node which 
%      you want to calculate its betweenness
% Ak : Ak_{ell} contains the matrix of 
%      path with length ell, 1 <= ell <= diam( G) 
%      Ak_calls{ell}(i,j) = number of path with length ell 
%      from vertex j to vertex i
% flag: 1 for undirected graph and 0 for directed graph
% 
% Output
% ======
% B_score : the betweenness score of the node with index k
%            
% 
% 

%% 
    S = get_geodesics_all( Ak, 1 );
    m = find(S(:,k)>0);
    n = find(S(k,:)>0);
    B_score = 0;
    for i=1:length(m)
        for j=1:length(n)
            if(S(k,m(i))+S(n(j),k)==S(n(j),m(i)))
                B_score = B_score + 1/Ak{S(n(j),m(i))}(n(j),m(i));
            end
        end
    end
    if(flag)
        B_score = B_score/2;
    end
    
end