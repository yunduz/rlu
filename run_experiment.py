import subprocess

#subprocess.call("ls -l", shell=True)
subprocess.call(
    "./bench-rlu -a -b1 -d1000 -i256 -r512 -w1 -u20 -n4", 
    shell=True)