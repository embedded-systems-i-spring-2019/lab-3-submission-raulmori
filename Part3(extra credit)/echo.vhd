

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
            clk                     : in std_logic;
            en, ready, newChar      : in std_logic;
            charIn                  : in std_logic_vector(7 downto 0);       --These are the "NETID" characters coming in
            send                    : out std_logic;
            charOut                 : out std_logic_vector(7 downto 0)       --These are the "NETID" characters going out
            );
end echo;


architecture Behavioral of echo is

      type characters is array (0 to 4) of std_logic_vector(7 downto 0);              --Here we Create an Array  to hold our "NETID"
      signal netID : characters := (x"72", x"66", x"6D", x"39", x"38");       --Here we use TEMPORARY signals for our "NETID"
      
      type state_type is (idle, busyA, busyB, busyC);                     --declare states
      signal state_reg : state_type := idle;                              --This is the First "STATE" being Initialized to "IDLE"
      
      signal i : std_logic_vector(2 downto 0) := (others => '0');         --This is just a temporary signal for a counter that counts from 0 to 5 (need 4 bits). It is started a "0"
      

      begin         --Here we begin the actual process 
          process(clk)                   --set registers. Here we buil the logic for the registers      
                  begin                                            --Remember that for our NETID numbers we store them in "CHAR",  and we don't use integers.
                      if(rising_edge(clk))then  
                              if (en = '1') then                    --Remember this is the "CLOCK_ENABLE" that comes from the output of the "CLOCK_DIVDER"
                                     
                                      case state_reg is
                                              when idle =>                       --We Start in the "IDLE" "STATE"
                                                  if(newChar = '1') then
                                                         send <= '1';
                                                         charOut <= CharIn;
                                                         state_reg <= busyA;       --the Present-State now becomes "BusyA"
                                                   else                        --We don't need this but we write it as good VHDL practice
                                                         state_reg <= idle;         --Remains in the Current "IDLE" "STATE"
                                                  end if;
                                          
                                              when busyA =>                     --This is the busyA state
                                                  state_reg <= busyB;        --Nothing else happens. The "Present-State" now becomes "BusyB"
                                                  
                                              when busyB =>                     --This is the busyB state
                                                  send <= '0';
                                                  state_reg <= busyC;
                                          
                                              when busyC =>                     --This is the busyC state
                                                      if ready = '1' then
                                                            state_reg <= idle;   
                                                      else
                                                            state_reg <= busyC;
                                                      end if;
                                                             
                                              when others => state_reg <= idle;     --This is not necessary but is just good VHDL writing pratice.
                                      end case;
                              end if;
                    end if;
         end process;

end Behavioral;
