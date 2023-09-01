module clk_gen(clk,reset,en,scancnt,clk_1kHz,clk_9600Hz,clock16);
input clk,reset,en;
output clk_1kHz,clk_9600Hz,clock16;
output [1:0] scancnt;
reg [1:0] scancnt=0; 
parameter LEDnum=1;//��Ҫnλ�����
parameter sim=0;
// ʱ�ӽ��̣���������ʱ���ź�
counter_n #(.n(sim==1?1000:6000),.counter_bits(13)) FreqDivide_1(.clk(clk),.r(reset),.en(en),.co(clk_1kHz),.q());//����1kHz��ʱ���ź�

//counter_n #(.n(10),.counter_bits(4)) FreqDivide_2(.clk(clk_1kHz),.r(reset),.en(en),.co(clk_100Hz),.q());//����100Hz(����10ms)��ʱ���ź�

counter_n #(.n(625),.counter_bits(10)) FreqDivide_3(.clk(clk),.r(reset),.en(en),.co(clk_9600Hz),.q());//����9600Hz��ʱ���ź�

counter_n #(.n(39),.counter_bits(6)) FreqDivide_4(.clk(clk),.r(reset),.en(en),.co(clock16),.q());//����9600*16Hz��ʱ���ź�

always @(posedge clk_1kHz)//
begin //����ˢ��Ƶ��Ϊ1000Hz/4=250Hz,��1s�ڶ�4λ����ܶ�ˢ��250�Σ�����50��ÿ���Ҫ��
    if(scancnt==(LEDnum-1)) scancnt=0; //scancntΪLEDɨ����ת�ź�(��0��3)
    else scancnt=scancnt+1;   
end
endmodule

