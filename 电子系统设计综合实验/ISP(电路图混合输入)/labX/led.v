module LED(clk_50m,reset_n,led_col,led_row,switch);

    input clk_50m,reset_n;
    input switch;
    output [7:0] led_col;
    output [7:0] led_row;

    reg [15:0] cnt_scan;
    reg [7:0] row_buf,col_buf;
    reg [25:0] cnt_next;
    reg [6:0] scan_data;
    reg [7:0] col1,col2,col3,col4,col5,col6,col7,col8;
    wire [7:0] led_col,led_row;
    reg question_num;


    always @(posedge switch or negedge reset_n) begin
        if(!reset_n) begin
            question_num<=0;
        end
        else if(question_num==1) begin
            question_num<=0;
        end
        else begin question_num<=question_num+1; end
    end



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
	else if(cnt_next!=29999999)//һ֡��ʾͣ����ʱ��Ϊ0.8s(����һʱ���� scan data ����)
	begin
		cnt_next<=cnt_next+1;
	end
	else if(scan_data==6) begin
		scan_data<=0;
	end
	else //��cnt next ���� 39999999ʱ
	begin
		cnt_next<=0;
		scan_data<=scan_data+1'b1;//��ʾ��һ���ַ�(��ʾ����)
	end 
end


    //ΪҪ��ʾ���ַ����е������ݱ���
    always@(scan_data)
        begin
            case(question_num) 
                0: begin
                    case(scan_data)
                        6'd1: //8
                            begin
                            col1<=8'h18; //��һ����Чʱ��8 λ���ݱ���
                            col2<=8'h24; //�ڶ�����Чʱ��8λ���ݱ���
                            col3<=8'h24;//��������Чʱ��8λ���ݱ���
                            //��������Чʱ��8 λ���ݱ���
                            col4<=8'h18;
                            //��������Чʱ��8λ���ݱ���
                            col5<=8'h24;
                            //��������Чʱ��8λ���ݱ���
                            col6<=8'h24;
                            //��������Чʱ��8 λ���ݱ���
                            col7<=8'h18;
                            col8<=8'h00; //�ڰ�����Чʱ��8 λ���ݱ���
                            end
                        6'd2: //X
                            begin
                            col1<=8'h00;
                            col2<=8'h22;
                            col3<=8'h14;
                            col4<=8'h08;
                            col5<=8'h14;
                            col6<=8'h22;
                            col7<=8'h00;
                            col8<=8'h00;
                            end
                        6'd3: //8
                            begin
                            col1<=8'h18; //��һ����Чʱ��8 λ���ݱ���
                            col2<=8'h24; //�ڶ�����Чʱ��8λ���ݱ���
                            col3<=8'h24;//��������Чʱ��8λ���ݱ���
                            //��������Чʱ��8 λ���ݱ���
                            col4<=8'h18;
                            //��������Чʱ��8λ���ݱ���
                            col5<=8'h24;
                            //��������Чʱ��8λ���ݱ���
                            col6<=8'h24;
                            //��������Чʱ��8 λ���ݱ���
                            col7<=8'h18;
                            col8<=8'h00; //�ڰ�����Чʱ��8 λ���ݱ���
                            end
                        6'd4: //=
                            begin
                            col1<=8'h00;
                            col2<=8'h00;
                            col3<=8'h3C;
                            col4<=8'h00;
                            col5<=8'h00;
                            col6<=8'h3C;
                            col7<=8'h00;
                            col8<=8'h00;
                            end
                        6'd5: //?
                            begin
                            col1<=8'h00;
                            col2<=8'h18;
                            col3<=8'h24;
                            col4<=8'h04;
                            col5<=8'h08;
                            col6<=8'h08;
                            col7<=8'h00;
                            col8<=8'h08;
                            end




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
                1: begin
                    case(scan_data)
                        6'd1: //Z
                            begin
                            col1<=8'h18; //��һ����Чʱ��8 λ���ݱ���
                            col2<=8'h24; //�ڶ�����Чʱ��8λ���ݱ���
                            col3<=8'h04;//��������Чʱ��8λ���ݱ���
                            //��������Чʱ��8 λ���ݱ���
                            col4<=8'h18;
                            //��������Чʱ��8λ���ݱ���
                            col5<=8'h04;
                            //��������Чʱ��8λ���ݱ���
                            col6<=8'h24;
                            //��������Чʱ��8 λ���ݱ���
                            col7<=8'h18;
                            col8<=8'h00; //�ڰ�����Чʱ��8 λ���ݱ���
                            end
                        6'd2: //H
                            begin
                            col1<=8'h00;
                            col2<=8'h22;
                            col3<=8'h14;
                            col4<=8'h08;
                            col5<=8'h14;
                            col6<=8'h22;
                            col7<=8'h00;
                            col8<=8'h00;
                            end
                        6'd3: //E
                            begin
                            col1<=8'h18; //��һ����Чʱ��8 λ���ݱ���
                            col2<=8'h24; //�ڶ�����Чʱ��8λ���ݱ���
                            col3<=8'h04;//��������Чʱ��8λ���ݱ���
                            //��������Чʱ��8 λ���ݱ���
                            col4<=8'h18;
                            //��������Чʱ��8λ���ݱ���
                            col5<=8'h04;
                            //��������Чʱ��8λ���ݱ���
                            col6<=8'h24;
                            //��������Чʱ��8 λ���ݱ���
                            col7<=8'h18;
                            col8<=8'h00; //�ڰ�����Чʱ��8 λ���ݱ���
                            end
                        6'd4: //J
                            begin
                            col1<=8'h00;
                            col2<=8'h00;
                            col3<=8'h3C;
                            col4<=8'h00;
                            col5<=8'h00;
                            col6<=8'h3C;
                            col7<=8'h00;
                            col8<=8'h00;
                            end
                        6'd5: //I
                            begin
                            col1<=8'h00;
                            col2<=8'h18;
                            col3<=8'h24;
                            col4<=8'h04;
                            col5<=8'h08;
                            col6<=8'h08;
                            col7<=8'h00;
                            col8<=8'h08;
                            end




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
