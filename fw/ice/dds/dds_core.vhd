library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity dds_core is
  generic (
    NCO_LENGTH: integer := 16;
    DDS_LENGTH: integer := 16
  );
    port (
      -- Basic control
    clk, rst: in std_logic;
        
        -- NCO control
        pha, inc: in unsigned(NCO_LENGTH-1 downto 0);

    -- WAV Control
    waveform: in std_logic_vector(1 downto 0);

    -- Output
    dds: out signed(DDS_LENGTH-1 downto 0)
    );
end entity ; -- dds_core

architecture arch_dds_core of dds_core is
  
    -- NCO accumulator
  signal nco_pha: unsigned(NCO_LENGTH-1 downto 0) := (others => '0');
    
begin
     
    -- Numerically Controlld Oscillator
  -- Creates a phase output of varying velocity
    -- PHAse => 360*pha/(2**LENGTH) deg
    -- INCrement => 360*inc/(2**LENGTH) deg/clk
  NCO: entity dds_nco(arch_dds_nco)
    port map(
          clk => clk, rst => rst,
            pha => pha,
            inc => inc,
          nco => nco_pha            
    );
    
    -- Wave generator
    --
  WAV: entity dds_wav(arch_dds_wav) 
      port map (
          clk => clk,
            rst => rst,
            nco => nco_pha,
            waveform => waveform,
            dds => dds
        );

end architecture ; -- arch_dds_core


