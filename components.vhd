library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package components is
	component fulladder is
		port(
			a, b, cin: in std_logic;	--input bits to be added and input carry
			cout, s: out std_logic);	--output carry and sum bit
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