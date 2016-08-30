TITLE="jenkins-slave:slave_win_97”
color 47
REM javaw -jar slave.jar -jnlpUrl http://172.26.186.83:9999/computer/slave_win_97/slave-agent.jnlp -secret 4920340777f46faad15e87fe6671696bc88de7bbdae26f3862c2bb47ff908ec4
TASKKILL /F /IM javaw.exe
:ECHO OFF "shutdown javaw succesful"
PAUSE
