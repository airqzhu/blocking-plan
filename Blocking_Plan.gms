$title Blocking Plan Based AV Platoon Problem

sets
    i  nodes  /1*6/
    w  OD pairs /1*8/;

alias (i, j);

parameters n_block(i,j) block network /
    1.2 1
    1.3 1
    1.4 1
    1.5 1
    1.6 1
    2.3 1
    2.4 1
    2.5 1
    2.6 1
    3.5 1
    3.6 1
    4.5 1
    4.6 1
    5.6 1/;

parameter q(w) demand of each od pair /
    1 100
    2 100
    3 100
    4 100
    5 100
    6 100
    7 100
    8 100/;

parameter origin(w,i) origin of each od pair /
    1.1 1
    2.1 1
    3.1 1
    4.2 1
    5.2 1
    6.3 1
    7.4 1
    8.5 1/;

parameter destination(w,i) destination of each od pair /
    1.4 1
    2.5 1
    3.6 1
    4.5 1
    5.6 1
    6.6 1
    7.5 1
    8.6 1/;

parameter intermediate(w,i);
intermediate(w,i)=(1-origin(w,i))*(1-destination(w,i));


parameter c(i,j) cost of each block /
    1.2 10
    1.3 20
    1.4 20
    1.5 30
    1.6 40
    2.3 10
    2.4 10
    2.5 20
    2.6 30
    3.5 10
    3.6 20
    4.5 10
    4.6 20
    5.6 10/;

parameter cap(i,j) capacity of each block /
    1.2 500
    1.3 500
    1.4 500
    1.5 500
    1.6 500
    2.3 500
    2.4 500
    2.5 500
    2.6 500
    3.5 500
    3.6 500
    4.5 500
    4.6 500
    5.6 500/;

parameter g(i) fixed cost at classification node for each block /
    1 100
    2 100
    3 100
    4 100
    5 100
    6 100/;

parameter b(i) maximum number of blocks created at node i /
    1 2
    2 3
    3 2
    4 2
    5 2
    6 3/;

parameter d(i) maximum number of cars handling at node i /
    1 1000
    2 1000
    3 1000
    4 200
    5 1000
    6 1000/;

parameter M an infinite number  /10000/;


variable z;
positive variable f(i,j,w) the amount of flow travels block from i to j;
binary variable y(i,j) whether block from i to j open or not;

equations
obj
comm_flow_on_node_origin(w,i)
comm_flow_on_node_destination(w,i)
comm_flow_on_node_intermediate(w,i)
fy_connection_constrain(i,j,w)
block_cap_constrain(i,j)
node_track_constrain(i)
node_cars_constrain(i);

*obj.. z=e=sum((i,j),sum(w,f(i,j,w))*c(i,j))+sum((i,j,w),f(i,j,w)*c_p);
obj.. z=e=sum((i,j),sum(w,f(i,j,w))*c(i,j))+sum((i,j),y(i,j)*g(i));
comm_flow_on_node_origin(w,i)$(origin(w,i)>0.1)..sum(j$(c(i,j)>0.1),f(i,j,w))=e=q(w);
comm_flow_on_node_destination(w,i)$(destination(w,i)>0.1)..sum(j$(c(j,i)>0.1),f(j,i,w))=e=q(w);
comm_flow_on_node_intermediate(w,i)$(intermediate(w,i)>0.1)..sum(j$(c(j,i)>0.1),f(j,i,w))-sum(j$(c(i,j)>0.1),f(i,j,w))=e=0;
fy_connection_constrain(i,j,w)..f(i,j,w)=l=y(i,j)*M;
block_cap_constrain(i,j)$(c(i,j)>0.1)..sum(w,f(i,j,w))=l=cap(i,j);
node_track_constrain(i)..sum(j,y(i,j))=l=b(i);
node_cars_constrain(i)..sum((j,w),f(i,j,w))=l=d(i);

model BPAV /all/;
solve BPAV using mip minimizing z;
display z.l,f.l,y.l;