library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity i2s_master is
  generic (
    DATA_WIDTH : integer;
    PCM_PRECISION  : integer
  );

  port (
    clk  : in std_logic;
    clk_1  : in std_logic;

    i2s_lrcl   :  out std_logic;
    i2s_dout   : in std_logic;
    i2s_bclk   : out std_logic;

    fifo_din   : out std_logic_vector(DATA_WIDTH-1 downto 0);
    fifo_w_stb : out std_logic;
    fifo_full  : out std_logic
  );
end i2s_master;

architecture rtl of i2s_master is
  -- audio sample buffer
    signal sample_buf : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal lrctr      : std_logic := '0';
    signal counter    : integer := 0;
begin
    -- reading left channel for 32 bclks


end rtl;