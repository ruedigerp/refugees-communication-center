# refugees-communication-center
commincation center for refugees on small or diskless computer

## Internetdienste schnell zur Verfügung stellen

Wer aktuell die Medien verfolgt wird von den vielen Projekten gehört haben, 
die Flüchtlingen helfen. Dabei werden sind auch Projekte die den Flüchtlingen 
Internet zur Verfügung stellen möchten. 

Freifunk und andere Projekte dieser Art möchten den Flüchtlingen WLAN freizugänglich machen.
Andere sammeln ältere PCs um diese ins Netz zu bringen. 

Genau für den zweiten Fall habe ich gerade mal eben etwas Docker und bash zusammen geschrieben, um
schnell und einfach auf einem Rechner per Docker z.B. Firefox und Skype zur Verfügung zu stellen. 
Weitere benötigte Sachen können schnell hinzugefügt werden. 

    * Einen etwas dickeren Hobel in die Ecke stellen und installieren
    * Einfach alte PC/Laptops sammeln und per USB booten
    * Alles vorbereiten
    * User Images erstellen 
    * Los geht's 

## Wieso für jeden PC auch ein Docker Image?

Ja, ich hötte auch einfach beim "docker run -d ..." ein "-v /data/user1:/data/user1" machen können. 
Dann liegen aber die Date des Users auf dem Server nachher noch rum. So kann man einfach wenn der 
User den PC wieder verlässt den Container und das Image wegräumen. 
Ausserdem kann man das Image bei Bedarf auch schnell exportieren dem User auf einem Stick mitgeben und
am nächsten Tag wieder schnell einspielen. Für den Fall das er Daten später noch weiter bearbeiten will. 

## Wieso Diskless PCs am besten sind?

Diskless PCs oder Diskless Boot und für jeden User einen eigenen Container aus einem einfachen Grund:

    * Jeder erhält ein frisches System ohne irgendwelche Einstellungen und Schadsoftware 
    die ggf. Daten abgreifen kann.
    * Jeder kann sicher sein das seine Daten: Chatprotokolle, Mailaccounts und -daten, 
    sonstige Daten im Browser usw. 

Die Leute sollen sicher sein. Sie sind geflüchtet. 

## Für die Honks schon mal ein Hinweis!!!

Wenn das hier manche hirnlosen Menschen lesen, wird bestimmt etwas kommen wie: 

    Wieso macht ihr das für die? Wieso macht ihr das nicht für unsere Kinder/Leute?

Spart euch das. Ich und viele andere haben in den letzten Jahren in Linux/BSD-Usergroups und auch 
in vielen anderen Projekten für Kinder/Jugendliche und Erwachsene solche ähnlichen Systeme 
aufgesetzt, betrieben und gepflegt. Um Leuten auch PCs, Linux, Internet, Software, Server usw. usw. 
näher zu bringen. Ihr hattete alle mindestens 15 Jahre Zeit auch solche Systeme benutzen zu können. 
Der Großteil von euch hat sich dafür aber einen Scheiß interessiert. Also einfach mal die Fresse halten. 

## Aufbau

 * Base Image erstellen 
 * Service Images erstellen (Browser, Skype, ...) 
 * PC Image und Container erstellen und starten. 

Die ersten beiden Punkte sind getrennt und müssen jeweils nur einmal erstellt werden. Ausser es ändert sich mal etwas. 

Service Images bauen auf das Base Image auf und sollen das erstellen weiterer Images schneller machen. Da nicht immer 
alles installiert werden muss. Das Base Image erhält alles für den Headless Support. Also den Betrieb ohne kompletten 
X-Server, was das System small hält. 

Die Service Image enthalten immer die einzelnen Softwarepakete. 

    .
    |____base
    | |____Dockerfile
    | |____prepare.sh
    |____browser
    | |____Dockerfile
    | |____prepare.sh
    |____final
    | |____create.sh
    | |____destroy.sh
    | |____Dockerfile
    | |____Dockerfile.tpl
    | |____list.sh
    |____skype
    | |____Dockerfile
    | |____prepare.sh

Grundsätzlich enthält jeder Order das Dockerfile und das prepare.sh Script. Der Ordner "final" enthält andere Scripte:

  * Dockerfile.tpl
  * create.sh
  * destroy.sh
  * list.sh

Final erstell das eigentlich Image für den einzelnen User und seinen Container. 

## System aufsetzen. 

