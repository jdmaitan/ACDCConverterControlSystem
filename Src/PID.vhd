LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY PID IS PORT(

	Main_Clock:IN STD_LOGIC; 
	Tm:IN STD_LOGIC;	
	Setpoint:IN INTEGER;
	Input_ADC:IN STD_LOGIC_VECTOR(15 DOWNTO 0);
	CalculoListo:OUT STD_LOGIC; 
	Output:OUT INTEGER);
	
END PID;

ARCHITECTURE ARQPID OF PID IS

TYPE ESTADO IS (Inicio,EsperaMuestra,CalculoPID,EsperaReinicioTm);
SIGNAL Estado_Actual:ESTADO:=Inicio;
SIGNAL Input_Data:STD_LOGIC_VECTOR(11 DOWNTO 0);
SIGNAL Input:INTEGER RANGE 0 TO 4095:=0;
SIGNAL Kp:INTEGER:=100000; 
SIGNAL Ki:INTEGER:=1; 
SIGNAL Kd:INTEGER:=0; 
SIGNAL Error:INTEGER:=0;
SIGNAL Int_Term:INTEGER:=0;
SIGNAL dIntput:INTEGER:=0;
SIGNAL Input_Anterior:INTEGER RANGE 0 TO 4095:=0;
SIGNAL Output_Escalada:INTEGER:=0;
SIGNAL IntTermMax:INTEGER:=999000000;
SIGNAL IntTermMin:INTEGER:=0;
SIGNAL Output_Max:INTEGER RANGE 0 TO 4095:=999;
SIGNAL Output_Min:INTEGER RANGE 0 TO 4095:=97;
SIGNAL Output_Buffer:INTEGER:=0;
SIGNAL Output_int:INTEGER:=97;


BEGIN
	PID_FSM:PROCESS(Main_Clock)
		BEGIN
		IF FALLING_EDGE(Main_Clock) THEN
			CASE Estado_Actual IS
			
				WHEN Inicio=>	
					Output<=0;
					CalculoListo<='0';
					IF (Tm='1') THEN
						Estado_Actual<=CalculoPID;
					END IF;
				
				WHEN CalculoPID=>  
					Input_Data(10 DOWNTO 0)<=Input_ADC(10 DOWNTO 0); 
					Input_Data(11)<=NOT(Input_ADC(11));
					Input<=Conv_integer(Input_Data);
					
					Error<=Setpoint-Input;          
					Int_Term<=Int_Term+(Ki*Error);  
				
					IF Int_Term>IntTermMax THEN
						Int_Term<=IntTermMax;
					ELSIF Int_Term<IntTermMin THEN
						Int_Term<=IntTermMin;
					END IF;
					dIntput<=Input-Input_Anterior;  
					
					Output_Escalada<=(Kp*Error)+(Int_Term)-(Kd*dIntput); 
					Output_Buffer<=Output_Escalada/1000000;        
					
					IF Output_Buffer>Output_Max THEN              
						Output<=Output_Max;
						Output_int<=Output_Max;
					ELSIF Output_Buffer<Output_Min THEN
						Output<=Output_Min;
						Output_int<=Output_Min;
					ELSE 
						Output<=Output_Buffer;
						Output_int<=Output_Buffer;
					END IF;

					Input_Anterior<=Input; 
					Estado_Actual<=EsperaReinicioTm;
				
				WHEN EsperaReinicioTm=> 
					Output<=Output_int;
					CalculoListo<='1';
					IF (Tm='0') THEN
					Estado_Actual<=EsperaMuestra;
					END IF;
					
				WHEN EsperaMuestra=> 
					Output<=Output_int;
					CalculoListo<='0';
					IF (Tm='1') THEN
						Estado_Actual<=CalculoPID;
					END IF;
					
				WHEN OTHERS=>NULL;
				
			END CASE;
			
		END IF;			
		
	END PROCESS;				

END ARQPID;

