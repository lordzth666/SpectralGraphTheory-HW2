function Geod = get_geodesics_all( Ak_cells, dispFlag ) 
% 
%  Geod = get_geodesics_all( Ak_cells ) ; 
%  
%  INPUT 
%  Ak_cells : the out of get_Pk_counts(..) 
%  dispFlag : binary flag for displaying the resulting matrix 
% 
%  OUTPUT 
%  the geodesic distance matrix 
%   (-c) for no path, c = 5 for better contrast in display 
% 
%  see demo_get_Pk 
%% 


diamG = length(Ak_cells);
n     = size( Ak_cells{1}, 1 );

c     = 5; 
Geod  = (-c) * ones( n, n );

for i = 1:diamG   
    
    Geod = Geod + (c+i)*full( Ak_cells{i}(:,:) > 0 ); 

end

Geod(1:n+1:end) = 0;            % set zero diagonal elements 


%%

figure 
imagesc( Geod )
colorbar 
axis equal tight 
title( 'the geodesic matrix') 
colormap( pink ) 
xlabel('\bf any negative value denotes the absence of path')
return 

%% Program Log 
%  Initial draft: Sept. 15, 2019 
%  Last revision: Sept. 30, 2019  
%
%  Programmer: Xiaobai Sun 
%               Duke CS 
% 

