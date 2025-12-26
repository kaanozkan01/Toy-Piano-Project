Toy Piano Using 555 Timer IC

This repository contains the complete design, analysis, and simulation files of the Toy Piano project developed as part of Module Project III in the Electrical and Electronics Engineering Department at Sivas Science and Technology University.

The project focuses on generating musical tones using a 555 timer configured in astable mode and driving a small loudspeaker through a push-pull amplifier stage.


Project Overview

The Toy Piano system generates different musical notes when push buttons are pressed. Each button selects a specific resistance value, which changes the oscillation frequency of the 555 timer. The output signal is a square wave operating in the audio frequency range.

Since the 555 timer cannot directly drive a low-impedance speaker, a complementary push-pull amplifier stage is used to provide sufficient current while maintaining signal integrity.


Theoretical Background

- Electronics:
  - 555 timer internal structure and astable operation  
  - Push-pull amplifier design  

- Circuit Theory II:
  - RC-based frequency derivation  
  - Speaker modeled as a series RL load  
  - Transient and steady-state analysis  

- Signals and Systems: 
  - Discrete-time modeling of square wave signals  
  - Harmonic analysis using Fourier series  
  - Speaker treated as a linear time-invariant (LTI) system  


 Simulations and Tools

- Proteus: 
  Used for circuit design, frequency verification, and oscilloscope measurements.

- MATLAB:
  Used to generate discrete-time square wave signals and compare theoretical results with experimental measurements.


 Repository Structure

- `Report/`  
  Final project report in PDF format.

- `Circuit/`  
  Proteus schematic files and circuit diagrams.

- `MATLAB/`  
  MATLAB code used for signal generation and analysis.

- `Images/`  
  Screenshots from oscilloscope and Proteus simulations.

- `References/`  
  Datasheets and reference materials used in the project.

---

 Project Team

- Kaan Özkan – Circuit theory analysis, Proteus simulation, report editing  
- Erkut Doğan – Electronics design and physical circuit setup  
- Furkan Hatipoğulları – Signals and systems analysis, MATLAB modeling  

Academic Advisor: 
Dr. Ass. Sıtkı Akkaya


 Conclusion

This project successfully demonstrates how theoretical concepts from electronics, circuit analysis, and signal processing can be integrated into a practical audio system. The close agreement between theoretical calculations, MATLAB simulations, Proteus results, and experimental measurements validates the correctness of the design.


References

- Wikipedia – 555 Timer IC  
- Sedra & Smith, *Microelectronic Circuits*  
- Oppenheim & Willsky, *Signals and Systems*  
- MATLAB Documentation

