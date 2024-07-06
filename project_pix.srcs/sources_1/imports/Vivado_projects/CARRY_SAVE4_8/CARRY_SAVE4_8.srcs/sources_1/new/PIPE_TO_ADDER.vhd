library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PIPE_TO_ADDER is
port ( A,B : in std_logic_vector (9 downto 0);
    Cin, clock, reset : in std_logic;
    pix_to_delay: in std_logic_vector(7 downto 0);
    Sum,central_pix : out std_logic_vector (9 downto 0));
end PIPE_TO_ADDER;

architecture Behavioral of PIPE_TO_ADDER is
signal sum_p : std_logic_vector(12 downto 0);

component ADDER12 is 
port ( A,B : in std_logic_vector (11 downto 0); 
Cin : in std_logic; 
Sum : out std_logic_vector (12 downto 0));
end component;

signal Aint,Bint: std_logic_vector(11 downto 0);

begin

Aint<="00"&A; 
Bint<="00"&B;

--Aint<=A(9)&A(9)&A; 
--Bint<=B(9)&B(9)&B;

dut: ADDER12 port map (Aint,Bint,Cin,sum_p);
process(clock, reset)
begin
if (reset = '1') then
sum <= (others=>'0');
central_pix<=(others=>'0');
elsif(rising_edge(clock)) then
sum<= sum_p(9 downto 0);
central_pix<="00"&pix_to_delay; 
end if;
end process;



end Behavioral;
