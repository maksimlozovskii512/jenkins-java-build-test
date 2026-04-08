# Deploy Java Artifacts To Nexus With Jenkins

A pipeline for running, testing and uploading Spring Boot artifacts to Nexus

## prerequisites
- Docker
- Docker-compose

## How-to-run
1. In root folder run 
```bash
docker compose up -d
```
2. Create a new GitHub repository (this will be used to pull your java code)
3. Remove remote origin and attach your own
```bash
git remote rm origin
```
4. Add your own with
```bash
git remote add origin <your repository>
```
5. Edit the JenkinsFile to use your repository
7. Get Jenkins credentials

Access jenkins container shell
```bash
docker exec -it jenkins bash
```
get credentials
```bash
cat /var/jenkins_home/secrets/initialAdminPassword
```
7. Access Jenkins on localhost:8080 using this password
8. Install suggested plugins
9. Create new user, save and start using Jenkins
10. If you are on linux, generate a new SSH key If you are on windows, get a shell into the Jenkins container and generate an SSH key using the same command. (Make sure the key is not in ~/.ssh as it might break your existing SSH keys)

```bash
ssh-keygen -t ed25519 -C "jenkins-pull" -f </path/to/directory>/id_ed25519
```
11. Once you have a private id_ed25519 and public id_ed25519.pub keys, in Jenkins settings go to credentials -> add credentials -> SSH Username with private key.
```bash
- Scope : global
- ID : jenkins-pull
- Username : jenkins
- Private key : <paste content of id_ed25519 file here>

leave the rest blank
```

12. Access Nexus via localhost:8081 and login with username = admin and password that you can find using this command 
```bash
docker exec -it nexus cat /nexus-data/admin.password
```

13. Create new password and enable anonymous mode
14. Create new user "jenkins-pull"


create new role in nexus
```bash
type: nexus-role
role-id: nexus-deploy
role-name: nexus-deploy

privilages:
- nx-repository-view-maven2-*-add
- nx-repository-view-maven2-*-browse
- nx-repository-view-maven2-*-read
- nx-repository-view-maven2-maven-snapshots-add
- nx-repository-view-maven2-maven-snapshots-edit
- nx-repository-view-maven2-maven-snapshots-read
```
create new user in nexus
ID: nexus-deploy
first-name: nexus
last-name: deploy
email: nexus-deploy@mail.com
status: Active
roles: nexus-deploy