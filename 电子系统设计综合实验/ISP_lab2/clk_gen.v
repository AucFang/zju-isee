module clk_gen(clk,reset,en,scancnt,clk_1kHz);
input clk,reset,en;
output scancnt,clk_1kHz;
reg [1:0] scancnt=0; 
parameter n=1;//��Ҫnλ�����

// ʱ�ӽ��̣���������ʱ���ź�
counter_n #(.n(1000),.counter_bits(13)) FreqDivide(.clk(clk),.r(reset),.en(en),.co(clk_1kHz),.q());

always @(posedge clk_1kHz)//
begin //����ˢ��Ƶ��Ϊ1000Hz/4=250Hz,��1s�ڶ�4λ����ܶ�ˢ��250�Σ�����50��ÿ���Ҫ��
    if(scancnt==(n-1)) scancnt=0; //scancntΪLEDɨ����ת�ź�(��0��3)
    else scancnt=scancnt+1;   
end

endmodule

