
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
                   char : in STD_LOGIC_VECTOR (7 downto 0);
                   ready : out STD_LOGIC;
                   tx : out STD_LOGIC);
end uart_tx;


architecture Behavioral of uart_tx is

        type state is (idle, start, data);
        signal curr : state := idle;
        
        signal D :std_logic_vector(7 downto 0) := X"00";


        begin               --This starts the part  that has to do with the recieving side Of the Finite State Machine (FSM)
                FSM:process(clk)
                variable count : natural := 0;
                        begin
                            if rising_edge(clk) then    --.This is the Main "IF" . This is if "reset" is high
                                    if rst = '1' then
                                            D <= X"00";
                                            curr <= idle;
                                    end if;
                                    
                                    if en = '1' then           --This is the "SUB-IF" because the main-if wasn't closed
                                            case curr is                    --Here we start a "CASE"
                                                    when idle => 
                                                            ready <= '1';
                                                            tx <= '1';
                                                            if send = '1' then
                                                                curr <= start;
                                                            end if;
                                                    when start => 
                                                            ready <='0';
                                                            tx <= '0';
                                                            D <= char;
                                                            count := 0;
                                                            curr <= data;
                                                    when data =>
                                                            if count < 8 then
                                                                    tx <= D(count);
                                                                            count := count +1;
                                                            else
                                                                tx <= '1';
                                                                curr <= idle;
                                                            end if;
                                            end case;                       
                                    end if;                 --Here we end the second "SUB-IF"
                            end if;                     --Here we end the "MAIN-IF"
                end process;
end Behavioral;
