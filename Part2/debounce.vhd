--The point of this counter is that we will only get an output after the counter has counted a "number" of times for a certain entitiy input called "btn"

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

--declare entity
entity debounce is          --Remember the entitiy values are values that the user manually inputs into the system
      Port (clk: in std_logic;
            btn: in std_logic;
            dbnc: out std_logic );  --Remember this is the Main Output
end debounce;

architecture DB of debounce is
            --Remember that when we assign a "0" to a more than one bit value, we must use the "others" command
          signal counter: std_logic_vector (25 downto 0) := (others => '0');    --use 26 bits to be able to count to 6.25 million 
          signal sft_Reg: std_logic_vector(1 downto 0);                          -- we create a 2 bit long shift register
begin

      process(clk, btn) begin --declare process. Notice we have two temporaries  (a clock period is a loop)
  
              if rising_edge(clk) then  --This is the loop of one period
                     
                   sft_Reg(1) <= sft_Reg(0);       --bit-1 gets value from bit-0
                    
                   sft_Reg(0) <= btn;        --Here we put the entity "btn" into register bit-0 (this happens no matter what the value of entity "btn" is)
                                              --Althought the button is not "held" pressing for 50ms will generate 6.25 million counts. So a "1" will change
                                              --positions within the 2 shift register 6.25 million times, because button "1" will always be during 6.25 million counts
                                                --need to count to 6.25 million
                                                --at the sample rate of 125MHZ, using this number of counts will give 50ms debounce time
                                                 --The counter starts counting every rising edge, and as long as it detects a button input of "1" 
                           if(unsigned(counter) < 6250000) then         --In this case (indepedent of the value of "btn") if temporary "counter" is less than 6.25 million
                                                                        --sherif said to use 50ms. This is only possible because we have a 125Mhz clock. So the numbers of counts we give it 
                                                                     --will determine the total time the circuit will debounce.
                                                                     --For example if we get a "1" signal that was caused by interference within the 50ms, but not long enough that it 
                                                                     --lasts the entire 50ms, so the counter will not count for the entire 50ms. 
                                                                     --Remember the counter and the 50ms time are equivalent
                                                                    --while less than 6.25 million output 0. This is within the period where the oscillation button interferance is happening, and the high signal dissapered before the 6.25 million count
                                                                   --This gives a debounce output of "0" if the debounce simply thought that the "high" btn was just interference. 
                                 dbnc <= '0';           -- A "0" is put into the  output entity port "dbnc" 
                            
                                          if(sft_Reg(1) = '1' ) then    --Addttionally, if bit-1 register is high
                                                     counter <= std_logic_vector( unsigned(counter) + 1 ); --We add a "1-integer" to temporary "counter"
                                          else
                                       
                                                     counter <= (others => '0'); -- This just puts a 26-bit "0" in the temporary "counter" (same as resetting the counter)
                                          end if;
                                          
                           else    -- This is if the counter has reached exaclty 6.25 million counts or more
               
                                 dbnc <= '1';           --A value of high is put on the output entity "dbnc"
                                                        --once the button is released, reset the output and counter. 
                                                        --Remember that the "btn" (button) is not the output of the debouncer, but it is the actual value of the button
                                                        
                                                        --!!!!!Remember that the button may still be oscilating so for the debounce circuit to generate a "0" it would have to 
                                                        --detect a "0" at any count for the debounce to give an output of "0"
                                                        --This is the debounce giving an output of "0" after the debounce detected a corrent and sufficient period for a "high btn"
                                          if(btn = '0') then  --Additionaly, if a "0" is detected for  entity "btn", while the counter reached the 6.25 million
                                                     dbnc <= '0';            --"0" is put in the output entity "dbnc"
                                                     counter <= (others => '0');    --We give a "0" to the temporary 26-bit "counter" (resets counter)
                                                     
                                                       --Remember that this works differently than a "1" btn output. This is because the "1" output of the button
                                                       --must occur 62.5 million times for the debounce output to finally give a "1". Whereas for the debounce to give an
                                                       --output of "0" it must detect a "0" from the btn at any point in time
                                          end if;   
                            
                         end if;  --This end the "if/else" condition. Remember the 2nd Main if condition is part of the first "if" because there is no "endif"
            end if;  --This ends the first "if" condition
            
      end process;

end DB;
