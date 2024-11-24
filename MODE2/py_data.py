import numpy as np

def generate_random_noise(num_samples):
    noise = np.random.randn(num_samples)
    return noise

# PARAMETER SET
N = 2 ** 12
scale = 2 ** 16

# TEST DATA GENERATION
noise = generate_random_noise(2 * N)
noise /= np.max(np.abs(noise))

# FP32 TO INT32
noise *= scale
noise_int32 = np.int32(noise)

# WRITE TO HEX
with open("./FILE/INPT.hex", "w") as f:
    for n in range(0, 2 * N, 2):
        REAL_HEX = format(noise_int32[n+0] & 0xFFFFFFFF, '08x')
        IMAG_HEX = format(noise_int32[n+1] & 0xFFFFFFFF, '08x')
        f.write(f"{REAL_HEX}{IMAG_HEX}\n")

# TWIDDLE FACTOR GENERATION
carr = np.zeros((N, 2), dtype=np.int32)

for n in range(N):
    cos = np.cos(2 * np.pi / N * n)
    sin = np.sin(2 * np.pi / N * n)

    cos_int32 = np.int32(cos * scale)
    sin_int32 = np.int32(sin * scale)

    carr[n][0] = cos_int32
    carr[n][1] = sin_int32

with open("./FILE/TF.hex", "w") as f:
    for n in range(N):
        cos_hex = format(carr[n][0] & 0xFFFFFFFF, '08x')
        sin_hex = format(carr[n][1] & 0xFFFFFFFF, '08x')
        f.write(f"{cos_hex}{sin_hex}\n")
