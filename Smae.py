import itertools
import string
import pickle
import time
import os

# --- CONFIGURATION ---
state_file = "sigma_state.pkl"  # local save for VM testing
session_speed = 0.005  # seconds per combo
letters = string.ascii_lowercase
numbers = string.digits
save_every = 1000  # save progress every N combos

# --- LOAD LAST COMBO INDEX ---
if os.path.exists(state_file):
    with open(state_file, "rb") as f:
        last_index = pickle.load(f)
else:
    last_index = 0

# --- DISPLAY LOGO ONCE ---
def display_logo():
    print(r"""
██╗░█████╗░████████╗  ██╗░██████╗  ░█████╗░░█████╗░░█████╗░██╗░░██╗███████╗██████╗░
██║██╔══██╗╚══██╔══╝  ██║██╔════╝  ██╔══██╗██╔══██╗██╔══██╗██║░██╔╝██╔════╝██╔══██╗
██║██║░░╚═╝░░░██║░░░  ██║╚█████╗░  ██║░░╚═╝██║░░██║██║░░██║█████═╝░█████╗░░██║░░██║
██║██║░░██╗░░░██║░░░  ██║░╚═══██╗  ██║░░██╗██║░░██║██║░░██║██╔═██╗░██╔══╝░░██║░░██║
██║╚█████╔╝░░░██║░░░  ██║██████╔╝  ╚█████╔╝╚█████╔╝╚█████╔╝██║░╚██╗███████╗██████╔╝
╚═╝░╚════╝░░░░╚═╝░░░  ╚═╝╚═════╝░  ░╚════╝░░╚════╝░░╚════╝░╚═╝░░╚═╝╚══════╝╚═════╝░

███████╗██████╗░
██╔════╝██╔══██╗
█████╗░░██████╔╝
██╔══╝░░██╔══██╗
██║░░░░░██║░░██║
╚═╝░░░░░╚═╝░░╚═╝
""")

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
    display_logo()
    user = input("Enter mock target user: ")
    print("\nStarting Sigma Simulation on VM...\n")
    count = 0
    gen = combo_generator()

    # skip combos already tried
    for _ in range(last_index):
        next(gen)
        count += 1

    try:
        for password in gen:
            count += 1
            print(f"Trying password: {password}", end="\r")  # only show current attempt

            # save progress locally every N attempts
            if count % save_every == 0:
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
