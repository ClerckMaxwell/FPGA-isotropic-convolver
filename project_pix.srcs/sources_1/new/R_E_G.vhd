library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity R_E_G is
Port (Din: in std_logic;
clk, rst: in std_logic;
Q: out std_logic
);
end R_E_G;

architecture Behavioral of R_E_G is
begin
 process(clk,rst)
 begin
 if (rst='1') then
 Q <='0';
 elsif rising_edge(clk) then 
  Q<=Din;
  end if; 
 end process;

end Behavioral;
