module KEYBOARD(clk,reset,KeyClock,KeyData,PS_Data,save);
input clk,reset,KeyClock,KeyData;
output [3:0] PS_Data;
output [3:0] save;

wire neg_KeyClock;

reg KeyClock_r0,KeyClock_r1,KeyClock_r2,RxEn,LedEn;
reg [3:0] save,counter,PS_Data;
reg [7:0] LastRxData;
reg [10:0] RxData;


always @(posedge clk or negedge reset) //clk Ϊϵͳ��Ƶʱ��(��6MHz)�źţ�reset Ϊϵͳ��λ�ź�
begin
    if(!reset)
        begin
            KeyClock_r0 <= 1'b0;
            KeyClock_r1 <= 1'b0;
            KeyClock_r2 <= 1'b0;
        end
    else
        begin //����״̬�������˲�����
            KeyClock_r0 <= KeyClock;//KeyClock r0 �����µ�
            KeyClock_r1 <= KeyClock_r0;
            KeyClock_r2 <= KeyClock_r1;//KeyClock r2 ����ɵ�
        end
end
assign neg_KeyClock =~KeyClock_r1 & KeyClock_r2;
//neg KeyClock��־�� KeyClock �½��أ�ǰ1��0������˵r2Ϊ1��r1Ϊ0

//����ɨ����
always @(posedge clk or negedge reset)
begin
    if(reset==0)
        begin
            counter=0;//counter Ϊ���ռ�����
            RxEn<=1;//RxEn Ϊ������ɱ�־�źţ��½�����Ч;�����ʼ��Ϊ������δ���
        end
    else if(neg_KeyClock)
        begin
            RxData[counter]<=KeyData;
            //RxData������ʱ�洢���յ��� PS/2 ����
            //��Ȼ�����յ�λ�����ո�λ(��Ϊ������ʱ���ȷ���λ���󷢸�λ��)
            if(counter>=10) 
                RxEn<=0;
            else RxEn<=1;
            //������ϣ���������11 ��
            //��0��10������1����ʼλ��8������λ��1����żУ��λ��1��ֹͣλ
            if(counter>=10)
                counter=0;
            else counter=counter+1;
        end
end

