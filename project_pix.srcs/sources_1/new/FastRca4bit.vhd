library IEEE; 
use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL;

library UNISIM;
use UNISIM.vcomponents.all;--CARRY4:FastCarryLogicComponent--7Series--XilinxHDLLibrariesGuide,version2012.2
 
entity FastRCA_4bit is 
port(a,b : in std_logic_vector (3 downto 0); 
Cin : in std_logic; 
Sic : out std_logic_vector (3 downto 0);
Cout : out std_logic); 
end FastRCA_4bit;
 
architecture Behavioral of FastRCA_4bit is

 signal p_int, co_int: std_logic_vector (3 downto 0);

begin 

prop: for i in 0 to 3 generate
        p_int(i) <= a(i) xor b(i);
      end generate;

CARRY4_inst: CARRY4
 port map(
 CO=>co_int,--4-bitcarryout
 O=>Sic,--4-bitcarrychainXORdataout
 CI=>Cin,--1-bitcarrycascadeinput
 CYINIT=>'0',--1-bitcarryinitialization
 DI=>a,--4-bitcarry-MUXdatain
 S=>p_int--4-bitcarry-MUXselectinput
 );--EndofCARRY4_instinstantiation
 
 Cout <= co_int(3);

end Behavioral;
