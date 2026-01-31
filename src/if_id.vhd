library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity IF_ID is
    Port (
        clk         : in  STD_LOGIC;
        reset       : in  STD_LOGIC;
        enable      : in  STD_LOGIC;
        PC_Plus4_in : in  STD_LOGIC_VECTOR (31 downto 0);
        Instr_in    : in  STD_LOGIC_VECTOR (31 downto 0);
        PC_Plus4_out: out STD_LOGIC_VECTOR (31 downto 0);
        Instr_out   : out STD_LOGIC_VECTOR (31 downto 0)
    );
end IF_ID;

architecture Behavioral of IF_ID is
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                PC_Plus4_out <= (others => '0');
                Instr_out    <= (others => '0');
            elsif enable = '1' then
                PC_Plus4_out <= PC_Plus4_in;
                Instr_out    <= Instr_in;
            end if;
        end if;
    end process;
end Behavioral;
