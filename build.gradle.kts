plugins {
    java
    war
}
group = "org.orbeon.session"
version = "0.0.1-SNAPSHOT"
java.sourceCompatibility = JavaVersion.VERSION_11

repositories {
        mavenCentral()
}

var tomcatVersion = "10.1.8"
dependencies {
    implementation("org.apache.tomcat:tomcat-catalina:${tomcatVersion}")
    implementation("org.apache.tomcat:tomcat-tribes:${tomcatVersion}")
}