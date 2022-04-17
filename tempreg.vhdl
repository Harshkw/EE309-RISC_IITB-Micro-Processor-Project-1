library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

library work;
use work.components.all;

entity temp_reg is
	generic(
		data_length: integer := 16);
		
	port(
		d_in1,d_in2: in std_logic_vector(data_length-1 downto 0);
		d_out: out std_logic_vector(data_length-1 downto 0);
		sel_in: in std_logic;
		clk, wr_ena: in std_logic);
		
end entity;

architecture behave of temp_reg is
	signal ena: std_logic;
	signal data_out: std_logic_vector(data_length-1 downto 0);
	signal reg_out: std_logic_vector(data_length-1 downto 0);
	
begin
	mux21:mux2
	generic map(data_length)
	port map ( inp1 => d_in1,inp2 => d_in2, sel => sel_in, output =>data_out);
		REG: reg_process
		generic map(data_length)
			port map(clk => clk, ena => ena, 
				Din => data_out, Dout => reg_out);
	
	in_decode: process(sel_in, wr_ena)
	begin
		ena <= wr_ena;	
	end process;
	
	d_out <= reg_out;
	
end architecture;