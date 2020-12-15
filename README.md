# Blocking plan problem
The classic railroad blocking problem is to identify the classification plan for all shipments at all yards.<br>
**Input**: railroad network, demands(shipments) with origins and destinationsm, link capacity, node capacity, link cost and node cost.<br>
**Output**: whihc blocks to build at each yard and assignment sequences of blocks delivering each shipment.<br>
**Constraint**: flow conservation constraints, link capacity constraints, blocking building capacity constraints, the maximum car volume that can be handled at each yard, binary constraints and nonnegative constriants.<br>
**Objective**: minimizing total mileage and yard handling costs.<br>
