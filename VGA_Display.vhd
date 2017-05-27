library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;


entity VGA_DISPLAY is
	Port(	CLOCK_27 : in STD_LOGIC;
			SW		: in STD_LOGIC_VECTOR(9 downto 0);  --- RESET
			VGA_HS	: out STD_LOGIC;
			VGA_VS	: out STD_LOGIC;
			VGA_R		: out STD_LOGIC_VECTOR(3 downto 0);
			VGA_G		: out STD_LOGIC_VECTOR(3 downto 0);
			VGA_B		: out STD_LOGIC_VECTOR(3 downto 0)
	);
end VGA_DISPLAY;

architecture Main of VGA_DISPLAY is

	Component vga_driver is
    Port ( CLK : in  STD_LOGIC; --- has to be 24Mhz
           RST : in  STD_LOGIC;
           HSYNC : out  STD_LOGIC;
           VSYNC : out  STD_LOGIC;
           R : out  STD_LOGIC_VECTOR (3 downto 0);
			  G : out  STD_LOGIC_VECTOR (3 downto 0);
			  B : out  STD_LOGIC_VECTOR (3 downto 0)
			  );
	end Component vga_driver;

begin

	my_vga_driver : 	Component vga_driver 
		port map ( CLK => CLOCK_27, --- has to be 24Mhz
           RST 		=> SW(0),
           HSYNC 		=> VGA_HS,
           VSYNC 		=> VGA_VS,
			  R 			=> VGA_R,
			  G			=> VGA_G,
			  B			=> VGA_B );


end Main;