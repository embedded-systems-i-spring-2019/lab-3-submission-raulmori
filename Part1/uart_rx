--
-- written by Raul Mori
-- Spring 2018
--
---------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity uart_rx is
         port (
         clk, en, rx, rst    : in std_logic;             --Here we have the, "Clock", "Enable", 
         newChar             : out std_logic;
         char                : out std_logic_vector (7 downto 0)  --Both outputs are the same except one is 8-bit
    );
end uart_rx;


architecture fsm of uart_rx is
  
         type state is (idle, start, data);                   -- state type enumeration and state variable
         signal curr : state := idle;
        
         signal d : std_logic_vector (7 downto 0) := (others => '0');        -- shift register to read data in
       
         signal count : std_logic_vector(2 downto 0) := (others => '0');     -- counter for data state
       
         signal inshift : std_logic_vector(3 downto 0) := (others => '0');       -- double flop rx plus 2 extra samples to take majority vote of 3
         signal maj : std_logic := '0';                                           -- majority vote of samples helps mitigate noise on line

         begin          --We have a total 3 processes  
             -- double flop input to fix potential metastability
             -- plus 2 extra samples to take majority vote of 3 inputs (oversampling)
             -- majority vote of samples helps mitigate noise on line
                 process(clk) begin                     --This is the Process for the Clock
                     if rising_edge(clk) then
                         inshift <= inshift(2 downto 0) & rx;
                     end if;
                 end process;
         
             -- majority vote of 3 samples (oversampling)
             -- majority vote of samples helps mitigate noise on line
                 process(inshift)                       --This is the process 
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
         
             
                 process(clk) begin                 -- Finite State Machine (FSM)  process  for ingle process implementation
                         if rising_edge(clk) then
                                 if rst = '1' then                  -- If we reset  state machine then its outputs will be                 
                                         curr <= idle;
                                         d <= (others => '0');          
                                         count <= (others => '0');          --This resets the counter
                                         newChar <= '0';                    
                                 elsif en = '1' then            -- usual operation
                                         case curr is               --Notice we use "case" for CHARACTERS instead of integers
                                                 when idle =>
                                                        newChar <= '0';
                                                                 if maj = '0' then
                                                                         curr <= start;
                                                                 end if;
                                                 when start =>
                                                         d <= maj & d(7 downto 1);
                                                         count <= (others => '0');
                                                         curr <= data;
                                                 when data =>
                                                         if unsigned(count) < 7 then
                                                                 d <= maj & d(7 downto 1);
                                                                 count <= std_logic_vector(unsigned(count) + 1);
                                                         elsif maj <= '1' then                      --Remember we use an"elsif" because we can't simply add another "if" because it creates a 2nd individual loop
                                                                 curr <= idle;
                                                                 newChar <= '1';
                                                                 char <= d;
                                                         else
                                                                curr <= idle;
                                                         end if;
                                                 when others =>
                                                         curr <= idle;
                                                     
                                         end case;                          --This just ends the the "CASE" we opened
                                 end if;                                    --This just ends the very first "if" we declared
                         end if;                                     --This just ends the very first "if" we declared
                 end process;

end fsm;
