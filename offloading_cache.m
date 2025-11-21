function lpp = offloading_cache(C,P,D)
np = size(C,1);
nc=size(C,2);
nx=numel(C);

% f, A, b ,lb
% Objective Functions
f=C(:);
ind=@(i,j) sub2ind(size(C),i,j);
A=zeros(np + nc,nx);
b=zeros(np + nc,1);
c=0;

% Constraints  Prodactions Capacities 
for i=1:np
    c=c+1;
    for j=1:nc
 A(c,ind(i,j))=1;
    end
b(c)=P(i);
end


for j=1:nc
    c=c+1;
    for i=1:np
    A(c,ind(i,j))=1;
    end
   b(c)= D(j);
end

lb=zeros(nx,1);


lpp.np=np;
lpp.nc=nc;
lpp.nx=nx;
lpp.s=size(C);
lpp.f=f;
lpp.A=A;
lpp.b=b;
lpp.lb=lb;


end



