`timescale 1ns/1ps
`include "top.v"
module test( 
);



reg[31:0] x1=32'h3fa00000,x2=32'h3fa00000,x3=32'h3fa00000;




wire[31:0] y1,y2,y3;


NetWork net(
.Xi	({x1,x2,x3}),
.Yo ({y1,y2,y3})
);



endmodule
