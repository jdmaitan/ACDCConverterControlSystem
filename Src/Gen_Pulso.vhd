LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

ENTITY Gen_Pulso IS PORT(
	Main_Clock:IN STD_LOGIC; 
	Angulo_Disparo:IN INTEGER; 
	ZCD_SCR1:IN STD_LOGIC;	
	ZCD_SCR2:IN STD_LOGIC;	
	ZCD_SCR3:IN STD_LOGIC;	
	ZCD_SCR4:IN STD_LOGIC;	
	ZCD_SCR5:IN STD_LOGIC;	
	ZCD_SCR6:IN STD_LOGIC;	
	Pulso_SCR1:OUT STD_LOGIC;
	Pulso_SCR2:OUT STD_LOGIC; 
	Pulso_SCR3:OUT STD_LOGIC; 
	Pulso_SCR4:OUT STD_LOGIC;
	Pulso_SCR5:OUT STD_LOGIC; 
	Pulso_SCR6:OUT STD_LOGIC); 
END Gen_Pulso;

ARCHITECTURE Arq_Gen_Pulso OF Gen_Pulso IS

SIGNAL Bandera_Encendido:STD_LOGIC:='1'; 
CONSTANT Duracion_Pulso:INTEGER RANGE 0 TO 850000:=416666; 
CONSTANT Periodo_TrenPulso:INTEGER RANGE 0 TO 3000:=2083;
SIGNAL Retardo_SCR1:INTEGER RANGE 0 TO 850000:=0; 
SIGNAL Retardo_SCR2:INTEGER RANGE 0 TO 850000:=0;
SIGNAL Retardo_SCR3:INTEGER RANGE 0 TO 850000:=0;
SIGNAL Retardo_SCR4:INTEGER RANGE 0 TO 850000:=0;
SIGNAL Retardo_SCR5:INTEGER RANGE 0 TO 850000:=0;
SIGNAL Retardo_SCR6:INTEGER RANGE 0 TO 850000:=0;
SIGNAL Contador_TrenPulso1:INTEGER RANGE 0 TO 2090:=2084;
SIGNAL Contador_TrenPulso2:INTEGER RANGE 0 TO 2090:=2084;
SIGNAL Contador_TrenPulso3:INTEGER RANGE 0 TO 2090:=2084;
SIGNAL Contador_TrenPulso4:INTEGER RANGE 0 TO 2090:=2084;
SIGNAL Contador_TrenPulso5:INTEGER RANGE 0 TO 2090:=2084;
SIGNAL Contador_TrenPulso6:INTEGER RANGE 0 TO 2090:=2084;
SIGNAL Duracion_Pulso_SCR1:INTEGER RANGE 0 TO 850000:=0;
SIGNAL Duracion_Pulso_SCR2:INTEGER RANGE 0 TO 850000:=0;
SIGNAL Duracion_Pulso_SCR3:INTEGER RANGE 0 TO 850000:=0;
SIGNAL Duracion_Pulso_SCR4:INTEGER RANGE 0 TO 850000:=0;
SIGNAL Duracion_Pulso_SCR5:INTEGER RANGE 0 TO 850000:=0;
SIGNAL Duracion_Pulso_SCR6:INTEGER RANGE 0 TO 850000:=0;
SIGNAL Pulso_SCR1_Listo:STD_LOGIC:='0';
SIGNAL Pulso_SCR2_Listo:STD_LOGIC:='0';
SIGNAL Pulso_SCR3_Listo:STD_LOGIC:='0';
SIGNAL Pulso_SCR4_Listo:STD_LOGIC:='0';
SIGNAL Pulso_SCR5_Listo:STD_LOGIC:='0';
SIGNAL Pulso_SCR6_Listo:STD_LOGIC:='0';
SIGNAL Pulso_SCR1_Buffer:STD_LOGIC;	
SIGNAL Pulso_SCR2_Buffer:STD_LOGIC;	
SIGNAL Pulso_SCR3_Buffer:STD_LOGIC;	
SIGNAL Pulso_SCR4_Buffer:STD_LOGIC;
SIGNAL Pulso_SCR5_Buffer:STD_LOGIC;	
SIGNAL Pulso_SCR6_Buffer:STD_LOGIC;	

