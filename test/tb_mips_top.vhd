library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_mips_top is
-- Empty entity for testbench
end tb_mips_top;

architecture Behavioral of tb_mips_top is

    -- Component Declaration for the Unit Under Test (UUT)
    component MIPS_Top
    Port (
        clk     : in  STD_LOGIC;
        reset   : in  STD_LOGIC
    );
    end component;

    -- Inputs
    signal clk : std_logic := '0';
    signal reset : std_logic := '0';

    -- Clock period definitions
    constant clk_period : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: MIPS_Top PORT MAP (
        clk => clk,
        reset => reset
    );

    -- Clock process definitions
    clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin		
        -- hold reset state for 100 ns.
        reset <= '1';
        wait for 100 ns;	
        reset <= '0';

        -- Let the processor run for some cycles
        wait for 200 ns;

        -- End simulation (in a real simulator, we might assert or stop)
        wait;
    end process;

end Behavioral;
