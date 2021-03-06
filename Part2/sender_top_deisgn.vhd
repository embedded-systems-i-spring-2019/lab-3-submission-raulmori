--Remember that to make the PORT connections easier, we can visualize the Design using the RTL given to us
--Notice we don't use a TEMPORARY variable for "CLOCK" when connecting "PORTS"
--When Connecting PORTS we go from Right to Left
--For TEMPORARY Signals it goes from Left to Right

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sender_top is
        Port (
                   TXD : in STD_LOGIC;
                   btn : in STD_LOGIC_VECTOR (1 downto 0);
                   clk : in STD_LOGIC;                                  --This is the "CLOCK"
                   RXD : out STD_LOGIC;
                   CTS : out STD_LOGIC;
                   RTS : out STD_LOGIC);
end sender_top;


architecture Structural of sender_top is

        signal rstbtn, btn1: std_logic;
        signal div, snd, ready : STD_LOGIC;
        signal char: std_logic_vector(7 downto 0);
--------------------------------------------------------------------------       

        component uart                  --Here we call "UART" which is another TOP-DESIGN
                port (
                      clk, en, send, rx, rst      : in std_logic;
                      charSend                    : in std_logic_vector (7 downto 0);
                      ready, tx, newChar          : out std_logic;
                      charRec                     : out std_logic_vector (7 downto 0));
        end component;
--------------------------------------------------------------------------       
        component debounce              --Here we call the "BUTTON"
                Port (
                       clk : in STD_LOGIC;
                       btn : in STD_LOGIC;
                       dbnc : out STD_LOGIC);
        end component;
        
--------------------------------------------------------------------------       
   
        component clk_div               --Here we call the "CLOCK_ENABLE"
                Port (
                      div : out STD_LOGIC;
                      clk : in STD_LOGIC);
        end component;
        
--------------------------------------------------------------------------       

        component sender                --Here we call the "SENDER" which is relative to the'UART_TX"
                Port ( 
                       rst : in STD_LOGIC;
                       clk : in STD_LOGIC;
                       en : in STD_LOGIC;
                       btn : in STD_LOGIC;
                       ready : in STD_LOGIC;
                       send : out STD_LOGIC;
                       char : out STD_LOGIC_VECTOR (7 downto 0));
        end component;
--------------------------------------------------------------------------       

    
        begin                               
                rts <= '0';                     --IMPORANT "RTS" has to be Grounded
                cts <= '0';                     --IMPORANT "CTS" has to be Grounded
                

                clkdiv: clk_div port map(
                                     clk=> clk,         --Here we connect the MAIN-CLOCK to the "Clock-Divider"
                                     div =>div          --Here we connect the OUTPUT of the "Clock-Divider" to a TEMPORARY Signal
                                        );
                              
                rstdbnc: debounce port map(
                                     clk => clk,        --Here we connect the MAIN-CLOCK to one of the "BUTTONS"
                                     btn => btn(0),     --Here we connect one of the MAIN "Bit-Button" to the INPUT of one of our BUTTON called "BTN"
                                     dbnc => rstbtn             --Here we convert the OUTPUT of one of our "BUTTON"S into a TEMPORARY signal "RSTBTN"
                                          );
                        
                btndbnc: debounce port map(
                                     clk => clk,        --Here we connect the MAIN-CLOCK to one of the "BUTTONS"       
                                     btn => btn(1),             --Here we connect one of the MAIN "Bit-Button" to the INPUT of one of our BUTTONS called "BTN"
                                     dbnc => btn1              --Here we convert the OUTPUT of one of our "BUTTON"S into a TEMPORARY signal "BTN1"
                                        );
                
                snder: sender port map(
                                     clk => clk,         --Here we connect the MAIN-CLOCK to  the "SENDER"
                                     btn => btn1,          --Here TEMPORARY Signal "BTN1" is connected to "BTN" of "SENDER"
                                     en => div,            --Here TEMPORARY Signal "DIV" is connected to "ENABLE" of "SENDER"
                                     ready => ready,            --Here the TEMPORARY Signal "READY (from the UART) is connected to the INPUT of "SENDER" called "READY"
                                     rst => rstbtn,       --Here TEMPORARY Signal "RSTBTN" is connected to "RESET" of "SENDER"
                                     send => snd,         --Here the OUTPUT of "SENDER" called "SEND"  connected to TEMPORARY signal "SND"
                                     char => char       --Here we convert the OUTPUT of the "SENDER'S" "CHAR" into a TEMPORARY signal called "CHAR"
                                     );
                         
                u5: uart port map  (
                                     clk => clk,         --Here we connect the MAIN-CLOCK to  the "UART"
                                     en => div,         --Here we connect the TEMPORARY signal for the "Clock_Divider" OUTPUT and connect it to the "ENABLE" of the "UART"
                                     send => snd,        --Here the TEMPORARY Signal "SND" is connected to the INPUT of the "UART" called "SEND"
                                     rx => TXD,            --Here we connect Main-Signal "TXD" to the "INPUT" of the UART "RX" 
                                     rst => rstbtn,     --Here the TEMPORARY Signal "RSTBTN" (comes from the output of one of the BUTTONS) is connected to the INPUT of the "UART" called "RST"
                                     charSend => char,          --Here the TEMPORARY Signal "CHAR" is connected to the INPUT of the "UART" called "CHARSEND"
                                     ready => ready,         --Here we convert the OUTPUT of the "UART'S" "READY" into a TEMPORARY signal called "READY"
                                     tx => RXD                 --Here the OUTOUT of the "UART" called "TX" is connected to the INPUT called "RXD"
                                    );
end Structural;
