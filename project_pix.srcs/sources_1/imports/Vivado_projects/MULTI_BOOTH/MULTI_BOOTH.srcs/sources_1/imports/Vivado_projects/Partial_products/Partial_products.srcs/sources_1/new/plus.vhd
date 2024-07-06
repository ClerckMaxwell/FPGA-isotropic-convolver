library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity plus is
Port(a : in std_logic_vector(10 downto 0);
a_out: out std_logic_vector(10 downto 0));
end plus;

architecture Behavioral of plus is
signal c : std_logic_vector(10 downto 0);

begin
c(0)<= a(0) and '1';
a_out(0) <= a(0) xor '1';
logic:
for i in 1 to 10 generate
c(i)<=a(i) and c(i-1);
a_out(i) <= a(i) xor c(i-1);
end generate;

end Behavioral;
