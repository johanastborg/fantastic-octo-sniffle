library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ID_EX is
    Port (
        clk             : in  STD_LOGIC;
        reset           : in  STD_LOGIC;
        -- Control Signals
        RegWrite_in     : in  STD_LOGIC;
        MemToReg_in     : in  STD_LOGIC;
        MemWrite_in     : in  STD_LOGIC;
        MemRead_in      : in  STD_LOGIC;
        ALUOp_in        : in  STD_LOGIC_VECTOR (1 downto 0);
        ALUSrc_in       : in  STD_LOGIC;
        RegDst_in       : in  STD_LOGIC;
        
        -- Data Signals
        PC_Plus4_in     : in  STD_LOGIC_VECTOR (31 downto 0);
        ReadData1_in    : in  STD_LOGIC_VECTOR (31 downto 0);
        ReadData2_in    : in  STD_LOGIC_VECTOR (31 downto 0);
        SignExtend_in   : in  STD_LOGIC_VECTOR (31 downto 0);
        Rs_in           : in  STD_LOGIC_VECTOR (4 downto 0);
        Rt_in           : in  STD_LOGIC_VECTOR (4 downto 0);
        Rd_in           : in  STD_LOGIC_VECTOR (4 downto 0);
        
        -- Outputs
        RegWrite_out    : out STD_LOGIC;
        MemToReg_out    : out STD_LOGIC;
        MemWrite_out    : out STD_LOGIC;
        MemRead_out     : out STD_LOGIC;
        ALUOp_out       : out STD_LOGIC_VECTOR (1 downto 0);
        ALUSrc_out      : out STD_LOGIC;
        RegDst_out      : out STD_LOGIC;
        
        PC_Plus4_out    : out STD_LOGIC_VECTOR (31 downto 0);
        ReadData1_out   : out STD_LOGIC_VECTOR (31 downto 0);
        ReadData2_out   : out STD_LOGIC_VECTOR (31 downto 0);
        SignExtend_out  : out STD_LOGIC_VECTOR (31 downto 0);
        Rs_out          : out STD_LOGIC_VECTOR (4 downto 0);
        Rt_out          : out STD_LOGIC_VECTOR (4 downto 0);
        Rd_out          : out STD_LOGIC_VECTOR (4 downto 0)
    );
end ID_EX;

architecture Behavioral of ID_EX is
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                RegWrite_out <= '0'; MemToReg_out <= '0'; MemWrite_out <= '0'; MemRead_out <= '0';
                ALUOp_out <= "00"; ALUSrc_out <= '0'; RegDst_out <= '0';
                PC_Plus4_out <= (others => '0'); ReadData1_out <= (others => '0'); ReadData2_out <= (others => '0');
                SignExtend_out <= (others => '0'); Rs_out <= "00000"; Rt_out <= "00000"; Rd_out <= "00000";
            else
                RegWrite_out <= RegWrite_in; MemToReg_out <= MemToReg_in; MemWrite_out <= MemWrite_in; MemRead_out <= MemRead_in;
                ALUOp_out <= ALUOp_in; ALUSrc_out <= ALUSrc_in; RegDst_out <= RegDst_in;
                PC_Plus4_out <= PC_Plus4_in; ReadData1_out <= ReadData1_in; ReadData2_out <= ReadData2_in;
                SignExtend_out <= SignExtend_in; Rs_out <= Rs_in; Rt_out <= Rt_in; Rd_out <= Rd_in;
            end if;
        end if;
    end process;
end Behavioral;
