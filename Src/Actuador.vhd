LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

ENTITY Actuador IS PORT(
	Main_Clock:IN STD_LOGIC;
	AjustePID:IN INTEGER;
	CalculoListo:IN STD_LOGIC;
	Angulo_Disparo:OUT INTEGER);
END Actuador;

ARCHITECTURE Arq_Actuador OF Actuador IS

SIGNAL Angulo_Buffer:INTEGER:=416666000;
SIGNAL Angulo_DisparoInt:INTEGER:=416666;					    
TYPE ESTADO IS (Inicio,CalculoAlfa,Espera1,Espera2);
SIGNAL Estado_Actual:ESTADO:=Inicio;

BEGIN

	Actuador_FSM:PROCESS(Main_Clock)
	
	BEGIN
	
		IF FALLING_EDGE(Main_Clock) THEN
		
			CASE Estado_Actual IS
			
				WHEN Inicio=>
					Angulo_Disparo<=416666000;
					IF CalculoListo='1' THEN
						Estado_Actual<=CalculoAlfa;
					END IF;
				
				WHEN CalculoAlfa=>
					IF (AjustePID<10) THEN
						Angulo_Buffer<=416666;
					ELSIF (AjustePID>=10 AND AjustePID<97) THEN
						Angulo_Buffer<=((-45560*AjustePID)+45916300)/100;
					ELSIF (AjustePID>=97 AND AjustePID<999) THEN    
						Angulo_Buffer<=((-25210*AjustePID)+44399600)/100;
					ELSIF (AjustePID>=999) THEN
						Angulo_Buffer<=185185;								
					END IF;
					
					Angulo_DisparoInt<=Angulo_Buffer;
					Angulo_Disparo<=Angulo_Buffer;											
					Estado_Actual<=Espera1;
																
				WHEN Espera1=>
					Angulo_Disparo<=Angulo_DisparoInt;
					IF CalculoListo='0' THEN
						Estado_Actual<=Espera2;
					END IF;
											
				WHEN Espera2=>
					Angulo_Disparo<=Angulo_DisparoInt;
					IF CalculoListo='1' THEN
						Estado_Actual<=CalculoAlfa;						
					END IF;				
				
				WHEN OTHERS=>NULL;			
			END CASE;			
		END IF;		
	END PROCESS;
END Arq_Actuador;