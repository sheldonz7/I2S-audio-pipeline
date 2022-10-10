library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
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
        fifo_full  : in std_logic
    );
end i2s_master;

architecture rtl of i2s_master is
    -- audio sample buffer
    --signal sample_buf : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal lrctr      : std_logic := '0';
    signal counter    : integer := 0;

    --signal lrcl       : std_logic := '0';
    type i2s_state_type is (S_INIT, S_READ, S_PAD);
    signal y1 : i2s_state_type := S_INIT;
    ATTRIBUTE keep : boolean; 
	ATTRIBUTE keep of y1 : SIGNAL IS true;
begin
    -- fsm
    fsm_transitions: process (clk_1) is
    begin
        if (falling_edge(clk_1)) then
            case y1 is
                when S_INIT =>
                    counter <= 0;
                    y1 <= S_READ;
                when S_READ =>
                    counter <= counter + 1;
                    if (counter = 17) then
                        y1 <= S_PAD;
                    end if;
                when S_PAD =>
                    counter <= counter + 1;
                    if (counter = 31) then
                        y1 <= S_INIT;
                    end if;
            end case;
        end if;
    end process;
                    
                    
                       
    -- reading left channel for 32 bclks
    read_sample: process (clk_1) is
    variable v_sample_buf : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
    begin
        -- initialize control signal and output
        fifo_w_stb <= '0';
        if (falling_edge(clk_1)) then
            case y1 is
                when S_INIT =>
                    if (counter = 32) then
                        if (fifo_full = '0') then
                            fifo_din <= v_sample_buf;
                            fifo_w_stb <= '1';
                        end if;
                        v_sample_buf := (others => '0');
                    end if;
                    lrctr <= not lrctr;
                when S_READ =>
                    -- shift in one bit from the data input to the buffer
                    v_sample_buf := v_sample_buf(DATA_WIDTH-2 downto 0) & i2s_dout;
                    
                when S_PAD =>
                    v_sample_buf := v_sample_buf(DATA_WIDTH-2 downto 0) & '0';
                   
            end case;
        end if;
    end process;
    
    i2s_lrcl <= lrctr;
    i2s_bclk <= clk_1;
    
end rtl;