library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity BCD_disp is
    Port ( sw   : in STD_LOGIC_VECTOR (15 downto 0);
           an   : out STD_LOGIC_VECTOR (7 downto 0);
           seg  : out STD_LOGIC_VECTOR (6 downto 0);
           clk  : in STD_LOGIC;
           btnC : in STD_LOGIC);
end BCD_disp;

architecture Behavioral of BCD_disp is
signal request                          : std_logic;
signal BCD0, BCD1, BCD2, BCD3, BCD4     : std_logic_vector(3 downto 0); 
begin

request <= '1';

disp:   entity work.DispCont
        port map(   clk             => clk,
                    leftL           => (others =>'0'),
                    near_leftL      => (others =>'0'),
                    near_rightL     => (others =>'0'),
                    rightL          => BCD4,--BCD4,
                    leftR           => BCD3,--BCD3,
                    near_leftR      => BCD2,--BCD2,
                    near_rightR     => BCD1,--BCD1,
                    rightR          => BCD0,--BCD0,
                    select_display  => an,
                    segments        => seg  );
                    
conv:   entity work.BinToBCD16
        port map(   clk     => clk,
                    reset   => btnC,
                    ready   => open,
                    binary  => sw,
                    request => request,
                    BCD0    => BCD0,
                    BCD1    => BCD1,
                    BCD2    => BCD2,
                    BCD3    => BCD3,
                    BCD4    => BCD4     );
                    

end Behavioral;
