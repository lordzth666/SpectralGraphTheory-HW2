%
% SCRIPT: SCRIPT_BUILD_KNN_ADJACENCY
%
%  DEMO case for vertex data to kNN graph 
%       with a specific dataset pbmc8k_v2.1.0_knn.mat 
%
%  in detail
%     
%     -- specify the vertex feature data file 
%     -- load the data file 
%     -- convert the vertex data to kNN graph 
%     -- calculate and displey graph statistics 101 
% 
%  Callee function 
%      knnsearch2sparse( ... ) ;  
% 

%% CLEAN-UP

clear all 
close all


%% PARAMETERS

Datafilename = 'pbmc8k_v2.1.0_knn.mat'


%% (BEGIN)

fprintf('\n\n   *** %s  BEGAN *** \n\n', mfilename);

%% LOAD DATA

fprintf( '\n   loading data from file %s...\n', Datafilename  ); 

iodata = matfile( Datafilename );

I = iodata.I;                   % indices to neighbor nodes  
D = iodata.D;                   % distances to neighbors 

kmax = size( D, 2 );
n    = size( D, 1 ); 

fprintf('\n   data with %d vertices and their %d neighbors loaded \n', n, kmax ); 

fprintf( '\n   select a k value (<= %d)', kmax ); 
k = input( ' and enter k = ');




%% ======================== mostly data indepdent ===================== 

%%  ... truncate data to k-neighbors/vertex 

Ik = I(:,1:k);
Dk = D(:,1:k);


%% ... BUILD ADJACENCY GRAPH

fprintf( '\n   building the kNN graph...\n' ); 

Ak = knnsearch2sparse( Ik, Dk )';   % k-neighbors per node column 


%% ... DISPLAY KNN GRAPH

fprintf( '\n   displayomg the  kNN graph ...\n\n' ); 

figure 
imagesc( log( Ak + eps) ) 
title('The kNN graph : k-neighbor/column (weighted)  ' )
axis equal tight 
colorbar 
xlabel( sprintf( 'n=%d, k=%d', n, k) )

figure 
dout = sum(Ak,1)';
din  = sum(Ak,2) ;

gplot( Ak, [ dout, din ], 'm+' );
axis tight 
title('vertex embedding by in-degrees and out-degrees (weighted)' )
xlabel( 'out-degrees')
ylabel( 'in-degrees')

figure 
gplot( Ak, [dout, din], 'b.-' );
axis tight 
title( 'graph plotting with vertices embeded by in-degrees and out-degrees') 
xlabel( 'out-degrees')
ylabel( 'in-degrees')

figure 
subplot(2,1,1)
histogram( sum( Ak > 0, 2), 10 ) 
xlabel('histogram of in-degrees (unweighted edges)')
subplot(2,1,2) 
histogram( sum( Ak > 0, 1) )
xlabel('histogram of out-degrees (unweighted edges)')


%% (END)

fprintf('\n *** %s ENDED *** \n\n', mfilename);


%%------------------------------------------------------------
%
% AUTHORS
%
%   Dimitris Floros                         fcdimitr@auth.gr
%
% VERSION       0.1
%
% TIMESTAMP     <Oct 1, 2019: 21:03:30 Dimitris>
%
% ------------------------------------------------------------
%% Review and revision by 
%    Xiaobai Sun 
%    Oct. 1, 2019 
% 
%% 