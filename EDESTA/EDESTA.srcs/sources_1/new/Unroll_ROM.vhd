library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.numeric_std.all;

entity Unroll_ROM is
    generic(data_width      : integer := 32;
            address_bits    : integer := 4  );
    port ( clk              : in STD_LOGIC;
           addr             : out STD_LOGIC_VECTOR (address_bits-1 downto 0);
           data_in          : in std_logic_vector(data_width-1 downto 0);
           rst              : in STD_LOGIC;
           data_out         : out STD_LOGIC_VECTOR (data_width*2**address_bits-1 downto 0);
           completed        : out std_logic                         );
end Unroll_ROM;

architecture Behavioral of Unroll_ROM is
type state_type is (init, copy, final); 	
signal C_S, N_S 	       : state_type;
constant    depth          : integer := 2**address_bits;
signal addr_in, addr_in_N  : integer range 0 to depth-1;
signal comp, comp_N        : std_logic;
signal data_tmp, data_tmp_N       : STD_LOGIC_VECTOR (data_width*2**address_bits-1 downto 0);
begin

process (clk)	 
begin
   if falling_edge(clk) then 
      if (rst = '1') then   	C_S <= init; 	addr_in       <= 0;          comp <= '0';    --Registers <= (others => (others => '0'));
                                data_tmp <= (others => '0');
      else                  	C_S <= N_S; 	addr_in       <= addr_in_N;  comp <= comp_N; --Registers_N<=Registers;
                                data_tmp <= data_tmp_N; 
      end if;
   end if;
end process;

process (C_S,addr_in,data_in, data_tmp) --,Registers)
begin
N_S <= C_S; addr_in_N <= addr_in; comp_N <= '0'; data_tmp_N <= data_tmp;    
case C_S is
   when init =>  
    addr_in_N <= 0;
	N_S <= copy;       
   when copy => 
    data_tmp_N(data_width*(addr_in+1)-1 downto data_width*addr_in) <= data_in; 
	if(addr_in = depth-1) then N_S <= final;  
    else    addr_in_N <= addr_in+1;
            N_S  <= copy;  
    end if; 
   when final => N_S <= final; 	comp_N <= '1';
   when others => N_S <= init;
end case;
end process;

data_out <= data_tmp;

addr <= std_logic_vector(to_unsigned(addr_in,address_bits));
completed <= comp;

end Behavioral;

