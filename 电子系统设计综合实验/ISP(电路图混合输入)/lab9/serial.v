module SERIAL(clk,reset,dout,Rx,Tx,Data1,Data2);
    input clk,reset,Rx,dout;
    output Tx;
    output [3:0] Data1;
    output [3:0] Data2;

    reg Tx;
    reg [3:0] Data1;
    reg [3:0] Data2;
    reg [9:0] ClockCount;
    reg [5:0] ClockCount_Rx;
    reg Clock9600,Clock16,Send_en,Send_over,Rx_Hold,Rx_Valid;
    reg [3:0] Send_count;
    reg [9:0] Send_data;
    reg [7:0] m;
    reg [7:0] Rx_Data;


//ʱ�Ӳ�������
    always @(posedge clk or negedge reset)
    begin
        if(reset==0);
        else
        begin
            if(ClockCount==624) begin Clock9600<=1;ClockCount<=0; end
            else begin Clock9600<=0;ClockCount<=ClockCount+1; end
            //Clock9600 Ϊ9600 ������ʱ�ӣ���Ƶ��Ϊ6MHZ/625=9600Hz//ClockCount Ϊ���� Clock9600 �ļ�����
            if(ClockCount_Rx==38) begin Clock16<=1;ClockCount_Rx<=0;end
            else begin Clock16<=0; ClockCount_Rx<=ClockCount_Rx+1;end
            //CIock16Ϊ9600 ������ʱ�ӵ� 1 ��Ƶ����ʱ��,�ڽ���ʱʹ�ã��� 625/16:39(��ΪԼ�����������Կ���)
            //ClockCount RxΪ���� Clock16 �ļ�����
        end
    end
    //���ڷ��Ͳ��֣�����ISP ʵ��巢�͵�PC�ϣ��ô��ڵ���������ʾ
    //Tx Ϊ���ڷ������ݣ�������ʵ��� ISP оƬ�ϵ�97 �ţ���ͨ��Ӳ���������ģ��ķ��Ͷ�����
    //Send en Ϊ���ڷ���ʹ�ܣ�0 ��Ч��0��ʾ����ʹ��
    //Send over Ϊ���ڷ�����ɣ�0 ��Ч��0��ʾ�������
    //Sendcount Ϊ���ڷ���ʱ��λ���ͼ���
    //Send data Ϊ���ͼĴ���
    always @(posedge Clock9600 or posedge Send_en)
    begin
        if(Send_en==1) begin Send_count<=0;Tx<=1; Send_over<=1;end //����δʹ�ܣ�����δ���
        else if(Send_count==9)begin Tx<=Send_data[9];Send_over<=0;end
        //������ɣ��ܹ����� 10 �� (1λ��ʼλ��8λ����λ��1λֹͣλ���� 10 λ������żУ��λ)
        else begin Tx<=Send_data[Send_count]; Send_count<=Send_count+1;end
    end


    //���ͼ���
    always @(posedge dout or negedge reset or negedge Send_over) //dout �ǰ�������������,��������һ�´�����ʼ����
    begin
        if(reset==0)begin Send_en<=1; Send_data<=10'b1000000000; end //��ʼ����ʹ�ܷ��ͣ���������Ϊȫ0
        else if(Send_over==0)begin Send_en<=1; Send_data<=10'b1000000000;end //������ϣ���ָ����Ͳ�ʹ��
        else
            begin
                Send_en <= 0; //ʹ�ܷ���
                Send_data<=10'b1010101100;//��������Ϊ:ֹͣλ1������ 56����ʼλ0
                //��Ϊ�ӵ�[0]λ��ʼ������󷢵�[9]λ�����������ȷ���λ���󷢸�λ
            end 
    end
    //���ڽ��ղ��֣����� PC �ϵĴ��ڵ������ַ��͵�ISP ʵ����ϣ����������ʾ
    //���ڽ��ռ����ʼλ�������͹����ĵ�[0]λΪ 0��һ����⵽����ʼ��������
    //Rx Ϊ���ڽ������ݣ������ڰ��ϵ�98 �ţ���ͨ��Ӳ�������봮��ģ��Ľ��ն�����
    //Rx Hold Ϊ���ڽ��յ���ʼλ�ı�־�źţ�1��Ч����ʾ���յ���
    //Rx Valid ��־���յ�һ�ֽ���Ч���ݣ�1 ��Ч����ʾ���յ��� 8 λ����
    //Rx Data Ϊ���ռĴ���
    always @(Rx or reset)
    begin
        if(reset==0)Rx_Hold<=0;//��ʼ��ʱ�����ձ���
        else if(Rx==0)Rx_Hold<=1;//ͨ�� Rx Hold �ź��������ս���
        else Rx_Hold <= 0;
    end

    //���ս���
    always @(posedge Clock16 or negedge reset)
    begin
        if(reset==0) begin Rx_Valid<=0;m<=0;end //��ʼ��ʱ����8λ������Ϊ��Ч����m�� Clock16 ����Ϊ0
        else
        begin
            case(m)
                0: begin
                    if(Rx_Hold == 1) begin m<=m+1; end
                    else begin m<=0; Rx_Valid<=0; end
                end

                //���� 24 �� Clock16 ���ں󣬲ɵ�1λ���ݼ����λ[0]
                24:begin Rx_Data[0]<=Rx; m<=m+1;end
                //���� 16��Clock16 ���ں󣬲ɵ�2λ���ݼ��ε�λ[1];������������
                40: begin Rx_Data[1]<=Rx; m<=m+1;end
                56: begin Rx_Data[2]<=Rx; m<=m+1;end
                72: begin Rx_Data[3]<=Rx; m<=m+1;end
                88: begin Rx_Data[4]<=Rx; m<=m+1;end
                104: begin Rx_Data[5]<=Rx; m<=m+1;end
                120: begin Rx_Data[6]<=Rx; m<=m+1;end

                //���� 16�� Clock16 ���ں󣬲ɵ�8λ���ݼ����λ[7]
                136: begin Rx_Data[7]<=Rx; m<=m+1;end
                //Rx Valid ��1����־�������ݽ������:��ʱ���� 16�� Clock1 ����Ӧ�յ���ֹͣλ
                152: begin Rx_Valid<=1; m<=m+1;end
                168: begin m<=0; Rx_Valid<=1; end//�ָ�Ϊ��ʼ̬�����ո���Ϊ0�����������Ч
                default: m<=m+1;//ÿ��һ�� Clock16 ������һ�������أ�������ʱm һֱ�ڼ�1
            endcase
        end
    end 

    //������յ��Ĵ������ݣ��͵��������ȥ��ʾ
    always @(negedge Rx_Valid or negedge reset) //Rx Valid ���½���˵��һ�ν����Ѿ���ɲ���1��0��
    begin
        if(reset==0) begin Data1<=0;Data2<=0;end
        else
        begin
            Data1<={Rx_Data[3],Rx_Data[2],Rx_Data[1],Rx_Data[0]};//���յ��ĵ�4λ
            Data2<={Rx_Data[7],Rx_Data[6],Rx_Data[5],Rx_Data[4]};//���յ��ĸ�4λ
        end 
    end 

endmodule
