import sys
import os
import subprocess
import shutil


def main():
    if len(sys.argv) < 2:
        print("Usage: python3 build.py <build_threads>")
        sys.exit(1)

    num_jobs = sys.argv[1]
    prj_root = os.getcwd()
    lib_dirc = os.path.join(prj_root, "util")
    targ_dll = os.path.join(lib_dirc, "target", "release", "insolence.dll")
    outp_dll = os.path.join(prj_root, "insolence.dll")

    print(f"Building insolence-lib in {lib_dirc}...")
    result = subprocess.run(
        ["cargo", "build", f"-j{num_jobs}", "--release"], cwd=lib_dirc
    )

    if result.returncode != 0:
        print("Failed to build insolence-lib")
        sys.exit(result.returncode)

    if not os.path.isfile(targ_dll):
        print(f"Error: {targ_dll} not found.")
        sys.exit(1)

    print(f"Copying {targ_dll} to {outp_dll}...")
    shutil.copy2(targ_dll, outp_dll)
    print("Done!")


if __name__ == "__main__":
    main()
