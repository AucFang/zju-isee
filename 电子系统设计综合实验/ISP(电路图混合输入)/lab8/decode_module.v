module DECODE_MODULE(clk,reset,key_in,key_out,led);
    input clk,reset;
    input [3:0] key_in;
    output [3:0] key_out;
    output [4:0] led;

    reg [3:0] key_out;
    reg [4:0] led;
    reg [3:0] scanvalue;
    reg [7:0] combvalue;


    always @(posedge clk or negedge reset) //clk Ϊ��Ƶʱ��Դ��128Hz\
    begin
        if(reset==0)
            begin
                scanvalue<=1;//scanvalue ��¼ɨ������
                led<=5'b11111; //5 λ led ��������ʾ��Ӧ�����µļ�:��ֵΪ0ʱ��Ч��LED ����
                combvalue<=0;//combvalue Ϊ��ɨ�����ɨ������ֵ
            end
        else
            begin//ÿ����ms����һ�μ���ɨ��
                key_out<=scanvalue;//���ɨ��ֵ: ey out ��Ӧrow ��
    //ע��:����δ���¼�ʱĬ�ϵ�ƽΪ0������(��MAGIC3100)ɨ��Ч��ƽӦȡΪ1������0001:
    //����δ���¼�ʱĬ�ϵ�ƽΪ1������(��EDA-E )ɨ��ЧƽӦȡΪ0������1110
    //��˼Ϊʲô��Ҫ����?
                case(scanvalue)
                    4'b0001:scanvalue<=4'b0010;
                    4'b0010:scanvalue<=4'b0100;
                    4'b0100:scanvalue<=4'b1000;
                    4'b1000:scanvalue<=4'b0001;
                    default:scanvalue<=4'b0001;
                endcase
                combvalue<={key_in,key_out};//key in ��Ӧcolumn��
                case(combvalue)
                    8'b00010001:led<=5'b11110; //��Ӧ���̡�1��
                    8'b00100001:led<=5'b11101;//��Ӧ���̡�2��
                    8'b01000001:led<=5'b11100;//��Ӧ���̡�3��
                    8'b10000001:led<=5'b11011;//��Ӧ���̡�X��
                    8'b00010010:led<=5'b11010;//��Ӧ���̡�4��
                    8'b00100010:led<=5'b11001; //��Ӧ���̡�5��
                    8'b01000010:led<=5'b11000;//��Ӧ���̡�6��
                    8'b10000010:led<=5'b10111;//��Ӧ���̡�Y��
                    8'b00010100:led<=5'b10110;//��Ӧ���̡�7��
                    8'b00100100:led<=5'b10101;//��Ӧ���̡�8��
                    8'b01000100:led<=5'b10100;//��Ӧ���̡�9��
                    8'b10000100:led<=5'b10011;//��Ӧ���̡�Z��
                    8'b00011000:led<=5'b10010;//��Ӧ���̡�0��
                    8'b00101000:led<=5'b10001;//��Ӧ���̡�+��
                    8'b01001000:led<=5'b10000;//��Ӧ���̡�_��/
                    8'b10001000:led<=5'b01111; //��Ӧ���̡�=��
                    default: led<=5'b11111;//�޼��̰��£�ȫ��LED �ƶ�����
                endcase
            end
    end

endmodule
