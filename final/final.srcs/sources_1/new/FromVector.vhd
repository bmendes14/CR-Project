library IEEE;		
use IEEE.STD_LOGIC_1164.ALL;	 
use IEEE.STD_LOGIC_UNSIGNED.ALL;	

entity FromVector is
generic (   M         : integer := 16;
            L         : integer := 3);
port (  	data_in   : in std_logic_vector(2**L*M-1 downto 0);
            ToMem     : out std_logic_vector(M-1 downto 0);
            addr      : in std_logic_vector(L-1 downto 0)   );
end FromVector;

architecture Behavioral of FromVector is
signal address          : integer; --std_logic_vector(M-1 downto 0);
begin

ToMem <=    data_in(M*(address+1)-1 downto M*address);
            
address <= conv_integer(addr(L-1 downto 0));            
   
end Behavioral;