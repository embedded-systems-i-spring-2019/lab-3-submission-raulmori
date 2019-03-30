

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity echo is
       Port (
            clk, en, ready, newChar : in std_logic;
            charIn : in std_logic_vector(7 downto 0);
            send : out std_logic;
            charOut : out std_logic_vector(7 downto 0));
end echo;


architecture Behavioral of echo is

      type characters is array (0 to 5) of std_logic_vector(7 downto 0);              --create a array that to hold netID
      signal netID : characters := (x"6A", x"74", x"68", x"31", x"34", x"30");        --initialize a temporary signal for netID
      
      type state_type is (idle, busyA, busyB, busyC);                     --declare states
      signal state_reg : state_type := idle;                              --initialize to idle
      
      signal i : std_logic_vector(2 downto 0) := (others => '0');         --This is just a temporary signal for a counter that counts from 0 to 5 (need 4 bits). It is started a "0"
      
      
      begin         --Here we begin the actual process 
          process(clk)                   --set registers. Here we buil the logic for the registers      
              
                  begin                                            --Remember that for our NETID numbers we store them in "CHAR",  and we don't use integers.
                      if(rising_edge(clk))then  
                              if (en = '1') then                    --When enable is "high", the system will start checking.
                                      case state_reg is
                                              when idle =>                       --This is the idle state
                                                  if(newChar = '1') then
                                                  send <= '1';
                                                  charOut <= CharIn;
                                                  state_reg <= busyA;
                                                  else
                                                  state_reg <= idle;
                                                  end if;
                                          
                                              when busyA =>                     --This is the busyA state
                                                  state_reg <= busyB;
                                                  
                                              when busyB =>                     --This is the busyB state
                                                  send <= '0';
                                                  state_reg <= busyC;
                                          
                                              when busyC =>                     --This is the busyC state
                                                      if(ready = '0') then
                                                             state_reg <= busyC;
                                                      else
                                                             state_reg <= idle;
                                                      end if;
                                              when others => state_reg <= idle;
                               end case;
               end if;
             end if;
         end process;

end Behavioral;
