--Notice that this FINITE-STATE-MACHINE was made using TEMPLATES from Chapter#11 of the VHDLD book 
--Remember that the Order of the "STATES" are "IDLE", "START", and "DATA"

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity uart_rx is
         port (
         clk                 : in std_logic;             --Here we have the, "Clock", "Enable", 
         en, rx, rst         : in std_logic; 
         newChar             : out std_logic;
         char                : out std_logic_vector (7 downto 0)  --Both outputs are the same except one is 8-bit
    );
end uart_rx;


architecture fsm of uart_rx is
  
         type state is (idle, start, data);                   --These are the TEMPORARY "TYPES" for the Finite-State-Machine's "STATES"
         signal curr : state := idle;                 --This is just another way of making. TEMPORARY signal of the Current "STATE" of the initial "STATE" "IDLE"
        
         signal d : std_logic_vector (7 downto 0) := (others => '0');        -- shift register to read data in
       
         signal count : std_logic_vector(2 downto 0) := (others => '0');     -- counter for data state
       
         signal inshift : std_logic_vector(3 downto 0) := (others => '0');       -- double flop rx plus 2 extra samples to take majority vote of 3
         signal maj : std_logic := '0';                                           -- majority vote of samples helps mitigate noise on line

         begin          --We have a total 3 processes  
             -- double flop input to fix potential metastability
             -- plus 2 extra samples to take majority vote of 3 inputs (oversampling)
             -- majority vote of samples helps mitigate noise on line
                  
         ----------------------------------------------------------------------         
                 process(clk) begin                     --This is the Process for the "CLOCK"
                     if rising_edge(clk) then
                         inshift <= inshift(2 downto 0) & rx;
                     end if;
                 end process;
         ----------------------------------------------------------------------
             -- majority vote of 3 samples (oversampling)
             -- majority vote of samples helps mitigate noise on line
                 process(inshift)                       --This is the process for "SHIFT Register"
                 begin
                         if (inshift(3) = '1' and inshift(2) = '1' and inshift(1) = '1') or
                            (inshift(3) = '1' and inshift(2) = '1') or
                            (inshift(2) = '1' and inshift(1) = '1') or
                            (inshift(3) = '1' and inshift(1) = '1') then
                                 maj <= '1';
                         else
                             maj <= '0';
                         end if;
                 end process;
         ----------------------------------------------------------------------
             
                 process(clk) begin                 -- Finite State Machine (FSM)  process  for ingle process implementation
                         if rising_edge(clk) then
                                 if rst = '1' then                  -- Here we "RESET the System so all the OUTPUTS return "0" and the Preset-State goes back to "IDLE"                 
                                         curr <= idle;
                                         d <= (others => '0');          
                                         count <= (others => '0');          --This resets the counter
                                         newChar <= '0';                    
                                 elsif en = '1' then            -- This is if the "RESET" wasn't pressed but the "ENABLE" button was pressed
                                         case curr is               --Notice we use "case" for CHARACTERS instead of integers
                                                 when idle =>                             --This is if this was the PRESENT-STATE 
                                                        newChar <= '0';
                                                                 if maj = '0' then
                                                                         curr <= start;
                                                                 end if;
                                                 when start =>                            --This is if this was the PRESENT-STATE  
                                                         d <= maj & d(7 downto 1);
                                                         count <= (others => '0');
                                                         curr <= data;
                                                 when data =>                             --This is if this was the PRESENT-STATE 
                                                         if unsigned(count) < 7 then
                                                                 d <= maj & d(7 downto 1);
                                                                 count <= std_logic_vector(unsigned(count) + 1);     --Notice here that we use the method of changing the "COUNT" in Bit-Form to UNSIGNED form
                                                         elsif maj <= '1' then                      --Remember we use an"elsif" because we can't simply add another "if" because it creates a 2nd individual loop
                                                                 curr <= idle;                     --This returns us to the Initial "STATE"
                                                                 newChar <= '1';
                                                                 char <= d;
                                                         else
                                                                curr <= idle;                       --This returns us to the Initial "STATE"
                                                         end if;
                                                 when others =>                           --This is good programming practice, in case any other "STATE" is detected.
                                                         curr <= idle;           -- It go back to the Initial "STATE"
                                                     
                                         end case;                          --This just ends the the "CASE" we opened
                                 end if;                                    --This just ends the very first "if" we declared
                         end if;                                     --This just ends the very first "if" we declared
                 end process;
         ----------------------------------------------------------------------
end fsm;
