/* 
���ҽ��������źŵ����ĵ�һ��ʱ�����ڣ��Ĵ���q��û�д�0���1����out���Ϊ1,֮��q���1���������뻹��1����out���0��
*/

module width_trans(in,clk,out);
    parameter width=1;
    input  [width-1:0] in;
    output [width-1:0] out;
    input clk;

    reg [width-1:0] q=0;
    always @(posedge clk)
        q=in;

    assign out=in&(~q);
endmodule
/*
in  0 0 1 1
q   1 0 0 1
out 0 1 1 1
*/