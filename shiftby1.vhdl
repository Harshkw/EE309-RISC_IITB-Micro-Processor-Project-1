library ieee;
use ieee.std_logic_1164.all;

entity mux21 is
	port(
		 I  : in std_logic_vector ( 1 downto 0);
			 S : in std_logic;
			 Y : out std_logic );
end entity;

architecture struct of mux21 is
 
begin
Y <= I(0) when (S = '0') else
		I(1);

end struct;

library ieee;
use ieee.std_logic_1164.all;
entity shiftby1 is
   port( 
          A  : in std_logic_vector ( 7 downto 0);
			 S : in std_logic;
			 Y : out std_logic_vector ( 7 downto 0) );
end entity shiftby1;


 
architecture struct of shiftby1 is
component mux21 is
   port( 
          I  : in std_logic_vector ( 1 downto 0);
			 S : in std_logic;
			 Y : out std_logic );
   end component;
 
begin
n1_bit : for i in 0 to 7 generate

        lsb: if i < 1 generate
            b1: mux21 port map(I(1) => A(7), I(0) => A(i), S => S, Y => Y(i));
        end generate lsb;

        msb: if i > 0 generate
            b2: mux21 port map(I(0) => A(i), I(1) => A(i-1), S => S, Y => Y(i));
        end generate msb;

    end generate ;

end struct;