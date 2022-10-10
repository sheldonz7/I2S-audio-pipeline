library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity clock_division is
  port (
    clk_in : in std_logic;
    freq_out : in integer;  -- division rate
    clk_out : out std_logic);
    
end clock_division;

architecture rtl of clock_division is
  constant REF_FREQ : integer := 100;
  signal clk_counter : integer := 1;
  signal clk_tmp : std_logic := '0';
begin
  
  clk_gen: process( clk_in,
  					enable ) is
  begin
    
    if (rising_edge(clk_in)) then
        clk_counter <= clk_counter + 1;
        if (clk_counter = freq_out) then
            clk_tmp <= NOT clk_tmp;
            clk_counter <= 1;
        end if;
    end if;

  end process;
  clk_out <= clk_tmp;
end rtl;
  
