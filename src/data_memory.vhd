library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DataMemory is
    Port (
        clk         : in  STD_LOGIC;
        Address     : in  STD_LOGIC_VECTOR (31 downto 0);
        WriteData   : in  STD_LOGIC_VECTOR (31 downto 0);
        MemWrite    : in  STD_LOGIC;
        MemRead     : in  STD_LOGIC;
        ReadData    : out STD_LOGIC_VECTOR (31 downto 0)
    );
end DataMemory;

architecture Behavioral of DataMemory is
    type mem_array is array (0 to 63) of STD_LOGIC_VECTOR(31 downto 0);
    signal mem : mem_array := (others => (others => '0'));
begin

    process (clk)
    begin
        if rising_edge(clk) then
            if MemWrite = '1' then
                 -- Word aligned access
                mem(to_integer(unsigned(Address(7 downto 2)))) <= WriteData;
            end if;
        end if;
    end process;

    process (Address, MemRead, mem)
        variable addr_index : integer;
    begin
        if MemRead = '1' then
            addr_index := to_integer(unsigned(Address(7 downto 2)));
            if addr_index < 64 then
                ReadData <= mem(addr_index);
            else
                ReadData <= (others => '0');
            end if;
        else
            ReadData <= (others => '0');
        end if;
    end process;

end Behavioral;
