library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity TOP is
   port( 
        clk	: in std_logic;
        btnC: in std_logic;
        an   : out std_logic_vector (7 downto 0);
        sw   : in std_logic_vector(3 downto 0);
        seg  : out std_logic_vector (6 downto 0));
end TOP;

architecture Behavioral of TOP is
    signal SortIn: std_logic_vector(127 downto 0);
    signal SortOut: std_logic_vector(7 downto 0);
    signal addrIn: std_logic_vector(3 downto 0);
    signal fromRom: std_logic_vector(7 downto 0);
    signal comp: std_logic;
    signal toBCD: std_logic_vector(15 downto 0);
    signal InVector: std_logic_vector(127 downto 0);
    
    signal WordOnes : std_logic_vector(11 downto 0);
begin 
    
    ROM: entity work.blk_mem_gen_0
           port map(addra => addrIn,
                    clka => clk,
                    douta => fromRom
           );
     
            
            
    Unroll :    entity work.Unroll_ROM
                generic map (   data_width      => 8,
                                address_bits    => 4)
                port map(       clk             => clk,
                                addr            => addrIn,
                                data_in         => fromRom,
                                rst             => btnC,
                                data_out        => SortIn,
                                completed       => comp    );
                       
       
     sort : entity work.cnter
                port map(
                    dataIN => SortIn ,
                    clk => clk,
                    btnC => btnc,
                    data_out => InVector);
                    
     vector : entity work.FromVector
       generic map (   M => 8,
                       L => 4)
        port map (  data_in => InVector,
                    ToMem => SortOut,
                    addr => sw );
    
     toBCD <= (15 downto 8 => '0') & SortOut;                   
     BCD_disp : entity work.BCD_disp
        port map (  sw      => toBCD,
                    an      => an,
                    seg     => seg,
                    clk     => clk,
                    btnC    => btnC );
                    

end Behavioral;

