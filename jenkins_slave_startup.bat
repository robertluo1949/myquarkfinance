@echo off  
REM -Dfile.encoding="UTF-8"
REM SET JAVA_OPTS="-server -Xms800m -Xmx800m -XX:PermSize=64M -XX:MaxNewSize=256M -XX:MaxPermSize=128M -Djava.awt.headless=true"
TITLE=jenkins-slave:slave_win_97”
color 47
@echo on
javaw -jar slave.jar -jnlpUrl http://172.26.186.83:9999/computer/slave_win_97/slave-agent.jnlp -secret 4920340777f46faad15e87fe6671696bc88de7bbdae26f3862c2bb47ff908ec4  
@echo  "startup javaw successful"
TASKLIST |FIND "javaw.exe"
PAUSE
