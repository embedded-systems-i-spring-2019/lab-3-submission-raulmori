--For this part, because of the name "SENDER",  we know  we are work with "UART_TX" (the design we made)
--The FPGA "SENDS" information out
--We have Total of FOUR "STATES"

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sender is
        Port ( 
              rst : in STD_LOGIC;                       --This is a "BUTTON"
              clk : in STD_LOGIC;
              en : in STD_LOGIC;                        --This is the "BUTTON"
              btn : in STD_LOGIC;                       --This is the actual "BUTTON"
              ready : in STD_LOGIC;                     
              send : out STD_LOGIC;                              --This is the "OUTPUT"
              char : out STD_LOGIC_VECTOR (7 downto 0)                  --This is the "OUTPUT"
             );
end sender;


architecture Behavioral of sender is

        
        signal i : STD_LOGIC_VECTOR(2 downto 0) := "000";                       --This is the BINARY-COUNTER. Notice it was initialized to "0"

        type word is array (0 to 4) of STD_LOGIC_VECTOR(7 downto 0);
        type state is (idle, busyA, busyB, busyC);                              --These are the TEMPORARY "Type" "STATES".
        signal curr : state := idle;                                            --Here we made the Initial "STATE" be "IDLE"
        signal NETID : word := (x"72", x"66", x"6D", x"39", x"38");          --These are "ASCII codes" in Hexadecimal form. Notice we have 5 characters. If we put this as the First LINE, the code won't work   
        


        begin
            FSM:process(clk)
                    begin
                        if rising_edge(clk) then
                                if en = '1' then                        --Notice for this new part there must be an extra "ENDIF"
                                        if rst = '1' then                       --If "RESET" BUTTON is pressed    
                                                send <= '0';
                                                char <= x"00";                          --Clears all Letters. The (x"00") is a shortcut for "0000000"
                                                i <= "000";                             
                                                curr <= idle;                           --We go back to the "IDLE" "STATE"
                                        end if;
                                
                                        case curr is                    --The CASE Conditions start Here
                                                when idle =>
                                                        if ready = '1' then
                                                                if btn = '1' then
                                                                        if unsigned(i) < 5 then         --"5" is the number of characters we use for our "NETID"
                                                                                send <= '1';            
                                                                                char <= NETID (natural(to_integer(unsigned(i))));                       
                                                                                i <= STD_logic_VECTOR(unsigned(i) + 1);
                                                                                curr <= busyA;          --Here the Present-State become "BusyA"
                                                                        else                      --Here we we have the same conditions for "READY" and "BUTTON" but now "i" is equal to "5"
                                                                              i <= "000";               --Here it clear the "i" COUNTER. We also remain in the Current "STATE"
                                                                        end if;
                                                                end if;
                                                        end if;                
                                                when busyA =>
                                                           curr <= busyB;               --Here we just move the Next "STATE" which is "BusyB"
                                                when busyB =>
                                                            send <= '0';                     --Here we change "SEND" to "0"
                                                            curr <= busyC; 
                                                when busyC =>
                                                          if ready = '1' then
                                                                  if btn = '0' then
                                                                        curr <= idle;
                                                                  end if;
                                                          end if;    
                                                when others => curr <= idle;                  
                                        end case;
                                end if;        
                        end if;
            end process;
end Behavioral;
