library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;



entity CARRY_SAVE_3 is
Port (clk, rst: in std_logic;
      OP1,OP2,OP3:IN STD_LOGIC_VECTOR(17 DOWNTO 0);
      FINAL_RIS:OUT STD_LOGIC_VECTOR(19 DOWNTO 0));
end CARRY_SAVE_3;

architecture Behavioral of CARRY_SAVE_3 is

SIGNAL VR1,SP1: STD_LOGIC_VECTOR(18 DOWNTO 0);

component STEP1_3 is
Port (clk, rst: in std_logic;
      op1,op2,op3:in std_logic_vector(17 downto 0);
      SP,VR:OUT STD_LOGIC_VECTOR(18 DOWNTO 0) );
end component;

component Pipeline_3 is
port ( A,B : in std_logic_vector (18 downto 0);
     clock, reset, cin : in std_logic;
    Sum : out std_logic_vector (19 downto 0));
end component;


begin

BLOCCO1: STEP1_3 port map(clk, rst, OP1, OP2, OP3, SP1, VR1);
FINAL: Pipeline_3 port map(SP1, VR1, clk, rst,'0', FINAL_RIS);

end Behavioral;
