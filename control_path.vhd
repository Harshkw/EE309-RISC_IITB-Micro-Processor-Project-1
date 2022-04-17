library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library work;
use work.components.all;

entity control_path is
	port(
		 clock: in std_logic; 
		op_code: in std_logic_vector(3 downto 0);
		CZ: in std_logic_vector(1 downto 0);
		C: out std_logic_vector(29 downto 0);
		wren,rden:out std_logic;
		state: out std_logic_vector(4 downto 0);
		CY, Z,invalid_next: in std_logic);
end entity;

architecture fsm of control_path is
	type fsm_state is (S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, S13, S14, S15, S16,s17,s18);
	signal Q, nQ: fsm_state := S0;
begin
		clockcycle:
		process(clock, nQ)
	begin
		if (clock'event and clock = '1') then
			Q <= nQ;
		end if;
	end process;
	control_pin:
	process(op_code,Q)
	begin
	
		C<= (others => '0');
		case Q is
			when S0 =>
							C <= (others => '0');
							state <= "00000";
			when S1 =>
							wren <= '0';
							rden <= '1';
							C(11) <= '1';
							C(13 downto 12) <= "10";
							C(16 downto 14) <= "110";
							C(18 downto 17) <= "10";
							C(21) <= '1';
							C(22) <= '0';
							C(25 downto 23) <= "000";
							C(26) <= '0';
							C(27) <= '0';
							C(29 downto 28) <= "10";
							C(0) <= '0';
							
			when S2 =>	
							C(4 downto 0) <= "00001";
							C(11 downto 9) <= "001";
							C(29 downto 21) <= "001110000";
							
			when S3 =>	
							C(0 downto 0) <= "0";
							C(16 downto 12) <= "00100";
							C(19 downto 19) <= "0";
							C(29 downto 21) <= "010000000";
							
			when S4 =>				
							C(0 downto 0) <="1";
							C(8 downto 5) <= "0000";
							C(29 downto 21) <= "000001000";
							
			when S5 =>
							C(0 downto 0) <="1";
							C(8 downto 5) <= "0110";
							C(29 downto 21) <= "000001000";
							
			when S6 => 	
							C(4 downto 0) <= "10101";
							C(16 downto 9) <= "00010001";
							C(19) <= '0';
							C(29 downto 21) <= "011110010";
							
			when S7 =>
							C(0 downto 0) <="1";
							C(4 downto 3) <= "01";
							C(10 downto 9) <= "01";
							C(16 downto 12) <= "00000";
							C(19) <= '0';
							C(29 downto 21) <= "011011000";
							
			when S8 =>
							C(0 downto 0) <="1";
							C(8 downto 5) <= "1100";
							C(29 downto 21) <= "000001000";
							
			when S9 =>	
							wren <= '0';
							rden <='1';
							C(0 downto 0) <="0";
							C(19 downto 17) <= "101";
							C(29 downto 21) <= "010000000";
							
			when S10 =>	
							wren <= '1';
							rden <= '0';
							C(0 downto 0) <="0";
							C(18 downto 17) <= "01";
							C(29 downto 21) <= "000000000";
				
			when S11 =>
							C(0 downto 0) <="0";
							C(16 downto 12) <= "00100";
							C(29 downto 20) <= "0000000001";
							
			when S12 =>	
							C(0 downto 0) <="1";
							C(8 downto 5) <= "0100";
							C(16 downto 12) <= "10001";
							C(29 downto 21) <= "100001000";
							
			when S17 => 
							C(2 downto 0) <= "011";
							C(10 downto 9) <= "00";
							C(29 downto 21) <= "001010110";

			when S16 =>
							C(0 downto 0) <="1";
							C(8 downto 5) <= "1001";
							C(16 downto 11) <= "110001";
							C(29 downto 21) <= "000101010";

			when S15 =>
							wren <= '0';
							rden <= '1';
							C(0 downto 0) <="0";
							C(10 downto 9) <= "10";
							C(18 downto 17) <= "00";
							C(29 downto 21) <= "001000000";

			when S14 =>
							C(2 downto 0) <= "101";
							C(16 downto 12) <= "01011";
							C(29 downto 20) <= "1000101001";

			when S13 =>
							C(2 downto 0) <= "001";
							C(8 downto 5) <= "0100";
							C(29 downto 20) <= "1000001000";
							
			when S18 =>
		               wren <= '1';
   		            rden <= '0';
							C(17 downto 11) <= "0110001";
							C(29 downto 21) <= "000100000";
							C(0 downto 0) <="0";
							
							
				end case;
		end process;
		
		state_next:
		process(op_code,  CY,CZ,  Z, invalid_next, Q)
		begin
		nQ <= Q;
		
			case Q is
					 when S0 => nQ <= S1;
					 when S1 =>
									case op_code is
										when "0000" =>
											   nQ <= S8;
												
										when "1100" | "1101" | "1000" =>
										      nQ <= S6;
												
										when "1001" =>
										      nQ <= S12;
												
										when "1010" =>
										      nQ <= S13;
												
										when "1011" =>
												nQ <= S14;
										when others => nQ<=S2;
										end case;
					 when S2 =>
									case op_code is
										when "0001" | "0010"=>
												case CZ is
													when "00" => nQ <= S3;
													when "10" =>
																	if (CY = '1') then	nQ <= S3;
																		else	nQ <= S5;
																	end if;
													when "01" =>
																	if (Z = '1') then	nQ <= S3;
																	else nQ <= S5;
																	end if;
													when "11" =>nQ <= S3;
													when others =>	nQ <= S5;
													end case;
													
										when "0000" | "0111" | "0101" =>
												nQ <= S7;
										
										when others =>	nQ <= S5;
										
										end case;
					when S3 => nQ <= S4;
					
					when S4 => nQ <= S5;
					
					when S6 => 
							     case op_code is 
										when "1100" =>
												nQ <= S15;
										
										when "1101" =>
												nQ <= S17;
												
										when "1000" =>
												nQ <= S11;
												
										when others => nQ <= S5;
									end case;	
					when S7 => 
								  case op_code is
										when "0111" =>
												nQ <= S9;
												
										when "0101" =>
												nQ <= S10;
										
										when others => nQ <= S5;
								end case;		
					when S8 => nQ <= S5;
					
					when S9 => 
								  case op_code is
										when "0111" =>
												nQ <= S4;
												
										when others => nQ <= S5;
									end case;	
					when S10 => nQ <= S5;
               
               when S11 => nQ <= S5;

					when S12 => nQ <= S5;
					
					when S13 => nQ <= S5;
					
					when S14 => nQ <= S5;
					
					when S15 => nQ <= S16;
					
					when S16 =>
								   if(invalid_next = '0') then nQ <= S15;
									else nQ <= S1;
									end if;	
									
					when S17 => 
					            case op_code is 
										when "1101" =>
												nQ <= S18;
												
										when others => nQ <= S5;
									end case;	
					when S18 => 
									if(invalid_next = '0') then nQ <= S17;
									else nQ <= S1;
									end if;
								  
					when S5 => nQ <= S0;
					
				end case;
				end process;
	
end architecture;