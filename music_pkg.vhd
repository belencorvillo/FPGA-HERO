
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package music_pkg is
    -- Creamos un tipo de dato "note_t"
    -- Estructura de una nota: Sonido, Duración y Color visual
    type note_t is record
        freq : integer; -- Hz
        dur  : integer; -- ms
        code : integer; -- 0=Verde, 1=Rojo, etc.
    end record;

    -- Array de la canción (Intro + Riff repetido)
    type song_t is array (0 to 29) of note_t; 

    -- Frecuencias (Afinación grave)
    constant NOTE_E3 : integer := 165;
    constant NOTE_G3 : integer := 196;
    constant NOTE_D3 : integer := 147;
    constant NOTE_C3 : integer := 131;
    constant NOTE_B2 : integer := 123;
    constant SILENCE : integer := 0; 
    
    -- Códigos de color 
    constant C_GRN : integer := 0; --verde
    constant C_RED : integer := 1; --rojo
    constant C_YEL : integer := 2; --amarillo
    constant C_BLU : integer := 3; --azul
    constant C_ORG : integer := 4; --naranja
    constant C_NUL : integer := 5; --silencio (ninguna nota cae), el usuario no debe pulsar

    -- CANCIÓN: Seven Nation Army
    constant SEVEN_NATION_SONG : song_t := (
        -- Intro (Silencio de espera)
        (SILENCE, 1, C_NUL), (SILENCE, 1, C_NUL), 
        
        -- Vuelta 1
        (NOTE_E3, 700, C_GRN), (NOTE_E3, 250, C_GRN), (NOTE_G3, 250, C_YEL),
        (NOTE_E3, 250, C_GRN), (NOTE_D3, 250, C_RED), (NOTE_C3, 1000, C_BLU),
        (NOTE_B2, 1000, C_ORG), (SILENCE, 100, C_NUL),
        
        -- Vuelta 2
        (NOTE_E3, 700, C_GRN), (NOTE_E3, 250, C_GRN), (NOTE_G3, 250, C_YEL),
        (NOTE_E3, 250, C_GRN), (NOTE_D3, 250, C_RED), (NOTE_C3, 1000, C_BLU),
        (NOTE_B2, 1000, C_ORG), (SILENCE, 100, C_NUL),
        
        -- Vuelta 3 (Variación final)
        (NOTE_E3, 700, C_GRN), (NOTE_E3, 250, C_GRN), (NOTE_G3, 250, C_YEL),
        (NOTE_E3, 250, C_GRN), (NOTE_D3, 250, C_RED), (NOTE_C3, 250, C_BLU), 
        (NOTE_D3, 250, C_RED), (NOTE_C3, 250, C_BLU), (NOTE_B2, 1000, C_ORG),
        
        -- Relleno final
        (SILENCE, 1000, C_NUL), (SILENCE, 1000, C_NUL), (SILENCE, 1000, C_NUL) 
    );

end music_pkg;
