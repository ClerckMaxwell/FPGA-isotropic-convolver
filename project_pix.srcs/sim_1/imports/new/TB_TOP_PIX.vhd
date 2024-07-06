library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
use ieee.numeric_std.all;
use STD.textio.all;
use ieee.std_logic_textio.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity TB_TOP_PIX is

end TB_TOP_PIX;

architecture Behavioral of TB_TOP_PIX is

component TOP is
port(clk,rst,rgb2gray: in std_logic;
cmd: in std_logic_vector(1 downto 0);
pixel_in: in std_logic_vector(24 downto 0);
wc,wl,w: in std_logic_vector(23 downto 0);
pixel_out: out std_logic_vector(23 downto 0);
valid, finish: out std_logic);
end component;

signal wc,wl,w,temp:std_logic_vector(23 downto 0):=(others=>'0');
signal pixel: std_logic_vector(24 downto 0):=(others=>'0');
signal clock,reset,ena,rgb2gray:std_logic := '0';
signal cmd: std_logic_vector(1 downto 0):=(others=>'0');
signal valid, finish: std_logic;
signal pix_out: std_logic_vector(23 downto 0);
signal pix_out_R,pix_out_G,pix_out_B,pixelR,pixelG,pixelB: std_logic_vector(7 downto 0);
constant clk_period : time := 2.9 ns;


file file_RESULTS_R, file_RESULTS_G, file_RESULTS_B, R,G,B : text;

begin

uut: TOP port map(clock,reset,rgb2gray,cmd,pixel,wc,wl,w,pix_out,valid,finish);

pix_out_R<=pix_out(7 downto 0);
pix_out_G<=pix_out(15 downto 8);
pix_out_B<=pix_out(23 downto 16);

pixelR<=pixel(7 downto 0);
pixelG<=pixel(15 downto 8);
pixelB<=pixel(23 downto 16);

process
 begin
 wait for clk_period/2;
 clock<= not clock;
 end process;
 
 process
 begin
 reset <= '1';
 wait for 50*clk_period;
 --R oppure il gray dell'immagine
 w(7 downto 0)<=conv_std_logic_vector(11,8);
 wc(7 downto 0)<=conv_std_logic_vector(-1,8);
 wl(7 downto 0)<=conv_std_logic_vector(-1,8);
 --
 --G
 w(15 downto 8)<=conv_std_logic_vector(11,8);
 wc(15 downto 8)<=conv_std_logic_vector(-1,8);
 wl(15 downto 8)<=conv_std_logic_vector(-1,8);
 --
 --B
 w(23 downto 16)<=conv_std_logic_vector(11,8);
 wc(23 downto 16)<=conv_std_logic_vector(-1,8);
 wl(23 downto 16)<=conv_std_logic_vector(-1,8);
 --
 -- comando gestione bordi
 cmd <= "01";   -- "00" => toroidale (non fa nulla)
                -- "01" => padding di 0 (nero)
                -- "10" => padding di 255 (bianco)
                -- "11" => mirroring
 rgb2gray<='0';
 
 wait for 20*clk_period;
 reset <= '0';
 wait;
 
 end process;
 
 process
          variable rdline : line;
          variable tmp : integer;
          file R    :    text open read_mode is 
         "C:\Users\raffy\Documents\MATLAB\prog_perri\RMonaLisa.txt";
          begin 
          wait for 101*clk_period; 
          while not endfile(R) loop   
                readline(R, rdline);
                   read(rdline, tmp);
                   pixel(7 downto 0)  <= CONV_STD_LOGIC_VECTOR(tmp,8);
             wait for CLK_period;
             end loop;
          WAIT;
 end process;
 
  process
          variable rdline : line;
          variable tmp : integer;
          file G    :    text open read_mode is 
         "C:\Users\raffy\Documents\MATLAB\prog_perri\GMonaLisa.txt";
          begin 
          wait for 101*clk_period; 
          while not endfile(G) loop   
                readline(G, rdline);
                   read(rdline, tmp);
                   pixel(15 downto 8)  <= CONV_STD_LOGIC_VECTOR(tmp,8);
             wait for CLK_period;
             end loop;
          WAIT;
 end process;
 
  process
          variable rdline : line;
          variable tmp : integer;
          file B    :    text open read_mode is 
         "C:\Users\raffy\Documents\MATLAB\prog_perri\BMonaLisa.txt";
          begin 
          wait for 101*clk_period; 
          while not endfile(B) loop   
                readline(B, rdline);
                   read(rdline, tmp);
                   pixel(24 downto 16)  <= '1'& CONV_STD_LOGIC_VECTOR(tmp,8);
             wait for CLK_period;
             end loop;
             pixel(24)<='0';
          WAIT;
 end process;

    process
   variable v_ILINE     : line;
    variable v_OLINE     : line;
    variable v_SPACE     : character;
      begin
      file_open(file_RESULTS_R, "Routput_results.txt", write_mode);
      file_open(file_RESULTS_G, "Goutput_results.txt", write_mode);
      file_open(file_RESULTS_B, "Boutput_results.txt", write_mode);

    --wait for 158*clk_period;
    --wait for 161*clk_period; -- post_impl con rgb2gray = '1'
    wait for 151*clk_period; --post_impl con rgb2gray = '0'
for i in 0 to 1023 loop
    
      write(v_OLINE, pix_out_R, right, 8);
      writeline(file_RESULTS_R, v_OLINE);
      
      write(v_OLINE, pix_out_G, right, 8);
      writeline(file_RESULTS_G, v_OLINE);
      
      write(v_OLINE, pix_out_B, right, 8);
      writeline(file_RESULTS_B, v_OLINE);
      wait for clk_period;
      end loop;
      file_close(file_RESULTS_R);
      file_close(file_RESULTS_G);
      file_close(file_RESULTS_B);
      wait;      
      end process;
 
 


end Behavioral;