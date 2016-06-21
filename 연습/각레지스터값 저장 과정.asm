MOV P0,#83H // Initializing push button switches and initializing LED in OFF state.
READSW: MOV A,P0 // Moving the port value to Accumulator.
RRC A // Checking the vale of Port 0 to know if switch 1 is ON or not
JC NXT // If switch 1 is OFF then jump to NXT to check if switch 2 is ON
CLR P0.7 // Turn ON LED because Switch 1 is ON
SJMP READSW // Read switch status again.
NXT: RRC A // Checking the value of Port 0 to know if switch 2 is ON or not
JC READSW // Jumping to READSW to check status of switch 1 again (provided switch 2 is OFF)
SETB P0.7 // Turning OFF LED because Switch 2 is ON
SJMP READSW // Jumping to READSW to read status of switch 1 again.
END