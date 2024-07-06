library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity BUFFER_DECODE is
  Port ( clk, rst: in std_logic;
         cmd: in std_logic_vector(1 downto 0);
         stato: in std_logic_vector(3 downto 0);
         pixels: in std_logic_vector(71 downto 0);
         pixels_out: out std_logic_vector(71 downto 0));
end BUFFER_DECODE;

architecture Behavioral of BUFFER_DECODE is

signal enc: std_logic_vector(5 downto 0);
signal buf_gen,buf_p: std_logic_vector(71 downto 0);
signal pix1, pix2, pix3, pix4, pix5, pix6, pix7, pix8, pix9,zero,white: std_logic_vector(7 downto 0);
signal stato_p: std_logic_vector(3 downto 0);
begin

pix1 <= pixels(71 downto 64);
pix2 <= pixels(63 downto 56);
pix3 <= pixels(55 downto 48);
pix4 <= pixels(47 downto 40);
pix5 <= pixels(39 downto 32);
pix6 <= pixels(31 downto 24);
pix7<= pixels(23 downto 16);
pix8<= pixels(15 downto 8);
pix9<= pixels(7 downto 0);
zero<=(others=>'0');
white<=(others=>'1');
--giro il buffer per semplicità visiva


enc<=cmd&stato_p;


with cmd select
buf_p<= pixels when "00",
        buf_gen when others; 

with enc select
buf_gen<= --nord_ovest code 0001

          pix9&pix8&zero&pix6&pix5&pix4&pix3&pix2&pix1 when "010001", --black padding code 01
          pix9&pix8&white&pix6&pix5&white&white&white&white when "100001", --white padding code 10
          pix9&pix8&pix9&pix6&pix5&pix6&pix9&pix8&pix9 when "110001", --mirroing code 11
          
          -- up code 0010
          pix9&pix8&pix7&pix6&pix5&pix4&zero&zero&zero when "010010", --black padding
          pix9&pix8&pix7&pix6&pix5&pix4&white&white&white when "100010", --white padding
          pix9&pix8&pix7&pix6&pix5&pix4&pix9&pix8&pix7 when "110010", --mirroring
          
          --nord_est code 0011
          zero&pix8&pix7&zero&pix5&pix4&pix3&pix2&pix1 when "010011", --black padding
          white&pix8&pix7&white&pix5&pix4&white&white&white when "100011", --white padding
          pix7&pix8&pix7&pix4&pix5&pix4&pix7&pix8&pix7 when "110011",--mirroring
          
          --left code 0100
          pix9&pix8&zero&pix6&pix5&zero&pix3&pix2&zero when "010100",--black padding
          pix9&pix8&white&pix6&pix5&white&pix3&pix2&white when "100100",--white padding
          pix9&pix8&pix9&pix6&pix5&pix6&pix3&pix2&pix3 when "110100", --mirroring 
          

          (others=>'0') when "010000",
          (others=>'0') when "100000",
          (others=>'0') when "110000",
          
          --right code 0110
            zero&pix8&pix7&zero&pix5&pix4&zero&pix2&pix1 when "010110",  
            white&pix8&pix7&white&pix5&pix4&white&pix2&pix1 when "100110",
            pix7&pix8&pix7&pix4&pix5&pix4&pix1&pix2&pix1 when "110110",
            
           --sud_ovest code 0111
           zero&zero&zero&pix6&pix5&zero&pix3&pix2&zero when "010111",
           white&white&white&pix6&pix5&white&pix3&pix2&white when "100111",
           pix3&pix2&pix3&pix6&pix5&pix6&pix3&pix2&pix3 when "110111",
           
           -- down code 1000
           zero&zero&zero&pix6&pix5&pix4&pix3&pix2&pix1 when "011000",
           white&white&white&pix6&pix5&pix4&pix3&pix2&pix1 when "101000",
           pix3&pix2&pix1&pix6&pix5&pix4&pix3&pix2&pix1 when "111000",
           
           --sud_est code 1001
           zero&zero&zero&zero&pix5&pix4&zero&pix2&pix1 when "011001",
           white&white&white&white&pix5&pix4&white&pix2&pix1 when "101001",
           pix1&pix2&pix1&pix4&pix5&pix4&pix1&pix2&pix1 when "111001",
           
           pixels when others;
           
          
           
process(clk,rst)
begin
if rst = '1' then
pixels_out<=(others=>'0');
stato_p<="0000";
elsif rising_edge(clk) then
pixels_out<=buf_p;
stato_p<=stato;
end if;
end process;


end Behavioral;
