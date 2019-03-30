----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/20/2019 11:03:54 AM
-- Design Name: 
-- Module Name: clk_div - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity clk_div is
port (
  clk : in std_logic;
  div : out std_logic
);
end clk_div;

architecture behavioral of clk_div is
--use 11 bits to be able to count to 1085 (125MHz/115.2hz = 1085.07)
  signal count : std_logic_vector (10 downto 0) := (others => '0');
begin
  
--declare process  
  process(clk) begin
  --check on rising edge
    if rising_edge(clk) then
    --update counter while less than 1085
        if(unsigned(count) < 1085) then
        --while less than the desired count div = '0'
        div <= '0';
        --update counter
      count <= std_logic_vector( unsigned(count) + 1 );
        else
        --once you reach 1085 reset counter 
        count <= (others => '0');
        --output 1 pulse
        div <= '1';
        end if;
    
    end if;
  end process;

end behavioral;
