@ECHO OFF
SETLOCAL
SET MVNW_ROOT_DIR=%~dp0
SET WRAPPER_JAR=%MVNW_ROOT_DIR%\.mvn\wrapper\maven-wrapper.jar
SET WRAPPER_PROPERTIES=%MVNW_ROOT_DIR%\.mvn\wrapper\maven-wrapper.properties

IF NOT DEFINED JAVA_HOME (
  SET JAVA_EXE=java
) ELSE (
  SET JAVA_EXE="%JAVA_HOME%\bin\java.exe"
)

%JAVA_EXE% -Dmaven.multiModuleProjectDirectory=%MVNW_ROOT_DIR% -cp %WRAPPER_JAR% org.apache.maven.wrapper.MavenWrapperMain %*

ENDLOCAL

