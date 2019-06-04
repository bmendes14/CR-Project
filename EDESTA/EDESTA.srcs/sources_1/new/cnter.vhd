library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;


entity cnter is
    Port (
        dataIN: in std_logic_vector(127 downto 0);
        clk: in std_logic;
        btnC: in std_logic;
        data_out: out std_logic_vector(127 downto 0)
       );
end cnter;

architecture Behavioral of cnter is
type state_type is (initial_state,counter,final_state,even,odd); -- enumeração de estados
signal C_S, N_S : state_type;
signal index, next_index : integer range 0 to 8-1;
signal Res, next_Res : integer range 0 to 8;
signal max_n_of_ones, next_max_n_of_ones,next_cnt: integer range 0 to 16;
signal cnt : integer range 0 to 15;
type in_data is array (16 - 1 downto 0) of std_logic_vector(8 - 1 downto 0);
--signal MyAr, N_MyAr: in_data; -- signals can be used here instead of variables
signal counter1, N_counter: natural range 0 to 2 * 4 - 1 := 0;
signal dout : std_logic_vector(127 downto 0);



signal sorting_completed, N_sorting_completed: std_logic;
signal counter_order, N_counter_order: natural range 0 to 2 * 16 - 1 := 0;
                    -- the signals below allow even and odd vertical lines of C/S to be selected sequentially
signal even_odd_switcher, N_even_odd_switcher: std_logic;

signal din: std_logic_vector(127 downto 0);


signal bitNum, bitNum_next : integer range 0 to 8 := 0;
signal PalavraNum,PalavraNum_next: integer range 0 to 16 := 0;
signal CurrentMax, NextCurrentMax, CurrentOne, NextCurrentOne : integer range 0 to 8 := 0;

type in_data2 is array (16 - 1 downto 0) of std_logic_vector(12 - 1 downto 0);
signal order1,n_order1: in_data2;

constant MyAr : in_data := ("00001111","00111100","00010011","11010100","00001010","10000111","11110010","00011001","11101000","10010101","10111011","00011000","10100100","01001001","11010011","00010101");
--("11111111","00111100","00010011","11010100","00001010","10000111","11110010","00011001","11101000","10010101","10111011","00011000","10100100","01001001","11010011","00010101");

--00001111
begin
--    MyAr <= ("00001111","00111100","00010011","11010100","00001010","10000111","11110010","00011001","11101000","10010101","10111011","00011000","10100100","01001001","11010011","00010101");
    din <= dataIN;
    process (clk) -- processo sequencial
    begin
        if rising_edge(clk) then
            if (btnC = '1') then
                C_S <= initial_state;
                index <= 1;
                Res <= 0;
                cnt <=0;
                sorting_completed <= '0';
                bitNum <= 0;
                PalavraNum <= 0;
                CurrentOne <= 0;
                CurrentMax <= 0;
                order1 <= (others => (others =>'0')); 
            else C_S <= N_S;
                index <= next_index; -- índice do vetor
--                MyAr <= N_MyAr;
                Res <= next_Res; -- resultado
                Res <= next_Res; -- resultado
                
                
                sorting_completed <= N_sorting_completed;
                bitNum <= bitNum_next;
                PalavraNum <= PalavraNum_Next;
                CurrentOne <= NextCurrentOne;
                CurrentMax <= NextCurrentMax;
                order1 <= n_order1;
--                for i in 16 - 1 downto 0 loop -- forming the long size output vector with the sorted items
--                    dout(8 * (i + 1)-1 downto 8 * i) <= MyAr(i)(7 downto 0);
--                end loop;
            end if;
        end if;
    end process;


    process (C_S, dataIN, index, Res) -- processo combinatório
    begin
--        N_MyAr <= MyAr;
        N_S <= C_S;
        next_index <= index;
        next_max_n_of_ones <= max_n_of_ones; 
        n_order1<=order1;
        bitNum_next <= bitNum;
        PalavraNum_Next <= PalavraNum;
        NextCurrentOne <= CurrentOne;
        NextCurrentMax <= CurrentMax;
        
        N_sorting_completed <= sorting_completed;
        
        
    case C_S is
        when initial_state => 
                N_S <= counter;
