library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MIPS_Top is
    Port (
        clk     : in  STD_LOGIC;
        reset   : in  STD_LOGIC
    );
end MIPS_Top;

architecture Behavioral of MIPS_Top is

    -- Component Declarations
    component ProgramCounter
        Port ( clk : in STD_LOGIC; reset : in STD_LOGIC; PC_in : in STD_LOGIC_VECTOR(31 downto 0); PC_out : out STD_LOGIC_VECTOR(31 downto 0));
    end component;

    component InstructionMemory
        Port ( ReadAddress : in STD_LOGIC_VECTOR(31 downto 0); Instruction : out STD_LOGIC_VECTOR(31 downto 0));
    end component;

    component IF_ID
        Port ( clk, reset, enable : in STD_LOGIC; PC_Plus4_in, Instr_in : in STD_LOGIC_VECTOR(31 downto 0); PC_Plus4_out, Instr_out : out STD_LOGIC_VECTOR(31 downto 0));
    end component;

    component ControlUnit
        Port ( Opcode, Funct : in STD_LOGIC_VECTOR(5 downto 0); RegDst, Jump, Branch, MemRead, MemToReg : out STD_LOGIC; ALUOp : out STD_LOGIC_VECTOR(1 downto 0); MemWrite, ALUSrc, RegWrite : out STD_LOGIC);
    end component;

    component RegFile
        Port ( clk, reset : in STD_LOGIC; ReadReg1, ReadReg2, WriteReg : in STD_LOGIC_VECTOR(4 downto 0); WriteData : in STD_LOGIC_VECTOR(31 downto 0); RegWrite : in STD_LOGIC; ReadData1, ReadData2 : out STD_LOGIC_VECTOR(31 downto 0));
    end component;
    
    component ID_EX
        Port ( clk, reset : in STD_LOGIC; RegWrite_in, MemToReg_in, MemWrite_in, MemRead_in, ALUSrc_in, RegDst_in : in STD_LOGIC; ALUOp_in : in STD_LOGIC_VECTOR(1 downto 0);
               PC_Plus4_in, ReadData1_in, ReadData2_in, SignExtend_in : in STD_LOGIC_VECTOR(31 downto 0); Rs_in, Rt_in, Rd_in : in STD_LOGIC_VECTOR(4 downto 0);
               RegWrite_out, MemToReg_out, MemWrite_out, MemRead_out, ALUSrc_out, RegDst_out : out STD_LOGIC; ALUOp_out : out STD_LOGIC_VECTOR(1 downto 0);
               PC_Plus4_out, ReadData1_out, ReadData2_out, SignExtend_out : out STD_LOGIC_VECTOR(31 downto 0); Rs_out, Rt_out, Rd_out : out STD_LOGIC_VECTOR(4 downto 0));
    end component;

    component ALU
        Port ( A, B : in STD_LOGIC_VECTOR(31 downto 0); ALUControl : in STD_LOGIC_VECTOR(3 downto 0); Result : out STD_LOGIC_VECTOR(31 downto 0); Zero : out STD_LOGIC);
    end component;

    component EX_MEM
        Port ( clk, reset : in STD_LOGIC; RegWrite_in, MemToReg_in, MemWrite_in, MemRead_in : in STD_LOGIC;
               ALUResult_in, WriteData_in : in STD_LOGIC_VECTOR(31 downto 0); WriteReg_in : in STD_LOGIC_VECTOR(4 downto 0);
               RegWrite_out, MemToReg_out, MemWrite_out, MemRead_out : out STD_LOGIC;
               ALUResult_out, WriteData_out : out STD_LOGIC_VECTOR(31 downto 0); WriteReg_out : out STD_LOGIC_VECTOR(4 downto 0));
    end component;

    component DataMemory
        Port ( clk : in STD_LOGIC; Address, WriteData : in STD_LOGIC_VECTOR(31 downto 0); MemWrite, MemRead : in STD_LOGIC; ReadData : out STD_LOGIC_VECTOR(31 downto 0));
    end component;

    component MEM_WB
        Port ( clk, reset : in STD_LOGIC; RegWrite_in, MemToReg_in : in STD_LOGIC;
               ReadData_in, ALUResult_in : in STD_LOGIC_VECTOR(31 downto 0); WriteReg_in : in STD_LOGIC_VECTOR(4 downto 0);
               RegWrite_out, MemToReg_out : out STD_LOGIC;
               ReadData_out, ALUResult_out : out STD_LOGIC_VECTOR(31 downto 0); WriteReg_out : out STD_LOGIC_VECTOR(4 downto 0));
    end component;

    component HazardUnit
        Port ( ID_EX_MemRead : in STD_LOGIC; ID_EX_Rt, IF_ID_Rs, IF_ID_Rt : in STD_LOGIC_VECTOR(4 downto 0); PCWrite, IF_ID_Write, ControlMux : out STD_LOGIC);
    end component;

    component ForwardingUnit
        Port ( ID_EX_Rs, ID_EX_Rt : in STD_LOGIC_VECTOR(4 downto 0); EX_MEM_RegWrite : in STD_LOGIC; EX_MEM_Rd : in STD_LOGIC_VECTOR(4 downto 0); MEM_WB_RegWrite : in STD_LOGIC; MEM_WB_Rd : in STD_LOGIC_VECTOR(4 downto 0);
               ForwardA, ForwardB : out STD_LOGIC_VECTOR(1 downto 0));
    end component;

    -- Signal Declarations
    
    -- IF Stage
    signal PC_in, PC_out, PC_Plus4, Instr : STD_LOGIC_VECTOR(31 downto 0);
    signal PCWrite : STD_LOGIC;
    
    -- IF/ID Signals
    signal IF_ID_Write : STD_LOGIC;
    signal ID_PC_Plus4, ID_Instr : STD_LOGIC_VECTOR(31 downto 0);
    
    -- ID Stage
    signal RegDst, Jump, Branch, MemRead, MemToReg, MemWrite, ALUSrc, RegWrite : STD_LOGIC;
    signal ALUOp : STD_LOGIC_VECTOR(1 downto 0);
    signal ControlMux : STD_LOGIC;
    signal ReadData1, ReadData2, SignExtend : STD_LOGIC_VECTOR(31 downto 0);
    signal Mux_RegWrite, Mux_MemToReg, Mux_MemWrite, Mux_MemRead, Mux_ALUSrc, Mux_RegDst : STD_LOGIC;
    signal Mux_ALUOp : STD_LOGIC_VECTOR(1 downto 0);
    
     -- ID/EX Signals
    signal EX_RegWrite, EX_MemToReg, EX_MemWrite, EX_MemRead, EX_ALUSrc, EX_RegDst : STD_LOGIC;
    signal EX_ALUOp : STD_LOGIC_VECTOR(1 downto 0);
    signal EX_PC_Plus4, EX_ReadData1, EX_ReadData2, EX_SignExtend : STD_LOGIC_VECTOR(31 downto 0);
    signal EX_Rs, EX_Rt, EX_Rd : STD_LOGIC_VECTOR(4 downto 0);
    
    -- EX Stage
    signal ALUControl : STD_LOGIC_VECTOR(3 downto 0);
    signal ALU_SrcA, ALU_SrcB, ALUResult : STD_LOGIC_VECTOR(31 downto 0);
    signal ForwardA, ForwardB : STD_LOGIC_VECTOR(1 downto 0);
    signal WriteReg_EX : STD_LOGIC_VECTOR(4 downto 0);
    signal Zero : STD_LOGIC; -- Used for branch, though branch not fully implemented in pipeline example yet (requires addr calc)
    
    -- EX/MEM Signals
    signal MEM_RegWrite, MEM_MemToReg, MEM_MemWrite, MEM_MemRead : STD_LOGIC;
    signal MEM_ALUResult, MEM_WriteData : STD_LOGIC_VECTOR(31 downto 0);
    signal MEM_WriteReg : STD_LOGIC_VECTOR(4 downto 0);
    
    -- MEM Stage
    signal MEM_ReadData : STD_LOGIC_VECTOR(31 downto 0);
    
    -- MEM/WB Signals
    signal WB_RegWrite, WB_MemToReg : STD_LOGIC;
    signal WB_ReadData, WB_ALUResult : STD_LOGIC_VECTOR(31 downto 0);
    signal WB_WriteReg : STD_LOGIC_VECTOR(4 downto 0);
    
    -- WB Stage
    signal WB_WriteData : STD_LOGIC_VECTOR(31 downto 0);

