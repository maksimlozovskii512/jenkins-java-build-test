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
5. Get Jenkins credentials

Access jenkins container shell
```bash
docker exec -it jenkins bash
```
get credentials
```bash
cat /var/jenkins_home/secrets/initialAdminPassword
```
6. Access Jenkins on localhost:8080 using this password
7. Install suggested plugins
8. Create new user, save and start using Jenkins
9. If you are on linux, generate a new SSH key If you are on windows, get a shell into the Jenkins container and generate an SSH key using the same command. (Make sure the key is not in ~/.ssh as it might break your existing SSH keys)

```bash
ssh-keygen -t ed25519 -C "jenkins-pull" -f </path/to/directory>/id_ed25519
```
10. Once you have a private id_ed25519 and public id_ed25519.pub keys, in Jenkins settings go to credentials -> add credentials -> SSH Username with private key.
```bash
- Scope : global
- ID : jenkins-pull
- Username : jenkins
- Private key : <paste content of id_ed25519 file here>

leave the rest blank
```

11. Access Nexus via localhost:8081 and login with username = admin and password that you can find using this command 
```bash
docker exec -it nexus cat /nexus-data/admin.password
```

12. Create new password and disable anonymous mode

13. create new role in nexus
Settings -> Roles -> Create Role

```bash
type: nexus-role
role-id: nexus-deploy
role-name: nexus-deploy

privilages:
- nx-repository-view-maven2-maven-snapshots-add
- nx-repository-view-maven2-maven-snapshots-edit
- nx-repository-view-maven2-maven-snapshots-read
- nx-repository-view-maven2-maven-releases-add
- nx-repository-view-maven2-maven-releases-edit
- nx-repository-view-maven2-maven-releases-read
```
create new user in nexus
```bash
ID: nexus-deploy
first-name: nexus
last-name: deploy
email: nexus-deploy@mail.com
status: Active
roles: nexus-deploy
```
14. Configure pipeline tools
Jenkins settings -> tools; 
under JDK -> name: JDK17; 
under Maven -> name: Maven3 and use version 3.9

15. Configure settings.xml in Jenkins
Jenkins settings -> Managed files;
Add new config -> Maven settings.xml;
In ID box -> maven-settings-nexus;
In name box -> maven-settings-nexus;
In content ->
```bash
<settings>
  <servers>
    <server>
      <id>nexus-snapshots</id>
      <username>${env.NEXUS_USER}</username>
      <password>${env.NEXUS_PASS}</password>
    </server>
  </servers>
</settings>
```
Submit

16. Ensure your pom.xmk contains
```bash
<distributionManagement>
  <snapshotRepository>
    <id>nexus-snapshots</id>
    <url>http://nexus:8081/repository/maven-snapshots/</url>
  </snapshotRepository>

  <repository>
    <id>nexus-releases</id>
    <url>http://nexus:8081/repository/maven-releases/</url>
  </repository>
</distributionManagement>
```

17. Configure Jenkins pipeline
New item -> name: pull-build-deploy -> pipeline -> Pipeline script from SCM -> SCM=Git -> paste your repostiory SSH url and use jenkins-pull credentials

18. Run Pipeline
19. On build SUCCESS, check Nexus: Browse -> maven snapshots -> should see your snapshot stored