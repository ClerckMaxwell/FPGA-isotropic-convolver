library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity RCA_4BIT is
port(a,b : in std_logic_vector (3 downto 0); 
Cin : in std_logic; 
Sic : out std_logic_vector (3 downto 0); 
Cout: out std_logic); 
end RCA_4BIT;

architecture Behavioral of RCA_4BIT is

component FA is
 Port (op1,op2,op3:in std_logic;
       SP,VR:OUT STD_LOGIC);
end component;

signal Cint: std_logic_vector(4 downto 0);

begin

Cint(0)<=Cin;

FAs: for i in 0 to 3 generate
FA_i: FA port map (a(i),b(i),Cint(i),Sic(i),Cint(i+1));
end generate;
Cout<=Cint(4);
end Behavioral;
