module LCD(clk_50m,reset_n,lcd_rs,lcd_rw,lcd_en,lcd_d);

    input clk_50m,reset_n;
    output lcd_rs,lcd_en,lcd_rw;
    output [7:0] lcd_d;

    reg lcd_rs,lcd_rw;
    wire lcd_en;
    reg [7:0] lcd_d;
    reg [7:0] state;
    reg [19:0] cnt;
    reg clkhz;
    reg [5:0] disp_count;
    reg [255:0] data_in_buf;
    

    parameter CLEAR           =8'b00000001;//����
    parameter SETDDRAM        =8'b00000010;//����DDRAM ��ַ
    parameter SETFUNCTION     =8'b00000100;//������ʽ����
    parameter SWITCHMODE      =8'b00001000;//��ʾ״̬λ��
    parameter SETMODE         =8'b00010000;//���뷽ʽ����
    parameter RETURNCURSOR    =8'b00100000;//����λ
    parameter SHIFT           =8'b01000000;//����
    parameter WRITERAM        =8'b10000000;//д DDRAM
    parameter CUR_INC         =1;          ////���һ���ַ��봫�ͺ󣬵�ַ������ AC�Զ���1
    parameter CUR_NOSHIFT     =0;          //��ʾ��������λ
    parameter OPEN_DISPLAY    =1;          //����ʾ
    parameter OPEN_CUR        =0;          //��겻��ʾ
    parameter BLANK_CUR       =0;          //��겻��˸
    parameter DATAWIDTH8      =1;          //�������ߵĿ������Ϊ8λ
    parameter DATAWIDTH4      =0;          //�������ߵĿ������Ϊ4λ
    parameter TWOLINE         =1;          //��ʾ����Ϊ2��
    parameter ONELINE         =0;          //��ʾ����Ϊ1��
    parameter FONT5X10        =1;          //��ʾ��ʽΪ5*10����
    parameter FONT5X8         =0;          //��ʾ��ʽΪ5*8����
    parameter DATA_IN         ="    01234567        89ABCEDF    ";
    //�� DATA IN��ǰ��4���ַ����м�8���ַ�������4 ���ַ���Ϊ�ո�
    //ע��:�˾������ͬ��ʾ����ʱ���ܳ���ģ (ռ�ú굥Ԫ�������� LC4256V ��256��)

    //��50MHzϵͳʱ�ӵõ���Ƶʱ��clkhz
    always @(posedge clk_50m)
    begin
        if(cnt==20'hfffff)
        begin
            cnt<=0;
            clkhz<=~clkhz;
        end
        else begin
            cnt<=cnt+1;
        end
    end
    assign lcd_en=clkhz;

    //1602 ����״̬��
    always @(posedge clkhz or negedge reset_n)
    begin
        if(!reset_n)//�첽��λ
        begin
            lcd_rs<=0;
            lcd_rw<=0;//дָ��Ĵ���
            lcd_d<=8'b00000001;//����ָ��
            state<=CLEAR;
            disp_count<=6'b0;
        end
        else begin
            case(state)
                CLEAR: begin //����
                    lcd_rs<=0;
                    lcd_rw<=0;//дָ��Ĵ���
                    lcd_d<=8'b00000001;//����ָ��
                    data_in_buf<=DATA_IN;
                    state<=SETDDRAM;
                end
                SETDDRAM://��ַ����
                begin
                    lcd_rs<=0;
                    lcd_rw<=0;
                    lcd_d<=8'b100000000;
                    state<=SETFUNCTION;
                end
                SETFUNCTION: begin
                    lcd_rs<=0;
                    lcd_rw<=0;
                    lcd_d[7:5]<=3'b001;
                    lcd_d[4]<=DATAWIDTH8;
                    lcd_d[3]<=TWOLINE;
                    lcd_d[2]<=FONT5X8;
                    lcd_d[1:0]<=2'b00;
                    state<=SWITCHMODE;   
                end
                SWITCHMODE: begin
                    lcd_rs<=0;
                    lcd_rw<=0;
                    lcd_d[7:3]<=5'b00001;
                    lcd_d[2]<=OPEN_DISPLAY;
                    lcd_d[1]<=OPEN_CUR;
                    lcd_d[0]<=BLANK_CUR;
                    state<=SETMODE;
                end
                SETMODE: begin
                    lcd_rs<=0;
                    lcd_rw<=0;
                    lcd_d[7:2]<=6'b000001;
                    lcd_d[1]<=CUR_INC;
                    lcd_d[0]<=CUR_NOSHIFT;
                    state<=WRITERAM;
                end 
                RETURNCURSOR: begin
                    lcd_rs<=0;
                    lcd_rw<=0;
                    lcd_d<=8'b00000010;
                    state<=WRITERAM;
                end
                SHIFT: begin
                    lcd_rs<=1;
                    lcd_rw<=0;
                    lcd_d<=data_in_buf[255:248];
                    data_in_buf<=(data_in_buf<<8);
                    disp_count<=disp_count+1'b1;
                    state<=WRITERAM;
                end 
                WRITERAM: begin
                    lcd_rs<=1;
                    lcd_rw<=0;
                    if(disp_count==32) begin
                        disp_count<=4'b0;
                        state<=CLEAR;
                    end
                    else if (disp_count==16) begin
                        lcd_rs<=0;
                        lcd_rw<=0;
                        lcd_d<=8'b11000000;
                        state<=SHIFT;
                    end
                    else begin
                        lcd_d<=data_in_buf[255:248];
                        data_in_buf<=(data_in_buf<<8);
                        disp_count<=disp_count+1'b1;
                        state<=WRITERAM;
                    end
                end

        endcase
        end
    end


endmodule
 
