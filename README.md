## INTRODUCTION
As a SysOps (Systems Operations) engineer, managing user accounts and permissions is a critical task. Ensuring that users are properly created, assigned to the correct groups, and have secure passwords is essential for maintaining the security and efficiency of the system. A script file (`create_users.sh`) will be created to automate the process of user and group creation, making it easier to manage large numbers of users and maintain a secure environment. This is a stage 1 DevOps task given at the [HNG 11 INTERNSHIP PROGRAM](https://hng.tech/internship).

### Prerequisites
- Basic knowledge of the Linux CLI (command line interface).


### Key Features
**1. Automated User and Group Creation:**

- The script reads from a file containing user and group information and automates the creation of users and their respective groups.
- Personal groups are created for each user, ensuring clear ownership and security.
Group Assignment:
- Users can be assigned to multiple groups, facilitating organized and efficient permission management.

**2. Secure Password Generation:**

- Random passwords are generated for each user, enhancing security.
- Passwords are stored securely in a file with restricted access, ensuring that only authorized personnel can view them.

**3. Logging and Documentation:**

Actions performed by the script are logged to a file, providing an audit trail for accountability and troubleshooting.

### Usage:

**1 Input File:** The script takes an input file containing the list and users and groups they are to be added. it is formatted as `user;groups`

```
light; engineering,marketing,drama
idimma; drama,product
mayowa; hng-premium,design
```
**2. Script file:** You need to first make sure your script is executable by using this command `chmod +x create_users.sh`.
- Execute the script with root privileges to ensure it can create users and groups and manage passwords.

```
sudo bash create_users.sh <filename>
```
**3. Output:** 
- Passwords are securely stored in `/var/secure/user_passwords.txt`.
- All actions are logged to `/var/log/user_management.log`.


You can checkout for available roles at HNG [here](https://hng.tech/hire) and register for the next [HNG Internship Cohort](https://hng.tech/internship)
