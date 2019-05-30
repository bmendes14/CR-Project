library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity FSM is 
	port (		clk			: in std_logic; 
				reset		: in std_logic;
				data_in1 	: in std_logic_vector(127 downto 0);
				data_out	: out std_logic_vector(7 downto 0));
end entity FSM;

architecture Behavioral of FSM is
	type state_type is (initial_state, counting, toRam,completed); 	
	signal C_S, N_S : state_type;
	type data is array (15 downto 0) of std_logic_vector(7 downto 0);
	signal MyAr, N_MyAr : data; 
	signal min,temp: std_logic_vector(7 downto 0);
	signal minNr1,tempNr1: integer;
	signal index,indexMin,cnt: integer;
	signal sendOut: std_logic_vector(7 downto 0);
begin

process (clk)	 
begin
	if (rising_edge(clk)) then 
		if (reset = '1') then
			C_S 				<= initial_state; 
            min                 <= "00000000";
			minNr1              <= 0;
			temp                <= "00000000";
			tempNr1              <= 0;
			cnt                  <= 0;
			MyAr 				<= (others => (others => '0'));
		else
			C_S 				<= N_S;
			MyAr				<= N_MyAr;
		end if;
	end if;
end process;

process (C_S, data_in1, MyAr) 
begin
	N_S					<= C_S;
	N_MyAr				<= MyAr;
	case C_S is
		when initial_state => 
			for i in 7 downto 0 loop 
				N_MyAr(i) <= data_in1(8 * (i + 1)-1 downto 8 * i);
			end loop;
			
	when counting => 	
            cnt <= cnt+1;
            min <= N_MyAr(0);
            indexMin <= 0;
            for i in 7 downto 0 loop
                if min(i) = '1' then
                     minNr1 <= minNr1 + 1;
                 end if;
            end loop;
            
            for j in 14 downto 0 loop
               temp <= N_MyAr(j+1); 
               for k in 7 downto 0 loop
                 if temp(k) = '1' then
                     tempNr1 <= tempNr1 + 1;
                 end if;
                 if tempNr1 < minNr1 then
                     minNr1 <= tempNr1;
                     min <= temp;
                     indexMin <= j+1;
                 end if;
               end loop;
            end loop;
            
	   N_MyAr(indexMin) <= "00000000"; 
	   
	   if cnt = 15 then
	       N_S <= completed;
	   else
	       N_S <= toRam;
	   end if;
	
	when toRam =>
	   data_out <= min;
	   N_S <= counting;
	when completed => 
		N_S <= completed;
	when others => 
		N_S <= initial_state;
	end case;
end process;

end Behavioral;
