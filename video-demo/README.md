# scenario

This hypothetical scenario will attempt the following:

- A new application will be deployed. It needs:

* A new pdb
* A separate diskgroup to house the pdb
* Set init parameters to make sure that files end up in the new diskgroup
* A new app-user, which should get its permissions from a role
* A separate tablespace for the app-user
* A service which the application can use



## Pipeline setup

* All code stored in Bibucket (192.168.9.210:7990)
* Jenkins used for deployment (192.68.9.220:8080)
* The repository has hooks to Jenkins, meaning:
  * Whenever a commit is done to 2 specific files (group_vars/dbdemo/diskgroups.yml & pdbs.yml), either one of 2 jobs is triggered in Jenkins (manage-diskgroups or manage-pdbs)
  * If a pdb is successfully created, another job is automatically triggered which further customizes the pdb
