library IEEE;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
use ieee.numeric_std.all;

entity RGB_TO_GRAY is
generic ( DIM_FIFO_EXTRA : integer := 3;
          DELAY_PIPE: integer := 3);
port(clk,rst: in std_logic;
pix_in: in std_logic_vector(23 downto 0);
pix_grey: out std_logic_vector(7 downto 0));
end RGB_TO_GRAY;    

architecture Behavioral of RGB_TO_GRAY is

signal op1_R,op2_R,op3_R,zero: std_logic_vector(7 downto 0);
signal op1_G,op2_G,op3_G,op4_G: std_logic_vector(7 downto 0);
signal op1_B,op2_B,op3_B,op4_B: std_logic_vector(7 downto 0);

signal op1_R_p,op2_R_p,op3_R_p: std_logic_vector(7 downto 0);
signal op1_G_p,op2_G_p,op3_G_p,op4_G_p: std_logic_vector(7 downto 0);
signal op1_B_p,op2_B_p,op3_B_p,op4_B_p: std_logic_vector(7 downto 0);

signal results: std_logic_vector(39 downto 0);
signal correction_G,correction_B: std_logic_vector(7 downto 0);
signal special,special_p:std_logic_vector(10 downto 0);
signal pix_inp: std_logic_vector(23 downto 0);

signal restoR4,restoR32,restoR64: std_logic_vector(7 downto 0);
signal restoG2,restoG16,restoG64,restoG128,restoG128p,restoG64p,restoR64p,RESTOB64p: std_logic_vector(7 downto 0);
signal SUMRp,SUMR_Fp,SUMGp,SUMG2p,SUMG_Fp,SUMBp,SUMB2p,SUMB_Fp: std_logic_vector(7 downto 0);
signal restoB16,restoB32,restoB64, restoB128,restoB128p: std_logic_vector(7 downto 0);
signal SUMR,SUMR_F: std_logic_vector(8 downto 0);
signal SUMG,SUMG2,SUMG_F: std_logic_vector(8 downto 0);
signal SUMB,SUMB2,SUMB_F: std_logic_vector(8 downto 0);
signal correction_R,correction_R_p: std_logic_vector(7 downto 0);
signal ausiliars: std_logic_vector(15 downto 0);
signal auxG: std_logic_vector(15 downto 0);
signal auxB: std_logic_vector(15 downto 0);
signal EXTRA: std_logic_vector(8 downto 0);
signal FIX: std_logic_vector(7 downto 0);

component CARRY_SAVE4_8 is
Port (clk, rst: in std_logic;
      OP1,OP2,OP3,OP4:IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      pix_to_delay: in std_logic_vector(7 downto 0);
      FINAL_RIS, central_pix:OUT STD_LOGIC_VECTOR(9 DOWNTO 0));
end component;

--component COMPARATORE is --Comunica se A è > B, B va passato in complemento a due.
--port(A,B: in std_logic_vector(11 downto 0);
--is_greater: out std_logic);
--end component;

component ADDER8 is 
port ( A,B : in std_logic_vector (7 downto 0); 
Cin : in std_logic; 
Sum : out std_logic_vector (8 downto 0)); 
end component; 

component FIFO8_NORMAL is
    generic ( DIM_FIFO_N : integer);
Port(clk,rst: std_logic;
D_in : in std_logic_vector(7 downto 0);
D_out: out std_logic_vector(7 downto 0));
end component;

component FIFO_NORMAL is
    generic ( DIM_FIFO_N : integer);
Port(clk,rst: std_logic;
D_in : in std_logic;
D_out: out std_logic);
end component;

component REG8 is
Port (Din: in std_logic_vector(7 downto 0);
clk, rst: in std_logic;
Q: out std_logic_vector (7 downto 0)
);
end component;

begin

--ROSSI
op1_R<='0'&'0'&pix_inp(7 downto 2);--pix/4
op2_R<='0'&'0'&'0'&'0'&'0'&pix_inp(7 downto 5);--pix/32
op3_R<='0'&'0'&'0'&'0'&'0'&'0'&pix_inp(7 downto 6);--pix/64
zero<=(others=>'0');
restoR4<='0'&pix_inp(1 downto 0)&"00000";
restoR32<='0'&pix_inp(4 downto 0)&"00";
restoR64<='0'&pix_inp(5 downto 0)&'0';

--VERDI
op1_G<='0'&pix_inp(15 downto 9); --/2
op2_G<='0'&'0'&'0'&'0'&pix_inp(15 downto 12);--/16
op3_G<='0'&'0'&'0'&'0'&'0'&'0'&pix_inp(15 downto 14);--/64
op4_G<='0'&'0'&'0'&'0'&'0'&'0'&'0'&pix_inp(15);--/128
restoG2<='0'&pix_inp(8)&"000000";
restoG16<='0'&pix_inp(11 downto 8)&"000";
restoG64<='0'&pix_inp(13 downto 8)&'0';
restoG128<='0'&pix_inp(14 downto 8);

