import psutil
import subprocess
import time

def is_process_running(process_name):
    ##Checking if the process is running named: process_name##
    for proc in psutil.process_iter(['name']):
        if proc.info['name'] == process_name:
            return True
    return False

def restart_process(process_name, script_path):
    ##Restarting the process from the script path##
    try:
        subprocess.run(['python3', script_path])
        print(f"Restarted {process_name}.")
    except Exception as e:
        print(f"Failed to restart {process_name}: {e}")

if __name__ == "__main__":
    process_name = "dvrecord"    ##The name of script that needs to runs##
    script_path = "/usr/local/bin/dvrecord"    ##The path of script to restart##

    while True:
        if not is_process_running(process_name):
            restart_process(process_name, script_path)

        time.sleep(5)