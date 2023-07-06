/* 
���ҽ��������źŵ����ĵ�һ��ʱ�����ڣ��Ĵ���q��û�д�1���0����out���Ϊ0,֮��q���0���������뻹��0����out���1��
*/

module width_trans(in,clk,out);
    input in,clk;
    output out;
    reg q=1;

    always @(posedge clk)
        q=in;

    assign out=~((~in)&q);
endmodule
/*
in  0 0 1 1
q   1 0 0 1
out 0 1 1 1
*/