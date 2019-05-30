library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity TOP is
   port( 
        clk	: in std_logic;
        btnC: in std_logic;
        an   : out std_logic_vector (7 downto 0);
        seg  : out std_logic_vector (6 downto 0));
end TOP;

architecture Behavioral of TOP is
    signal SortIn: std_logic_vector(127 downto 0);
    signal SortOut: std_logic_vector(7 downto 0);
    signal addrIn: std_logic_vector(3 downto 0);
    signal fromRom: std_logic_vector(7 downto 0);
    signal comp: std_logic;
    signal toBCD: std_logic_vector(15 downto 0);
begin 
    
    ROM: entity work.blk_mem_gen_1
           port map(addra => addrIn,
                    clka => clk,
                    douta => fromRom
           );

    
--    Unroll :    entity work.Unroll_ROM
--                generic map (   data_width      => 8,
--                                address_bits    => 4)
--                port map(       clk             => clk,
--                                addr            => addrIn,
--                                data_in         => FromRom,
--                                rst             => btnC,
--                                data_out        => SortIn,
--                                completed       => comp    );
                       
       

--    Sorter :    entity work.FSM
--            port map (  clk      => clk,   
--                        reset    => btnC,
--                        data_in1  => SortIn,
--                        data_out => SortOut );
     
     
     toBCD <= (15 downto 8 => '0') & fromRom;                   
     BCD_disp : entity work.BCD_disp
        port map (  sw      => toBCD,
                    an      => an,
                    seg     => seg,
                    clk     => clk,
                    btnC    => btnC );
                    

end Behavioral;

