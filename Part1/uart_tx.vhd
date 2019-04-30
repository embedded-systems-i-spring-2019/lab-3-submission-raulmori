
--We use the SENDING-UART as reference to buid this RECEIVING-UART here

--This code does not have a "SEND" in the ARCHITECTURE

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity uart_tx is
             Port ( 
                   clk : in STD_LOGIC;
                   en : in STD_LOGIC;
                   send : in STD_LOGIC;
                   rst : in STD_LOGIC;
                   char : in STD_LOGIC_VECTOR (7 downto 0);      --This is the "DATA" that will hold our NETID 
                   ready : out STD_LOGIC;
                   tx : out STD_LOGIC
                 );
end uart_tx;


architecture Behavioral of uart_tx is

        type state is (idle, start, data);      --These are the TEMPORARY "TYPES" for the Finite-State-Machine's "STATES"
        signal curr : state := idle;        --This is just another way of making. TEMPORARY signal of the Current "STATE" of the initial "STATE" "IDLE" 
        
        signal D :std_logic_vector(7 downto 0) := X"00";      --Here we start the 8-bit REGISTER at "0"


        begin               --This starts the part  that has to do with the receiving side Of the Finite State Machine (FSM)
                ----------------------------------------------------------------------
                FSM:process(clk)
                variable count : natural := 0;
                        begin
                            if rising_edge(clk) then    --.This is the Main "IF" .
                                    if rst = '1' then                  --This is if "RESET" BUTTON was Pressed
                                            D <= X"00";                   --This is the D-FlipFlop REGISTER being Cleared
                                            curr <= idle;             --It goes back to the "IDLE" "STATE"
                                    end if;
                                    
                                    if en = '1' then           --This is the "SUB-IF" because the main-if wasn't closed
                                            case curr is                    --Here we start a "CASE"
                                                    when idle => 
                                                            ready <= '1';             --Remember that "READY" is only "1" When we are in the "IDLE" "STATE"
                                                            tx <= '1';              
                                                            if 
                                                              = '1' then
                                                                curr <= start;        --This sets the Current "STATE" to the  "STATE" of "START"
                                                            end if;
                                                    when start => 
                                                            ready <='0';
                                                            tx <= '0';
                                                            D <= char;            --This store "CHAR" into  "D-FlipFLop" (REGISTER)
                                                            count := 0;
                                                            curr <= data;             --This sets the Current "STATE" to the  "STATE" of "DATA"
                                                    when data =>
                                                            if count < 8 then
                                                                    tx <= D(count);
                                                                            count := count +1;
                                                            else
                                                                tx <= '1';      
                                                                curr <= idle;        --This sets the Current "STATE" to the Initial "STATE" of "IDLE"
                                                            end if;
                                            end case;                       
                                    end if;                 --Here we end the second "SUB-IF"
                            end if;                     --Here we end the "MAIN-IF"
                end process;
                ----------------------------------------------------------------------              
end Behavioral;
