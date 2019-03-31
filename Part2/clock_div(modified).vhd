
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity clk_div is
        port (
              clk : in std_logic;
              div : out std_logic
        );
end clk_div;

architecture behavioral of clk_div is

         signal count : std_logic_vector (10 downto 0) := (others => '0');     --use 11 bits to be able to count to 1085 (125MHz/115.2hz = 1085.07)

begin
      process(clk) begin        --declare process 
             if rising_edge(clk) then        --check on rising edge
                     if(unsigned(count) < 1085) then                 --update counter while less than 1085
                             div <= '0';                                                     --while less than the desired count div = '0'
                             count <= std_logic_vector( unsigned(count) + 1 );                                     -- This updates counter
                     else                                                                    --once you reach 1085 reset counter 
                             count <= (others => '0');
                             div <= '1';                                                     --output 1 pulse
                     end if;                                                   --This ends the second "IF"
             end if;                                           --This ends the first "IF"
      end process;

end behavioral;
