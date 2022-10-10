library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY Tb_clock_divider IS
END Tb_clock_divider;
 
ARCHITECTURE behavior OF Tb_clock_divider IS

--Inputs
signal clk : std_logic := '0';
signal enable : std_logic := '1';
signal freq_out : integer := 8 ;

--Outputs
signal clock_out : std_logic;
constant clk_period : time := 10 ns;
 
BEGIN
  uut: entity work.clock_division
	PORT MAP (
      clk_in => clk,
      freq_out => freq_out,
      clk_out => clock_out
	  );
 
  clk_process :process
  begin
    clk <= '0';
    wait for clk_period/2;
    clk <= '1';
    wait for clk_period/2;
  end process;

 
END;