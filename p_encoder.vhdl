library ieee;
use ieee.std_logic_1164.all;

entity P_Encoder is
	port (PEReg : std_logic_vector(7 downto 0);

				PE_out : OUT std_logic_vector(2 downto 0);
        PE0 : OUT STD_LOGIC);
end P_Encoder;


architecture behave of P_Encoder is

  begin
    process (PEReg)
    begin
      if PEReg(0) = '1' then
        PE_out <= "000";
        PE0 <= '0';
      elsif PEReg(1) = '1' then
        PE_out <= "001";
        PE0 <= '0';
      elsif PEReg(2) = '1' then
        PE_out <= "010";
        PE0 <= '0';
      elsif PEReg(3) = '1' then
        PE_out <= "011";
        PE0 <= '0';
      elsif PEReg(4) = '1' then
        PE_out <= "100";
        PE0 <= '0';
      elsif PEReg(5) = '1' then
        PE_out <= "101";
        PE0 <= '0';
      elsif PEReg(6) = '1' then
        PE_out <= "110";
        PE0 <= '0';
      elsif PEReg(7) = '1' then
        PE_out <= "111";
        PE0 <= '0';
      else
        PE_out <= "000";
        PE0 <= '1';
      end if;
    end process;
end behave;