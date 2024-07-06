library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity SECOND is
Port (clk, rst: in std_logic;
      op1,op2: in std_logic_vector(8 downto 0);
      op3,pix_to_delay: in std_logic_vector(7 downto 0);
      SP,VR:OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
      central_pix: out std_logic_vector(7 downto 0));
end SECOND;

architecture Behavioral of SECOND is
signal sp_int, vr_int: std_logic_vector(9 downto 0);

 component FA is
  Port (op1,op2,op3:in std_logic;
        SP,VR:OUT STD_LOGIC);
 end component;
 
 signal op3_int: std_logic_vector(8 downto 0);

begin

op3_int<='0'&op3;

--op3_int<=op3(7)&op3;

 FA_f: for i in 0 to 8 generate
 FA_i: FA port map (op1(i), op2(i), op3_int(i), sp_int(i), vr_int(i+1));
 end generate;
 
-- sp_int(9) <= sp_int(8);
 sp_int(9) <= '0';

 vr_int(0) <= '0';
 
 process(clk,rst)
 begin
  if rst = '1' then
   SP <= (others => '0');
   VR <= (others => '0');
   central_pix<=(others=>'0');
  elsif rising_edge(clk) then
   SP <= sp_int;
   VR <= vr_int;
   central_pix<=pix_to_delay;   
  end if;
 end process;
 
end Behavioral;

