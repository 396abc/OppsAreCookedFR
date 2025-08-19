import itertools
import string
import pickle
import time
import os

# --- CONFIGURATION ---
usb_drive = "E:"  # Change if your USB drive is different
state_file = os.path.join(usb_drive, "sigma_state.pkl")
session_speed = 0.05  # seconds per combo
letters = string.ascii_lowercase
numbers = string.digits

# --- LOAD LAST COMBO INDEX ---
if os.path.exists(state_file):
    with open(state_file, "rb") as f:
        last_index = pickle.load(f)
else:
    last_index = 0

# --- MOCK UAC FUNCTION ---
def mock_uac(user, password):
    os.system("cls")
    print("╭━━━┳╮╱╭┳━━━┳━━━━┳━━━┳━━━╮╭━━━┳━━━╮")
    print("┃╭━╮┃┃╱┃┃╭━╮┃╭╮╭╮┃╭━╮┃╭━╮┃╰╮╭╮┃╭━╮┃")
    print("┃┃╱╰┫╰━╯┃┃╱┃┣╯┃┃╰┫┃╱╰┫╰━╯┣╯┃┃╰╯╱┃┃┃┃┃")
    print("╰━━━┻╯╱╰┻╯╱╰╯╱╰╯╱╰━━━┻╯╱╱╰━━━┻╯╰━╯")
    print(f"User: {user}")
    print(f"Password: {password}")
    print("========================================")
    time.sleep(session_speed)

# --- GENERATOR FUNCTION ---
def combo_generator():
    for l1 in letters:
        for l2 in letters:
            for l3 in letters:
                for n1 in numbers:
                    for n2 in numbers:
                        for l4 in letters:
                            yield f"{l1}{l2}{l3}{n1}{n2}{l4}"

# --- MAIN SIGMA SIMULATION ---
def main():
    user = input("Enter mock target user: ")
    print("\nStarting Sigma Simulation...\n")
    count = 0
    gen = combo_generator()
    
    # skip combos already tried
    for _ in range(last_index):
        next(gen)
        count += 1

    try:
        for password in gen:
            count += 1
            mock_uac(user, password)

            # save progress to USB every 100 combos to reduce writes
            if count % 100 == 0:
                with open(state_file, "wb") as f:
                    pickle.dump(count, f)

    except KeyboardInterrupt:
        # pause sigma grind
        with open(state_file, "wb") as f:
            pickle.dump(count, f)
        print(f"\nSession paused at combo #{count}")
        return

    # save final progress
    with open(state_file, "wb") as f:
        pickle.dump(count, f)
    print("\nSigma simulation complete!")

if __name__ == "__main__":
    main()