begin

    -- ==================== IF Stage ====================
    PC_Inst: ProgramCounter port map (clk => clk, reset => reset, PC_in => PC_in, PC_out => PC_out);
    
    IMem_Inst: InstructionMemory port map (ReadAddress => PC_out, Instruction => Instr);
    
    PC_Plus4 <= std_logic_vector(unsigned(PC_out) + 4);
    
    -- Simple Mux for PC (Next PC logic needs Branch/Jump implementation, simplifying for now to just PC+4)
    -- Ideally: Mux between PC+4, Branch Target, Jump Target
    PC_in <= PC_Plus4; -- Placeholder, assuming no branches/jumps for basic structure check

    -- ==================== IF/ID Register ====================
    IF_ID_Inst: IF_ID port map (
        clk => clk, reset => reset, enable => IF_ID_Write,
        PC_Plus4_in => PC_Plus4, Instr_in => Instr,
        PC_Plus4_out => ID_PC_Plus4, Instr_out => ID_Instr
    );

    -- ==================== ID Stage ====================
    Control_Inst: ControlUnit port map (
        Opcode => ID_Instr(31 downto 26), Funct => ID_Instr(5 downto 0),
        RegDst => RegDst, Jump => Jump, Branch => Branch, MemRead => MemRead, MemToReg => MemToReg,
        ALUOp => ALUOp, MemWrite => MemWrite, ALUSrc => ALUSrc, RegWrite => RegWrite
    );

    -- Hazard Detection Mux (Control to 0 if Stall)
    Mux_RegWrite <= RegWrite when ControlMux = '1' else '0';
    Mux_MemToReg <= MemToReg when ControlMux = '1' else '0';
    Mux_MemWrite <= MemWrite when ControlMux = '1' else '0';
    Mux_MemRead  <= MemRead  when ControlMux = '1' else '0';
    Mux_ALUSrc   <= ALUSrc   when ControlMux = '1' else '0';
    Mux_RegDst   <= RegDst   when ControlMux = '1' else '0';
    Mux_ALUOp    <= ALUOp    when ControlMux = '1' else "00";

    RegFile_Inst: RegFile port map (
        clk => clk, reset => reset,
        ReadReg1 => ID_Instr(25 downto 21), ReadReg2 => ID_Instr(20 downto 16),
        WriteReg => WB_WriteReg, WriteData => WB_WriteData, RegWrite => WB_RegWrite, -- From WB Stage
        ReadData1 => ReadData1, ReadData2 => ReadData2
    );

    SignExtend <= std_logic_vector(resize(signed(ID_Instr(15 downto 0)), 32));

    Hazard_Inst: HazardUnit port map (
        ID_EX_MemRead => EX_MemRead, ID_EX_Rt => EX_Rt, IF_ID_Rs => ID_Instr(25 downto 21), IF_ID_Rt => ID_Instr(20 downto 16),
        PCWrite => PCWrite, IF_ID_Write => IF_ID_Write, ControlMux => ControlMux
    );

    -- ==================== ID/EX Register ====================
    ID_EX_Inst: ID_EX port map (
        clk => clk, reset => reset,
        RegWrite_in => Mux_RegWrite, MemToReg_in => Mux_MemToReg, MemWrite_in => Mux_MemWrite, MemRead_in => Mux_MemRead,
        ALUOp_in => Mux_ALUOp, ALUSrc_in => Mux_ALUSrc, RegDst_in => Mux_RegDst,
        PC_Plus4_in => ID_PC_Plus4, ReadData1_in => ReadData1, ReadData2_in => ReadData2,
        SignExtend_in => SignExtend, Rs_in => ID_Instr(25 downto 21), Rt_in => ID_Instr(20 downto 16), Rd_in => ID_Instr(15 downto 11),
        
        RegWrite_out => EX_RegWrite, MemToReg_out => EX_MemToReg, MemWrite_out => EX_MemWrite, MemRead_out => EX_MemRead,
        ALUOp_out => EX_ALUOp, ALUSrc_out => EX_ALUSrc, RegDst_out => EX_RegDst,
        PC_Plus4_out => EX_PC_Plus4, ReadData1_out => EX_ReadData1, ReadData2_out => EX_ReadData2,
        SignExtend_out => EX_SignExtend, Rs_out => EX_Rs, Rt_out => EX_Rt, Rd_out => EX_Rd
    );

    -- ==================== EX Stage ====================
    
    -- Forwarding Unit
    Forward_Inst: ForwardingUnit port map (
        ID_EX_Rs => EX_Rs, ID_EX_Rt => EX_Rt,
        EX_MEM_RegWrite => MEM_RegWrite, EX_MEM_Rd => MEM_WriteReg,
        MEM_WB_RegWrite => WB_RegWrite, MEM_WB_Rd => WB_WriteReg,
        ForwardA => ForwardA, ForwardB => ForwardB
    );

    -- ALU Source A Mux (Forwarding)
    with ForwardA select
        ALU_SrcA <= EX_ReadData1 when "00",
                    WB_WriteData when "01", -- Forward from WB
                    MEM_ALUResult when "10", -- Forward from MEM
                    EX_ReadData1 when others;

    -- ALU Source B Mux (Forwarding + Immediate)
    process(ForwardB, EX_ReadData2, WB_WriteData, MEM_ALUResult, EX_ALUSrc, EX_SignExtend)
        variable ForwardedB : STD_LOGIC_VECTOR(31 downto 0);
    begin
        case ForwardB is
            when "00" => ForwardedB := EX_ReadData2;
            when "01" => ForwardedB := WB_WriteData;
            when "10" => ForwardedB := MEM_ALUResult;
            when others => ForwardedB := EX_ReadData2;
        end case;
        
        if EX_ALUSrc = '1' then
            ALU_SrcB <= EX_SignExtend;
        else
            ALU_SrcB <= ForwardedB;
        end if;
    end process;

    -- ALU Control (Simplification: Mapping ALUOp to ALUControl directly or tiny logic)
    -- Real implementation needs a small ALU Control block decoding funct field.
    -- Assuming ALUOp handles it or hardcoding for demo.
    -- Let's add a small embedded ALU Decoder process here or simplified mapping.
    process(EX_ALUOp, EX_SignExtend(5 downto 0)) -- using low bits of sign extend as funct
    begin
        if EX_ALUOp = "00" then -- LW/SW/ADDI
             ALUControl <= "0010"; -- ADD
        elsif EX_ALUOp = "01" then -- BEQ
             ALUControl <= "0110"; -- SUB
        else -- R-Type
             case EX_SignExtend(5 downto 0) is
                 when "100000" => ALUControl <= "0010"; -- ADD
                 when "100010" => ALUControl <= "0110"; -- SUB
                 when "100100" => ALUControl <= "0000"; -- AND
                 when "100101" => ALUControl <= "0001"; -- OR
                 when "101010" => ALUControl <= "0111"; -- SLT
                 when others   => ALUControl <= "0000";
             end case;
        end if;
    end process;

    ALU_Inst: ALU port map (
        A => ALU_SrcA, B => ALU_SrcB, ALUControl => ALUControl, Result => ALUResult, Zero => Zero
    );

    -- Write Register Mux
    WriteReg_EX <= EX_Rd when EX_RegDst = '1' else EX_Rt;

    -- ==================== EX/MEM Register ====================
    EX_MEM_Inst: EX_MEM port map (
        clk => clk, reset => reset,
        RegWrite_in => EX_RegWrite, MemToReg_in => EX_MemToReg, MemWrite_in => EX_MemWrite, MemRead_in => EX_MemRead,
        ALUResult_in => ALUResult, WriteData_in => EX_ReadData2, WriteReg_in => WriteReg_EX, -- Note: Should fwd correct data to mem, simplified here
        
        RegWrite_out => MEM_RegWrite, MemToReg_out => MEM_MemToReg, MemWrite_out => MEM_MemWrite, MemRead_out => MEM_MemRead,
        ALUResult_out => MEM_ALUResult, WriteData_out => MEM_WriteData, WriteReg_out => MEM_WriteReg
    );

    -- ==================== MEM Stage ====================
    DMem_Inst: DataMemory port map (
        clk => clk, Address => MEM_ALUResult, WriteData => MEM_WriteData,
        MemWrite => MEM_MemWrite, MemRead => MEM_MemRead, ReadData => MEM_ReadData
    );

    -- ==================== MEM/WB Register ====================
    MEM_WB_Inst: MEM_WB port map (
        clk => clk, reset => reset,
        RegWrite_in => MEM_RegWrite, MemToReg_in => MEM_MemToReg,
        ReadData_in => MEM_ReadData, ALUResult_in => MEM_ALUResult, WriteReg_in => MEM_WriteReg,
        
        RegWrite_out => WB_RegWrite, MemToReg_out => WB_MemToReg,
        ReadData_out => WB_ReadData, ALUResult_out => WB_ALUResult, WriteReg_out => WB_WriteReg
    );

    -- ==================== WB Stage ====================
    WB_WriteData <= WB_ReadData when WB_MemToReg = '1' else WB_ALUResult;

end Behavioral;
