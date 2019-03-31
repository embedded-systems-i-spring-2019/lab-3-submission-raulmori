--
-- written by Raul Mori
-- Spring 2018
--Since this is a "TOP" design that brings in other designs, we will use "structural design" for this code
---------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity uart is
        port (
            clk, en, send, rx, rst      : in std_logic;
            charSend                    : in std_logic_vector (7 downto 0);
            ready, tx, newChar          : out std_logic;
            charRec                     : out std_logic_vector (7 downto 0)
);
end uart;


architecture structural of uart is                      --Notice that we are using Structural Model

        component uart_tx port                  --Here we call the Behavioral-Design of "uart_tx"
                (
                clk, en, send, rst  : in std_logic;
                char                : in std_logic_vector (7 downto 0);
                ready, tx           : out std_logic
                );
        end component;


        component uart_rx port                   --Here we call the Behavioral-Design of "uart_rx"
             (
                clk, en, rx, rst    : in std_logic;
                newChar             : out std_logic;
                char                : out std_logic_vector (7 downto 0)
             );
        end component;


        begin
        
                r_x: uart_rx port map(                  --Here we just start connecting the Component-Entity Parts of "rx" to the Main-Entity Parts of "TOP"
                            clk => clk,
                            en => en,
                            rx => rx,
                            rst => rst,
                            newChar => newChar,
                            char => charRec);
        
                t_x: uart_tx port map(                  --Here we just start connecting the Component-Entity Parts of "tx" to the Main-Entity Parts of "TOP"
                            clk => clk,
                            en => en,
                            send => send,
                            rst => rst,
                            char => charSend,
                            ready => ready,
                            tx => tx);

end structural;
