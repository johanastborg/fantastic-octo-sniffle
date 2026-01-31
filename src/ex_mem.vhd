library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity EX_MEM is
    Port (
        clk             : in  STD_LOGIC;
        reset           : in  STD_LOGIC;
        -- Control Signals
        RegWrite_in     : in  STD_LOGIC;
        MemToReg_in     : in  STD_LOGIC;
        MemWrite_in     : in  STD_LOGIC;
        MemRead_in      : in  STD_LOGIC;
        
        -- Data Signals
        ALUResult_in    : in  STD_LOGIC_VECTOR (31 downto 0);
        WriteData_in    : in  STD_LOGIC_VECTOR (31 downto 0);
        WriteReg_in     : in  STD_LOGIC_VECTOR (4 downto 0);
        
        -- Outputs
        RegWrite_out    : out STD_LOGIC;
        MemToReg_out    : out STD_LOGIC;
        MemWrite_out    : out STD_LOGIC;
        MemRead_out     : out STD_LOGIC;
        
        ALUResult_out   : out STD_LOGIC_VECTOR (31 downto 0);
        WriteData_out   : out STD_LOGIC_VECTOR (31 downto 0);
        WriteReg_out    : out STD_LOGIC_VECTOR (4 downto 0)
    );
end EX_MEM;

architecture Behavioral of EX_MEM is
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                RegWrite_out <= '0'; MemToReg_out <= '0'; MemWrite_out <= '0'; MemRead_out <= '0';
                ALUResult_out <= (others => '0'); WriteData_out <= (others => '0'); WriteReg_out <= "00000";
            else
                RegWrite_out <= RegWrite_in; MemToReg_out <= MemToReg_in; MemWrite_out <= MemWrite_in; MemRead_out <= MemRead_in;
                ALUResult_out <= ALUResult_in; WriteData_out <= WriteData_in; WriteReg_out <= WriteReg_in;
            end if;
        end if;
    end process;
end Behavioral;