--BLU
op1_B<='0'&'0'&'0'&'0'&pix_inp(23 downto 20);--/16
op2_B<='0'&'0'&'0'&'0'&'0'&pix_inp(23 downto 21);--/32
op3_B<='0'&'0'&'0'&'0'&'0'&'0'&pix_inp(23 downto 22);--/64
op4_B<='0'&'0'&'0'&'0'&'0'&'0'&'0'&pix_inp(23);--/128
restoB16<='0'&pix_inp(19 downto 16)&"000";
restoB32<='0'&pix_inp(20 downto 16)&"00";
restoB64<='0'&pix_inp(21 downto 16)&'0';
restoB128<='0'&pix_inp(22 downto 16);

--GESTIONE RESTI ROSSI
RESTI_R: ADDER8 port map(restoR4,restoR32,'0',SUMR);

special(0)<=SUMR(7);

pipeR: REG8 port map(SUMR(7 downto 0),clk,rst,SUMRp);
pipeR_s: FIFO_NORMAL generic map(2)
port map (clk,rst,special(0),special_p(0));
R_R64: FIFO8_NORMAL generic map(1)
port map(clk,rst,restoR64,restoR64p);
ausiliars(7 downto 0)<='0'&SUMRp(6 downto 0);
RESTI_R2:ADDER8 port map(restoR64p,ausiliars(7 downto 0),'0',SUMR_F);
pipeR2: REG8 port map(SUMR_F(7 downto 0),clk,rst,SUMR_Fp);

special_p(1)<=SUMR_Fp(7);
special_p(2)<=SUMR_Fp(6);

with special_p(2 downto 0) select
correction_R<= conv_std_logic_vector(1,8) when "001",
               conv_std_logic_vector(1,8) when "010",
               conv_std_logic_vector(1,8) when "100",
               conv_std_logic_vector(2,8) when "110",
               conv_std_logic_vector(2,8) when "101",
               conv_std_logic_vector(2,8) when "011",
               conv_std_logic_vector(3,8) when "111",
               conv_std_logic_vector(0,8) when others;
               
FIFO_FINALER: FIFO8_NORMAL generic map(1)
port map(clk,rst,correction_R,CORRECTION_R_p);

----------------------------------

--GESTIONE RESTI VERDI
RESTI_G: ADDER8 port map(restoG2,restoG16,'0',SUMG);
special(3)<=SUMG(7);
pipeG: REG8 port map(SUMG(7 downto 0),clk,rst,SUMGp);
pipeG_s: FIFO_NORMAL generic map(3)
port map (clk,rst,special(3),special_p(3));
G_R64: REG8 port map(restoG64,clk,rst,restoG64p);

auxG(7 downto 0)<='0'&SUMGp(6 downto 0);
RESTI_G2:ADDER8 port map(restoG64p,auxG(7 downto 0),'0',SUMG2);
special(4)<=SUMG2(7);

pipeG2: REG8 port map(SUMG2(7 downto 0),clk,rst,SUMG2p);

FIFO_RESTOG: FIFO8_NORMAL generic map(2)
port map(clk,rst,restoG128,restoG128p);
pipeG_s1: FIFO_NORMAL generic map(2)
port map (clk,rst,special(4),special_p(4));

auxG(15 downto 8)<='0'&SUMG2p(6 downto 0);
RESTI_G3:ADDER8 port map(restoG128p,auxG(15 downto 8),'0',SUMG_F);
FIFO_G3: FIFO8_NORMAL generic map(1)
port map(clk,rst,SUMG_F(7 downto 0),SUMG_Fp);
special_p(5)<=SUMG_Fp(7);
special_p(6)<=SUMG_Fp(6);

with special_p(6 downto 3) select
correction_G<= conv_std_logic_vector(1,8) when "0001",
               conv_std_logic_vector(1,8) when "0010",
               conv_std_logic_vector(1,8) when "0100",
               conv_std_logic_vector(2,8) when "0110",
               conv_std_logic_vector(2,8) when "0101",
               conv_std_logic_vector(2,8) when "0011",
               conv_std_logic_vector(3,8) when "0111",
               
               conv_std_logic_vector(1,8) when "1000",
               conv_std_logic_vector(2,8) when "1001",
               conv_std_logic_vector(2,8) when "1010",
               conv_std_logic_vector(2,8) when "1100",
               conv_std_logic_vector(3,8) when "1110",
               conv_std_logic_vector(3,8) when "1101",
               conv_std_logic_vector(3,8) when "1011",
               conv_std_logic_vector(4,8) when "1111",
               conv_std_logic_vector(0,8) when others;
----------------------------------

--GESTIONE RESTI BLU
RESTI_B: ADDER8 port map(restoB16,restoB32,'0',SUMB);
special(7)<=SUMB(7);

pipeB: REG8 port map(SUMB(7 downto 0),clk,rst,SUMBp);

