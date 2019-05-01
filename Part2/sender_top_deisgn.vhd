--This is the TOP-DESIGN part
--Remember that the "CLOCK-ENABLE" (Modified Clock.Div) will have a 25Mhz Frequency
--Remember that Calling the COMPONENTS is the Easy PART
--Step1: To know how to Connect the PORTS, we first type in all the COMPONENTS to have an idea of what INPUT and OUTPUT connections have Similar Names.

library ieee;
use ieee.std_logic_1164.all;


entity image_top is 
        Port (
              clk             : in std_logic;                          --This is the clock
              vga_hs, vga_vs  : out std_logic;                          --These are the HORIZONTAL and VERTICAL parts
              vga_r, vga_b    : out std_logic_vector (4 downto 0);
              vga_g           : out std_logic_vector (5 downto 0)
              );
end image_top;
  
  
architecture rtl of image_top is
  
          signal addrSig : std_logic_vector(17 downto 0);           --TEMPORARY Signal for the COUNTER
          signal pixelSig : std_logic_vector(7 downto 0);
          signal vsSig : std_logic;
          signal hsSig :  std_logic;
          signal vidSig : std_logic;
          signal hcountSig : std_logic_vector(9 downto 0);
          signal vcountSig : std_logic_vector(9 downto 0);
          signal enSig : std_logic;
    
    ------------------------------------------------------------
          component pixel_pusher is         --Here we call "PIXEL_PUSHER"                    
                Port (
                      clk, en, vs, vid : in std_logic;
                      pixel   : in std_logic_vector (7 downto 0);
                      hcount  : in std_logic_vector (9 downto 0);
                      R, B    : out std_logic_vector (4 downto 0);
                      G       : out std_logic_vector (5 downto 0);
                      addr    : out std_logic_vector (17 downto 0)
                     );
          end component;
    
          ------------------------------------------------------------
          component vga_ctrl is             --Here we call "VGA_CTRL"    
                Port (
                    clk : in std_logic;
                    en : in std_logic;
                    hcount, vcount : out std_logic_vector(9 downto 0);
                    vid, vs, hs : out std_logic
                     );
          end component;
    
          ------------------------------------------------------------
    
          component clock_div is      --Here we call the Modified "Clock.Div"
                  port(
                      clk : in std_logic;
                      div : out std_logic
                      );
          end component;
    
          ------------------------------------------------------------
    
          component picture IS          --Here we call the "PICTURE"
              PORT (
                  clka : IN STD_LOGIC;
                  addra : IN STD_LOGIC_VECTOR(17 DOWNTO 0);
                  douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
          );
          end component;
          ------------------------------------------------------------


          begin       --Here we start declaring port maps
              pixelPusher: pixel_pusher port map(                  --This port map is for PIXER-PUSHER (Part 2)
                    clk => clk,                               --Here  the MAIN-CLOCK is connected to the INPUT  of the PIXER_PUSHER called "CLK"        
                    en => enSig,                              --Here the TEMPORARY Signal "enSig" (OUTPUT of Clock.Div) is Connected to the INPUT of PIXER_PUSHER called "EN"
                    vs => vsSig,                                   --Here the TEMPORARY Signal "vsSig" (OUTPUT of VGA_CTRL) is Connected to the INPUT of PIXER_PUSHER called "VS"
                    pixel => pixelSig,hcount => hcountSig,vid => vidSig,
                    R => vga_r,
                    B => vga_b,
                    G => vga_g,
                    addr => addrSig);
    
              my_picture: picture port map(
                    clka => clk,                                        --Here  the MAIN-CLOCK is connected to the INPUT  of the PICTURE called "CLKA" 
                    addra => addrSig,douta => pixelSig);                --Here the 
    
              clockDiv: clock_div port map(             --This is the port map for clock-divider
                    clk => clk,                     --Here we connect the MAIN-CLOCK to the "Clock-Divider"
                    div => enSig);                  --Here the OUTPUT of the "CLOCK.DIV" is Converted into a TEMPORARY Signal called "enSig"
    
              vgaCTRL: vga_ctrl port map(
                    clk => clk,                                 --Here  the MAIN-CLOCK is connected to the INPUT  of the VGA_CTRL called "CLK"
                    en => enSig,                            --Here the TEMPORARY Signal "enSig" (OUTPUT of Clock.Div) is Connected to the INPUT of VGA_CTRL called "EN"
                    hcount => hcountSig,vcount => vcountSig,vid => vidSig,
                    vs => vsSig,                            --Here the OUTPUT of "VGA_CTRL" is converted to the TEMPORARY Signal called "vsSig"
                    hs => hsSig);
                    vga_vs <= vsSig;vga_hs <= hsSig;
end rtl;
