//ͬ�������������첽�����ȴ���ʱ������ʱ���������档
module synchro(async_in,clk,sync_out);
    input async_in,clk;
    output sync_out;
    wire q1;
    
    dffre #(.n(1)) D1(.d(async_in),.r(0),.clk(clk),.q(q1));
    dffre #(.n(1)) D2(.d(q1),.r(0),.clk(clk),.q(sync_out));

endmodule
