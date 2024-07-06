library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity FSM3 is
  Port ( clk, rst, is_reading: in std_logic;
         stato: out std_logic_vector(3 downto 0);
         valid, finish: out std_logic );
end FSM3;


architecture Behavioral of FSM3 is

type state_type is (prestart,temp, start, nordovest, up, nordest, left, center, right, sudovest, down, sudest, ending, idle);
signal state : state_type;
signal count_o, count_v: std_logic_vector(5 downto 0);
signal real_go: std_logic;
begin

process (clk, rst)
 begin

 if (rst = '1') then
    count_o <= (others=>'0');
    count_v <= (others=>'0');
    stato <= (others=>'0');
    valid <= '0';
    finish <= '0';
    state <= prestart;
    real_go<='0';
 elsif (rising_edge(clk)) then
    
    case state is
    
        when idle =>            
                        count_o <= (others => '0');
                        real_go<='0';
                        state<=idle;
   
                        
        when prestart =>       if(is_reading='1') then
                                state <= temp;
                                stato<="0000";
                                real_go<='1';
                                end if;
                                
        when temp =>            state<=start;          
                            
        when start =>       if(real_go='1') then
                                state <= nordovest;
                                stato <= "0001";
                                end if;                        
                            
        when nordovest =>   stato <= "0010";
                            state <= up;
                            valid<='1';
        
        when up =>          count_o <= count_o + 1;
                            if (count_o = "011101") then -- se count = 29;
                                stato <= "0011";
                                state <= nordest;
                            end if;
        
        when nordest =>     stato <= "0100";
                            state <= left;
                            count_o <= (others => '0');
        
        when left =>        state <= center;
                            stato<="0101";
        
        when center =>      count_o <= count_o+1;
                            if (count_o = "011101") then -- se count = 29;
                                 stato <= "0110";
                                 state <= right;
                            end if;
        
        when right =>      
                            count_v <= count_v + 1;
                            count_o <= (others => '0');
                            if (count_v = "011101") then -- se count_v = 29;
                                 stato <= "0111";
                                 state <= sudovest;
                            else stato <= "0100";
                                 state <= left;
                            end if;
        
        when sudovest =>    stato <= "1000";
                            state <= down;
                            count_v <= (others => '0');
        
        when down =>        count_o <= count_o + 1;
                            if (count_o = "011101") then -- se count = 29;
                                 stato <= "1001";
                                 state <= sudest;
                            end if;
        
        when sudest =>      state <= ending;
                            stato<="1010";
                            count_o <= (others => '0');
        
        when ending =>       
                                valid <= '0';
                                finish <= '1';
                                state <= idle;
                                stato<="0000";
        
    end case;
 end if;
 
end process;

end Behavioral;