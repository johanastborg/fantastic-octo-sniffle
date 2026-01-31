library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MEM_WB is
    Port (
        clk             : in  STD_LOGIC;
        reset           : in  STD_LOGIC;
        -- Control Signals
        RegWrite_in     : in  STD_LOGIC;
        MemToReg_in     : in  STD_LOGIC;
        
        -- Data Signals
        ReadData_in     : in  STD_LOGIC_VECTOR (31 downto 0);
        ALUResult_in    : in  STD_LOGIC_VECTOR (31 downto 0);
        WriteReg_in     : in  STD_LOGIC_VECTOR (4 downto 0);
        
        -- Outputs
        RegWrite_out    : out STD_LOGIC;
        MemToReg_out    : out STD_LOGIC;
        
        ReadData_out    : out STD_LOGIC_VECTOR (31 downto 0);
        ALUResult_out   : out STD_LOGIC_VECTOR (31 downto 0);
        WriteReg_out    : out STD_LOGIC_VECTOR (4 downto 0)
    );
end MEM_WB;

architecture Behavioral of MEM_WB is
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                RegWrite_out <= '0'; MemToReg_out <= '0';
                ReadData_out <= (others => '0'); ALUResult_out <= (others => '0'); WriteReg_out <= "00000";
            else
                RegWrite_out <= RegWrite_in; MemToReg_out <= MemToReg_in;
                ReadData_out <= ReadData_in; ALUResult_out <= ALUResult_in; WriteReg_out <= WriteReg_in;
            end if;
        end if;
    end process;
end Behavioral;
