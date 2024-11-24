import numpy as np
import cmath

# Convert 8-digit hex to signed INT32
def hex_to_signed_int32(hex_str):
    val = int(hex_str, 16)
    return val if val < 0x80000000 else val - 0x100000000

# READ INPUT DATA
real_int32 = []
imag_int32 = []

with open("./FILE/INPT.hex", "r") as f:
    for line in f:
        # Extract REAL and IMAG from 16-digit hex (8 digits each)
        real_hex = line[:8]
        imag_hex = line[8:16]

        # Convert to INT32
        real_int32.append(hex_to_signed_int32(real_hex))
        imag_int32.append(hex_to_signed_int32(imag_hex))

# Combine REAL and IMAG into complex numbers
idata_complex = np.array(real_int32, dtype=np.float64) + 1j * np.array(imag_int32, dtype=np.float64)

# FFT
scale = 2 ** 16
fft_res = np.fft.fft(idata_complex)

# READ OTUPUT FROM TESTBENCH
real_part = []
imag_part = []

with open("./FILE/OUPT.hex", "r") as f:
    for line in f:
        real_hex = line[:8]
        imag_hex = line[8:16]

        real_part.append(hex_to_signed_int32(real_hex))
        imag_part.append(hex_to_signed_int32(imag_hex))

rtl_res = np.float64(real_part) + 1j * np.float64(imag_part)
rtl_res

# Calculate SQNR
signal_power = np.sum(np.abs(fft_res)**2) / len(fft_res)
noise_power = np.sum(np.abs(fft_res - rtl_res)**2) / len(fft_res)
sqnr = 10 * np.log10(signal_power / noise_power)

# Print SQNR rounded to two decimal places
print('**************** MODE1 ****************')
print('- PARAMETER SET: N = 256, r = 4, L = 2')
print(f"- SQNR: {sqnr:.2f} dB")
print('***************************************')
