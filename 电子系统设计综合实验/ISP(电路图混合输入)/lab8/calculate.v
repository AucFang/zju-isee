module CALCULATE(clk,reset,key_in,PointTime,led_int_Data0,led_int_Data1,led_int_Data2,key_out);

    input clk,reset;
    input [3:0] key_in;
    output PointTime;
    output [3:0] led_int_Data0;
    output [3:0] led_int_Data1;
    output [3:0] led_int_Data2;
    output [3:0] key_out;



    reg [16:0] timecnt;
    reg time10ms;
    reg [3:0] scanvalue;
    reg [3:0] flag_Data;
    reg flag_Over;
    reg [1:0] flag_Cal;
    reg [7:0] int_Data0;
    reg [7:0] int_Data1;
    reg  PointTime;
    reg [7:0] int_Data;
    reg [3:0] key_out;
    reg [3:0] led_int_Data0,led_int_Data1,led_int_Data2;


    //����10msʱ�ӵĽ���
    always @(posedge clk or negedge reset) //clk Ϊϵͳʱ���ź� 6MHz
    begin
        if(reset==1'b0)timecnt<=0; //timecnt Ϊ��Ƶ�������������õ�10ms ʱ��
        else if(timecnt==29999)
            begin
                time10ms<=~time10ms; //timel0ms Ϊ10ms ʱ��
                timecnt<=0;
            end
        else timecnt<=timecnt+1;
    end
    //����ɨ�����
    always @(posedge time10ms or negedge reset)
    begin
        if(reset==0)
            begin
                scanvalue<=1;//scanvalue ���ڼ�¼ɨ������
                flag_Data<=0;//flag Data Ϊ��������˳���־
                flag_Over<=0;//flag Over Ϊ��ɼ����־
                flag_Cal<=0;//flag Cal���ڱ�����㷽ʽ��1һ�ӷ���2һ����
                int_Data0<=0;
                int_Data1<=0;//int Data0 ��int DatalΪ���������������
                PointTime<=1;//PintTime Ϊ������м�ġ�;��������������ָʾ��+����_�������������
                led_int_Data2<=10;
                //led int Data2 Ϊ��ȥ��2 ���������ʾ�����ݣ�Ϊ 10 ��ʾ��������ʾ��Ϊ11 ��ʾ������ʾ��
                int_Data<=0;//int Data Ϊ������
            end
        else
            begin
                key_out<=scanvalue;//���ɨ��ֵ
                case(scanvalue)//ɨ��ֵ��λ
                    4'b0001: scanvalue<=4'b0010;
                    4'b0010: scanvalue<=4'b0100;
                    4'b0100: scanvalue<=4'b1000;
                    4'b1000: scanvalue<=4'b0001;
                    default: scanvalue<=4'b0001;
                endcase
                case({key_in,key_out})//����ɨ����
                    8'b00010001://��Ӧ���̡�1��
                        begin
                            case(flag_Data)
                                0: begin led_int_Data2<=10;int_Data0<=1;int_Data<=1;flag_Data<=1; end //�� 1 ����
                                2: begin int_Data1<=1;int_Data<=1;flag_Data<=3; end //�� 2����default::
                            endcase
                        end
                    8'b00100001://��Ӧ���̡�2��
                        begin
                            case(flag_Data)
                                0: begin led_int_Data2<=10;int_Data0<=2;int_Data<=2;flag_Data<=1; end //�� 1����
                                2: begin int_Data1<=2;int_Data<=2;flag_Data<=3;end //��2����
                                default:;
                            endcase
                        end
                    //��Ӧ���̡�3������g������0����Դ������1��2���ƣ�ע������ɨ����Ĳ�ͬ���ɣ�����
                    8'b01000001://��Ӧ���̡�3��
                        begin
                            case(flag_Data)
                                0: begin led_int_Data2<=10;int_Data0<=3;int_Data<=3;flag_Data<=1; end //�� 1����
                                2: begin int_Data1<=3;int_Data<=3;flag_Data<=3;end //��2����
                                default:;
                            endcase
                        end
                    8'b00010010://��Ӧ���̡�4��
                        begin
                            case(flag_Data)
                                0: begin led_int_Data2<=10;int_Data0<=4;int_Data<=4;flag_Data<=1; end //�� 1����
                                2: begin int_Data1<=4;int_Data<=4;flag_Data<=3;end //��2����
                                default:;
                            endcase
                        end
                    8'b00100010://��Ӧ���̡�5��
                        begin
                            case(flag_Data)
                                0: begin led_int_Data2<=10;int_Data0<=5;int_Data<=5;flag_Data<=1; end //�� 1����
                                2: begin int_Data1<=5;int_Data<=5;flag_Data<=3;end //��2����
                                default:;
                            endcase
                        end
                    8'b01000010://��Ӧ���̡�6��
                        begin
                            case(flag_Data)
                                0: begin led_int_Data2<=10;int_Data0<=6;int_Data<=6;flag_Data<=1; end //�� 1����
                                2: begin int_Data1<=6;int_Data<=6;flag_Data<=3;end //��2����
                                default:;
                            endcase
                        end
                    8'b00010100://��Ӧ���̡�7��
                        begin
                            case(flag_Data)
                                0: begin led_int_Data2<=10;int_Data0<=7;int_Data<=7;flag_Data<=1; end //�� 1����
                                2: begin int_Data1<=7;int_Data<=7;flag_Data<=3;end //��2����
                                default:;
                            endcase
                        end
                    8'b00100100://��Ӧ���̡�8��
                        begin
                            case(flag_Data)
                                0: begin led_int_Data2<=10;int_Data0<=8;int_Data<=8;flag_Data<=1; end //�� 1����
                                2: begin int_Data1<=8;int_Data<=8;flag_Data<=3;end //��2����
                                default:;
                            endcase
                        end
                    8'b01000100://��Ӧ���̡�9��
                        begin
                            case(flag_Data)
                                0: begin led_int_Data2<=10;int_Data0<=9;int_Data<=9;flag_Data<=1; end //�� 1����
                                2: begin int_Data1<=9;int_Data<=9;flag_Data<=3;end //��2����
                                default:;
                            endcase
                        end
                    8'b00011000://��Ӧ���̡�0��
                        begin
                            case(flag_Data)
                                0: begin led_int_Data2<=10;int_Data0<=0;int_Data<=0;flag_Data<=1; end //�� 1����
                                2: begin int_Data1<=0;int_Data<=0;flag_Data<=3;end //��2����
                                default:;
                            endcase
                        end
                    8'b10000001://��Ӧ���̡�X��
                        begin
                            if(flag_Data == 1) begin flag_Cal<=3; PointTime <= 0; flag_Data<=2; end
                            end
                    8'b10000010:;//��Ӧ���̡�Y��
                    8'b10000100://��Ӧ���̡�Z������λ
                        begin
                            flag_Over<=0;
                            flag_Data<=0;
                            int_Data0<=0;
                            int_Data1<=0;
                            PointTime<=1;
                            led_int_Data2<=10;
                            int_Data<=0;
                        end
                    8'b00101000://��Ӧ���̡�+����׼�����ӷ�
                        begin
                            if(flag_Data==1) begin flag_Cal<=1;PointTime<=0;flag_Data<=2;end
                        end
                    8'b01001000://��Ӧ���̡�-����׼��������
                        begin
                            if(flag_Data==1) begin flag_Cal<=2;PointTime<=0;flag_Data<=2; end
                        end
                    8'b10001000://��Ӧ���̡�=������������
                        begin
                            case(flag_Cal)
                                1: begin int_Data<=int_Data0+int_Data1;led_int_Data2<=10; end //�ӷ�
                                2: begin
                                    if(int_Data0>=int_Data1)
                                        begin
                                            int_Data<=int_Data0-int_Data1;led_int_Data2<=10;//��������Ϊ�������� 2������ܲ���ʾ��ʾ������Ϊ 10 ʱ�������ʹ��Ӧ�����ȫ��)
                                        end
                                    else
                                        begin
                                            int_Data<=int_Data1-int_Data0;led_int_Data2<=11;//��������Ϊ�������� 2 ���������ʾ��_���ű�ʾ����(Ϊ11 ʱ�������ʹ��Ӧ�������ʾ��"��)
                                        end
                                    end
                                3: begin //�˷�
                                    int_Data<=int_Data0*int_Data1; led_int_Data2<=10; 
                                    end
                                default:;
                            endcase
                            PointTime<=1;
                            flag_Cal<=0;
                            flag_Data<=0;
                        end
                    default:;//�޼��̰���
                endcase
            end
    end
    //������ܴ�������
    //�����������ʾ���벿���ԣ��μ�ʵ����е������ɨ����ʾԭ��
    always @(posedge clk or negedge reset)
    begin
        if(reset==0)
            begin
                led_int_Data1<=0;led_int_Data0<=0;//��1������ܲ���ʾ����3��4 �������Ϊ0
            end
        else
            begin
                if(int_Data>9 && int_Data <20)
                    begin
                        led_int_Data1<=1;led_int_Data0<=int_Data-10;//�ֽ��BCD��
                    end
                else if(int_Data>19 && int_Data <30)
                    begin
                        led_int_Data1<=2;led_int_Data0<=int_Data-20;//�ֽ��BCD��
                    end
                else if(int_Data>29 && int_Data <40)
                    begin
                        led_int_Data1<=3;led_int_Data0<=int_Data-30;//�ֽ��BCD��
                    end
                else if(int_Data>39 && int_Data <50)
                    begin
                        led_int_Data1<=4;led_int_Data0<=int_Data-40;//�ֽ��BCD��
                    end
                else if(int_Data>49 && int_Data <60)
                    begin
                        led_int_Data1<=5;led_int_Data0<=int_Data-50;//�ֽ��BCD��
                    end
                else if(int_Data>59 && int_Data <70)
                    begin
                        led_int_Data1<=6;led_int_Data0<=int_Data-60;//�ֽ��BCD��
                    end
                else if(int_Data>69 && int_Data <80)
                    begin
                        led_int_Data1<=7;led_int_Data0<=int_Data-70;//�ֽ��BCD��
                    end
                else if(int_Data>79 && int_Data <90)
                    begin
                        led_int_Data1<=8;led_int_Data0<=int_Data-80;//�ֽ��BCD��
                    end
                else
                    begin
                        led_int_Data1<=10;//��3 ������ܲ���ʾ
                        led_int_Data0<=int_Data;
                    end
            end
    end



endmodule
