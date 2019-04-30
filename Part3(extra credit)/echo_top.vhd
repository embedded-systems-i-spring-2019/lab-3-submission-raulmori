--Remember that the TOP-DESIGN for "ECHO" will be almost the same as "SENDER"

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity echo_top is
      Port (
            TXD, btn : in std_logic;
            clk           : in std_logic;
            char_in       : in std_logic_vector(7 downto 0);
            CTS, RTS, RXD : out std_logic);
end echo_top;

architecture Behavioral of echo_top is

        signal u1_out, u3_out, u4_send, u5_ready : std_logic;
        signal u4_char : std_logic_vector(7 downto 0);

--------------------------------------------------------------------
        component uart                  --Here we declare Entity-components for "UART"
                port(
                       clk, en, send, rx, rst      : in std_logic;
                       charSend                    : in std_logic_vector (7 downto 0);
                       ready, tx, newChar          : out std_logic;
                       charRec                     : out std_logic_vector (7 downto 0)
        );
        end component;
        
--------------------------------------------------------------------
        component debounce                          --
                Port (
                        clk: in std_logic;        
                        btn: in std_logic;
                        dbnc: out std_logic);
        end component;
        
--------------------------------------------------------------------
        component clk_div                       --This is the Entity-Component for "clock div"
            port (
                        clk : in std_logic;
                        div : out std_logic);
        end component;
        
--------------------------------------------------------------------
        component echo                                              --This is the Entity-Component for "sender"
          Port (
                        clk, en, ready, newChar : in std_logic;
                        charIn : in std_logic_vector(7 downto 0);
                        send : out std_logic;
                        charOut : out std_logic_vector(7 downto 0));
        end component;
--------------------------------------------------------------------

        begin

                RTS <= '0';                           --IMPORANT "RTS" has to be Grounded
                CTS <= '0';                           --IMPORANT "CTS" has to be Grounded
                
                --Here we start the port maps. This just just so we can connect values from "Entity-Component" values with "Main-Temporary" values
                u1: debounce port map(
                                      btn => btn,
                                      clk => clk,
                                      dbnc => u1_out        --The button OUTPUT is connected to TEMPORARY signal of "u1_out"
                                      );
                                                           
                u3: clk_div port map(                       --This is the Conceptual "CLOCK-ENABLE"
                                     clk => clk,
                                     div => u3_out          --this is the OUTPUT of the "Clk_En" connected to the TEMPORARY Signal "u3_out"
                                    );
                                     
                u4: echo port map (  
                                    clk => clk,
                                    newChar => u1_out,
                                    charin => char_in,
                                    en => u3_out,                 --Here we connect the "EN" to the OUTPUT of the "Modified-Clock"
                                    ready => u5_ready,
                                    charOut => u4_char,
                                    send => u4_send
                                  );
                                    
                u5: uart port map(
                                  charSend => u4_char,
                                  clk => clk,
                                  en => u3_out,
                                  rst => '0',
                                  rx => TXD,
                                  send => u4_send,
                                  ready => u5_ready,
                                  tx => RXD
                                  );

end Behavioral;
