library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity Partial_products is
Port( a: in std_logic_vector(9 downto 0);
exa, da, mda, ma: out std_logic_vector(11 downto 0);
clk,rst: in std_logic);
end Partial_products;


architecture Behavioral of Partial_products is

signal da_p,ma_p, mda_p,exa_p: std_logic_vector(11 downto 0);
signal a_ext, comp_2, temp: std_logic_vector(10 downto 0);

component plus is
Port(a : in std_logic_vector(10 downto 0);
a_out: out std_logic_vector(10 downto 0));
end component;

begin

a_ext <= '0' & a;
temp <= a_ext xor "11111111111";

plus_1: plus port map (temp,comp_2);

mda_p <= comp_2 & '0';

ma_p <= comp_2(10) & comp_2;

exa_p<= '0' & a_ext;

da_p <= a_ext & '0';

process(clk,rst)
begin
if rst = '1' then
exa<= (others => '0');
da<= (others => '0');
mda<= (others => '0');
ma<= (others => '0');
elsif rising_edge(clk) then
exa<= exa_p;
mda<=mda_p;
ma<=ma_p;
da<=da_p;
end if;
end process;



end Behavioral;
