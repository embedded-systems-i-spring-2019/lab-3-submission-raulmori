--This is the TOP-DESIGN that combines our "UART_RX" and "UART_TX"

library ieee;
use ieee.std_logic_1164.all;

entity uart is
        port 
            (
            clk                         : in std_logic;
            en, send, rx, rst           : in std_logic;   
            charSend                    : in std_logic_vector (7 downto 0);     --This is for the "UART_TX" part that Send "DATA"
            ready, tx, newChar          : out std_logic;
            charRec                     : out std_logic_vector (7 downto 0)     --This is for the "UART_RX" part that receives "DATA"
            );
end uart;

architecture structural of uart is        
        ----------------------------------------------------------------------
        component uart_tx port              --Here we call "UART_TX" (Sending Side)
                 (
                 clk, en, send, rst  : in std_logic;
                 char                : in std_logic_vector (7 downto 0);
                 ready, tx           : out std_logic
                 );
        end component;
        ----------------------------------------------------------------------
        component uart_rx port              --Here we call "UART_RX" (Receiving Side)
                (
                clk, en, rx, rst    : in std_logic;
                newChar             : out std_logic;
                char                : out std_logic_vector (7 downto 0)
                );
        end component;
        ----------------------------------------------------------------------
        begin
            r_x: uart_rx port map           --Here we just Connect the PORTS for "UART_RX"
                        (
                        clk => clk,
                        en => en,
                        rx => rx,
                        rst => rst,
                        newChar => newChar,         --This is the only part that is different from "UART_TX"
                        char => charRec                 --This is the only part that is different from "UART_TX"
                        );

            t_x: uart_tx port map           --Here we just Connect the PORTS for "UART_TX"
                        (              
                        clk => clk,
                        en => en,
                        send => send,
                        rst => rst,
                        char => charSend,           --This is the only part that is different from "UART_RX"
                        ready => ready,                 --This is the only part that is different from "UART_RX"
                        tx => tx                        --This is the only part that is different from "UART_RX"
                        );

end structural;
