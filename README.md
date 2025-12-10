# FPGA-HERO

music_pkg.vhd: Contiene la partitura de la canción y el código de colores a usar
(YORGOS, MÍRALO PARA LA PARTE GRÁFICA :) )

controladora_audio.vhd: es el motor del sonido

top_sonido.vhd: ni caso, lo he usado solo para generar el testbench NO INTEGRAR EN EL TOP DEL PROYECTO

EN EL ARCHIVO TOP DEL PROYECTO TENDREMOS QUE TENER ALGO ASÍ PARA USAR controladora_audio:

-- 1. Añadir esto antes del begin (Declaración del componente)
component controladora_audio is
    Port ( 
        clk_100MHz : in STD_LOGIC;
        reset      : in STD_LOGIC;
        user_hit   : in STD_LOGIC; 
        pwm_audio  : out STD_LOGIC;
        pwm_sd     : out STD_LOGIC;
        current_note_index : out integer range 0 to 499
    );
end component;

-- 2. Señal interna para conectar Audio con Video
signal cable_indice_nota : integer range 0 to 499;

begin

-- 3. Instancia (Mapeo)
U_AUDIO: controladora_audio
port map (
    clk_100MHz => CLK100MHZ,
    reset      => reset_interno,
    
    -- CONEXIÓN CLAVE:
    -- Si la lógica dice que el usuario acertó, poner a '1'.
    -- Si falló o no toca nada, poner a '0'.
    user_hit   => senal_acierto_logica, 
    
    -- Salidas físicas
    pwm_audio  => AUD_PWM, -- Al pin A11
    pwm_sd     => AUD_SD,  -- Al pin D12
    
    -- Chivato para el video
    current_note_index => cable_indice_nota
);


@YORGOS

en el modulo de vídeo tienes que añadir use work.music_pkg.ALL; al principio. Así puedes leer directamente:

 - SEVEN_NATION_SONG(cable_indice_nota).code -> Te dice el color (0, 1, 2...).

- SEVEN_NATION_SONG(cable_indice_nota).freq -> Te dice la nota (por si quieres pintar pentagrama).



Sobre los constraints (.xdc): He actualizado el archivo de pines. Aseguraos de descomentar las líneas AUD_PWM y AUD_SD en vuestro proyecto o no sonará.


