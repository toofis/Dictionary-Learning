function [D,X] = ksvd(D,X,Y)
    
 for i = 1 : size(D,2)
     
  ind = find(X(i,:) ~= 0);
  
  E = Y - D*X + D(:,i)*X(i,:);
  E_reduced = E(:,ind);
  
  if (ind~=0)>0
      
     [U,S,V] = svd(E_reduced);
     
     D(:,i) = U(:,1);
     X(i,:) = 0;
     X(i,ind) = S(1,1)*V(:,1)';
  end
 end
end