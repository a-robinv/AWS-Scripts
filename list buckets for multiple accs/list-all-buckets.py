import os
import time
import subprocess

with open('roles.txt', 'r') as file: #This is an arbitrary text file inputted. This text files contains all the accounts we would assume as (eg: CLIENT/AdministratorAccess)
    # Loop through each line in the file
    for client in file:
        # Process the current line
        print(client.strip())  # This removes newline characters and prints the line
        # Command: assume -c
        assume_command = f"assume {client.strip()}"
        # Command: aws s3 ls
        account_name=client.split('/')[0] #This parses the Account Name without the /AdministratorAccess
        aws_command = f"aws s3 ls --output text > {account_name}.txt"
        # Run the commands sequentially in the same environment
        process = subprocess.Popen(f"{assume_command} && {aws_command}", shell=True) #used subprocess.Popen to run the two commands on the same environment
        process.wait()
        time.sleep(2)
