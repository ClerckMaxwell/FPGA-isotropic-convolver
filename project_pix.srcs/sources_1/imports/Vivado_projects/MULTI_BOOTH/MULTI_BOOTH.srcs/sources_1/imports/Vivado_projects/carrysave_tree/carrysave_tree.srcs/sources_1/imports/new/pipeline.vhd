library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Pipeline is
port ( A,B : in std_logic_vector (19 downto 0);
    Cin, clock, reset : in std_logic;
    Sum : out std_logic_vector (20 downto 0));
end Pipeline;

architecture Behavioral of Pipeline is
signal sum_p : std_logic_vector(20 downto 0);

component ADDER20  
port ( A,B : in std_logic_vector (19 downto 0); 
Cin : in std_logic; 
Sum : out std_logic_vector (20 downto 0)); 
end component;


begin


dut: ADDER20 port map (A,B,Cin,sum_p);
process(clock, reset)
begin
if (reset = '1') then
sum <= (others=>'0');
elsif(rising_edge(clock)) then
sum<= sum_p;
end if;
end process;



end Behavioral;
