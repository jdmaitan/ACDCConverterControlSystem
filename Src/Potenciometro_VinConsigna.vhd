LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY Potenciometro_VinConsigna IS PORT(

	Main_Clock:IN STD_LOGIC;					
    V_ADC:IN STD_LOGIC_VECTOR (15 DOWNTO 0);    				
	Setpoint:OUT INTEGER);
	
END Potenciometro_VinConsigna;

ARCHITECTURE ArqPotenciometro_VinConsigna OF Potenciometro_VinConsigna IS

SIGNAL V_ADC_Binario:STD_LOGIC_VECTOR (11 DOWNTO 0);
SIGNAL V_ADC_Entero:INTEGER RANGE 0 TO 4095:=0;
SIGNAL SetpointBuffer:INTEGER:=0;
SIGNAL SetpointInt:INTEGER:=0;

BEGIN

	AsignacionVinConsigna:PROCESS(Main_Clock)
	BEGIN
	
		IF FALLING_EDGE(Main_Clock) THEN
			V_ADC_Binario(10 DOWNTO 0)<=V_ADC(10 DOWNTO 0);
			V_ADC_Binario(11)<=NOT(V_ADC(11));
			V_ADC_Entero<=Conv_integer(V_ADC_Binario);
			SetpointBuffer<=(199*V_ADC_Entero+183000)/1000;
			IF (SetpointBuffer>999) THEN
				SetpointInt<=999;
			ELSIF (SetpointBuffer<183) THEN
				SetpointInt<=183;
			ELSE
				SetpointInt<=SetpointBuffer;
			END IF;		
			Setpoint<=((9955*SetpointInt)-1822800)/10000;
		 END IF;	
		 
	END PROCESS;	
END ArqPotenciometro_VinConsigna;