library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ForwardingUnit is
    Port (
        ID_EX_Rs        : in  STD_LOGIC_VECTOR (4 downto 0);
        ID_EX_Rt        : in  STD_LOGIC_VECTOR (4 downto 0);
        EX_MEM_RegWrite : in  STD_LOGIC;
        EX_MEM_Rd       : in  STD_LOGIC_VECTOR (4 downto 0);
        MEM_WB_RegWrite : in  STD_LOGIC;
        MEM_WB_Rd       : in  STD_LOGIC_VECTOR (4 downto 0);
        
        ForwardA        : out STD_LOGIC_VECTOR (1 downto 0);
        ForwardB        : out STD_LOGIC_VECTOR (1 downto 0)
    );
end ForwardingUnit;

architecture Behavioral of ForwardingUnit is
begin

    process(ID_EX_Rs, ID_EX_Rt, EX_MEM_RegWrite, EX_MEM_Rd, MEM_WB_RegWrite, MEM_WB_Rd)
    begin
        -- Initialize to default (no forwarding)
        ForwardA <= "00";
        ForwardB <= "00";

        -- EX Hazard (Forward from EX/MEM stage)
        if (EX_MEM_RegWrite = '1') and (unsigned(EX_MEM_Rd) /= 0) and (EX_MEM_Rd = ID_EX_Rs) then
            ForwardA <= "10";
        end if;
        
        if (EX_MEM_RegWrite = '1') and (unsigned(EX_MEM_Rd) /= 0) and (EX_MEM_Rd = ID_EX_Rt) then
            ForwardB <= "10";
        end if;

        -- MEM Hazard (Forward from MEM/WB stage)
        -- Only if EX Hazard condition is not met (double hazard)
        if (MEM_WB_RegWrite = '1') and (unsigned(MEM_WB_Rd) /= 0) and 
           not ((EX_MEM_RegWrite = '1') and (unsigned(EX_MEM_Rd) /= 0) and (EX_MEM_Rd = ID_EX_Rs)) and
           (MEM_WB_Rd = ID_EX_Rs) then
            ForwardA <= "01";
        end if;

        if (MEM_WB_RegWrite = '1') and (unsigned(MEM_WB_Rd) /= 0) and 
           not ((EX_MEM_RegWrite = '1') and (unsigned(EX_MEM_Rd) /= 0) and (EX_MEM_Rd = ID_EX_Rt)) and
           (MEM_WB_Rd = ID_EX_Rt) then
            ForwardB <= "01";
        end if;
        
    end process;

end Behavioral;
