-- written by Raul Mori
-- Spring 2018
-- This is just a TESTBENCH for the "TOP" design
--We bring in 2 designs. One is the "Clock" and the other design is the "Enable"
--We only use those two design because they are the only ones where their inputs cause a difference in the outputs.

library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_tb is
end uart_tb;

architecture tb of uart_tb is

        type str is array (0 to 4) of std_logic_vector(7 downto 0);
        signal word : str := (x"48", x"65", x"6C", x"6C", x"6F");
    
        signal rst : std_logic := '0';
        signal clk, en, send, rx, ready, tx, newChar : std_logic := '0';
        signal charSend, charRec : std_logic_vector(7 downto 0) := (others => '0');
        

        component uart port (
        clk, en, send, rx, rst  : in std_logic;
        charSend                : in std_logic_vector(7 downto 0);
        ready, tx, newChar      : out std_logic;
        charRec                 : out std_logic_vector(7 downto 0)
        );
        end component;


        begin                          --Notice we have a total of 3 processes
        
                process begin                   -- This is for the clock (clk) @125 MHz
                        clk <= '0';
                        wait for 4 ns;
                        clk <= '1';
                        wait for 4 ns;
                end process;
            
                
                process begin                   --This is the ENABLE (en)  @ 125 MHz / 1085 = ~115200 Hz
                        en <= '0';
                        wait for 8680 ns;
                        en <= '1';
                        wait for 8 ns;
                end process;
            
                
                process begin                       -- This is the process for signal stimulation . This is the part of the processes the image.
                        rst <= '1';
                        wait for 100 ns;
                        rst <= '0';
                        wait for 100 ns;
            
                        for index in 0 to 4 loop                            --Here we create a loop
                                wait until ready = '1' and en = '1';
                                charSend <= word(index);
                                send <= '1';
                                wait for 200 ns;
                                charSend <= (others => '0');        --This sets "charSend" as "0", no matter how many bits it is
                                send <= '0';                        --This sets "send" as "0", no matter how many bits it is
                                wait until ready = '1' and en = '1' and newChar = '1';
            
                                if charRec /= word(index) then                                                 --This is the "IF" condition inside the loop
                                        report "Send/Receive MISMATCH at time: " & time'image(now) &
                                        lf & "expected: " &
                                        integer'image(to_integer(unsigned(word(index)))) &
                                        lf & "received: " & integer'image(to_integer(unsigned(charRec)))
                                        severity ERROR;
                                end if;
                                
                        end loop;              --Here we end a loop
            
                        wait for 1000 ns;
                        report "End of testbench" severity FAILURE;
            
               end process;

end tb;
