%%  test_get_Pk( A ) 
% 
%   SCRIPT for demonstrating the use of following functions 
%      get_Pk_counts(.) 
%      depict_Pk_counts(..) 
%      get_geodesics_all(...) 
% 
%% 

close all
clear all

fprintf('\n\n   %s BEGAN \n\n', mfilename); 


%% generate a test matrix A 

n = 17;


%% 
caseLab = { 'cycle unidirectional',
              'cycle bi-directional', 
             'path unidirectional', 
             'path bi-directional', 
             'star', 
             'wheel', 
             'star and uni-ring' };            

caseLab                       % to show the contents for case selection 

caseIdx = input('\n enter the index to a test case in the caseLib =  ') ; 
         
demoCase = caseLab{ caseIdx };

%% ====================================================================


fprintf('\n\n test case: %s \n', demoCase );  

switch demoCase 
    case 'cycle unidirectional'

    A = eye(n);
    A = A( :, [2:n,1] );    
    
    
    case 'cycle bi-directional' 
        
    A = eye(n);
    A = A( :, [2:n,1] );     
    A = A + A';             
    
    case 'path unidirectional' 
      A = eye(n);
      A = A( :, [2:n,1] );
      A(1,n) = 0;
      
    case 'path bi-directional' 
      A = eye(n);
      A = A( :, [2:n,1] );
      A(1,n) = 0;
      A = A + A';
      
    case 'star'
      A = zeros(n);
      A(:,n) = 1;
      A(n,n) = 0; 
      A = A + A';  
      
    case 'wheel' 
      
       A = eye(n-1);
       A = A( :, [2:n-1,1] );     
       A = [ A, ones(n-1,1); zeros(1,n) ]; 
       A = A + A';  
    
    case 'star and uni-ring'
       A = eye(n-1);
       A = A( :, [2:n-1,1] );     
       A = [ A, ones(n-1,1); ones(1,n-1), 0 ];
       
    otherwise 
        error('unknown demo case')
        
end 

A = sparse(A) ; 

%% =========  get the basic information, without losing the path counts 

%% ...  get the Pk graphs from P1, K > 1   

Ak_cells = get_Pk_counts( A );

%% ...  get betweenness
for k=1:n
    B_score = get_betweenness( k, Ak_cells, 1 );
    fprintf('\n\n   For node #%d, the betweenness score is %f \n\n', k, B_score);
end

%% 
fprintf('\n\n   %s ENDED \n\n', mfilename);

return 

