library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity HazardUnit is
    Port (
        ID_EX_MemRead   : in  STD_LOGIC;
        ID_EX_Rt        : in  STD_LOGIC_VECTOR (4 downto 0);
        IF_ID_Rs        : in  STD_LOGIC_VECTOR (4 downto 0);
        IF_ID_Rt        : in  STD_LOGIC_VECTOR (4 downto 0);
        
        -- Control outputs
        PCWrite         : out STD_LOGIC;
        IF_ID_Write     : out STD_LOGIC;
        ControlMux      : out STD_LOGIC -- 0 to stall (insert 0s), 1 to pass signals
    );
end HazardUnit;

architecture Behavioral of HazardUnit is
begin

    process(ID_EX_MemRead, ID_EX_Rt, IF_ID_Rs, IF_ID_Rt)
    begin
        -- Load-Use Hazard Detection
        if (ID_EX_MemRead = '1') and ((ID_EX_Rt = IF_ID_Rs) or (ID_EX_Rt = IF_ID_Rt)) then
            -- Stall the pipeline
            PCWrite     <= '0';
            IF_ID_Write <= '0';
            ControlMux  <= '0'; -- Insert NOP (set control signals to 0)
        else
            -- No hazard
            PCWrite     <= '1';
            IF_ID_Write <= '1';
            ControlMux  <= '1';
        end if;
    end process;

end Behavioral;
