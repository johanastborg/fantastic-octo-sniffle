library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RegFile is
    Port (
        clk         : in  STD_LOGIC;
        reset       : in  STD_LOGIC;
        ReadReg1    : in  STD_LOGIC_VECTOR (4 downto 0);
        ReadReg2    : in  STD_LOGIC_VECTOR (4 downto 0);
        WriteReg    : in  STD_LOGIC_VECTOR (4 downto 0);
        WriteData   : in  STD_LOGIC_VECTOR (31 downto 0);
        RegWrite    : in  STD_LOGIC;
        ReadData1   : out STD_LOGIC_VECTOR (31 downto 0);
        ReadData2   : out STD_LOGIC_VECTOR (31 downto 0)
    );
end RegFile;

architecture Behavioral of RegFile is
    type reg_array is array (0 to 31) of STD_LOGIC_VECTOR(31 downto 0);
    signal registers : reg_array := (others => (others => '0'));
begin

    -- Read ports (combinational)
    ReadData1 <= registers(to_integer(unsigned(ReadReg1)));
    ReadData2 <= registers(to_integer(unsigned(ReadReg2)));

    -- Write port (sequential)
    process (clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                 registers <= (others => (others => '0'));
            elsif RegWrite = '1' then
                if unsigned(WriteReg) /= 0 then -- Register 0 is hardwired to 0
                    registers(to_integer(unsigned(WriteReg))) <= WriteData;
                end if;
            end if;
        end if;
    end process;

end Behavioral;
