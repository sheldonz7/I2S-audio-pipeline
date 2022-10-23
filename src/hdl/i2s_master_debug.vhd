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
entity i2s_master_debug is
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
        fifo_full  : in std_logic;
        
        state : out std_logic_vector(1 downto 0);
        i2s_counter : out integer;
        sample_buf :  out std_logic_vector(DATA_WIDTH-1 downto 0);
        counter_buf : out unsigned(DATA_WIDTH - PCM_PRECISION - 1 downto 0)
    );
end i2s_master_debug;

architecture rtl of i2s_master_debug is
    -- audio sample buffer
    --signal sample_buf : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal sig_bclk   : std_logic := '0';
    signal lrctr      : std_logic := '0';
    signal sample_counter    : integer := 0;
    signal sig_w_stb  : std_logic;
    signal counter_buffer : unsigned(DATA_WIDTH - PCM_PRECISION - 1 downto 0) := (others => '0');
    signal bit_counter : integer := 0;
    type read_state_type is (S_INIT, S_READ, S_PAD);
    type write_state_type is (S_WAIT_R, S_WRITE, S_WAIT_P);
    signal y1 : read_state_type := S_INIT;
    signal y2 : write_state_type := S_WAIT_R;
    signal sig_fifo_din : std_logic_vector(DATA_WIDTH-1 downto 0)  := (others => '0');
    signal out_en: std_logic := '0';
begin
    -- fsm
    read_transitions: process (sig_bclk) is
    begin
        if (rising_edge(sig_bclk)) then
            case y1 is
                when S_INIT =>
                             
                    y1 <= S_READ;
                   
                when S_READ =>
                    if (bit_counter = PCM_PRECISION) then         
                        y1 <= S_PAD;
                    end if;         
                when S_PAD =>
                    if (bit_counter = 1) then
                        y1 <= S_READ;
                    end if;
            end case;
        end if;
    end process;

    write_transitions: process (clk) is
    begin
        if (rising_edge(clk)) then
            case y2 is
                when S_WAIT_R =>
                    if bit_counter = 19 then
                        y2 <= S_WRITE;
                    end if;
                when S_WRITE =>
                    y2 <= S_WAIT_P;
                
                when S_WAIT_P =>
                    if bit_counter = 32 then
                        y2 <= S_WAIT_R;
                    end if;
            end case;
         end if;
    end process;
        
    
    
    
    bclk :  process (clk) is
        variable clock_counter : integer := 0;
    begin
        if (rising_edge(clk)) then    
            clock_counter := clock_counter + 1;
            if (clock_counter = 16) then
                sig_bclk <= not sig_bclk;
                clock_counter := 0;
            end if;
            
        end if;
    end process;
    
    lrctr_gen: process (sig_bclk) is
    begin
        if (rising_edge(sig_bclk)) then
            
            if (bit_counter = 32) then
                lrctr <= not lrctr;
                counter_buffer <= counter_buffer + 1;
                bit_counter <= 1;
            else
                bit_counter <= bit_counter + 1;
            end if;
        end if;
    end process;


--    w_stb: process (clk) is
--    begin
--        if (rising_edge(clk)) then
--            fifo_w_stb <= '0';
--            if bit_counter = 19 and out_en = '1' then           
--                fifo_din <= std_logic_vector(counter_buffer) & sig_fifo_din(PCM_PRECISION - 1 downto 0);
--                fifo_w_stb <= '1';
--                out_en <= '0';
--            end if;
--        end if;
--    end process;
    
    -- read a bit of data when bit counter <= 18
    read_sample: process (y1, sig_bclk) is
    begin
        -- initialize control signal and output
        case y1 is
            when S_INIT =>
            
            when S_READ => 
                -- shift in one bit from the data input to the buffer
                if (rising_edge(sig_bclk)) then
                    sig_fifo_din <= sig_fifo_din(DATA_WIDTH-2 downto 0) & i2s_dout;
                end if;
            when S_PAD =>
    
        end case;     
    end process;
    
    
    
    write_sample: process(y2) is
    begin
        case y2 is
            when S_WAIT_R =>
                sig_w_stb <= '0';   
            when S_WRITE =>  
                fifo_din <= std_logic_vector(counter_buffer) & sig_fifo_din(PCM_PRECISION - 1 downto 0);     
                sig_w_stb <= '1';
            when S_WAIT_P =>
                sig_w_stb <= '0';
        end case;
    end process;
        
    sample_buf <= sig_fifo_din;
    counter_buf <= counter_buffer;
    i2s_counter <= bit_counter;
    fifo_w_stb <= sig_w_stb;
    i2s_lrcl <= lrctr;
    i2s_bclk <= sig_bclk;
end rtl;
