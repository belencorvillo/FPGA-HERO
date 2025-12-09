library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library work;
use work.music_pkg.ALL; 

entity controladora_audio is
    Port ( 
        clk_100MHz : in STD_LOGIC;
        reset      : in STD_LOGIC;
        user_hit   : in STD_LOGIC; -- '1' si el usuario está acertando (suena), '0' silencio
        pwm_audio  : out STD_LOGIC;
        pwm_sd     : out STD_LOGIC; -- apagamos sonido (shutdown)
        current_note_index : out integer range 0 to 29
    );
end controladora_audio;

architecture Behavioral of controladora_audio is
    signal counter_pwm : integer := 0; --para generar las ondas de sonido
    signal counter_ms  : integer := 0; --para contar en qué ms va de la canción
    signal note_idx : integer range 0 to 29 := 0; --índice nota
    signal current_freq : integer := 0;
    signal current_dur  : integer := 0;
    signal pwm_toggle : std_logic := '0'; --cambiar pwm para generar vibración (nota)
begin
    -- Ponemos esto a '1' para que el chip de audio de la Nexys se encienda
    pwm_sd <= '1'; 
    
    -- Lectura del paquete
    current_freq <= SEVEN_NATION_SONG(note_idx).freq;
    current_dur  <= SEVEN_NATION_SONG(note_idx).dur;
    current_note_index <= note_idx;

    process(clk_100MHz, reset)
        variable ticks_per_half_cycle : integer;
    begin
        if reset = '1' then
            note_idx <= 0;
            counter_ms <= 0;
            pwm_toggle <= '0';
        elsif rising_edge(clk_100MHz) then
            -- FRECUENCIA
            if current_freq > 0 then
                -- Fórmula: (100MHz / Freq) / 2
                -- (Se divide entre 2 porque es una onda cuadrada con dos partes iguales)
                ticks_per_half_cycle := (100000000 / current_freq) / 2;
                
                if counter_pwm >= ticks_per_half_cycle then --si ya ha pasado el tiempo...
                    pwm_toggle <= not pwm_toggle; --cambio para generar vibración
                    counter_pwm <= 0; --reiniciamos para contar el siguiente medio ciclo
                else
                    counter_pwm <= counter_pwm + 1;
                end if;
            end if;

            -- RITMO -> Avanza la canción aunque no suene
            -- Usamos 100,000 ciclos como aproximación de 1ms a 100MHz
            if counter_ms >= (current_dur * 100000) then 
                counter_ms <= 0;
                if note_idx = 29 then 
                    note_idx <= 2; -- Bucle infinito saltando intro
                else
                    note_idx <= note_idx + 1;
                end if;
            else
                counter_ms <= counter_ms + 1;
            end if;
        end if;
    end process;

    -- SALIDA FÍSICA: Solo sacamos sonido si hay frecuencia Y el usuario acierta
    pwm_audio <= pwm_toggle when (user_hit = '1' and current_freq > 0) else '0';

end Behavioral;