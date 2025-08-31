function z = myfun(x,y,A,type)
if(type) % circle
    z = x.^2 + y.^2 + A(1)*x + A(2)*y + A(3);
else % ellipse
    z = A(1)*(x.^2) + A(2)*(x.*y) + A(3)*(y.^2) + A(4)*x + A(5)*y + A(6);
end;
%% EOF