BEGIN
	Gen_Pulso_Process:PROCESS(Main_Clock)
	BEGIN
		IF FALLING_EDGE(Main_Clock) THEN
			IF Bandera_Encendido='1' THEN	
				--Generación del pulso para SCR1 (Vca -)
				IF ZCD_SCR1='1' THEN                                                          
					IF Retardo_SCR1<Angulo_Disparo THEN
						Retardo_SCR1<=Retardo_SCR1+1;
					ELSE
						IF (Duracion_Pulso_SCR1<Duracion_Pulso AND Pulso_SCR1_Listo='0') THEN						
							IF Contador_TrenPulso1>=Periodo_TrenPulso THEN
								Pulso_SCR1_Buffer<=NOT(Pulso_SCR1_Buffer);
								Pulso_SCR1<=Pulso_SCR1_Buffer;
								Contador_TrenPulso1<=0;
							ELSE
								Contador_TrenPulso1<=Contador_TrenPulso1+1;
							END IF;							
							Duracion_Pulso_SCR1<=Duracion_Pulso_SCR1+1;
						ELSE
							Pulso_SCR1<='0';
							Duracion_Pulso_SCR1<=0;
							Pulso_SCR1_Listo<='1';
						END IF;
					END IF;
				ELSE
					Pulso_SCR1<='0';
					Pulso_SCR1_Listo<='0';
					Duracion_Pulso_SCR1<=0;
					Retardo_SCR1<=0;
				END IF;	                                                                           	
				--Generación del pulso para SCR2 (Vbc +)
				IF ZCD_SCR2='1' THEN                                                          
					IF Retardo_SCR2<Angulo_Disparo THEN
						Retardo_SCR2<=Retardo_SCR2+1;
					ELSE
						 IF (Duracion_Pulso_SCR2<Duracion_Pulso AND Pulso_SCR2_Listo='0') THEN
							IF Contador_TrenPulso2>=Periodo_TrenPulso THEN
								Pulso_SCR2_Buffer<=NOT(Pulso_SCR2_Buffer);
								Pulso_SCR2<=Pulso_SCR2_Buffer;
								Contador_TrenPulso2<=0;
							ELSE								
								Contador_TrenPulso2<=Contador_TrenPulso2+1;
							END IF;		
							Duracion_Pulso_SCR2<=Duracion_Pulso_SCR2+1;
						ELSE
							Pulso_SCR2<='0';
							Duracion_Pulso_SCR2<=0;
							Pulso_SCR2_Listo<='1';
						END IF;
					END IF;
				ELSE
					Pulso_SCR2<='0';
					Pulso_SCR2_Listo<='0';
					Duracion_Pulso_SCR2<=0;
					Retardo_SCR2<=0;
				END IF;	
				--Generación del pulso para SCR3 (Vab -)
				IF ZCD_SCR3='1' THEN                                                          
					IF Retardo_SCR3<Angulo_Disparo THEN
						Retardo_SCR3<=Retardo_SCR3+1;
					ELSE
						IF (Duracion_Pulso_SCR3<Duracion_Pulso AND Pulso_SCR3_Listo='0') THEN
							IF Contador_TrenPulso3>=Periodo_TrenPulso THEN
								Pulso_SCR3_Buffer<=NOT(Pulso_SCR3_Buffer);
								Pulso_SCR3<=Pulso_SCR3_Buffer;
								Contador_TrenPulso3<=0;
							ELSE
								Contador_TrenPulso3<=Contador_TrenPulso3+1;
							END IF;		
							Duracion_Pulso_SCR3<=Duracion_Pulso_SCR3+1;
						ELSE
							Pulso_SCR3<='0';
							Duracion_Pulso_SCR3<=0;
							Pulso_SCR3_Listo<='1';
						END IF;
					END IF;
				ELSE
					Pulso_SCR3<='0';
					Pulso_SCR3_Listo<='0';
					Duracion_Pulso_SCR3<=0;
					Retardo_SCR3<=0;
				END IF;	
				--Generación del pulso para SCR4 (Vca +)
				IF ZCD_SCR4='1' THEN                                                          
					IF Retardo_SCR4<Angulo_Disparo THEN
						Retardo_SCR4<=Retardo_SCR4+1;
					ELSE
						IF (Duracion_Pulso_SCR4<Duracion_Pulso AND Pulso_SCR4_Listo='0') THEN
							IF Contador_TrenPulso4>=Periodo_TrenPulso THEN
								Pulso_SCR4_Buffer<=NOT(Pulso_SCR4_Buffer);
								Pulso_SCR4<=Pulso_SCR4_Buffer;
								Contador_TrenPulso4<=0;
							ELSE
								Contador_TrenPulso4<=Contador_TrenPulso4+1;
							END IF;		
							Duracion_Pulso_SCR4<=Duracion_Pulso_SCR4+1;
						ELSE
							Pulso_SCR4<='0';
							Duracion_Pulso_SCR4<=0;
							Pulso_SCR4_Listo<='1';
						END IF;
					END IF;
				ELSE
					Pulso_SCR4<='0';
					Pulso_SCR4_Listo<='0';
					Duracion_Pulso_SCR4<=0;
					Retardo_SCR4<=0;
				END IF;				
				--Generación del pulso para SCR5 (Vbc -)
				IF ZCD_SCR5='1' THEN                                                         
					IF Retardo_SCR5<Angulo_Disparo THEN
						Retardo_SCR5<=Retardo_SCR5+1;
					ELSE
						IF (Duracion_Pulso_SCR5<Duracion_Pulso AND Pulso_SCR5_Listo='0') THEN
							IF Contador_TrenPulso5>=Periodo_TrenPulso THEN
								Pulso_SCR5_Buffer<=NOT(Pulso_SCR5_Buffer);
								Pulso_SCR5<=Pulso_SCR5_Buffer;
								Contador_TrenPulso5<=0;
							ELSE
								Contador_TrenPulso5<=Contador_TrenPulso5+1;
							END IF;		
							Duracion_Pulso_SCR5<=Duracion_Pulso_SCR5+1;
						ELSE
							Pulso_SCR5<='0';
							Duracion_Pulso_SCR5<=0;
							Pulso_SCR5_Listo<='1';
						END IF;
					END IF;
				ELSE
					Pulso_SCR5<='0';
					Pulso_SCR5_Listo<='0';
					Duracion_Pulso_SCR5<=0;
					Retardo_SCR5<=0;
				END IF;		
				--Generación del pulso para SCR6 (Vab +)
				IF ZCD_SCR6='1' THEN                                                         
					IF Retardo_SCR6<Angulo_Disparo THEN
						Retardo_SCR6<=Retardo_SCR6+1;
					ELSE
						IF (Duracion_Pulso_SCR6<Duracion_Pulso AND Pulso_SCR6_Listo='0') THEN
							IF Contador_TrenPulso6>=Periodo_TrenPulso THEN
								Pulso_SCR6_Buffer<=NOT(Pulso_SCR6_Buffer);
								Pulso_SCR6<=Pulso_SCR6_Buffer;
								Contador_TrenPulso6<=0;
							ELSE
								Contador_TrenPulso6<=Contador_TrenPulso6+1;
							END IF;		
							Duracion_Pulso_SCR6<=Duracion_Pulso_SCR6+1;
						ELSE
							Pulso_SCR6<='0';
							Duracion_Pulso_SCR6<=0;
							Pulso_SCR6_Listo<='1';
						END IF;
					END IF;
				ELSE
					Pulso_SCR6<='0';
					Pulso_SCR6_Listo<='0';
					Duracion_Pulso_SCR6<=0;
					Retardo_SCR6<=0;
				END IF;	
			ELSE
				Pulso_SCR1<='0';
				Pulso_SCR2<='0';
				Pulso_SCR3<='0';
				Pulso_SCR4<='0';
				Pulso_SCR5<='0';
				Pulso_SCR6<='0';
				Pulso_SCR1_Listo<='0';
				Pulso_SCR2_Listo<='0';
				Pulso_SCR3_Listo<='0';
				Pulso_SCR4_Listo<='0';
				Pulso_SCR5_Listo<='0';
				Pulso_SCR6_Listo<='0';
				Duracion_Pulso_SCR1<=0;
				Duracion_Pulso_SCR2<=0;
				Duracion_Pulso_SCR3<=0;
				Duracion_Pulso_SCR4<=0;
				Duracion_Pulso_SCR5<=0;
				Duracion_Pulso_SCR6<=0;
				Retardo_SCR1<=0;
				Retardo_SCR2<=0;
				Retardo_SCR3<=0;
				Retardo_SCR4<=0;
				Retardo_SCR5<=0;
				Retardo_SCR6<=0;
			END IF;
		END IF;
	END PROCESS;
END Arq_Gen_Pulso;
