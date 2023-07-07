module DIVIDER_8(clk,reset,time10ms);
    input clk,reset;
    output time10ms;

    reg time10ms;
    reg [3:0] timecnt;

    //����10msʱ�ӵĽ���
    always @(posedge clk or negedge reset) //clk Ϊϵͳʱ���ź� 6MHz
    begin
        if(reset==1'b0)timecnt<=0; //timecnt Ϊ��Ƶ�������������õ�10ms ʱ��
        else if(timecnt==1)
            begin
                time10ms<=~time10ms; //timel0ms Ϊ10ms ʱ��
                timecnt<=0;
            end
        else timecnt<=timecnt+1;
    end

endmodule

