library IEEE;
use IEEE.std_logic_1164.all;
use ieee.math_real.uniform;
use ieee.numeric_std.all; 
use ieee.math_real.floor;
use ieee.std_logic_arith.all;

entity tb_microphone_sim is

end tb_microphone_sim;

architecture behavioral of tb_microphone_sim is
  signal ref_clk : std_logic := '0';
  signal clk : std_logic := '0';
  signal data : std_logic := '0';
  --signal counter : integer := 0;
  
  constant clk_period : time := 320 ns;
  constant ref_clk_period : time := 10 ns;
begin
  uut: entity work.i2s_master
    generic map (
      DATA_WIDTH => 32,
      PCM_PRECISION => 18
    )
    port map (
      clk => ref_clk,
      clk_1 => clk,
      
      i2s_lrcl => open,
      i2s_dout => data,
      i2s_bclk => open,
      
      fifo_din  => open,
      fifo_w_stb  => open,
      fifo_full => '0'
    );

  bclk_process: process
  begin
    clk <= '0';
    wait for clk_period/2;
    clk <= '1';
    wait for clk_period/2;
  end process;
  
  ref_clk_process: process
  begin
    ref_clk <= '0';
    wait for ref_clk_period/2;
    ref_clk <= '1';
    wait for ref_clk_period/2;
  end process;
  
  data_gen: process is
    variable seed1 : positive :=1;
    variable seed2 : positive :=1;
    variable x : real;
  begin
    seed1 := seed1 + 1;
    seed2 := seed2 + 1;
	wait until rising_edge(clk);
    uniform(seed1, seed2, x);
    if (x <= 0.5) then
    	data <= '0';
    else
    	data <= '1';
    end if;
  end process;
end behavioral;
  	