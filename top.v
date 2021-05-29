
//3*3*3*3的神经网络
module NetWork(
	input[3*32-1:0] Xi,
	output[3*32-1:0] Yo 
);


reg[3*3*3*32-1:0] ws = 
{
32'h3DCCCCCC,32'h3DCCCCCC,32'h3DCCCCCC,
32'h3DCCCCCC,32'h3DCCCCCC,32'h3DCCCCCC,
32'h3DCCCCCC,32'h3DCCCCCC,32'h3DCCCCCC,
32'h3DCCCCCC,32'h3DCCCCCC,32'h3DCCCCCC,
32'h3DCCCCCC,32'h3DCCCCCC,32'h3DCCCCCC,
32'h3DCCCCCC,32'h3DCCCCCC,32'h3DCCCCCC,
32'h3DCCCCCC,32'h3DCCCCCC,32'h3DCCCCCC,
32'h3DCCCCCC,32'h3DCCCCCC,32'h3DCCCCCC,
32'h3DCCCCCC,32'h3DCCCCCC,32'h3DCCCCCC
};

reg[3*3*32-1:0] bs =
{
32'h3DCCCCCC,32'h3DCCCCCC,32'h3DCCCCCC,
32'h3DCCCCCC,32'h3DCCCCCC,32'h3DCCCCCC,
32'h3DCCCCCC,32'h3DCCCCCC,32'h3DCCCCCC
};


wire[3*32-1:0] cen[1:0];
Layer l1(Xi,ws[0*3*3*32+3*3*32-1:0*3*3*32],bs[0*3*32+3*32-1:0*3*32],cen[0]);
Layer l2(cen[0],ws[1*3*3*32+3*3*32-1:1*3*3*32],bs[1*3*32+3*32-1:1*3*32],cen[1]);
Layer l3(cen[1],ws[2*3*3*32+3*3*32-1:2*3*3*32],bs[2*3*32+3*32-1:2*3*32],Yo);



endmodule


module Layer(
	input[3*32-1:0] Xi,
	input[3*3*32-1:0] Ws,	
	input[3*32-1:0] Bs,
	output[3*32-1:0] Yo
);	

Neural n1(Xi,Ws[0*3*32+3*32-1:0*3*32],Bs[0*32+32-1:0*32],Yo[0*32+32-1:0*32]);
Neural n2(Xi,Ws[1*3*32+3*32-1:1*3*32],Bs[1*32+32-1:1*32],Yo[1*32+32-1:1*32]);
Neural n3(Xi,Ws[2*3*32+3*32-1:2*3*32],Bs[2*32+32-1:2*32],Yo[2*32+32-1:2*32]);

endmodule


module Neural(
	input[3*32-1:0] Xi,
	input[3*32-1:0] Ws,//权重
	input[31:0]  B,//偏执
	output[31:0] Yo
);

wire[31:0] o[2:0];

FPU_MUL f1(Xi[0*32+32-1:0*32],Ws[0*32+32-1:0*32],o[0]);
FPU_MUL f2(Xi[1*32+32-1:1*32],Ws[1*32+32-1:1*32],o[1]);
FPU_MUL f3(Xi[2*32+32-1:2*32],Ws[2*32+32-1:2*32],o[2]);


wire[31:0] t[1:0],f;
FPU_ADD f4(o[0],o[1],t[0]);
FPU_ADD f5(o[2],t[0],t[1]);
FPU_ADD f6(B,t[1],f);
Act_Func act(f,Yo);
endmodule


//激活函数
module Act_Func(
	input[31:0] Xi,
	output[31:0] Yo
);

assign Yo = Xi[31] ? 32'd0 : Xi;

endmodule