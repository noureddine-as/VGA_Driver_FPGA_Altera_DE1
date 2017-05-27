library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity vga_driver is
    Port ( CLK : in  STD_LOGIC; --- has to be 24Mhz
           RST : in  STD_LOGIC;
           HSYNC : out  STD_LOGIC;
           VSYNC : out  STD_LOGIC;
           R : out  STD_LOGIC_VECTOR (3 downto 0);
			  G : out  STD_LOGIC_VECTOR (3 downto 0);
			  B : out  STD_LOGIC_VECTOR (3 downto 0)
			  );
end vga_driver;

architecture Behavioral of vga_driver is

	-------------- MY CHANGES --------------	
	signal PIXEL_CLOCK : std_logic;
	 
	 component PLL is
        port (
            clock_27_clk    : in  std_logic := 'X'; -- clk
            pixel_clock_clk : out std_logic;        -- clk
            reset_reset     : in  std_logic := 'X'  -- reset
        );
    end component PLL;

	
----------------------------------------
-- If u're working with  1280*1024 @75 HZ, we need 135Mhz of PIXEL_CLOCK so we have to configure the PLL using the QSYS utility
--	constant HD : integer := 1279;  --  639   Horizontal Display (640)
--	constant HFP : integer := 16;         --   16   Right border (front porch)
--	constant HSP : integer := 144;       --   96   Sync pulse (Retrace)
--	constant HBP : integer := 248;        --   48   Left boarder (back porch)
--	
--	constant VD : integer := 1023;   --  479   Vertical Display (480)
--	constant VFP : integer := 1;       	 --   10   Right border (front porch)
--	constant VSP : integer := 3;				 --    2   Sync pulse (Retrace)
--	constant VBP : integer := 38;       --   33   Left boarder (back porch)

-- If u're working with   1280*1024 @60Hz we need 108Mhz of PIXEL_CLOCK so we have to configure the PLL using the QSYS utility
	constant HD : integer := 1279;  --  639   Horizontal Display (640)
	constant HFP : integer := 48;         --   16   Right border (front porch)
	constant HSP : integer := 112;       --   96   Sync pulse (Retrace)
	constant HBP : integer := 248;        --   48   Left boarder (back porch)
	
	constant VD : integer := 1023;   --  479   Vertical Display (480)
	constant VFP : integer := 1;       	 --   10   Right border (front porch)
	constant VSP : integer := 3;				 --    2   Sync pulse (Retrace)
	constant VBP : integer := 38;       --   33   Left boarder (back porch)
	
	
	signal hPos : integer := 0;
	signal vPos : integer := 0;
	
	signal videoOn : std_logic := '0';

begin

		u0 : component PLL
        port map (
            clock_27_clk    => CLK,    --    CLOCK_27 Must be provided because we use 27 * 4 = 108Mhz for pixel clock
            pixel_clock_clk => PIXEL_CLOCK, -- pixel_clock.clk
            reset_reset     => RST      --       reset.reset
        );

Horizontal_position_counter:process(PIXEL_CLOCK, RST)
begin
	if(RST = '1')then
		hpos <= 0;
	elsif(PIXEL_CLOCK'event and PIXEL_CLOCK = '1')then
		if (hPos = (HD + HFP + HSP + HBP)) then
			hPos <= 0;
		else
			hPos <= hPos + 1;
		end if;
	end if;
end process;

Vertical_position_counter:process(PIXEL_CLOCK, RST, hPos)
begin
	if(RST = '1')then
		vPos <= 0;
	elsif(PIXEL_CLOCK'event and PIXEL_CLOCK = '1')then
		if(hPos = (HD + HFP + HSP + HBP))then
			if (vPos = (VD + VFP + VSP + VBP)) then
				vPos <= 0;
			else
				vPos <= vPos + 1;
			end if;
		end if;
	end if;
end process;

Horizontal_Synchronisation:process(PIXEL_CLOCK, RST, hPos)
begin
	if(RST = '1')then
		HSYNC <= '0';
	elsif(PIXEL_CLOCK'event and PIXEL_CLOCK = '1')then
		if((hPos <= (HD + HFP)) OR (hPos > HD + HFP + HSP))then
			HSYNC <= '1';
		else
			HSYNC <= '0';
		end if;
	end if;
end process;

Vertical_Synchronisation:process(PIXEL_CLOCK, RST, vPos)
begin
	if(RST = '1')then
		VSYNC <= '0';
	elsif(PIXEL_CLOCK'event and PIXEL_CLOCK = '1')then
		if((vPos <= (VD + VFP)) OR (vPos > VD + VFP + VSP))then
			VSYNC <= '1';
		else
			VSYNC <= '0';
		end if;
	end if;
end process;

video_on:process(PIXEL_CLOCK, RST, hPos, vPos)
begin
	if(RST = '1')then
		videoOn <= '0';
	elsif(PIXEL_CLOCK'event and PIXEL_CLOCK = '1')then
		if(hPos <= HD and vPos <= VD)then
			videoOn <= '1';
		else
			videoOn <= '0';
		end if;
	end if;
end process;


draw:process(PIXEL_CLOCK, RST, hPos, vPos, videoOn)
begin
	if(RST = '1')then
		R <= (others => '1');
		G <= (others => '1');
		B <= (others => '1');
			
	elsif(PIXEL_CLOCK'event and PIXEL_CLOCK = '1')then
		if(videoOn = '1')then
			if((hPos >= 10 and hPos <= 600) AND (vPos >= 10 and vPos <= 600))then
				R <= "1000"; 
				G <= "0000"; 
				B <= "0000"; 
			else
				R <= (others => '0');
				G <= (others => '0');
				B <= (others => '0');
			end if;
		else 
			R <= (others => '0');
			G <= (others => '0');
			B <= (others => '0');
		end if;
	end if;
end process;


end Behavioral;