pipeB_s: FIFO_NORMAL generic map(3)
port map (clk,rst,special(7),special_p(7));
B_R64: REG8 port map(restoB64,clk,rst,restoB64p);

auxB(7 downto 0)<='0'&SUMBp(6 downto 0);
RESTI_B2:ADDER8 port map(restoB64p,auxB(7 downto 0),'0',SUMB2);
special(8)<=SUMB2(7);

pipeB2: REG8 port map(SUMB2(7 downto 0),clk,rst,SUMB2p);
pipeB_s2: FIFO_NORMAL generic map(2)
port map (clk,rst,special(8),special_p(8));
FIFO_RESTOB: FIFO8_NORMAL generic map(2)
port map(clk,rst,restoB128,restoB128p);

auxB(15 downto 8)<='0'&SUMB2p(6 downto 0);
RESTI_B3:ADDER8 port map(restoB128p,auxB(15 downto 8),'0',SUMB_F);
FIFO_B3: FIFO8_NORMAL generic map(1)
port map(clk,rst,SUMB_F(7 downto 0),SUMB_Fp);

special_p(9)<=SUMB_Fp(7);
special_p(10)<=SUMB_Fp(6);

with special_p(10 downto 7) select
correction_B<= conv_std_logic_vector(1,8) when "0001",
               conv_std_logic_vector(1,8) when "0010",
               conv_std_logic_vector(1,8) when "0100",
               conv_std_logic_vector(2,8) when "0110",
               conv_std_logic_vector(2,8) when "0101",
               conv_std_logic_vector(2,8) when "0011",
               conv_std_logic_vector(3,8) when "0111",
               
               conv_std_logic_vector(1,8) when "1000",
               conv_std_logic_vector(2,8) when "1001",
               conv_std_logic_vector(2,8) when "1010",
               conv_std_logic_vector(2,8) when "1100",
               conv_std_logic_vector(3,8) when "1110",
               conv_std_logic_vector(3,8) when "1101",
               conv_std_logic_vector(3,8) when "1011",
               conv_std_logic_vector(4,8) when "1111",
               conv_std_logic_vector(0,8) when others;

SUM_R_CORR: ADDER8 port map(correction_B,correction_G,'0',EXTRA);

FIFO_OPR1: FIFO8_NORMAL generic map(DELAY_PIPE)
port map(clk,rst,op1_R,op1_R_p);
FIFO_OPR2: FIFO8_NORMAL generic map(DELAY_PIPE)
port map(clk,rst,op2_R,op2_R_p);
FIFO_OPR3: FIFO8_NORMAL generic map(DELAY_PIPE)
port map(clk,rst,op3_R,op3_R_p);
FIFO_OPG1: FIFO8_NORMAL generic map(DELAY_PIPE)
port map(clk,rst,op1_G,op1_G_p);
FIFO_OPG2: FIFO8_NORMAL generic map(DELAY_PIPE)
port map(clk,rst,op2_G,op2_G_p);
FIFO_OPG3: FIFO8_NORMAL generic map(DELAY_PIPE)
port map(clk,rst,op3_G,op3_G_p);
FIFO_OPG4: FIFO8_NORMAL generic map(DELAY_PIPE)
port map(clk,rst,op4_G,op4_G_p);
FIFO_OPB1: FIFO8_NORMAL generic map(DELAY_PIPE)
port map(clk,rst,op1_B,op1_B_p);
FIFO_OPB2: FIFO8_NORMAL generic map(DELAY_PIPE)
port map(clk,rst,op2_B,op2_B_p);
FIFO_OPB3: FIFO8_NORMAL generic map(DELAY_PIPE)
port map(clk,rst,op3_B,op3_B_p);
FIFO_OPB4: FIFO8_NORMAL generic map(DELAY_PIPE)
port map(clk,rst,op4_B,op4_B_p);
FIFO_EXTRA: FIFO8_NORMAL generic map(DIM_FIFO_EXTRA)
port map(clk,rst,EXTRA(7 downto 0),FIX);

TIMES_0299: CARRY_SAVE4_8 port map(clk,rst,op1_R_p,op2_R_p,op3_R_p,correction_R_p,zero,results(9 downto 0));
TIMES_0587: CARRY_SAVE4_8 port map(clk,rst,op1_G_p,op2_G_p,op3_G_p,op4_G_p,zero,results(19 downto 10));
TIMES_0114: CARRY_SAVE4_8 port map(clk,rst,op1_B_p,op2_B_p,op3_B_p,op4_B_p,zero,results(29 downto 20));

SUM_EACH_OTHER: CARRY_SAVE4_8 port map(clk,rst,results(7 downto 0),results(17 downto 10),results(27 downto 20),FIX,zero,results(39 downto 30));

pix_grey<=results(37 downto 30);

process(clk,rst)
begin
if rst = '1' then
pix_inp<=(others=>'0');
elsif rising_edge(clk) then
pix_inp<=pix_in;
end if;
end process;
end Behavioral;