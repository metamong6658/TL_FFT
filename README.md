# Three-level FFT (TL-FFT)

This repository provides example RTL code to illustrate the complex addressing and permutation scheme of TL-FFT. The default parameters are set as $r = 4$, $L = 2$, and $N = 2^8$, which correspond to Figure 4 in our paper. In this example, the SRAM and ROM are modeled to perform operations with a latency of 1 cycle.  

---

# Environment

The code has been developed and tested in the following environment:  

- **OS**: CentOS 7  
- **Python**: Python 3.6.8  
- **RTL Compiler**: Synopsys VCS S-2021.09  
- **Waveform Viewer**: Synopsys Verdi S-2021.09  

---

# How to Use

To clone and run the project, execute the following commands in your Linux terminal:

```bash
$ git clone https://github.com/metamong6658/TL_FFT.git
$ make
```

When you run `make` in your Linux terminal, the default mode (`mode1`) is executed. The workflow consists of the following steps:

1. **Generate test vectors and twiddle factors**  
   The `py_data.py` script generates the test vectors and twiddle factors required for the simulation.

2. **Compile and run the RTL code**  
   The Synopsys VCS compiler compiles and executes the RTL code.

3. **View waveforms**  
   Synopsys Verdi opens the waveform viewer, allowing you to inspect how control signals and appropriate addresses for each SRAM are generated.

<p align="center">
  <img src="https://github.com/user-attachments/assets/d3680425-9319-4b99-8fb3-5ad848542e41" alt="Waveform of DUT" />
  <br>
  <b>Figure 1:</b> Waveform of DUT in testbench
</p>

4. **Check SQNR**  
   The `py_sqnr.py` script computes the Signal-to-Quantization Noise Ratio (SQNR) and compares the results between the Python implementation and the RTL implementation.

---

# If you don't have VCS/Verdi

If you don't have a license for VCS and Verdi, you can use open-source tools such as Verilator, Icarus, GTKWave, and ModelSim.

Here are the links to these tools:

- [Verilator](https://github.com/verilator/verilator.git)  
- [Icarus Verilog](https://bleyer.org/icarus/)  
- [GTKWave](https://github.com/gtkwave/gtkwave.git)  
- [ModelSim (Intel Quartus II Web Edition)](https://www.intel.com/content/www/us/en/software-kit/666221/intel-quartus-ii-web-edition-design-software-version-13-1-for-windows.html)


