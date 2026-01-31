library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity InstructionMemory is
    Port (
        ReadAddress : in  STD_LOGIC_VECTOR (31 downto 0);
        Instruction : out STD_LOGIC_VECTOR (31 downto 0)
    );
end InstructionMemory;

architecture Behavioral of InstructionMemory is
    type mem_array is array (0 to 63) of STD_LOGIC_VECTOR(31 downto 0);
    -- Test Program:
    -- 0: addi $1, $0, 10  -> 001000 00000 00001 0000000000001010 -> 2001000A
    -- 4: addi $2, $0, 20  -> 001000 00000 00010 0000000000010100 -> 20020014
    -- 8: add  $3, $1, $2  -> 000000 00001 00010 00011 00000 100000 -> 00221820
    -- C: sw   $3, 4($0)   -> 101011 00000 00011 0000000000000100 -> AC030004
    -- 10:lw   $4, 4($0)   -> 100011 00000 00100 0000000000000100 -> 8C040004
    -- 14:nop              -> 00000000
    signal mem : mem_array := (
        0 => X"2001000A", -- addi $1, $0, 10
        1 => X"20020014", -- addi $2, $0, 20
        2 => X"00221820", -- add $3, $1, $2
        3 => X"AC030004", -- sw $3, 4($0)
        4 => X"8C040004", -- lw $4, 4($0)
        others => X"00000000" -- NOP
    );
begin

    process (ReadAddress)
        variable addr_index : integer;
    begin
        -- Word aligned access (ignoring lower 2 bits)
        addr_index := to_integer(unsigned(ReadAddress(7 downto 2)));
        if addr_index < 64 then
            Instruction <= mem(addr_index);
        else
            Instruction <= (others => '0');
        end if;
    end process;

end Behavioral;
