library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package components is
	component fulladder is
		port(
			a, b, cin: in std_logic;	--input bits to be added and input carry
			cout, s: out std_logic);	--output carry and sum bit
	end component;
	
	component adder4Bit is
		port(
			A,B: in std_logic_vector(3 downto 0);	--input pins
			S: out std_logic_vector(3 downto 0);	--result
			cin: in std_logic;	--input carry
			cout: out std_logic);	--output pins
	end component;
	
	component adder16Bit is
		port(
			A, B: in std_logic_vector(15 downto 0);	--input numbers to be added
			S: out std_logic_vector(15 downto 0);	--result
			cin: in std_logic;	--input carry
			cout: out std_logic);	--ouput carry
	end component;
	
	component Sub16Bit is	--subtracter
		port(
			A, B: in std_logic_vector(15 downto 0);	--input numbers
			S: out std_logic_vector(15 downto 0);	--output result
			cout: out std_logic);	-- output overflow/carry
	end component;
	
		component mux2 is		--2 bit mux
		generic(input_width: integer := 16);
		port(
			inp1, inp2: in std_logic_vector(input_width-1 downto 0) := (others => '0');
			sel: in std_logic;
			output: out std_logic_vector(input_width-1 downto 0));
	end component;
	
	component mux4_16 is		--4 bit mux with 16 bit input
		generic(input_width: integer := 16);
		port(
			inp1, inp2, inp3, inp4: in std_logic_vector(input_width-1 downto 0) := (others => '0');
			sel: in std_logic_vector(1 downto 0);
			output: out std_logic_vector(input_width-1 downto 0));
	end component;
	
	component mux4_3 is		--4 bit mux with 3 bit input
		generic(input_width: integer := 3);
		port(
			inp1, inp2, inp3, inp4: in std_logic_vector(input_width-1 downto 0) := (others => '0');
			sel: in std_logic_vector(1 downto 0);
			output: out std_logic_vector(input_width-1 downto 0));
	end component;
	
	component mux8 is
		generic(input_width: integer := 16);
		port(
			inp1, inp2, inp3, inp4, inp5, inp6, inp7, inp8: in std_logic_vector(input_width-1 downto 0) := (others => '0');
			sel: in std_logic_vector(2 downto 0);
			output: out std_logic_vector(input_width-1 downto 0));
	end component;
	
	component nand_16 is		--nand with 16 bit output for 2 16 bit input
		generic(input_width: integer := 16);
		port(
			A,B: in std_logic_vector(input_width-1 downto 0);
			S: out std_logic_vector(input_width-1 downto 0));
	end component;
	
	component nor_8 is  		--priority 
		generic(input_width: integer := 8);
		port(
			A: in std_logic_vector(input_width-1 downto 0);
			S: out std_logic);
	end component;
	
	component reg_process is
	generic ( data_width : integer);
	port(
		clk, ena: in std_logic;
		Din: in std_logic_vector(data_width-1 downto 0);
		Dout: out std_logic_vector(data_width-1 downto 0));
	end component;

end package;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fulladder is
	port(
		a, b, cin: in std_logic;	--input bits to be added and input carry
		cout, s: out std_logic);	--output carry and sum bit
end entity;

architecture behave of fulladder	is
	signal axorb: std_logic;	--xor of a and b
begin

	axorb <= (((not a) and b) or (a and (not b)));	--xor of a and b
	s <= (((not axorb) and cin) or (axorb and (not cin)));	--xor of a,b and cin
	cout <= (((a and b) or (a and cin)) or (cin and b));	--ab+ bcin+ acin

end behave;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.components.all;

entity adder4Bit is
	port(
			A,B: in std_logic_vector(3 downto 0);	--input pins
			S: out std_logic_vector(3 downto 0);	--result
			cin: in std_logic;	--input carry
			cout: out std_logic);	--output pins
end entity;

architecture behave of adder4Bit is
	signal C:std_logic_vector(2 downto 0);
begin
	full1: fullAdder port map( a =>A(0), b=>B(0), s => S(0), cin => cin, cout => C(0));	--first full adder
	full2: fullAdder port map( a =>A(1), b=>B(1), s => S(1), cin => C(0), cout => C(1));	--second full adder
	full3: fullAdder port map( a =>A(2), b=>B(2), s => S(2), cin => C(1), cout => C(2));	--third full adder
	full4: fullAdder port map( a =>A(3), b=>B(3), s => S(3), cin => C(2), cout => cout);	--fourth full adder
end behave;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.components.all;

entity adder16Bit is
	port(
			A,B: in std_logic_vector(15 downto 0);	--input pins
			S: out std_logic_vector(15 downto 0);	--result
			cin: in std_logic;	--input carry
			cout: out std_logic);	--output pins
end entity;

architecture behave of adder16Bit is
	signal C:std_logic_vector(2 downto 0);
