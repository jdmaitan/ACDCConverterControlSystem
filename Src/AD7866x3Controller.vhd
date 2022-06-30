LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

ENTITY AD7866x3Controller IS PORT(
    DoutA_ADC1:IN STD_LOGIC;
    DoutB_ADC1:IN STD_LOGIC; 
    DoutA_ADC2:IN STD_LOGIC;
    DoutB_ADC2:IN STD_LOGIC; 
    DoutA_ADC3:IN STD_LOGIC; 
    DoutB_ADC3:IN STD_LOGIC; 
	PllClk:IN STD_LOGIC; 
	SClk:IN STD_LOGIC;                       
	CS:OUT STD_LOGIC; 
	A0_ADC1:OUT STD_LOGIC; 
	A0_ADC2:OUT STD_LOGIC;
	A0_ADC3:OUT STD_LOGIC; 
	Tm:OUT STD_LOGIC;	
    Data_Adq_ADC1A:OUT STD_LOGIC_VECTOR (15 DOWNTO 0); 
    Data_Adq_ADC1B:OUT STD_LOGIC_VECTOR (15 DOWNTO 0); 
	Data_Adq_ADC2A:OUT STD_LOGIC_VECTOR (15 DOWNTO 0); 
    Data_Adq_ADC2B:OUT STD_LOGIC_VECTOR (15 DOWNTO 0); 
	Data_Adq_ADC3A:OUT STD_LOGIC_VECTOR (15 DOWNTO 0); 
    Data_Adq_ADC3B:OUT STD_LOGIC_VECTOR (15 DOWNTO 0)); 
END AD7866x3Controller;

ARCHITECTURE Arq_AD7866x3Controller OF AD7866x3Controller IS 

TYPE ESTADO IS (Inactivo,Inicio,Espera_Flanco,Ciclo_Siguiente,Espera1,Adquirir_Dato,Espera2,TQuiet1,TQuiet2);
SIGNAL Estado_Actual:ESTADO:=Inactivo;
SIGNAL IntData_Adq_ADC1A:STD_LOGIC_VECTOR (15 DOWNTO 0):="0000000000000000";
SIGNAL IntData_Adq_ADC1B:STD_LOGIC_VECTOR (15 DOWNTO 0):="0000000000000000";
SIGNAL IntData_Adq_ADC2A:STD_LOGIC_VECTOR (15 DOWNTO 0):="0000000000000000"; 
SIGNAL IntData_Adq_ADC2B:STD_LOGIC_VECTOR (15 DOWNTO 0):="0000000000000000";
SIGNAL IntData_Adq_ADC3A:STD_LOGIC_VECTOR (15 DOWNTO 0):="0000000000000000"; 
SIGNAL IntData_Adq_ADC3B:STD_LOGIC_VECTOR (15 DOWNTO 0):="0000000000000000";
SIGNAL Cuenta_Ciclo:INTEGER RANGE 0 TO 16:=0; 
SIGNAL Cuenta_Bit_Out:INTEGER RANGE -1 TO 14:=14; 
SIGNAL Enable:STD_LOGIC:='1';
SIGNAL Channel_Select:STD_LOGIC:='0';	

BEGIN
	FSM:PROCESS(PllClk)
		BEGIN
		IF FALLING_EDGE(PllClk) THEN
			CASE Estado_Actual IS                  
				WHEN Inactivo=>
					CS<='1';
					Tm<='0';
					IF Enable='1' THEN
						Estado_Actual<=Inicio;
					END IF;						
				WHEN Inicio=>			
					IF Channel_Select='0' THEN	
						A0_ADC1<='0';         
						A0_ADC2<='0';        
						A0_ADC3<='0';
					ELSE
						A0_ADC1<='1';
						A0_ADC2<='1';
						A0_ADC3<='1';
					END IF; 
					Tm<='0';
					CS<='0';
					Cuenta_Ciclo<=0;
					Cuenta_Bit_Out<=14;
					IF (Enable='1' AND SClk='1') THEN
						Estado_Actual<=Espera_Flanco;
					ELSIF Enable='0' THEN
						Estado_Actual<=Inactivo;					
					END IF;						
				WHEN Espera_Flanco=>
					CS<='0';
					Tm<='0';
					IF (SClk='0')THEN
						Estado_Actual<=Ciclo_Siguiente;				
					END IF;										
				WHEN Ciclo_Siguiente=>
					CS<='0';
					Tm<='0';
                    Cuenta_Ciclo<=Cuenta_Ciclo+1;
					Estado_Actual<=Espera1;						
				WHEN Espera1=>
					CS<='0';
					Tm<='0';
					IF (SClk='1' AND Cuenta_Ciclo<16) THEN
						Estado_Actual<=Adquirir_Dato;
					ELSIF (SClk='1' AND Cuenta_Ciclo=16) THEN
						Estado_Actual<=TQuiet1;					
					END IF;					
				WHEN Adquirir_Dato=>				
					CS<='0';
					Tm<='0';
					IntData_Adq_ADC1A(Cuenta_Bit_Out)<=DoutA_ADC1;
					IntData_Adq_ADC1B(Cuenta_Bit_Out)<=DoutB_ADC1;
					IntData_Adq_ADC2A(Cuenta_Bit_Out)<=DoutA_ADC2;
					IntData_Adq_ADC2B(Cuenta_Bit_Out)<=DoutB_ADC2;
					IntData_Adq_ADC3A(Cuenta_Bit_Out)<=DoutA_ADC3;
					IntData_Adq_ADC3B(Cuenta_Bit_Out)<=DoutB_ADC3;
					Cuenta_Bit_Out<=Cuenta_Bit_Out-1;
					Estado_Actual<=Espera2;					
				WHEN Espera2=>				
					CS<='0';
					Tm<='0';
					IF (SClk='0') THEN
						Estado_Actual<=Ciclo_Siguiente;
					END IF;																		
				WHEN TQuiet1=>
					CS<='1';
					Tm<='1';
					Data_Adq_ADC1A<=IntData_Adq_ADC1A;
					Data_Adq_ADC1B<=IntData_Adq_ADC1B;
					Data_Adq_ADC2A<=IntData_Adq_ADC2A;
					Data_Adq_ADC2B<=IntData_Adq_ADC2B;
					Data_Adq_ADC3A<=IntData_Adq_ADC3A;
					Data_Adq_ADC3B<=IntData_Adq_ADC3B;							
					IF (Enable='1' AND SClk='0') THEN    
						Estado_Actual<=TQuiet2;                
					END IF;   
				WHEN TQuiet2=>
					CS<='1';
					Tm<='1';					
					IF (Enable='1' AND SClk='1') THEN    
						Estado_Actual<=Inicio;                
					END IF;  				
				WHEN OTHERS=>NULL;								
			END CASE;					
		END IF;
	END PROCESS;
END Arq_AD7866x3Controller;