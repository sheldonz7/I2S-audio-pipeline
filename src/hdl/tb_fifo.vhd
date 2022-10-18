library IEEE;
use IEEE.std_logic_1164.all;
use ieee.math_real.uniform;
use ieee.numeric_std.all; 
use ieee.math_real.floor;
use ieee.std_logic_arith.all;

entity tb_fifo is
end tb_fifo;

architecture behavioral of tb_fifo is
    signal ref_clk : std_logic := '0';
    signal clk : std_logic := '0';
    signal i2s_data : std_logic := '0';
    signal sig_fifo_din : std_logic(DATA_WIDTH - 1 downto 0);
    signal sig_fifo_dout : std_logic(DATA_WIDTH - 1 downto 0);
    signal sig_fifo_wr : std_logic;
    signal sig_fifo_rd : std_logic;
    signal sig_fifo_full : std_logic;
    signal sig_fifo_empty : std_logic;
    constant clk_period : time := 320 ns;
    constant REF_CLK_PERIOD : time := 10 ns;
    constant PCM_PRECISION : integer := 18;
    constant DATA_WIDTH : integer := 32;
begin
    i2sm_inst: entity work.i2s_master
        generic map (
            DATA_WIDTH => DATA_WIDTH,
            PCM_PRECISION => PCM_PRECISION
        )
        port map (
            clk => ref_clk,
            clk_1 => clk,

            i2s_lrcl => open,
            i2s_dout => i2s_data,
            i2s_bclk => open,

            fifo_din => sig_fifo_din,
            fifo_w_stb => sig_fifo_wr,
            fifo_full => sig_fifo_full
        );

    fifo_inst: entity work.fifo
        generic map (
            DATA_WIDTH => DATA_WIDTH,
            FIFO_DEPTH => FIFO_DEPTH
        ) port map (
            clkw => ref_clk,
            clkr => ref_clk,
            rst => '0',

            wr => sig_fifo_wr,
            din => sig_fifo_din,
            full => sig_fifo_full,

            rd => sig_fifo_rd,
            dout => sig_fifo_dout,
            empty => sig_fifo_empty
        );

    sig_fifo_rd <= (not sig_fifo_empty);


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
        wait for REF_CLK_PERIOD/2;
        ref_clk <= '1';
        wait for REF_CLK_PERIOD/2;
    end process;

    fifo_read: process
    begin


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