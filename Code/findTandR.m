function [R,T] = findTandR(E)
    % Calculating R and T from essential matrix
    [U,~,V] = svd(E);
    
    W = [0 -1 0;
        1 0 0;
        0 0 1];
    
    R1 = U*W'*V';
    R2 = U*W*V';
    
    if (det(R1) < 0)
        R1=-R1;
    end
    
    if (det(R2) < 0)
        R2=-R2;
    end
    
    if((R1(1,1)>0)&&(R1(2,2)>0)&&(R1(3,3)>0))
        R=R1;
    else
        R=R2;
    end
    
    T = U(:,3);
end

