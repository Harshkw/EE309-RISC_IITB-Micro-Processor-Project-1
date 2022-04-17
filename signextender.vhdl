library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package signextender is
	component sign_extend_6 is
	generic(input_width: integer := 6;
		output_width: integer := 16);
	port(
		input: in std_logic_vector(input_width-1 downto 0);
		output: out std_logic_vector(output_width-1 downto 0));
	end component;
	component sign_extend_9 is
	generic(input_width: integer := 9;
		output_width: integer := 16);
	port(
		input: in std_logic_vector(input_width-1 downto 0);
		output: out std_logic_vector(output_width-1 downto 0));
	end component;
end package;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sign_extend_6 is
	generic(input_width: integer := 6;
		output_width: integer := 16);
	port(
		input: in std_logic_vector(input_width-1 downto 0);
		output: out std_logic_vector(output_width-1 downto 0));
end entity;

architecture struct of sign_extend_6 is
begin
	
	output(input_width-1 downto 0) <= input;
	
	extend:
	for i in input_width to output_width-1 generate
		output(i) <= input(input_width-1);
	end generate;
	
end struct;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sign_extend_9 is
	generic(input_width: integer := 9;
		output_width: integer := 16);
	port(
		input: in std_logic_vector(input_width-1 downto 0);
		output: out std_logic_vector(output_width-1 downto 0));
end entity;

architecture struct of sign_extend_9 is
begin
	
	output(input_width-1 downto 0) <= input;
	
	extend:
	for i in input_width to output_width-1 generate
		output(i) <= input(input_width-1);
	end generate;
	
end struct;