library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SATURATION is
Port( clk,rst: in std_logic;
pix_in: in std_logic_vector(19 downto 0);
pix_sat: out std_logic_vector(7 downto 0));
end SATURATION;

architecture Behavioral of SATURATION is

signal X: std_logic_vector(7 downto 0);
signal bool : std_logic;


begin
bool<=pix_in(18) or pix_in(17) or pix_in(16) or pix_in(15) or 
pix_in(14) or pix_in(13) or pix_in(12) or pix_in(11) or pix_in(10) or pix_in(9) or pix_in(8);

process(clk,rst)
begin
if(rst='1') then
pix_sat<=(others=>'0');
elsif(rising_edge(clk)) then
if(pix_in(19)='1') then
pix_sat<=(others=>'0');
elsif(bool='1') then
pix_sat<=(others=>'1');
elsif (bool='0') then
pix_sat<=pix_in(7 downto 0);
else pix_sat<=X;
end if;
end if;
end process;


end Behavioral;
