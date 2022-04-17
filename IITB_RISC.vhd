library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library work;
use work.components.all;

entity IITB_RISC is
    port(
		 clk: in std_logic);
end entity;

architecture overview of IITB_RISC is
    component control_path is
        port(
            clock: in std_logic; 
		op_code: in std_logic_vector(3 downto 0);
		CZ: in std_logic_vector(1 downto 0);
		C: out std_logic_vector(29 downto 0);
		state: out std_logic_vector(4 downto 0);
		wren,rden:out std_logic;
		CY, Z,invalid_next: in std_logic);
    end component;

    component data_path is
        port(
			op_code: out std_logic_vector(3 downto 0);
	CZ: out std_logic_vector(1 downto 0);
	clock,wren,rden: in std_logic;
	C: in std_logic_vector(29 downto 0);
	state: out std_logic_vector(4 downto 0));
    end component;
    
   signal op_code: std_logic_vector(3 downto 0);
   signal CZ: std_logic_vector(1 downto 0);
   signal C: std_logic_vector(29 downto 0);
   signal CY, Z, invalid_next,wren,rden: std_logic;
   signal state: std_logic_vector(4 downto 0);

begin
	
	data: data_path
	port map(op_code => op_code, CZ=>CZ,wren=> wren,rden=>rden,
       clock => clk, C => C, state => state);
   
	control: control_path
	port map( clock => clk,
		op_code => op_code, CZ => CZ,wren=> wren,rden=>rden,
		C => C, CY => CY, Z => Z, invalid_next => invalid_next);
        

    
	invalid_next <= state(0);

end architecture;