library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ControlUnit is
    Port (
        Opcode      : in  STD_LOGIC_VECTOR (5 downto 0);
        Funct       : in  STD_LOGIC_VECTOR (5 downto 0);
        RegDst      : out STD_LOGIC;
        Jump        : out STD_LOGIC;
        Branch      : out STD_LOGIC;
        MemRead     : out STD_LOGIC;
        MemToReg    : out STD_LOGIC;
        ALUOp       : out STD_LOGIC_VECTOR (1 downto 0);
        MemWrite    : out STD_LOGIC;
        ALUSrc      : out STD_LOGIC;
        RegWrite    : out STD_LOGIC
    );
end ControlUnit;

architecture Behavioral of ControlUnit is
begin

    process (Opcode)
    begin
        -- Default values (safe)
        RegDst   <= '0';
        Jump     <= '0';
        Branch   <= '0';
        MemRead  <= '0';
        MemToReg <= '0';
        ALUOp    <= "00";
        MemWrite <= '0';
        ALUSrc   <= '0';
        RegWrite <= '0';

        case Opcode is
            when "000000" => -- R-format
                RegDst   <= '1';
                RegWrite <= '1';
                ALUOp    <= "10";
            when "100011" => -- lw
                ALUSrc   <= '1';
                MemToReg <= '1';
                RegWrite <= '1';
                MemRead  <= '1';
                ALUOp    <= "00";
            when "101011" => -- sw
                ALUSrc   <= '1';
                MemWrite <= '1';
                ALUOp    <= "00";
            when "000100" => -- beq
                Branch   <= '1';
                ALUOp    <= "01";
            when "001000" => -- addi (treated like lw for ALU calc, but no mem access)
                ALUSrc   <= '1';
                RegWrite <= '1';
                ALUOp    <= "00";
             when "000010" => -- j
                Jump <= '1';
            when others =>
                null;
        end case;
    end process;

end Behavioral;