begin
	full1: adder4Bit port map( A(0) =>A(0),A(1) =>A(1),A(2) =>A(2),A(3) =>A(3), B(0)=>B(0),B(1)=>B(1),B(2)=>B(2),B(3)=>B(3), S(0) => S(0),S(1) => S(1),S(2) => S(2),S(3) => S(3), cin => cin, cout => C(0));	--first 4bitadder
	full2: adder4Bit port map( A(0) =>A(4),A(1) =>A(5),A(2) =>A(6),A(3) =>A(7), B(0)=>B(4),B(1)=>B(5),B(2)=>B(6),B(3)=>B(7), S(0) => S(4),S(1) => S(5),S(2) => S(6),S(3) => S(7), cin => C(0), cout => C(1));	--second 4bitadder
	full3: adder4Bit port map( A(0) =>A(8),A(1) =>A(9),A(2) =>A(10),A(3) =>A(11), B(0)=>B(8),B(1)=>B(9),B(2)=>B(10),B(3)=>B(11), S(0) => S(8),S(1) => S(9),S(2) => S(10),S(3) => S(11), cin => C(1), cout => C(2));	--third 4bitadder
	full4: adder4Bit port map( A(0) =>A(12),A(1) =>A(13),A(2) =>A(14),A(3) =>A(15), B(0)=>B(12),B(1)=>B(13),B(2)=>B(14),B(3)=>B(15), S(0) => S(12),S(1) => S(13),S(2) => S(14),S(3) => S(15), cin => C(2), cout => cout);	--fourth 4bitadder
end behave;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.components.all;

entity Sub16Bit is
	port(
		A, B: in std_logic_vector(15 downto 0);	--input numbers to be added
		S: out std_logic_vector(15 downto 0);	--result
		cout: out std_logic);	--ouput carry
end entity;

architecture behave of Sub16Bit is
	signal notB: std_logic_vector(15 downto 0);
begin
	
	notB <= not B;
	
	adder1: adder16Bit port map( A => A, B => notB, cin => '1', cout => cout, S => S);	--16-bit adder
	
end behave;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux4_16 is
	generic(input_width: integer := 16);
	port(
		inp1, inp2, inp3, inp4: in std_logic_vector(input_width-1 downto 0) := (others => '0');
		sel: in std_logic_vector(1 downto 0);
		output: out std_logic_vector(input_width-1 downto 0));
end entity;

architecture behave of mux4_16 is
begin
	output <= inp1 when (sel = "00") else
		inp2 when (sel = "01") else
		inp3 when (sel = "10") else
		inp4;
end behave;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux4_3 is
	generic(input_width: integer := 3);
	port(
		inp1, inp2, inp3, inp4: in std_logic_vector(input_width-1 downto 0) := (others => '0');
		sel: in std_logic_vector(1 downto 0);
		output: out std_logic_vector(input_width-1 downto 0));
end entity;

architecture behave of mux4_3 is
begin
	output <= inp1 when (sel = "00") else
		inp2 when (sel = "01") else
		inp3 when (sel = "10") else
		inp4;
end behave;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux2 is
	generic(input_width: integer := 16);
	port(
		inp1, inp2: in std_logic_vector(input_width-1 downto 0) := (others => '0');
		sel: in std_logic;
		output: out std_logic_vector(input_width-1 downto 0));
end entity;

architecture behave of mux2 is
begin
	output <= inp1 when (sel = '0') else
		inp2;
end behave;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux8 is
	generic(input_width: integer := 16);
	port(
		inp1, inp2, inp3, inp4, inp5, inp6, inp7, inp8: in std_logic_vector(input_width-1 downto 0) := (others => '0');
		sel: in std_logic_vector(2 downto 0);
		output: out std_logic_vector(input_width-1 downto 0));
end entity;

architecture behave of mux8 is
begin
	output <= inp1 when (sel = "000") else
		inp2 when (sel = "001") else
		inp3 when (sel = "010") else
		inp4 when (sel = "011") else
		inp5 when (sel = "100") else
		inp6 when (sel = "101") else
		inp7 when (sel = "110") else
		inp8;
end behave;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity nand_16 is
	generic(input_width: integer := 16);
		port(
			A,B: in std_logic_vector(input_width-1 downto 0);
			S: out std_logic_vector(input_width-1 downto 0));
end entity;
architecture behave of nand_16 is
begin
	S <= A nand B;
end behave;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity nor_8 is
	generic(input_width: integer := 8);
		port(
			A: in std_logic_vector(input_width-1 downto 0);
			S: out std_logic);
end entity;
architecture behave of nor_8 is
begin
	S <= (((((((A(0) nor A(1) ) nor A(2)) nor A(3)) nor A(4))nor A(5))nor A(6))nor A(7));
end behave;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg_process is
	generic ( data_width : integer);
	port(
		clk, ena: in std_logic;
		Din: in std_logic_vector(data_width-1 downto 0);
		Dout: out std_logic_vector(data_width-1 downto 0));
end entity;

architecture behave of reg_process is

begin

	process(clk)	
	begin
		if(clk'event and clk='1') then
			if (ena='1') then
				Dout <= Din;
			end if;
		end if;
	end process;
	
end behave;	

