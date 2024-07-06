library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Pipeline_3 is
port ( A,B : in std_logic_vector (18 downto 0);
     clock, reset, cin : in std_logic;
    Sum : out std_logic_vector (19 downto 0));
end Pipeline_3;

architecture Behavioral of Pipeline_3 is
signal sum_p : std_logic_vector(20 downto 0);

component ADDER20  
port ( A,B : in std_logic_vector (19 downto 0); 
Cin : in std_logic; 
Sum : out std_logic_vector (20 downto 0)); 
end component;

signal A_ext,B_ext: std_logic_vector(19 downto 0);

begin

A_ext<=A(18)& A;
B_ext<=B(18)& B;
dut: ADDER20 port map (A_ext,B_ext,cin,sum_p);
process(clock, reset)
begin
if (reset = '1') then
sum <= (others=>'0');
elsif(rising_edge(clock)) then
sum<= sum_p(19 downto 0);
end if;
end process;



end Behavioral;
