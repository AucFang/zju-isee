module dffre(d,r,clk,q);
    parameter n=1;//nΪ�Ĵ�����λ����n=1ʱΪD������
    
    input clk,r;
    input [n:1]d;
    output [n:1]q;
       reg [n:1]q=0;

    always @(posedge clk)
        begin
            if(r)   q=0;
            else q=d;
        end
endmodule
