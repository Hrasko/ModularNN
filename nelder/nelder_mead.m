function [ x_opt, n_feval, best] = nelder_mead ( x, function_handle, flag )

%****************************************************************************
%
%% NELDER_MEAD performs the Nelder-Mead optimization search.
%
%  Licensing:
%
%    This code is distributed under the GNU LGPL license.
%
%  Modified:
%
%    19 January 2009
%
%  Author:
%
%    Jeff Borggaard
%
%  Reference:
%
%    John Nelder, Roger Mead,
%    A simplex method for function minimization,
%    Computer Journal,
%    Volume 7, Number 4, January 1965, pages 308-313.
%
%  Parameters:
%
%    Input, real X(M+1,M), contains a list of distinct points that serve as 
%    initial guesses for the solution.  If the dimension of the space is M,
%    then the matrix must contain exactly M+1 points.  For instance,
%    for a 2D space, you supply 3 points.  Each row of the matrix contains
%    one point; for a 2D space, this means that X would be a
%    3x2 matrix.
%
%    Input, handle FUNCTION_HANDLE, a quoted expression for the function,
%    or the name of an M-file that defines the function, preceded by an 
%    "@" sign;
%
%    Input, logical FLAG, an optional argument; if present, and set to 1, 
%    it will cause the program to display a graphical image of the contours 
%    and solution procedure.  Note that this option only makes sense for 
%    problems in 2D, that is, with N=2.
%
%    Output, real X_OPT, the optimal value of X found by the algorithm.
%

%
%  Define algorithm constants
%

  rho = 1;    % rho > 0 reflection coeficient
  xi  = 2;    % xi  > max(rho, 1)
  gam = 0.5;  % 0 < gam < 1
  sig = 0.5;  % 0 < sig < 1
  
  tolerance = 1.0E-06;
%
%  Initialization
%
  [ temp, n_dim ] = size ( x );

  max_feval = n_dim*10;
  
  if ( temp ~= n_dim + 1 )
    fprintf ( 1, '\n' );
    fprintf ( 1, 'NELDER_MEAD - Fatal error!\n' );
    error('  Number of points must be = number of design variables + 1\n');
  end

  if ( nargin == 2 )
    flag = 0;
  end

  if ( flag )

    xp = linspace(-5,5,101);
    yp = xp;
    for i=1:101
      for j=1:101
        fp(j,i) = feval(function_handle,[xp(i),yp(j)]);
      end
    end
    
    figure ( 27 )
    hold on
    contour(xp,yp,fp,linspace(0,200,25))
    
    if ( flag )
      plot(x(1:2,1),x(1:2,2),'r')
      plot(x(2:3,1),x(2:3,2),'r')
      plot(x([1 3],1),x([1 3],2),'r')
      
      y = [-5*ones(1,11); -4*ones(1,11); -3*ones(1,11); -2*ones(1,11); -1*ones(1,11); 0*ones(1,11); 1*ones(1,11); 2*ones(1,11); 3*ones(1,11); 4*ones(1,11); 5*ones(1,11);];
      %z2 = [y; y; y; y; y; y; y; y; y; y];
      z = -5:1:5;
      plot([z;z;z;z;z;z;z;z;z;z;z],y,'.')
      
      %pause
      plot(x(1:2,1),x(1:2,2),'b')
      plot(x(2:3,1),x(2:3,2),'b')
      plot(x([1 3],1),x([1 3],2),'b')
    end

  end

  index = 1 : n_dim + 1;

  [f    ] = evaluate ( x, function_handle ); 
  n_feval = n_dim + 1;

  [ f, index ] = sort ( f );
  x = x(index,:);
  
  %disp([num2str(x(1,:)) + ' -> ' num2str(fp(1))]);
  %x(1,:)
  %f(1)
  %disp('--');
  
  %x(2,:)
  %f(2)
  %disp('--');

  %x(3,:)
  %f(3)
  %disp('--'); 
%  
%  Begin the Nelder Mead iteration.
%
  converged = 0;
  diverged  = 0;
  iter = 0;
  itermax = 10*n_dim;
  count_shrink = 0;
  %while ( ~converged && ~diverged )
  while(iter < itermax && ~diverged)
      iter=iter+1;
