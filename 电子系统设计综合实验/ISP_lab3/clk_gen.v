module clk_gen(clk,reset,en,scancnt,clk_1kHz,clk_3791);
input clk,reset,en;
output scancnt,clk_1kHz,clk_3791;
reg [1:0] scancnt=0; 
parameter n=1;//��Ҫnλ�����
parameter sim=0;
// ʱ�ӽ��̣���������ʱ���ź�
counter_n #(.n(sim==1?1000:6000),.counter_bits(13)) FreqDivide_1(.clk(clk),.r(reset),.en(en),.co(clk_1kHz),.q());//����1kHz��ʱ���ź�

counter_n #(.n(sim==1?1789:10733),.counter_bits(14)) FreqDivide_2(.clk(clk),.r(reset),.en(en),.co(clk_3791),.q());//����559Hz��ʱ���ź�

always @(posedge clk_1kHz)//
begin //����ˢ��Ƶ��Ϊ1000Hz/4=250Hz,��1s�ڶ�4λ����ܶ�ˢ��250�Σ�����50��ÿ���Ҫ��
    if(scancnt==(n-1)) scancnt=0; //scancntΪLEDɨ����ת�ź�(��0��3)
    else scancnt=scancnt+1;   
end
endmodule

