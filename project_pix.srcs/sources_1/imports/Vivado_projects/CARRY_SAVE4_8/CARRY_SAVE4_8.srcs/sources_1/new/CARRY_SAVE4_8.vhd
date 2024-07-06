library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity CARRY_SAVE4_8 is --la somma è totalmente unsigned!
Port (clk, rst: in std_logic;
      OP1,OP2,OP3,OP4:IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      pix_to_delay: in std_logic_vector(7 downto 0);
      FINAL_RIS, central_pix:OUT STD_LOGIC_VECTOR(9 DOWNTO 0));
end CARRY_SAVE4_8;

architecture Behavioral of CARRY_SAVE4_8 is

SIGNAL VR1,SP1: STD_LOGIC_VECTOR(8 DOWNTO 0);
SIGNAL VR2,SP2: STD_LOGIC_VECTOR(9 DOWNTO 0);

component FIRST is
Port (clk, rst: in std_logic;
      op1,op2,op3,op4:in std_logic_vector(7 downto 0);
      pix_to_delay: in std_logic_vector(7 downto 0);
      SP,VR:OUT STD_LOGIC_VECTOR(8 DOWNTO 0);
      op4_out,central_pix: out std_logic_vector(7 downto 0));
end component;

component SECOND is
Port (clk, rst: in std_logic;
      op1,op2: in std_logic_vector(8 downto 0);
      op3,pix_to_delay: in std_logic_vector(7 downto 0);
      SP,VR:OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
      central_pix: out std_logic_vector(7 downto 0));
end component;

component PIPE_TO_ADDER is
port ( A,B : in std_logic_vector (9 downto 0);
    Cin, clock, reset : in std_logic;
    pix_to_delay: in std_logic_vector(7 downto 0);
    Sum,central_pix : out std_logic_vector (9 downto 0));
end component;

signal op4_out: std_logic_vector(7 downto 0);
signal pix_temp:std_logic_vector(15 downto 0);

begin

BLOCCO1: FIRST port map(clk, rst, OP1, OP2, OP3, OP4, pix_to_delay, SP1, VR1, op4_out,pix_temp(7 downto 0));
BLOCCO2: SECOND port map(clk, rst, SP1, VR1, op4_out,pix_temp(7 downto 0), SP2, VR2,pix_temp(15 downto 8));
FINAL: PIPE_TO_ADDER port map(SP2, VR2, '0', clk, rst, pix_temp(15 downto 8), FINAL_RIS, central_pix);

end Behavioral;
