function [] = update_x(arg1,arg2)

%fprintf(strcat(arg1,"A.csv"))
A = csvread(strcat(arg1,"A.csv"));
x_old = csvread(strcat(arg1,"x.csv"));
y = csvread(strcat(arg1,"y.csv"));
mu = csvread(strcat(arg1,"mu.csv"));

%%% Init variables OPF
S_base = 100; %MVA
n = size(y,1);
c = zeros(n,1);
c(3)=1;

cp = zeros(n);
cp(5)=200;
rho=arg2;

n_childs = floor((n-7)/3);
B = zeros(3,n);
B(1,5)=2;
B(2,6)=2;
B(3,2)=-1;
B(3,7)=1;

D = zeros(n,1); 
E = zeros(n,1);

D(1,1) = 1;
E(7,1) = 1;

% Problem OPF: 
cvx_begin quiet
    variable x(n,1)
    minimize(square(c'*x) + mu'*x + .5*rho*(x-y)'*(x-y));
    x(3)==0;
    x(2)<=1.1;
    x(2)>=.9;
    x(1)<=1.1;
    x(1)>=.9;
    norm(B*x,2) <= x(1) + x(7);
cvx_end
csvwrite(strcat(arg1,"x.csv"),x)
residuo = norm(x-y,2);
dlmwrite('estado.dat',x','-append');
dlmwrite('residuo.dat',residuo,'-append');
dlmwrite('costo.dat',c'*x,'-append');
end