Docker sollte installiert sein. [Docker installieren](https://docs.docker.com/machine/install-machine/)

### Auf geht's

    mkdir ~/git && cd ~/git
    git clone git@github.com:ruedigerp/refugees-communication-center.git

### Base Image erstellen

    cd ~/git/refugees-communication-center/base 
    ./prepare.sh 

### Service Image erstellen 

    cd ~/git/refugees-communication-center/browser
    ./prepare.sh 
     
und/oder 

    cd ~/git/refugees-communication-center/skype 
    ./prepare.sh 
     
usw. Jetzt sind alle Service Images erstellt und die Image für einzelne PCs und Benutzer können erstellt werden. 
Weitere Service erstellen wird weiter unten noch beschrieben. Beispiel ist dabei der Mailclient Icedove in mehreren 
Sprachen. 

### User PCs vorbereiten und starten

#### PC1

    cd ~/git/refugees-communication-center/final
		➜  final  ./create.sh
		Images:
		browser
		skype
		From: skype
		Password: test123456
		PC Number: 1
		Sending build context to Docker daemon 6.144 kB
		Step 0 : FROM refugees/skype
		 ---> 24582492513a
		Step 1 : MAINTAINER Rüdiger Pretzlaff
		 ---> Running in 6d5ee8b92517
		 ---> e041965e24f3
		Removing intermediate container 6d5ee8b92517
		Step 2 : RUN mkdir ~/.vnc
		 ---> Running in 9d5d931ce273
		 ---> 750a6cdadc49
		Removing intermediate container 9d5d931ce273
		Step 3 : RUN x11vnc -storepasswd test123456 ~/.vnc/passwd
		 ---> Running in 5798075a67a7
		stored passwd in file: /root/.vnc/passwd
		 ---> f9c25630904b
		Removing intermediate container 5798075a67a7
		Successfully built f9c25630904b
		264fb1c82f15719db10f1761f12e570ad150881958b40d0ad5572b8fa01348bf
		5900/tcp -> 0.0.0.0:15901

#### PC2 

    cd ~/git/refugees-communication-center/final
		➜  final  ./create.sh
		Images:
		browser
		skype
		From: skype
		Password: strenggeheim
		PC Number: 2
		Sending build context to Docker daemon 6.144 kB
		Step 0 : FROM refugees/skype
		 ---> 24582492513a
		Step 1 : MAINTAINER Rüdiger Pretzlaff
		 ---> Using cache
		 ---> e041965e24f3
		Step 2 : RUN mkdir ~/.vnc
		 ---> Using cache
		 ---> 750a6cdadc49
		Step 3 : RUN x11vnc -storepasswd strenggeheim ~/.vnc/passwd
		 ---> Running in 62179ccf438e
		stored passwd in file: /root/.vnc/passwd
		 ---> 2b646914cbc5
		Removing intermediate container 62179ccf438e
		Successfully built 2b646914cbc5
		34368d4980e661d763f6d65d5cf9ee859275f8b494f4288822cc8221372da4fa
		5900/tcp -> 0.0.0.0:15902

### Verbinden vom Rechner

Wie erwähnt sind die Rechner nicht sehr leistungfähig oder auch Diskless Client. 
Das einzige was sie benötigen ist ein VNC Client. Bei Diskless wird ein System vom 
Server gestartet welches einfach nur einen VNC Client startet und auf den Server verbinden. 
Alternativ kann auch ein Boot von einem USB-Stick gemacht werden. Ein passendes Image für 
einen USB Boot inkl. VNC wird noch verlinkt oder so ein Image zur Verfügung gestellt. 

Wie man bei der Ausgabe beim erstellen sehen kann werden die VNC Ports immer auf die 
Nummer des PCs gemapped. 

    * PC1 5900 auf 15901 
    * PC2 5900 auf 15902 
    * PC3 5900 auf 15903 
    * ...

User an PC1 verbindet auf die Server IP und Port 15901 und das vorher vergebene Passwort. 
Nach dem Login startet xvfb (X Window Virtual Framebuffer (abgekürzt Xvfb) ist ein X-Server, 
der einen virtuellen Framebuffer verwendet und keinen physischen Screen) und anschliessend 
das vorher ausgewöhlte Programm (Browser, Skype, usw.). 

### Wenn fertig, löschen!

Ist ein User fertig und macht den PLatz für den nächsten frei kann der Container und das Image 
wieder gelöscht werden. 

    cd ~/git/refugees-communication-center/final
    ➜  final  ./destroy.sh 1
    pc1
    pc1
    Untagged: refugees/pc1:latest
    Deleted: e0367b1bdb5b1353e8448493760b30ae1e09a984bea361b35babe71f36835283
    Deleted: 2e6902a746e2c390a7fa13cf240ffc6505a9f5319fb519e6fafe54f67939b982
    Deleted: deafd910f3e71aff6f609f989474904f273b1c394cc6201f393e0f73be349703

### Liste der PC Container anzeigen

    cd ~/git/refugees-communication-center/final
    ➜  final  ./list.sh
    ee12f41de0ef        refugees/pc4        "x11vnc -forever -use"   3 seconds ago        Up 3 seconds        0.0.0.0:15904->5900/tcp                         pc4
    aaf92a25195c        refugees/pc3        "x11vnc -forever -use"   12 seconds ago       Up 11 seconds       0.0.0.0:15903->5900/tcp                         pc3
    33baba78f90f        refugees/pc2        "x11vnc -forever -use"   24 seconds ago       Up 24 seconds       0.0.0.0:15902->5900/tcp                         pc2
    c0e4572872f8        refugees/pc1        "x11vnc -forever -use"   About a minute ago   Up About a minute   0.0.0.0:15901->5900/tcp                         pc1


### Eigenen Service erstellen

Das prepare.sh Script kann einfach von einem anderen Services kompiert werden. Es baut das 
Image und legt es unter dem Namen "refugees/ORDNERNAME". 

   * Ordner erstellen z.B. icedove-arabic
   * Dockerfile erstellen 
   * prepare Script kopieren
   * Dockerfile bearbeiten

Im dockerfile sond für simple Softwarepakete nur install Zeile und der Autostart zu bearbeiten:

    ...
    RUN apt-get update && apt-get upgrade -y && apt-get install -y icedove enigmail icedove-l10n-ar
    ...
    RUN bash -c 'echo "icedove" >> /root/.bashrc'

#### Mailclient in arabisch

    cd ~/git/refugees-communication-center/
    mkdir icedove-arabic

Dockerfile erstellen. Inhalt: 

    # icedove over VNC
    #
    # VERSION               0.3
    
    FROM refugees/base
    MAINTAINER Rüdiger Pretzlaff
    
    RUN apt-get update && apt-get upgrade -y && apt-get install -y icedove enigmail icedove-l10n-ar
    # Autostart icedove (might not be the best way, but it does the trick)
    RUN bash -c 'echo "icedove" >> /root/.bashrc'
    RUN bash -c 'echo "nameserver 8.8.8.8" > /etc/resolv.conf'
    EXPOSE 5900
    CMD    ["x11vnc", "-forever", "-usepw", "-create"]

Prepare Script zum Bauen kopieren: 		

    cp -av ~/git/refugees-communication-center/base/prepare.sh ~/git/refugees-communication-center/icedove-arabic
    chmod +x ~/git/refugees-communication-center/icedove-arabic/prepare.sh

#### Mailclient in englisch

    cd ~/git/refugees-communication-center/
    mkdir icedove-en

Dockerfile erstellen. Inhalt: 

    # icedove over VNC
    #
    # VERSION               0.3
    
    FROM refugees/base
    MAINTAINER Rüdiger Pretzlaff
    
    RUN apt-get update && apt-get upgrade -y && apt-get install -y icedove enigmail icedove-l10n-de
    # Autostart icedove (might not be the best way, but it does the trick)
    RUN bash -c 'echo "icedove" >> /root/.bashrc'
    RUN bash -c 'echo "nameserver 8.8.8.8" > /etc/resolv.conf'
    EXPOSE 5900
    CMD    ["x11vnc", "-forever", "-usepw", "-create"]

Prepare Script zum Bauen kopieren: 		
    cp -av ~/git/refugees-communication-center/base/prepare.sh ~/git/refugees-communication-center/icedove-en
    chmod +x ~/git/refugees-communication-center/icedove-en/prepare.sh

#### Mailclient in deutsch 

    cd ~/git/refugees-communication-center/
    mkdir icedove-de

Dockerfile erstellen. Inhalt: 

    # icedove over VNC
    #
    # VERSION               0.3
    
    FROM refugees/base
    MAINTAINER Rüdiger Pretzlaff
    
    RUN apt-get update && apt-get upgrade -y && apt-get install -y icedove enigmail icedove-l10n-de
    # Autostart icedove (might not be the best way, but it does the trick)
    RUN bash -c 'echo "icedove" >> /root/.bashrc'
    RUN bash -c 'echo "nameserver 8.8.8.8" > /etc/resolv.conf'
    EXPOSE 5900
    CMD    ["x11vnc", "-forever", "-usepw", "-create"]
    
Prepare Script zum Bauen kopieren: 		

    cp -av ~/git/refugees-communication-center/base/prepare.sh ~/git/refugees-communication-center/icedove-de
    chmod +x ~/git/refugees-communication-center/icedove-de/prepare.sh

### Mailclient Images für die drei Sprachen erstellen 

    cd ~/git/refugees-communication-center/icedove-arabic
		./prepare.sh
    cd ~/git/refugees-communication-center/icedove-arabic
		./prepare.sh
    cd ~/git/refugees-communication-center/icedove-arabic
		./prepare.sh
    
### 3 User PCs mit je einer anderen Spache erstellen

    ➜  final  ./create.sh
    Images:
    icedove-de
    icedove-arabic
    icedove-en
    browser
    skype
    From: icedove-en
    Password: 123456
    PC Number: 1
    77267a51fa150eda54473bc540630716f4f4b9704d54a1f1d6d7bbe03fd21e87
    5900/tcp -> 0.0.0.0:15901


### Maximal 9 Rechner? 

Ja, wer sich die Scripte anguckt, der wird festgestellen es sind aktuell maximal 9 PCs damit möglich. 
Ja, das mit der Portrange wird noch geändert. 