%    
%  Compute the midpoint of the simplex opposite the worst point.
%
    % continuous midpoint
    %x_bar = sum ( x(1:n_dim,:) ) / n_dim;
    
    % integer midpoint
    %x_bar = (1/n_dim+1)*sum(x(n_dim+1,:))
    x_bar = (1/n_dim+1)*sum(x(1:n_dim,:)');
    
%
%  Compute the reflection point.
%
    % continuous reflection point 
    %x_r   = ( 1 + rho ) * x_bar ...
    %            - rho   * x(n_dim+1,:);

    % integer reflection point
    % x_r = x_v+ alpha_e*mi*signal(x_bar - x_v)
    %x_r = x(n_dim+1,:) + alpha*mi*signal(x_bar,x(n_dim+1,:));
    signal = sgnd(x_bar-x(n_dim+1,:));
    mi = ceil(abs(x_bar-x(n_dim+1,:)));
    x_r = x(n_dim+1,:) + mi.*signal.*rho;

    % aplha: integer reflection coeficient
    % mi: integer value between centroid and 
    % signal(k):    1, if k>0
    %               0, if k==0
    %              -1, if k<0
    
    f_r   = feval(function_handle,x_r); 
    n_feval = n_feval + 1;
%
%  Accept the point:
%    
    % if the reflection point is between best and worse
    if ( f(1) <= f_r && f_r <= f(n_dim) )

      x(n_dim+1,:) = x_r;
      f(n_dim+1  ) = f_r; 
      operation = 'reflection';
      if (flag)
        title('reflection')
        disp('reflection');
      end
%
%  Test for possible expansion.
%

    % in this case, the reflection point is better than best
    elseif ( f_r < f(1) )

      % continuous expansion
      %x_e = ( 1 + rho * xi ) * x_bar ...
      %          - rho * xi   * x(n_dim+1,:);
            
      % integer expansion
      %mi = ceil(abs(x_bar-x(n_dim+1,:)));
      %signal = sgnd(x_bar-x(n_dim+1,:));      
      
      %x_e = (1+rho*xi)*x_bar - rho*xi*x(n_dim+1,:);
      %x_c = (1+rho*gam)*x_bar - rho*gam*x(n_dim+1,:);
      x_e = x(n_dim+1,:) + rho.*xi.*mi.*signal;

      f_e = feval(function_handle,x_e); 
      n_feval = n_feval+1;
%
%  Can we accept the expanded point?
%
      if ( f_e < f_r )
        x(n_dim+1,:) = x_e;
        f(n_dim+1  ) = f_e;
        operation = 'expansion';
        if (flag)
            title('expansion');
            disp('expansion');
        end
      else
        x(n_dim+1,:) = x_r;
        f(n_dim+1  ) = f_r;
        operation = 'reflection';
        if (flag)
            title('eventual reflection')
            disp('eventual reflection')
        end
      end
%
%  Outside contraction.
%
    
    % if reflection point is between the worse and before worse, we
    % outside contraction
    elseif ( f(n_dim) <= f_r && f_r < f(n_dim+1) )

      % continuous outside contraction
      %x_c = (1+rho*gam)*x_bar - rho*gam*x(n_dim+1,:);
      
      % ingeger outside contraction
      x_c = x(n_dim+1,:) + rho.*gam.*mi.*signal;
      x_c = x(n_dim+1,:) + ceil(rho.*gam.*mi.*signal);
      
      f_c = feval(function_handle,x_c); n_feval = n_feval+1;
      
      if (f_c <= f_r) % accept the contracted point
        x(n_dim+1,:) = x_c;
        f(n_dim+1  ) = f_c;
        operation = 'contraction';
        if (flag)
            title('outside contraction');
            disp('outside contraction');
        end
      else
        [x,f] = shrink(x,function_handle,sig); n_feval = n_feval+n_dim;
        operation = 'shrink';
        if (flag)
            title('shrink')
            disp('shrink');
        end
      end
%
%  F_R must be >= F(N_DIM+1).
%  Try an inside contraction.
%
    else
      % continuous inside contraction
      %x_c = ( 1 - gam ) * x_bar ...
      %          + gam   * x(n_dim+1,:);
            
      % integer inside contraction
      %mi = ceil(abs(x_bar-x(n_dim+1,:)));
      %signal = sgnd(x_bar-x(n_dim+1,:));      
      x_c = x(n_dim+1,:) + round(gam.*mi.*signal); % round for low lost
      

      f_c = feval(function_handle,x_c); 
      n_feval = n_feval+1;
%
%  Can we accept the contracted point?
%
      if (f_c < f(n_dim+1))
        x(n_dim+1,:) = x_c;
        f(n_dim+1  ) = f_c;
        operation = 'contraction';
        if (flag)
            title('inside contraction')
            disp('inside contraction')
        end
      else
        [x,f] = shrink(x,function_handle,sig); n_feval = n_feval+n_dim;
        operation = 'shrink';
        if (flag)
            title('shrink')
            disp('shrink')
        end
      end
%
    end
%
%  Resort the points.  Note that we are not implementing the usual
%  Nelder-Mead tie-breaking rules  (when f(1) = f(2) or f(n_dim) =
%  f(n_dim+1)...
%
    [ f, index ] = sort ( f );
    x = x(index,:);
    
    % count of shrink operation
    if strcmp(operation,'shrink')
        count_shrink = count_shrink + 1;
    else
        count_shrink = 0;
    end
    
    if count_shrink == n_dim
        iter = itermax;
    end
    
    %disp('========');
  %x(1,:)
  %f(1)
  %disp('--');
  
  %x(2,:)
  %f(2)
  %disp('--');

  %x(3,:)
  %f(3)
  %disp('--'); 
%
%  Test for convergence
%
    converged = f(n_dim+1)-f(1) < tolerance;
%   
%  Test for divergence
%
    diverged = ( max_feval < n_feval );
    
    if (flag)
      plot(x(1:2,1),x(1:2,2),'r')
      plot(x(2:3,1),x(2:3,2),'r')
      plot(x([1 3],1),x([1 3],2),'r')
      %plot(x_bar,'r*')
      pause
      plot(x(1:2,1),x(1:2,2),'b')
      plot(x(2:3,1),x(2:3,2),'b')
      plot(x([1 3],1),x([1 3],2),'b')
    end

  end

  if ( 0 )
    fprintf('The best point x^* was: %d %d\n',x(1,:));
    fprintf('f(x^*) = %d\n',f(1));
  end

  x_opt = x(1,:);
  
  best = f(1);
  
  if ( diverged )
    fprintf ( 1, '\n' );
    fprintf ( 1, 'NELDER_MEAD - Warning!\n' );
    fprintf ( 1, '  The maximum number of function evaluations was exceeded\n')
    fprintf ( 1, '  without convergence being achieved.\n' );
  end
end

function signal=sgnd(k)
    signal = zeros(1,length(k));
    for i=1:length(signal)
        if k(i) > 0
            signal(i) = 1;
        end
        if k(i) == 0
            signal(i) = 0;
        end
        if k(i) < 0
            signal(i) = -1;
        end
    end
end

function f = evaluate ( x, function_handle )

%*****************************************************************************80
%
%% EVALUATE handles the evaluation of the function at each point.
%
%  Licensing:
%
%    This code is distributed under the GNU LGPL license.
%
%  Modified:
%
%    19 January 2009
%
%  Author:
%
%    Jeff Borggaard
%
%  Reference:
%
%    John Nelder, Roger Mead,
%    A simplex method for function minimization,
%    Computer Journal,
%    Volume 7, Number 4, January 1965, pages 308-313.
%
%  Parameters:
%
%    Input, real X(N_DIM+1,N_DIM), the points.
%
%    Input, real FUNCTION_HANDLE ( X ), the handle of a MATLAB procedure
%    to evaluate the function.
%
%    Output, real F(1,NDIM+1), the value of the function at each point.
%
  [ temp, n_dim ] = size ( x );

  f = zeros ( 1, n_dim+1 );
  
  for i = 1 : n_dim + 1
    f(i) = feval(function_handle,x(i,:));
  end

  return
end
function [ x, f ] = shrink ( x, function_handle, sig )

%*****************************************************************************80
%
%% SHRINK shrinks the simplex towards the best point.
%
%  Discussion:
%
%    In the worst case, we need to shrink the simplex along each edge towards
%    the current "best" point.  This is quite expensive, requiring n_dim new
%    function evaluations.
%
%  Licensing:
%
%    This code is distributed under the GNU LGPL license.
%
%  Modified:
%
%    19 January 2009
%
%  Author:
%
%    Jeff Borggaard
%
%  Reference:
%
%    John Nelder, Roger Mead,
%    A simplex method for function minimization,
%    Computer Journal,
%    Volume 7, Number 4, January 1965, pages 308-313.
%
%  Parameters:
%
%    Input, real X(N_DIM+1,N_DIM), the points.
%
%    Input, real FUNCTION_HANDLE ( X ), the handle of a MATLAB procedure
%    to evaluate the function.
%
%    Input, real SIG, ?
%
%    Output, real X(N_DIM+1,N_DIM), the points after shrinking was applied.
%
%    Output, real F(1,NDIM+1), the value of the function at each point.
%
  [temp,n_dim] = size(x);

  x1 = x(1,:);
  f(1) = feval(function_handle,x1);

  for i=2:n_dim+1
    x(i,:) = floor(sig*x(i,:) + (1-sig)*x(1,:));
    f(i) = feval(function_handle,x(i,:));
  end
end