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
    |____browser
    | |____Dockerfile
    |____final
    | |____Dockerfile.tpl
    |____skype
    | |____Dockerfile

Grundsätzlich enthält jeder Order das Dockerfile. ~~und das prepare.sh Script.~~ Der Ordner "final" enthält andere Scripte:

  * Dockerfile.tpl

~~Final erstell das eigentlich Image für den einzelnen User und seinen Container. ~~
Der Ordner "final" heisst jetzt pc und enthält nur noch das Dockerfile.tpl. 
Generiert wird jetz auch nur noch über das rcc Script. 


## System aufsetzen. 

Docker sollte installiert sein. [Docker installieren](https://docs.docker.com/machine/install-machine/)

### Auf geht's

		➜  mkdir ~/git && cd ~/git
		➜  git clone git@github.com:ruedigerp/refugees-communication-center.git

### Base Image erstellen

		➜  cd ~/git/refugees-communication-center
		➜  ./rcc -n base -g

### Service Image erstellen 

Das Image für den Internerbrowser erstellen 

		➜  ./rcc -n browser -g
     
und/oder 

Das Image für Skype erstellen 

		➜  ./rcc -n skype -g
     
usw. Jetzt sind alle Service Images erstellt und die Image für einzelne PCs und Benutzer können erstellt werden. 
Weitere Service erstellen wird weiter unten noch beschrieben. Beispiel ist dabei der Mailclient Icedove in mehreren 
Sprachen. 

### User PCs vorbereiten und starten

#### PC1

		➜  ./rcc -i skype -P test -p 1
		6ede50fe1f84a0434b37ff3c037a7b947e7c887905d6e7140014cc5a803f6589
		5900/tcp -> 0.0.0.0:15901


#### PC2 

		➜  ./rcc -i browser -P 12345 -p 2
		55e8ef94ec12c97032a62cc62556cca01a5eef665001b30a88a141d872897bd2
		5900/tcp -> 0.0.0.0:15902

usw. 

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

    ➜  rcc -p 1 -d
		pc01
		pc01
		Untagged: refugees/pc01:latest
		Deleted: dc896b4bffeb8d2a71dbf7b87ac324c09f614f48639c681b4e9398f5801a8499
		Deleted: 671409ebbd6f1c74f7ebe6042cddd94fb0f2d29f421bb2a88fed8ad99465f16d
		Deleted: ba1c6b9e165a2039b1d9c44399c92a5b78626e08d1732d5ea1d004a00f65de0c


### Liste der PC Container anzeigen

    ➜  rcc -l
		8129f8494b3e        refugees/pc02       "x11vnc -forever -use"   5 seconds ago        Up 4 seconds        0.0.0.0:15902->5900/tcp   pc02
		0589fb38ae46        refugees/pc01       "x11vnc -forever -use"   About a minute ago   Up About a minute   0.0.0.0:15901->5900/tcp   pc01


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

    ➜  cd ~/git/refugees-communication-center/
    ➜  mkdir icedove-arabic

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

    ➜  cp -av ~/git/refugees-communication-center/base/prepare.sh ~/git/refugees-communication-center/icedove-arabic
    ➜  chmod +x ~/git/refugees-communication-center/icedove-arabic/prepare.sh

#### Mailclient in englisch

    ➜  cd ~/git/refugees-communication-center/
    ➜  mkdir icedove-en

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
	
    ➜  cp -av ~/git/refugees-communication-center/base/prepare.sh ~/git/refugees-communication-center/icedove-en
    ➜  chmod +x ~/git/refugees-communication-center/icedove-en/prepare.sh

#### Mailclient in deutsch 

    ➜  cd ~/git/refugees-communication-center/
    ➜  mkdir icedove-de

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

    ➜  cp -av ~/git/refugees-communication-center/base/prepare.sh ~/git/refugees-communication-center/icedove-de
    ➜  chmod +x ~/git/refugees-communication-center/icedove-de/prepare.sh

### Mailclient Images für die drei Sprachen erstellen 

    ➜  rcc -n icedove-arabic -g 
    ➜  rcc -n icedove-de -g 
    ➜  rcc -n icedove-en-gb -g 
    
### 3 User PCs mit je einer anderen Spache erstellen

    ➜  rcc -i icedove-de -P 1234 -p 3
		438b11d511224a76f7dc6ced7cc521c95cb219432d2e939383d027cd8927ff6b
		5900/tcp -> 0.0.0.0:15903
		
    ➜  rcc -i icedove-en -P 4567 -p 4
    5fcd6a533dd17772e1001e61544a07df470aac3b38107200b45c88f65a03db24
    5900/tcp -> 0.0.0.0:15904

    ➜  rcc -i icedove-arabic -P geheim -p 5
    78a25000d79707441bdc57f78dfe548870814efea26e4008bc13949aba2c6956
    5900/tcp -> 0.0.0.0:15905

		➜  rcc -l 
		78a25000d797        refugees/pc05       "x11vnc -forever -use"   About a minute ago   Up About a minute   0.0.0.0:15905->5900/tcp   pc05
		5fcd6a533dd1        refugees/pc04       "x11vnc -forever -use"   About a minute ago   Up About a minute   0.0.0.0:15904->5900/tcp   pc04
		438b11d51122        refugees/pc03       "x11vnc -forever -use"   About a minute ago   Up About a minute   0.0.0.0:15903->5900/tcp   pc03
		8129f8494b3e        refugees/pc02       "x11vnc -forever -use"   12 minutes ago       Up 12 minutes       0.0.0.0:15902->5900/tcp   pc02
		0589fb38ae46        refugees/pc01       "x11vnc -forever -use"   13 minutes ago       Up 13 minutes       0.0.0.0:15901->5900/tcp   pc01 


### Maximal 9 Rechner? 

~~Ja, wer sich die Scripte anguckt, der wird festgestellen es sind aktuell maximal 9 PCs damit möglich.~~
<s>Ja, das mit der Portrange wird noch geändert.</s>

Jetzt sind 99 Container möglich.

