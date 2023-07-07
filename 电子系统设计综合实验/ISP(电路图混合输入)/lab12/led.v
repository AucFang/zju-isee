module LED(clk_50m,reset_n,led_col,led_row);

    input clk_50m,reset_n;
    output [7:0] led_col;
    output [7:0] led_row;

    reg [15:0] cnt_scan;
    reg [7:0] row_buf,col_buf;
    reg [25:0] cnt_next;
    reg [6:0] scan_data;
    reg [7:0] col1,col2,col3,col4,col5,col6,col7,col8;
    wire [7:0] led_col,led_row;


    //��ʾ 16��������0~F
    always@(posedge clk_50m or negedge reset_n) //clk 50m Ϊ50MHz ʱ��Դ
    begin
        if(!reset_n)
        begin
            cnt_scan<=0;//��ɨ�����������
            row_buf<=8'b10000000; //�������ѡ���ߵĳ�ʼ״̬(��Ч�ڰ��У�L8 ���λ��L1 ���λ)
        end
       else if(cnt_scan!=16'hffff)//������ʱ��ԼΪ1.3ms (һ����ʾͣ����ʱ��)
       begin
            cnt_scan<=cnt_scan+1;//��ɨ���������1����
       end 
       else//��cnt scan ����16hffff ʱ
       begin
            row_buf[7:1]<=row_buf[6:0];
            row_buf[0]<=row_buf[7]; //�������ѡ�����ź�һ��ѭ������1λ(�����ͨÿһ��)
            cnt_scan<=0;//��ɨ����������¼���
       end
    end


    always@(posedge clk_50m or negedge reset_n)
    begin
        if(!reset_n)
        begin
            cnt_next<=0;//��ʾ��һ��ʱ�������(һ8*8 ������ʾͣ����ʱ��)����
            scan_data<=0;//��ʾ��ǰ֡��ʾ�ַ�����(�ӡ�0����ʼ)
        end
        else if(cnt_next!=39999999)//һ֡��ʾͣ����ʱ��Ϊ0.8s(����һʱ���� scan data ����)
        begin
            cnt_next<=cnt_next+1;
        end
        else //��cnt next ���� 39999999ʱ
        begin
            cnt_next<=0;
            scan_data<=scan_data+1'b1;//��ʾ��һ���ַ�(�ӡ�0��һֱ��ʾ����F��)
        end 
    end


    //ΪҪ��ʾ���ַ����е������ݱ���
    always@(scan_data)
        begin
            case(scan_data)
                4'd0: //Z
                    begin
                    col1<=8'h00; //��һ����Чʱ��8 λ���ݱ���
                    col2<=8'h1F; //�ڶ�����Чʱ��8λ���ݱ���
                    col3<=8'h02;//��������Чʱ��8λ���ݱ���
                    //��������Чʱ��8 λ���ݱ���
                    col4<=8'h04;
                    //��������Чʱ��8λ���ݱ���
                    col5<=8'h08;
                    //��������Чʱ��8λ���ݱ���
                    col6<=8'h1F;
                    //��������Чʱ��8 λ���ݱ���
                    col7<=8'h00;
                    col8<=8'h00; //�ڰ�����Чʱ��8 λ���ݱ���
                    end
                4'd1: //H
                    begin
                    col1<=8'h00;
                    col2<=8'h11;
                    col3<=8'h11;
                    col4<=8'h1F;
                    col5<=8'h11;
                    col6<=8'h11;
                    col7<=8'h00;
                    col8<=8'h00;
                    end
                4'd2: //E
                    begin
                    col1<=8'h00;
                    col2<=8'h1F;
                    col3<=8'h10;
                    col4<=8'h1E;
                    col5<=8'h10;
                    col6<=8'h1F;
                    col7<=8'h00;
                    col8<=8'h00;
                    end
                4'd3: //J
                    begin
                    col1<=8'h00;
                    col2<=8'h0F;
                    col3<=8'h02;
                    col4<=8'h02;
                    col5<=8'h12;
                    col6<=8'h0C;
                    col7<=8'h00;
                    col8<=8'h00;
                    end
                4'd4: //I
                    begin
                    col1<=8'h00;
                    col2<=8'h0E;
                    col3<=8'h04;
                    col4<=8'h04;
                    col5<=8'h04;
                    col6<=8'h0E;
                    col7<=8'h00;
                    col8<=8'h00;
                    end
                4'd5: //A
                    begin
                    col1<=8'h04;
                    col2<=8'h0a;
                    col3<=8'h11;
                    col4<=8'h1f;
                    col5<=8'h11;
                    col6<=8'h11;
                    col7<=8'h11;
                    col8<=8'h00;
                    end
                4'd6: //N
                    begin
                    col1<=8'h00;
                    col2<=8'h11;
                    col3<=8'h19;
                    col4<=8'h15;
                    col5<=8'h13;
                    col6<=8'h11;
                    col7<=8'h00;
                    col8<=8'h00;
                    end
                4'd7: //G
                    begin
                    col1<=8'h00;
                    col2<=8'h0E;
                    col3<=8'h11;
                    col4<=8'h16;
                    col5<=8'h12;
                    col6<=8'h0E;
                    col7<=8'h00;
                    col8<=8'h00;
                    end
                4'd8: //U
                    begin
                    col1<=8'h00;
                    col2<=8'h11;
                    col3<=8'h11;
                    col4<=8'h11;
                    col5<=8'h11;
                    col6<=8'h0E;
                    col7<=8'h00;
                    col8<=8'h00;
                    end
                4'd9: //N
                    begin
                    col1<=8'h00;
                    col2<=8'h11;
                    col3<=8'h19;
                    col4<=8'h15;
                    col5<=8'h13;
                    col6<=8'h11;
                    col7<=8'h00;
                    col8<=8'h00;
                    end
                4'd10: //V
                    begin
                    col1<=8'h00;
                    col2<=8'h11;
                    col3<=8'h00;
                    col4<=8'h0A;
                    col5<=8'h00;
                    col6<=8'h04;
                    col7<=8'h00;
                    col8<=8'h00;
                    end
                4'd11: //E
                    begin
                    col1<=8'h00;
                    col2<=8'h1F;
                    col3<=8'h10;
                    col4<=8'h1E;
                    col5<=8'h10;
                    col6<=8'h1F;
                    col7<=8'h00;
                    col8<=8'h00;
                    end
                4'd12: //R
                    begin
                    col1<=8'h00;
                    col2<=8'h0C;
                    col3<=8'h0A;
                    col4<=8'h0C;
                    col5<=8'h0C;
                    col6<=8'h0A;
                    col7<=8'h00;
                    col8<=8'h00;
                    end
                4'd13: //S
                    begin
                    col1<=8'h00;
                    col2<=8'h06;
                    col3<=8'h09;
                    col4<=8'h04;
                    col5<=8'h02;
                    col6<=8'h09;
                    col7<=8'h06;
                    col8<=8'h00;
                    end
                4'd14: //I
                    begin
                    col1<=8'h00;
                    col2<=8'h0E;
                    col3<=8'h04;
                    col4<=8'h04;
                    col5<=8'h04;
                    col6<=8'h0E;
                    col7<=8'h00;
                    col8<=8'h00;
                    end
                4'd15: //T
                    begin
                    col1<=8'h00;
                    col2<=8'h1F;
                    col3<=8'h04;
                    col4<=8'h04;
                    col5<=8'h04;
                    col6<=8'h04;
                    col7<=8'h00;
                    col8<=8'h00;
                    end
                4'd16: //Y
                    begin
                    col1<=8'h00;
                    col2<=8'h11;
                    col3<=8'h0A;
                    col4<=8'h04;
                    col5<=8'h04;
                    col6<=8'h04;
                    col7<=8'h04;
                    col8<=8'h00;
                    end
                // 4'd0: //0
                //     begin
                //     col1<=8'h0e; //��һ����Чʱ��8 λ���ݱ���
                //     col2<=8'h11; //�ڶ�����Чʱ��8λ���ݱ���
                //     col3<=8'h13;//��������Чʱ��8λ���ݱ���
                //     //��������Чʱ��8 λ���ݱ���
                //     col4<=8'h15;
                //     //��������Чʱ��8λ���ݱ���
                //     col5<=8'h19;
                //     //��������Чʱ��8λ���ݱ���
                //     col6<=8'h11;
                //     //��������Чʱ��8 λ���ݱ���
                //     col7<=8'h0e;
                //     col8<=8'h00; //�ڰ�����Чʱ��8 λ���ݱ���
                //     end
                // 4'd1: //1
                //     begin
                //     col1<=8'h04;
                //     col2<=8'h0c;
                //     col3<=8'h04;
                //     col4<=8'h04;
                //     col5<=8'h04;
                //     col6<=8'h04;
                //     col7<=8'h0e;
                //     col8<=8'h00;
                //     end
                // 4'd2: //2
                //     begin
                //     col1<=8'h0e;
                //     col2<=8'h11;
                //     col3<=8'h01;
                //     col4<=8'h02;
                //     col5<=8'h04;
                //     col6<=8'h08;
                //     col7<=8'h1f;
                //     col8<=8'h00;
                //     end
                // 4'd3: //3
                //     begin
                //     col1<=8'h0e;
                //     col2<=8'h11;
                //     col3<=8'h01;
                //     col4<=8'h0e;
                //     col5<=8'h01;
                //     col6<=8'h11;
                //     col7<=8'h01;
                //     col8<=8'h00;
                //     end
                // 4'd4: //4
                //     begin
                //     col1<=8'h02;
                //     col2<=8'h06;
                //     col3<=8'h0a;
                //     col4<=8'h12;
                //     col5<=8'h1f;
                //     col6<=8'h02;
                //     col7<=8'h02;
                //     col8<=8'h00;
                //     end
                // 4'd5: //5
                //     begin
                //     col1<=8'h1f;
                //     col2<=8'h10;
                //     col3<=8'h1e;
                //     col4<=8'h01;
                //     col5<=8'h01;
                //     col6<=8'h11;
                //     col7<=8'h0e;
                //     col8<=8'h00;
                //     end
                // 4'd6: //6
                //     begin
                //     col1<=8'h0e;
                //     col2<=8'h11;
                //     col3<=8'h10;
                //     col4<=8'h1e;
                //     col5<=8'h11;
                //     col6<=8'h11;
                //     col7<=8'h0e;
                //     col8<=8'h00;
                //     end
                // 4'd7: //7
                //     begin
                //     col1<=8'h1f;
                //     col2<=8'h01;
                //     col3<=8'h02;
                //     col4<=8'h04;
                //     col5<=8'h08;
                //     col6<=8'h08;
                //     col7<=8'h08;
                //     col8<=8'h00;
                //     end
                // 4'd8: //8
                //     begin
                //     col1<=8'h0e;
                //     col2<=8'h11;
                //     col3<=8'h11;
                //     col4<=8'h0e;
                //     col5<=8'h11;
                //     col6<=8'h11;
                //     col7<=8'h0e;
                //     col8<=8'h00;
                //     end
                // 4'd9: //8
                //     begin
                //     col1<=8'h0e;
                //     col2<=8'h11;
                //     col3<=8'h11;
                //     col4<=8'h0f;
                //     col5<=8'h01;
                //     col6<=8'h01;
                //     col7<=8'h0e;
                //     col8<=8'h00;
                //     end
                // 4'd10: //A
                //     begin
                //     col1<=8'h04;
                //     col2<=8'h0a;
                //     col3<=8'h11;
                //     col4<=8'h1f;
                //     col5<=8'h11;
                //     col6<=8'h11;
                //     col7<=8'h11;
                //     col8<=8'h00;
                //     end
                // 4'd11: //B
                //     begin
                //     col1<=8'h1e;
                //     col2<=8'h09;
                //     col3<=8'h09;
                //     col4<=8'h0e;
                //     col5<=8'h09;
                //     col6<=8'h09;
                //     col7<=8'h1e;
                //     col8<=8'h00;
                //     end
                // 4'd12: //C
                //     begin
                //     col1<=8'h0e;
                //     col2<=8'h11;
                //     col3<=8'h10;
                //     col4<=8'h10;
                //     col5<=8'h10;
                //     col6<=8'h11;
                //     col7<=8'h0e;
                //     col8<=8'h00;
                //     end
                // 4'd13: //D
                //     begin
                //     col1<=8'h1e;
                //     col2<=8'h09;
                //     col3<=8'h09;
                //     col4<=8'h09;
                //     col5<=8'h09;
                //     col6<=8'h09;
                //     col7<=8'h1e;
                //     col8<=8'h00;
                //     end
                // 4'd14: //E
                //     begin
                //     col1<=8'h1f;
                //     col2<=8'h10;
                //     col3<=8'h10;
                //     col4<=8'h1e;
                //     col5<=8'h10;
                //     col6<=8'h10;
                //     col7<=8'h1f;
                //     col8<=8'h00;
                //     end
                // 4'd15: //F
                //     begin
                //     col1<=8'h1f;
                //     col2<=8'h10;
                //     col3<=8'h10;
                //     col4<=8'h1e;
                //     col5<=8'h10;
                //     col6<=8'h10;
                //     col7<=8'h10;
                //     col8<=8'h00;
                //     end
                default: //ȫ��
                    begin
                    col1<=8'b00000000;
                    col2<=8'b00000000;
                    col3<=8'b00000000;
                    col4<=8'b00000000;
                    col5<=8'b00000000;
                    col6<=8'b00000000;
                    col7<=8'b00000000;
                    col8<=8'b00000000;
                    end
            endcase
        end

    always@(row_buf) //�����ͨÿһ��
    begin
        case(row_buf)//ÿ��ͨ�µ�һ�У�����װ�����ж�Ӧ��8������
            8'b00000001://�˴��»��������岻���룬ֻ��Ϊ�˱����Ķ�
            begin col_buf=col1;//��1��ѡͨʱ��������Ҫ��ʾ�ַ��ĵ� 1���������������������
            end
            8'b00000010:
            col_buf=col2;//��2��ѡͨʱ��������Ҫ��ʾ�ַ��ĵ� 2���������������������
            8'b00000100:
            col_buf=col3;//��2��ѡͨʱ��������Ҫ��ʾ�ַ��ĵ� 2���������������������
            8'b00001000:
            col_buf=col4;//��2��ѡͨʱ��������Ҫ��ʾ�ַ��ĵ� 2���������������������
            8'b00010000:
            col_buf=col5;//��2��ѡͨʱ��������Ҫ��ʾ�ַ��ĵ� 2���������������������
            8'b00100000:
            col_buf=col6;//��2��ѡͨʱ��������Ҫ��ʾ�ַ��ĵ� 2���������������������
            8'b01000000:
            col_buf=col7;//��2��ѡͨʱ��������Ҫ��ʾ�ַ��ĵ� 2���������������������
            8'b10000000:
            col_buf=col8;//��2��ѡͨʱ��������Ҫ��ʾ�ַ��ĵ� 2���������������������
            default: col_buf=8'h00;
        endcase
    end

    assign led_row=row_buf;
    assign led_col=~col_buf;
endmodule
