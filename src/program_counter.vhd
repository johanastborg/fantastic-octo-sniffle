library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ProgramCounter is
    Port (
        clk         : in  STD_LOGIC;
        reset       : in  STD_LOGIC;
        PC_in       : in  STD_LOGIC_VECTOR (31 downto 0);
        PC_out      : out STD_LOGIC_VECTOR (31 downto 0)
    );
end ProgramCounter;

architecture Behavioral of ProgramCounter is
    signal pc_reg : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
begin

    process (clk, reset)
    begin
        if reset = '1' then
            pc_reg <= (others => '0');
        elsif rising_edge(clk) then
            pc_reg <= PC_in;
        end if;
    end process;

    PC_out <= pc_reg;

end Behavioral;
