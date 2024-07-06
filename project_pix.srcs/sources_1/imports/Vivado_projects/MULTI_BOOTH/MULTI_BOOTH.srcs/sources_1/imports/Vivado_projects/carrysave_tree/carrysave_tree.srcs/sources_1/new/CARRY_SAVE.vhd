library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;



entity CARRY_SAVE is
Port (clk, rst: in std_logic;
      OP1,OP2,OP3,OP4:IN STD_LOGIC_VECTOR(11 DOWNTO 0);
      FINAL_RIS:OUT STD_LOGIC_VECTOR(20 DOWNTO 0));
end CARRY_SAVE;

architecture Behavioral of CARRY_SAVE is

SIGNAL VR1,SP1: STD_LOGIC_VECTOR(18 DOWNTO 0);
SIGNAL VR2,SP2: STD_LOGIC_VECTOR(19 DOWNTO 0);

component STEP1 is
Port (clk, rst: in std_logic;
      op1,op2,op3,op4:in std_logic_vector(11 downto 0);
      SP,VR, op4_out:OUT STD_LOGIC_VECTOR(18 DOWNTO 0) );
end component;

component STEP2 is
Port (clk, rst: in std_logic;
      op1,op2: in std_logic_vector(18 downto 0);
      op3: in std_logic_vector(18 downto 0);
      SP,VR:OUT STD_LOGIC_VECTOR(19 DOWNTO 0));
end component;

component Pipeline is
port ( A,B : in std_logic_vector (19 downto 0);
    Cin, clock, reset : in std_logic;
    Sum : out std_logic_vector (20 downto 0));
end component;

signal op4_out: std_logic_vector(18 downto 0);

begin

BLOCCO1: STEP1 port map(clk, rst, OP1, OP2, OP3, OP4, SP1, VR1, op4_out);
BLOCCO2: STEP2 port map(clk, rst, SP1, VR1, op4_out, SP2, VR2);
FINAL: Pipeline port map(SP2, VR2, '0', clk, rst, FINAL_RIS);

end Behavioral;