--                for i in 16 - 1 downto 0 loop -- forming the long size output vector with the sorted items
--                    N_MyAr(i) <= din( 8 * (i + 1)-1 downto 8 * i);
--                end loop;
                
                --for i in 7 downto 0 loop 
				  
        when counter =>
                if bitNum < 7 then
                    if MyAr(PalavraNum)(bitNum) = '1' and MyAr(PalavraNum)(bitNum+1)='1' then
                        NextCurrentOne <= CurrentOne +1 ;
                        if bitNum =6 then
                            NextCurrentMax <= CurrentOne +1;
                        end if;
                    else
                        if CurrentOne > CurrentMax then
                           NextCurrentMax <= CurrentOne; 
                        end if;
                        NextCurrentOne <= 0;
                    end if;
                    bitNum_next <= bitNum +1;
                else
                    bitNum_next <= 0;
                    NextCurrentMax <=0;
                    NextCurrentOne <= 0;
                    n_order1(PalavraNum) <=std_logic_vector(to_unsigned(CurrentMax,4)) & MyAr(PalavraNum) ; --(15 downto 8 => '0')
                    PalavraNum_Next <= PalavraNum +1;
                end if;
                
                if PalavraNum = 16 then
                    if (even_odd_switcher = '0') then
                        N_S <= even; -- selecting even or odd lines
                    else
                        N_S <= odd;
                    end if;
--                    N_S <= sort;
                end if;
--                  if bitNum < 8 then
--                    if MyAr(PalavraNum)(bitNum) ='1' then
--                        NextCurrentOne <= CurrentOne +1 ;
--                    else
--                        if CurrentOne > CurrentMax then
--                            NextCurrentMax <= CurrentOne; 
--                            NextCurrentOne<=0; 
--                        end if;
--                        NextCurrentOne <= 0;
--                    end if;
--                    bitNum_next <= bitNum +1;
--                  else
--                        bitNum_next <= 0;
--                        NextCurrentMax <=0;
--                        n_order1(PalavraNum) <=(15 downto 4 => '0') & std_logic_vector(to_unsigned(CurrentMax,4)) ; --(15 downto 8 => '0')
--                        PalavraNum_Next <= PalavraNum +1;
--                  end if;
--                  if PalavraNum > 15 then
--                        N_S <= final_state;
--                  end if;
                
                      
--        when sort => 
--            if (sorting_completed = '0') then
--                N_sorting_completed <= '1';
--                for i in 0 to 16/2-1 loop
--                    if (order1(2 * i)(11 downto 8)  > order1(2 * i + 1)(11 downto 8)) then
--                        N_sorting_completed <= '0';
--                        n_order1(2 * i) <= order1(2 * i + 1);
--                        n_order1(2 * i + 1) <= order1(2 * i);
--                        else null;
--                    end if;
--                end loop;
--            else
--            N_S <= final_state;  -- no swapping and the current iteration is the last
--            end if;
            
            
            
       when even =>
        N_even_odd_switcher <= '1';
        N_S <= odd; -- even line is activated
        if (sorting_completed = '0') then
            N_counter_order <= counter_order + 1;
            N_sorting_completed <= '1';
            for i in 0 to 16/2-1 loop
                if (order1(2 * i)(11 downto 8) < order1(2 * i + 1)(11 downto 8)) then
                    N_sorting_completed <= '0';
                    n_order1(2 * i) <= order1(2 * i + 1);
                    n_order1(2 * i + 1) <= order1(2 * i);
                    else null;
                end if;
            end loop;
        else
        N_S <= final_state;  -- no swapping and the current iteration is the last
        end if;
        
    when odd =>
        N_even_odd_switcher <= '0';
        N_S <= even; -- odd line is activated
        if (sorting_completed = '0') then
            N_counter_order <= counter_order + 1;
            N_sorting_completed <= '1';
            for i in 0 to 16 / 2 - 2 loop
                if (order1(2 * i + 1)(11 downto 8) < order1(2 * i + 2)(11 downto 8)) then
                    N_sorting_completed <= '0';
                    n_order1(2 * i + 1) <= order1(2 * i + 2);
                    n_order1(2 * i + 2) <= order1(2 * i + 1);
                else null;
                end if;
            end loop;
        else
            N_S <= final_state; -- no swapping and the current iteration is the last
        end if;
            
            
   
    
    when final_state =>
            N_S <= final_state;
    
    when others => 
    
            N_S <= initial_state;
    end case;
    end process;
    
process (order1)
begin
    for i in 16 - 1 downto 0 loop -- forming the long size output vector with the sorted items
        dout(8 * (i + 1)-1 downto 8 * i) <= order1(i)(7 downto 0);
    end loop;
end process;
--led <= std_logic_vector(to_unsigned(Res, 16)); -- resultado
data_out <= dout;
end Behavioral;
