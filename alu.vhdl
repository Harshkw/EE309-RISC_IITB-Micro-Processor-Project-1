library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.components.all;

entity alu is
	generic(alu_length: integer := 16);
	port(
		input1, input2: in std_logic_vector(alu_length-1 downto 0);
		output: out std_logic_vector(alu_length-1 downto 0);
		sel:in std_logic_vector(1 downto 0);
		cin: in std_logic;
		CY, Z: out std_logic);
end entity;

architecture behave of alu is
	signal output_temp: std_logic_vector(alu_length-1 downto 0);
	signal output_add: std_logic_vector(alu_length-1 downto 0);
	signal output_sub: std_logic_vector(alu_length-1 downto 0);
	signal output_nand: std_logic_vector(alu_length-1 downto 0);
	signal C: std_logic_vector(1 downto 0) ;
begin
	
	ADD0: adder16Bit
		port map(
			A => input1, B => input2,
			cin => cin, S => output_add, cout => C(1));
			CY <= C(1);
	SUB0:Sub16Bit	
		port map(
			A => input1, B => input2, S => output_sub, cout => C(0));	
			CY <= C(0);
	NAND0:nand_16
		port map(
			A => input1, B => input2, S => output_nand);
	
	process(input1,input2,sel,output_add,output_sub,output_nand)
	begin
		if (sel = "00") then
			output_temp <= output_add;
		elsif (sel = "01") then
			output_temp <= output_sub;
		elsif (sel = "10") then
			output_temp <= output_nand;	
		end if;
	end process;
	
	Z <= '1' when (to_integer(unsigned(output_temp)) = 0) else '0';
	output <= output_temp;

		
end architecture;