//����һ����������������
always @(negedge RxEn or negedge reset)
begin
    if(reset==0)
        begin
            LastRxData<=8'b01000101;//LastRxData���ڼ�¼��һ�ν��յ���PS/2����;��ʼ��Ϊ45h����0��ͨ��
            LedEn<=0;//LedEnΪ0�������������ʾ��Ϊ1��������ʾ
        end
    else if(RxEn==0)//�������
        begin
            if(LastRxData==8'b11110000) LedEn<=1;//FOh �Ƕ����־�������Ͳ�����ʾ�� (��LedEn=1 ������)�����ⰴһ�μ�����������ͬ����
            else LedEn<=0;//�����������ʾ
            LastRxData<=RxData[8:1];
            //�洢��RxData�����յ���8λ�����͸�LastRxData��[0]����ʼλ�Ͳ�����
        end
end
//����ɨ����
always @(LastRxData or reset or LedEn)
begin
    if(reset==0)
        PS_Data<=0;
    else if(LedEn==0)//��������ʾʱ
        begin
            case(LastRxData)
                //ʹ��һ�����������ʾͨ������Ӧ������:�����Ȱ�ͨ��LastRxData ���������PS Data
                //save ���ڼ�ס�ղŵİ���ֵ���Ա��ڰ����������ּ�ʱ����ԭֵ
                //ע:ֱ����save<=PS Data �Ļ��������⣬��Ϊ�Ƿ�����ʽ��ֵ
                8'b01000101: begin PS_Data<=4'b0000;save<=4'b0000;end //45hΪ0��ͨ��
                8'b00010110: begin PS_Data<=4'b0001;save<=4'b0001;end //16hΪ1��ͨ��
                8'b00011110: begin PS_Data<=4'b0010;save<=4'b0010;end //1EhΪ2��ͨ��
                8'b00100110: begin PS_Data<=4'b0011;save<=4'b0011;end //26hΪ3��ͨ��
                8'b00100101: begin PS_Data<=4'b0100;save<=4'b0100;end //25h Ϊ4��ͨ��
                8'b00101110: begin PS_Data<=4'b0101;save<=4'b0101;end //2EhΪ5��ͨ��
                8'b00110110: begin PS_Data<=4'b0110;save<=4'b0110;end //36h Ϊ6��ͨ��
                8'b00111101: begin PS_Data<=4'b0111;save<=4'b0111;end //3DhΪ7��ͨ��
                8'b00111110: begin PS_Data<=4'b1000;save<=4'b1000;end //3EhΪ8��ͨ��
                8'b01000110: begin PS_Data<=4'b1001;save<=4'b1001;end //46hΪ9��ͨ��
                //�����Ҫʶ�������̰�������������������
                default: PS_Data<=save;//���������������־FO ����Ч������ԭֵ
            endcase
        end
end
//     input clk,reset;
//     input KeyData,KeyClock;
//     output [3:0] PS_Data;

//     reg [3:0] PS_Data,save;
//     reg KeyClock_r0,KeyClock_r1,KeyClock_r2,RxEn,LedEn;
//     wire neg_KeyClock;
//     reg [3:0] counter;
//     reg [10:0] RxData;
//     reg [7:0] LastRxData;


// //KeyData Ϊ PS/2�������ߣ��� KeyClock Ϊ PS/2 ��ʱ����
// //KeyData �� KBDATA ��Ӧ CPLD ��4 �ţ���ʵ����ϲ��뿪��3 ���ã���������һ�༴��Ӱ�� PS/2����
// //KeyClock �� KBCLK ��Ӧ CPLD ��3 �ţ���ʵ����ϲ��뿪��4 ���ã���������һ�༴��Ӱ�� PS/2����
// always @(posedge clk or negedge reset) //clk Ϊϵͳ��Ƶʱ��(��6MH) �źţ�reset Ϊϵͳ��λ�ź�
// begin
//   if(!reset)
//   begin
//     KeyClock_r0 <= 1'b0;
//     KeyClock_r1 <= 1'b0;
//     KeyClock_r2 <= 1'b0;
//   end
//   else begin  //����״̬�������˲�����
//     KeyClock_r0 <= KeyClock; //KeyClock r0 �����µ�
//     KeyClock_r1 <= KeyClock_r0;
//     KeyClock_r2 <= KeyClock_r1;//KeyClock r2 ����ɵ�
//   end
// end

//     assign neg_KeyClock =~KeyClock_r1 & KeyClock_r2;
//     //neg KeyClock ��־�� KeyClock �½��أ�ǰ1��0������˵r2Ϊ1��r1Ϊ0
//     //����ɨ����
//     always @(posedge clk or negedge reset)
//     begin
//         if(reset==0) begin
//             counter = 0;//counter Ϊ���ռ�����
//             RxEn<=1;//RxEn Ϊ������ɱ�־�źţ��½�����Ч:�����ʼ��Ϊ������δ���
//         end
//         else if(neg_KeyClock) begin
//             RxData[counter]<=KeyData;
//             //RxData ������ʱ�洢���յ���PS/2����
//             //��Ȼ�����յ�λ�����ո�λ(��Ϊ������ʱ���ȷ���λ���󷢸�λ��)
//             if(counter>=10) RxEn<=0;
//             else RxEn<=1;
//             //������ϣ��������� 11 ��
//             //��0��10������1����ʼλ��8 ������λ��1����żУ��λ��1��ֹͣλ
//             if(counter>=10)counter=0;
//             else counter=counter+1;
//         end
//     end

//     //����һ����������������
//     always @(negedge RxEn or negedge reset)
//     begin
//         if(reset ==0)begin
//             LastRxData<=8'b01000101;
//             //LastRxData���ڼ�¼��һ�ν��յ��� PS/2����:��ʼ��Ϊ45h����0��ͨ��
//             LedEn<=0;//LedEn Ϊ0�������������ʾ��Ϊ1��������ʾ

//         end 
//         else if(RxEn==0)//�������
//         begin
//             if(LastRxData==8'b11110000) LedEn<=1;
//             //FOh �Ƕ����־�������Ͳ�����ʾ��(�� LedEn=1 ������)�����ⰴһ�μ�����������ͬ����
//             else LedEn<=0;//�����������ʾ
//             LastRxData<=RxData[8:1];
//             //�洢�� RxData �����յ���8λ�����͸� LastRxData��[0����ʼλ�Ͳ�����
//         end
//     end

//     //����ɨ����
//     always @(LastRxData or reset or LedEn)
//     begin
//         if(reset ==0)
//         begin
//             PS_Data <= 0;
//         end 
//         else if (LedEn == 0)//��������ʾʱ
//         begin
//             case(LastRxData)
//                 //ʹ��һ�����������ʾͨ������Ӧ������;�����Ȱ�ͨ�� LastRxData ��������� PS Data
//                 //save ���ڼ�ס�ղŵİ���ֵ���Ա��ڰ����������ּ�ʱ����ԭֵ
//                 //ע:ֱ���� save<=PS Data �Ļ��������⣬��Ϊ�Ƿ�����ʽ��ֵ
//                 8'b01000101: begin PS_Data<=4'b0000; save<=4'b0000; end //45hΪ0��ͨ��
//                 8'b00010110: begin PS_Data<=4'b0001; save<=4'b0001; end //16h Ϊ1��ͨ��
//                 8'b00011110: begin PS_Data<=4'b0010; save<=4'b0010; end //1Eh Ϊ2��ͨ��
//                 8'b00100110: begin PS_Data<=4'b0011; save<=4'b0011; end //26h Ϊ3 ��ͨ��
//                 8'b00100101: begin PS_Data<=4'b0100; save<=4'b0100; end //25h Ϊ4 ��ͨ��
//                 8'b00101110: begin PS_Data<=4'b0101; save<=4'b0101; end //2EhΪ5��ͨ��
//                 8'b00110110: begin PS_Data<=4'b0110; save<=4'b0110; end //36h Ϊ6��ͨ��
//                 8'b00111101: begin PS_Data<=4'b0111; save<=4'b0111; end //3DhΪ7��ͨ��
//                 8'b00111110: begin PS_Data<=4'b1000; save<=4'b1000; end //3Eh Ϊ8��ͨ��
//                 8'b01000110: begin PS_Data<=4'b1001; save<=4'b1001; end //46h Ϊ9��ͨ��
//                 //�����Ҫʶ�������̰�������������������
//                 default: PS_Data<=save; //���������������־ FO ����Ч������ԭֵ
//         endcase
//         end
//         // else PS_Data <= save; 
//         // else begin
//         //     PS_Data <= save;
//         // end
//     end

endmodule
