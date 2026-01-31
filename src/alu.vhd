library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is
    Port (
        A           : in  STD_LOGIC_VECTOR (31 downto 0);
        B           : in  STD_LOGIC_VECTOR (31 downto 0);
        ALUControl  : in  STD_LOGIC_VECTOR (3 downto 0);
        Result      : out STD_LOGIC_VECTOR (31 downto 0);
        Zero        : out STD_LOGIC
    );
end ALU;

architecture Behavioral of ALU is
    signal result_temp : STD_LOGIC_VECTOR (31 downto 0);
begin

    process (A, B, ALUControl)
    begin
        case ALUControl is
            when "0000" => -- AND
                result_temp <= A and B;
            when "0001" => -- OR
                result_temp <= A or B;
            when "0010" => -- ADD
                result_temp <= std_logic_vector(unsigned(A) + unsigned(B));
            when "0110" => -- SUB
                result_temp <= std_logic_vector(unsigned(A) - unsigned(B));
            when "0111" => -- SLT (Set on Less Than)
                if (signed(A) < signed(B)) then
                    result_temp <= X"00000001";
                else
                    result_temp <= (others => '0');
                end if;
            when "1100" => -- NOR
                result_temp <= not (A or B);
            when others =>
                result_temp <= (others => '0');
        end case;
    end process;

    Result <= result_temp;
    Zero <= '1' when unsigned(result_temp) = 0 else '0';

end Behavioral;
