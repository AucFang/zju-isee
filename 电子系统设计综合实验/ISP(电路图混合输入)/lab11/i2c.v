module I2C(CLK,RST,SDA,SCL,CMD_RD,CMD_WR,DATA_IN,DataLED);
    //SDA Ϊ12C �������ߣ���ӦCPLD ��5 �ţ���ʵ����ϲ��뿪��2 ���ã���������һ�༴��Ӱ�� 12C
    //SCLΪ12C ʱ���ߣ���ӦCPLD ��6�ţ���ʵ����ϲ��뿪��1���ã���������һ�༴��Ӱ��12C
    //CMD RD��CMD WR Ϊ��������
    //CMD WRΪд����Ӧ��������A;CMD RD Ϊ������Ӧ�������� B

    //phase0,phasel,phase2,phase3 Ϊ�ĸ��׶ε�״̬����
    //phase0 ��Ӧ SCL��������ʱ�̣�phase2 ��Ӧ SCL ���½���ʱ��
    //phase1 ��Ӧ��SCL�ߵ�ƽ���м�ʱ�̣�phase3 ��Ӧ�� SCL�͵�ƽ���м�ʱ��
    //phase1 Ϊ���ݵ���Чʱ�Σ���ʱ�����߲�����仯
    //phase3 Ϊ���ݵ���Чʱ�Σ������������

    input CLK,RST,CMD_RD,CMD_WR;
    inout SDA;
    input [3:0] DATA_IN;
    output SCL;
    output [3:0] DataLED;

    //�������ã��൱��C�����еĺ궨��
    parameter i2c_addr=7'b1010000,eeprom_addr=8'b00000110;
    //i2c addr Ϊ EEPROM �����ӻ���ַ
    //eeprom addr Ϊ EEPROM�洢�ռ��ַ��������̶��洢��ַΪ 00000110
    assign SCL=scl_buf; //scl bufΪI2C ʱ���߻���
    assign SDA=(Flag_RW)?sda_buf:1'bz;//sda bufΪI2C �����߻���
    //Flag RWΪ1��SDA ����Ϊд״̬��Ϊ0��SDA ����Ϊ��״̬

    reg [3:0] clk_div,DataLED;
    reg phase0,phase1,phase2,phase3,Flag_RW,start_delay;
    reg sda_buf,scl_buf,sda_tem;
    reg [5:0] bit_state;
    reg [9:0] key_delay;
    reg [7:0] WrData,RdData;
    reg [1:0] eeprom_state;

    //����������4���׶�
    always @(posedge CLK or negedge RST)//CLK Ϊ6MHz ʱ��Դ�ź�
    begin
        if(RST==0)
        begin
            phase0 <= 0;
            phase1 <= 0;
            phase2 <= 0;
            phase3 <= 0;
            clk_div <= 0;
        end
        else begin
            if(clk_div!=4'b1111) clk_div <= clk_div + 4'b0001;
            else clk_div <= 0;
            //phase0:������
            if(phase0==1) phase0 <= 0;
            else if(clk_div==4'b1111) phase0 <= 1;
            //phasel:��1�����м�ʱ��
            if(phase1==1)phase1 <= 0;
            else if(clk_div==4'b0011) phase1 <= 1;
            //phase2:�½���
            if(phase2==1)phase2 <= 0;
            else if(clk_div==4'b0111) phase2 <= 1;
            //phase3:��0�����м�ʱ��
            if(phase3==1)phase3 <= 0;
            else if(clk_div==4'b1011) phase3 <= 1;
            //����Ч����:4��Ϊһ��phase������16 �ľ����ĸ� phase
            //0 ʱ�� phase0=1��4 ʱ�� phasel=1��8 ʱ�� phase2=1��12 ʱ�� phase3=1
        end 

    end 

    //���ڰ�����������ʱ����
    always @(posedge CLK or negedge RST)
    begin
        if(RST==0)key_delay<=0; //key_delay Ϊ��������������
        else if(start_delay==1) key_delay<=key_delay+1; // start delay Ϊ��������������������ʼ�źţ�1��Ч
        else key_delay<=0;
    end

    //I2C ����
    always @(posedge CLK or negedge RST)
    begin
        if(RST==0)
        begin
            start_delay<=0;
            eeprom_state<=0;//eeprom state Ϊ����״̬��0 �޲�����1д����״̬��2������״̬
	    //DataLED<=DATA_IN;
	    DataLED<=0;
        end
        else begin
            case(eeprom_state)
            0: begin //�޲�������״̬
                WrData<={4'b0000,DATA_IN};//�ϲ���һ��8λ��
                //DATAINΪ�����4λ����;WrData Ϊ��д��EEPROM��8λ����
                RdData<=0;//RdData ���ڴ�Ŵ� EEPROM������8λ����
                bit_state<=0;//bit state Ϊ�������ݻ��������ʱ��λ״̬
                Flag_RW<=0;//��
		//DataLED<=DATA_IN;

                //����������
                if((key_delay==0)&&((CMD_WR==0)||(CMD_RD==0)))start_delay<=1;
                else if(key_delay==10'b1000000000)
                begin
                    if(CMD_WR==0)eeprom_state<=1;//д����״̬
                    else if(CMD_RD==0)eeprom_state<=2;//������״̬
                    else eeprom_state<=0;//�޲�������״̬
                    start_delay<=0;//ֹͣ������������������
                end
            end
            1: begin  //дEEPROM����(��ʱ��μ�ͼ9-17�е�(b)ͼ
                if(phase0==1)scl_buf<=1;
                else if(phase2==1)scl_buf<=0;
                //1 ��0���䣬������ʼSTART �ź�
                case(bit_state)
                    0://�ٿ�ʼ���ӻ���ַ�ĵ�0λ
                    //i2c addr �ӻ���ַ�ǴӸ�λ��ʼ�ģ�����洢��ַ�����ݷ�����ʽ�෴
                    //����ɲο�24LC02�����ֲ�
                    begin
                        if(phase1==1)begin sda_buf<=0;Flag_RW<=1;end
                        if((phase3&Flag_RW)==1)
                        begin sda_buf<=i2c_addr[6];Flag_RW<=1;bit_state<=1;end
                    end
                    1: begin //�ӻ���ַ�ĵ�1λ
                        if(phase3==1)begin sda_buf<=i2c_addr[5];Flag_RW<=1;bit_state<=2;end
                    end
                    2: begin //�ӻ���ַ�ĵ�2λ
                        if(phase3==1)begin sda_buf<=i2c_addr[4];Flag_RW<=1;bit_state<=3;end
                    end
                    3: begin //�ӻ���ַ�ĵ�3λ
                        if(phase3==1)begin sda_buf<=i2c_addr[3];Flag_RW<=1;bit_state<=4;end
                    end
                    4: begin //�ӻ���ַ�ĵ�4λ
                        if(phase3==1)begin sda_buf<=i2c_addr[2];Flag_RW<=1;bit_state<=5;end
                    end
                    5: begin //�ӻ���ַ�ĵ�5λ
                        if(phase3==1)begin sda_buf<=i2c_addr[1];Flag_RW<=1;bit_state<=6;end
                    end
                    6: begin //�ӻ���ַ�ĵ�6λ
                        if(phase3==1)begin sda_buf<=i2c_addr[0];Flag_RW<=1;bit_state<=7;end
                    end
                    7: begin //��ʾд�ӻ�(�����ֽ� CONTROLBYTE �е�RWΪ0)
                        if(phase3==1)begin sda_buf<=0;Flag_RW<=1;bit_state<=8;end
                    end
                    8: begin //׼����Ӧ�� ACK
                        if(phase3==1)begin Flag_RW<=0;bit_state<=9;end
                    end
                    9: begin
                        if(phase0==1) sda_tem<=SDA;//sda temΪ12C�����߻��壬��ʱ�洢��SDA ����
                        if((phase1 == 1)&&(sda_tem==1)) eeprom_state<=0;//�ж� ACK �ź��Ƿ���Ч��Ϊ1��ʾ��Ч�����س�ʼ״̬
                        if(phase3==1)begin sda_buf<=eeprom_addr[7];Flag_RW<=1;bit_state<=10;end
                        //�������ݴ洢��ַ WORDADDRESS��д��ַ bit0 
                    end
                    10: begin //дbit1
                        if(phase3==1)begin sda_buf<=eeprom_addr[6];Flag_RW<=1;bit_state<=11;end
                    end
                    11: begin //дbit2
                        if(phase3==1)begin sda_buf<=eeprom_addr[5];Flag_RW<=1;bit_state<=12;end
                    end
                    12: begin //дbit3
                        if(phase3==1)begin sda_buf<=eeprom_addr[4];Flag_RW<=1;bit_state<=13;end
                    end
                    13: begin //дbit4
                        if(phase3==1)begin sda_buf<=eeprom_addr[3];Flag_RW<=1;bit_state<=14;end
                    end
                    14: begin //дbit5
                        if(phase3==1)begin sda_buf<=eeprom_addr[2];Flag_RW<=1;bit_state<=15;end
                    end
                    15: begin //дbit6
                        if(phase3==1)begin sda_buf<=eeprom_addr[1];Flag_RW<=1;bit_state<=16;end
                    end
                    16: begin //дbit7
                        if(phase3==1)begin sda_buf<=eeprom_addr[0];Flag_RW<=1;bit_state<=17;end
                    end
                    17: begin ////׼���� ACK
                        if(phase3==1)begin Flag_RW<=0;bit_state<=18;end
                    end
                    18: begin //��ACK����ʼд������
                        if(phase0==1)begin sda_tem<=SDA;end
                        if((phase1==1)&&(sda_tem==1))eeprom_state<=0;
                        //��ʼд����[7]
                        if(phase3==1)begin sda_buf<=WrData[7];Flag_RW<=1;bit_state<=19;end
                    end
                    19: begin ////׼���� ACK
                        if(phase3==1)begin sda_buf<=WrData[6];Flag_RW<=1;bit_state<=20;end
                    end
                    20: begin //дbit2
                        if(phase3==1)begin sda_buf<=WrData[5];Flag_RW<=1;bit_state<=21;end
                    end
                    21: begin //дbit3
                        if(phase3==1)begin sda_buf<=WrData[4];Flag_RW<=1;bit_state<=22;end
                    end
                    22: begin //дbit4
                        if(phase3==1)begin sda_buf<=WrData[3];Flag_RW<=1;bit_state<=23;end
                    end
                    23: begin //дbit5
                        if(phase3==1)begin sda_buf<=WrData[2];Flag_RW<=1;bit_state<=24;end
                    end
                    24: begin //дbit6
                        if(phase3==1)begin sda_buf<=WrData[1];Flag_RW<=1;bit_state<=25;end
                    end
                    25: begin //дbit7
                        if(phase3==1)begin sda_buf<=WrData[0];Flag_RW<=1;bit_state<=26;end
                    end
                    26: begin //дbit7
                        if(phase3==1)begin Flag_RW<=0;bit_state<=27;end
                    end
                    27: begin //дbit7
                        if(phase0==1) sda_tem<=SDA;
                        if((phase1==1)&&(sda_tem==1)) eeprom_state<=0;
                        if(phase3==1)begin sda_buf<=0;Flag_RW<=1;bit_state<=28;end
                    end
                    28: begin //дbit7
                        if(phase1==1)sda_buf<=1;//SDA ��0��1�����䣬����ֹͣλ STOP
                        if(phase3 == 1) begin
                            bit_state<=0;
                            eeprom_state<=0;
                            //DataLED<=DATA_IN;
                        end
                    end
                    default: begin bit_state<=0;eeprom_state<=0;end
            endcase
            end 
            2: begin
                if(phase0==1)scl_buf<=1;
                else if(phase2==1)scl_buf<=0;
                //1 ��0���䣬������ʼSTART �ź�
                case(bit_state)
                    0://�ٿ�ʼ���ӻ���ַ�ĵ�0λ
                    //i2c addr �ӻ���ַ�ǴӸ�λ��ʼ�ģ�����洢��ַ�����ݷ�����ʽ�෴
                    //����ɲο�24LC02�����ֲ�
                    begin
                        if(phase1==1)begin sda_buf<=0;Flag_RW<=1;end
                        if((phase3&Flag_RW)==1)
                        begin sda_buf<=i2c_addr[6];Flag_RW<=1;bit_state<=1;end
                    end
                    1: begin //�ӻ���ַ�ĵ�1λ
                        if(phase3==1)begin sda_buf<=i2c_addr[5];Flag_RW<=1;bit_state<=2;end
                    end
                    2: begin //�ӻ���ַ�ĵ�2λ
                        if(phase3==1)begin sda_buf<=i2c_addr[4];Flag_RW<=1;bit_state<=3;end
                    end
                    3: begin //�ӻ���ַ�ĵ�3λ
                        if(phase3==1)begin sda_buf<=i2c_addr[3];Flag_RW<=1;bit_state<=4;end
                    end
                    4: begin //�ӻ���ַ�ĵ�4λ
                        if(phase3==1)begin sda_buf<=i2c_addr[2];Flag_RW<=1;bit_state<=5;end
                    end
                    5: begin //�ӻ���ַ�ĵ�5λ
                        if(phase3==1)begin sda_buf<=i2c_addr[1];Flag_RW<=1;bit_state<=6;end
                    end
                    6: begin //�ӻ���ַ�ĵ�6λ
                        if(phase3==1)begin sda_buf<=i2c_addr[0];Flag_RW<=1;bit_state<=7;end
                    end
                    7: begin //��ʾд�ӻ�(�����ֽ� CONTROLBYTE �е�RWΪ0)
                        if(phase3==1)begin sda_buf<=0;Flag_RW<=1;bit_state<=8;end
                    end
                    8: begin //׼����Ӧ�� ACK
                        if(phase3==1)begin Flag_RW<=0;bit_state<=9;end
                    end
                    9: begin
                        if(phase0==1) sda_tem<=SDA;//sda temΪ12C�����߻��壬��ʱ�洢��SDA ����
                        if((phase1 == 1)&&(sda_tem==1)) eeprom_state<=0;//�ж� ACK �ź��Ƿ���Ч��Ϊ1��ʾ��Ч�����س�ʼ״̬
                        if(phase3==1)begin sda_buf<=eeprom_addr[7];Flag_RW<=1;bit_state<=10;end
                        //�������ݴ洢��ַ WORDADDRESS��д��ַ bit0 
                    end
                    10: begin //дbit1
                        if(phase3==1)begin sda_buf<=eeprom_addr[6];Flag_RW<=1;bit_state<=11;end
                    end
                    11: begin //дbit2
                        if(phase3==1)begin sda_buf<=eeprom_addr[5];Flag_RW<=1;bit_state<=12;end
                    end
                    12: begin //дbit3
                        if(phase3==1)begin sda_buf<=eeprom_addr[4];Flag_RW<=1;bit_state<=13;end
                    end
                    13: begin //дbit4
                        if(phase3==1)begin sda_buf<=eeprom_addr[3];Flag_RW<=1;bit_state<=14;end
                    end
                    14: begin //дbit5
                        if(phase3==1)begin sda_buf<=eeprom_addr[2];Flag_RW<=1;bit_state<=15;end
                    end
                    15: begin //дbit6
                        if(phase3==1)begin sda_buf<=eeprom_addr[1];Flag_RW<=1;bit_state<=16;end
                    end
                    16: begin //дbit7
                        if(phase3==1)begin sda_buf<=eeprom_addr[0];Flag_RW<=1;bit_state<=17;end
                    end
                    17: begin ////׼���� ACK
                        if(phase3==1)begin Flag_RW<=0;bit_state<=18;end
                    end
                    18: begin //��ACK����ʼд������
                        if(phase0==1)begin sda_tem<=SDA;end
                        if((phase1==1)&&(sda_tem==1))eeprom_state<=0;
                        //��ʼд����[7]
                        if(phase3==1)begin sda_buf<=1; Flag_RW<=1; bit_state<=19; end
                    end
                    //�ٴη��ʹӻ���ַ����ͼ 9-18(b)ͼ�еĵڶ��� CONTROLBYTE
                    19:
                    begin
                        if(phase1==1)begin sda_buf<=0;Flag_RW<=1;end
                        if((phase3&Flag_RW)==1)
                        begin sda_buf<=i2c_addr[6];Flag_RW<=1;bit_state<=20;end
                    end
                    20: begin //�ӻ���ַ�ĵ�1λ
                        if(phase3==1)begin sda_buf<=i2c_addr[5];Flag_RW<=1;bit_state<=21;end
                    end
                    21: begin //�ӻ���ַ�ĵ�2λ
                        if(phase3==1)begin sda_buf<=i2c_addr[4];Flag_RW<=1;bit_state<=22;end
                    end
                    22: begin //�ӻ���ַ�ĵ�3λ
                        if(phase3==1)begin sda_buf<=i2c_addr[3];Flag_RW<=1;bit_state<=23;end
                    end
                    23: begin //�ӻ���ַ�ĵ�4λ
                        if(phase3==1)begin sda_buf<=i2c_addr[2];Flag_RW<=1;bit_state<=24;end
                    end
                    24: begin //�ӻ���ַ�ĵ�5λ
                        if(phase3==1)begin sda_buf<=i2c_addr[1];Flag_RW<=1;bit_state<=25;end
                    end
                    25: begin //�ӻ���ַ�ĵ�6λ
                        if(phase3==1)begin sda_buf<=i2c_addr[0];Flag_RW<=1;bit_state<=26;end
                    end
                    26: begin //��ʾд�ӻ�(�����ֽ� CONTROLBYTE �е�RWΪ0)
                        if(phase3==1)begin sda_buf<=1;Flag_RW<=1;bit_state<=27;end
                    end
                    27: begin ////׼���� ACK
                        if(phase3==1)begin Flag_RW<=0;bit_state<=28;end
                    end
                    28: begin //��ACK����ʼд������
                        if(phase0==1)begin sda_tem<=SDA; end
                        if((phase1==1)&&(sda_tem==1)) eeprom_state<=0;
                        //��ʼд����[7]
                        if(phase3==1)begin Flag_RW<=0; bit_state<=29; end
                    end
                    29:
                    begin
                        if(phase1 == 1) RdData[7]<=SDA;
                        if(phase3 == 1) bit_state<=30;
                    end
                    30: begin
                        if(phase1==1) RdData[6]<=SDA;
                        if(phase3==1) bit_state<=31;
                    end 
                    31: begin
                        if(phase1==1) RdData[5]<=SDA;
                        if(phase3==1) bit_state<=32;
                    end
                    32: begin
                        if(phase1==1) RdData[4]<=SDA;
                        if(phase3==1) bit_state<=33;
                    end
                    33: begin
                        if(phase1==1) RdData[3]<=SDA;
                        if(phase3==1) bit_state<=34;
                    end
                    34: begin
                        if(phase1==1) RdData[2]<=SDA;
                        if(phase3==1) bit_state<=35;
                    end
                    35: begin
                        if(phase1==1) RdData[1]<=SDA;
                        if(phase3==1) bit_state<=36;
                    end
                    36: begin
                        if(phase1==1) RdData[0]<=SDA;
                        if(phase3==1) bit_state<=37;
                    end
                    37: begin
                        if(phase3==1) begin sda_buf<=0; Flag_RW<=1; bit_state<=38; end
                    end
                    38: begin
                        if(phase1==1) sda_buf<=1;
                        if(phase3==1) begin
                            bit_state<=0;
                            eeprom_state<=0;
                            DataLED<=RdData[3:0];
                        end
                    end
                    default: begin bit_state<=0; eeprom_state<=0; end
                endcase
            end
            default: eeprom_state<=0;
        endcase
        end 
    end 

endmodule
