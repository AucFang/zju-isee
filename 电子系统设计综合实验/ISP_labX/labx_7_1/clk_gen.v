module clk_gen(clk,reset,en/*,scancnt*/,clk_1kHz,clk_4Hz);
input clk,reset,en;
output clk_1kHz,clk_4Hz;
/*output [1:0] scancnt;
reg [1:0] scancnt=0; 
parameter LEDnum=1;//��Ҫnλ�����*/
// ʱ�ӽ��̣���������ʱ���ź�

counter_n #(.n(6000),.counter_bits(13)) FreqDivide_1(.clk(clk),.r(reset),.en(en),.co(clk_1kHz),.q());//����1kHz��ʱ���ź�

counter_n #(.n(2300),.counter_bits(12)) FreqDivide_2(.clk(clk_1kHz),.r(reset),.en(en),.co(clk_4Hz),.q());//����1kHz��ʱ���ź�

/*always @(posedge clk_1kHz)//
begin //����ˢ��Ƶ��Ϊ1000Hz/4=250Hz,��1s�ڶ�4λ����ܶ�ˢ��250�Σ�����50��ÿ���Ҫ��
    if(scancnt==(LEDnum-1)) scancnt=0; //scancntΪLEDɨ����ת�ź�(��0��3)
    else scancnt=scancnt+1;   
end*/
endmodule

