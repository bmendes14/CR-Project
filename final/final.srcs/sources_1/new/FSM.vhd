library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity FSM is -- interface is the same as in the previous code 
	port (		clk			: in std_logic; 
				addr        : in std_logic_vector(3-1 downto 0);
				reset		: in std_logic;
				data_in1 	: in std_logic_vector(127 downto 0);
				data_out	: out std_logic_vector(7 downto 0));
end entity FSM;

architecture Behavioral of FSM is
	type state_type is (initial_state, counting, toRam,completed); 	
	signal C_S, N_S : state_type;
	type data is array (15 downto 0) of std_logic_vector(7 downto 0);
	signal MyAr, N_MyAr : data; -- signals can be used here instead of variables
	signal sorting_completed, N_sorting_completed : std_logic;
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

			sorting_completed	<= N_sorting_completed; 	

		end if;
	end if;
end process;

process (C_S, data_in1, sorting_completed, MyAr) 
begin
	N_S					<= C_S;
	N_MyAr				<= MyAr;
	N_sorting_completed	<= sorting_completed;	
	case C_S is
		when initial_state => -- initialization of signals and variables in the initial state
			N_sorting_completed <= '0'; 
			for i in 7 downto 0 loop -- getting individual items from the input vector
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
                     indexMin <= j;
                 end if;
               end loop;
            end loop;
	   if cnt = 15 then
	       N_S <= completed;
	   else
	       N_S <= completed;
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
