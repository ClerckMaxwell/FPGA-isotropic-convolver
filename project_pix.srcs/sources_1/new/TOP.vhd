library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TOP is
generic ( DIM_FIFO_GO : integer := 30;
           DIM_FIFO_GO_GRAY: integer := 10;
           DIM_FIFO_VALID_FINISH: integer:= 12);
port(clk,rst,rgb2gray: in std_logic;
cmd: in std_logic_vector(1 downto 0);
pixel_in: in std_logic_vector(24 downto 0);
wc,wl,w: in std_logic_vector(23 downto 0);
pixel_out: out std_logic_vector(23 downto 0);
valid, finish: out std_logic);
end TOP;

architecture Behavioral of TOP is

component TOP_PIX is
port(pixels: in std_logic_vector(71 downto 0);
wc,wl,w: in std_logic_vector(7 downto 0);
clk,rst: in std_logic;
pix_out: out std_logic_vector(7 downto 0));
end component;

component RGB_TO_GRAY is
port(clk,rst: in std_logic;
pix_in: in std_logic_vector(23 downto 0);
pix_grey: out std_logic_vector(7 downto 0));
end component;

component TOP_BUF is
Port (pixel_in: in std_logic_vector(7 downto 0);
clk,rst: in std_logic;
pixel_out: out std_logic_vector(71 downto 0)
);
end component;

component FSM3 is
Port ( clk, rst, is_reading: in std_logic;
         stato: out std_logic_vector(3 downto 0);
         valid, finish: out std_logic );
end component;

component BUFFER_DECODE is
  Port ( clk, rst: in std_logic;
         cmd: in std_logic_vector(1 downto 0);
         stato: in std_logic_vector(3 downto 0);
         pixels: in std_logic_vector(71 downto 0);
         pixels_out: out std_logic_vector(71 downto 0));
end component;

component FIFO_NORMAL is
    generic ( DIM_FIFO_N : integer);
Port(clk,rst,D_in : in std_logic;
D_out: out std_logic);
end component;

signal pixels,correct_pix,pixels_w: std_logic_vector(215 downto 0);
signal prec,go: std_logic;
signal pix_grey, pixR_IN: std_logic_vector(7 downto 0);
signal ready_int:std_logic_vector(2 downto 0);
signal valid_int,finish_int:std_logic;
signal stato: std_logic_vector(3 downto 0);
signal pixel_eff: std_logic_vector(15 downto 0);
signal pixelin_gray:std_logic_vector(23 downto 0);

begin
ready_int(0)<=pixel_in(24) and prec;

FIFO_READY: FIFO_NORMAL generic map(DIM_FIFO_GO)
port map(clk,rst,ready_int(0),ready_int(1));

FIFO_READY2:FIFO_NORMAL generic map(DIM_FIFO_GO_GRAY)
port map(clk,rst,ready_int(1),ready_int(2));

FIFO_VALID: FIFO_NORMAL generic map(DIM_FIFO_VALID_FINISH)
port map(clk,rst,finish_int,finish);

FIFO_FINISH: FIFO_NORMAL generic map(DIM_FIFO_VALID_FINISH)
 port map(clk,rst,valid_int,valid);


V3_FSM: FSM3 port map(clk, rst,go,stato ,valid_int, finish_int);

TO_GRAY: RGB_TO_GRAY port map(clk,rst,pixelin_gray,pix_grey);

with rgb2gray select
pixR_in<= pix_grey when '1',
          pixel_in(7 downto 0) when others;
with rgb2gray select
pixel_eff<=  (others=>'0') when '1',
               pixel_in(23 downto 8) when others;
with rgb2gray select
pixelin_gray<=   (others=>'0') when '0',
               pixel_in(23 downto 0) when others;               
          
with rgb2gray select          
go<= ready_int(1) when '0',
     ready_int(2) when others;

TO_BUF: TOP_BUF port map(pixR_in,clk,rst,pixels(71 downto 0));
DECOD_BUFFER: BUFFER_DECODE port map(clk,rst,cmd,stato,pixels_w(71 downto 0),correct_pix(71 downto 0));
TO_HW_0: TOP_PIX port map(correct_pix(71 downto 0), wc(7 downto 0), wl(7 downto 0), w(7 downto 0), clk, rst, pixel_out(7 downto 0));

FOR_RGB: for i in 1 to 2 generate
TO_BUF: TOP_BUF port map(pixel_eff(8*(i-1)+7 downto 8*(i-1)),clk,rst,pixels(72*i+71 downto 72*i));
DECOD_BUFFER: BUFFER_DECODE port map(clk,rst,cmd,stato,pixels_w(72*i+71 downto 72*i),correct_pix(72*i+71 downto 72*i));
TO_HW_i: TOP_PIX port map(correct_pix(72*i+71 downto 72*i), wc(8*i+7 downto 8*i), wl(8*i+7 downto 8*i), w(8*i+7 downto 8*i), clk, rst, pixel_out(8*i+7 downto 8*i));
end generate;

process(clk,rst)
begin
if rst ='1' then
pixels_w<=(others=>'0');
prec<='0';
elsif (rising_edge(clk)) then
pixels_w<=pixels;
prec<=pixel_in(24);
end if;
end process;

end Behavioral;
