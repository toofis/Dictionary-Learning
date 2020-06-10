function x = GenOMP(D,y,T,e)

r_0 = y;
x = zeros(256,1);
ids=[];
t = 0;

  while (t < T && norm(r_0) > e)
  
   [~,idx] = max(abs(D'*r_0));
   x(idx) = D(:,idx)'*r_0;
   
   ids = [ids idx];
   
   r_0 = (eye(64) - D(:,ids)*inv((D(:,ids)'*D(:,ids)))*D(:,ids)')*y;
   
   t = sum(x ~=0 );
  end
end
