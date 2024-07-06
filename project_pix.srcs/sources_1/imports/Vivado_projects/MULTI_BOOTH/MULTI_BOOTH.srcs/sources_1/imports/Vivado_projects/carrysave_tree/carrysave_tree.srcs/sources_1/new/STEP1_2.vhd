library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity STEP1 is
Port (clk, rst: in std_logic;
      op1,op2,op3,op4:in std_logic_vector(11 downto 0);
      SP,VR,op4_out:OUT STD_LOGIC_VECTOR(18 DOWNTO 0) );
end STEP1;

architecture Behavioral of STEP1 is
signal op1_int, op2_int, op3_int: std_logic_vector(17 downto 0);
signal sp_int, vr_int, op4_int: std_logic_vector(18 downto 0);

 component FA is     
  Port (op1,op2,op3:in std_logic;
        SP,VR:OUT STD_LOGIC);
 end component;

begin

  op1_int <= op1 & "000000";
  op2_int <= op2(11) & op2(11) & op2 & "0000";
  op3_int <= op3(11) & op3(11) & op3(11) & op3(11) & op3 & "00";
  op: for i in 0 to 6 generate
      op4_int(i+12) <= op4(11);
      end generate;
    op4_int(11 downto 0)<= op4(11 downto 0);

 FA_f: for i in 0 to 17 generate
 FA_i: FA port map (op1_int(i), op2_int(i), op3_int(i), sp_int(i), vr_int(i+1));
 end generate;
 
 sp_int(18) <= sp_int(17);
 vr_int(0) <= '0';
 
 process(clk,rst)
 begin
  if rst = '1' then
   SP <= (others => '0');
   VR <= (others => '0');
   op4_out <= (others=>'0');
  elsif rising_edge(clk) then
   SP <= sp_int;
   VR <= vr_int;
   op4_out <= op4_int;
  end if;
 end process;
 
end Behavioral;
