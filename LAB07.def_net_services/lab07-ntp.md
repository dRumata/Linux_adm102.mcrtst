## Installing Chrony

The chrony daemon, chronyd, can be controlled by the command line utility chronyc. To install chrony, run the command below;
```
sudo dnf install chrony -y
```
After the installation, the chronyd daemon is running by default. You can check the status by running the command below;
```
systemctl status chronyd
```
You can also enable it to start on system boot by running i
```
systemctl enable chronyd
```

## Configuring Chrony

After the installtion of Chrony suite, you need to configure it in order to provide the NTP services in your environment. The default configuration file for chronyd is `/etc/chrony.conf`.

### Set the time servers

To begin configuration, you need to change the line, pool 2.fedora.pool.ntp.org iburst that specifies the time servers used for time synchronization, to servers that are close to your timezone area.

To obtain a list of these servers, navigate to http://www.pool.ntp.org/en/ and choose your continent area where the servers are physically located. 
1. Edit the /etc/chrony.conf and comment out the line, pool 2.fedora.pool.ntp.org iburst, replacing it as shown below
>vim /etc/chrony.conf

```ini
...
# pool 2.fedora.pool.ntp.org iburst
server 0.africa.pool.ntp.org iburst
server 1.africa.pool.ntp.org iburst
server 2.africa.pool.ntp.org iburst
server 3.africa.pool.ntp.org iburst
...
```
2. Specify a host, subnet, or network from which to allow NTP connections to your NTP server. The default is not to allow connections. As an example, to allow hosts on the network subnet 192.168.43.0/24, your configuration would look like:
```ini
...
# Allow NTP client access from local network.
#allow 192.168.0.0/16
allow 192.168.43.0/24
...
```
3. The Chronyd listens on UDP port 123 and therefore this port needs to be open in the firewall in order to allow the client access:
```
firewall-cmd --add-port=123/udp --permanent
firewall-cmd --reload
```
After that, restart chronyd.
```
systemctl restart chronyd
```
## Checking if chrony is Synchronized

To check if chrony is synchronized, make use of the tracking, sources, and sourcestats commands.

### Checking chrony Tracking

To check chrony tracking, run the following command:
```
chronyc tracking
```
```console
Reference ID    : B23E73D4 (cacti.digital-satellites.com)
Stratum         : 3
Ref time (UTC)  : Sat Nov 17 20:43:46 2018
System time     : 0.000046934 seconds slow of NTP time
Last offset     : -0.008311978 seconds
RMS offset      : 0.072417602 seconds
Frequency       : 9.445 ppm fast
Residual freq   : -21.688 ppm
Skew            : 10.302 ppm
Root delay      : 0.254697442 seconds
Root dispersion : 0.020058062 seconds
Update interval : 1.3 seconds
Leap status     : Normal
```
The `reference ID`  specifies the reference ID and hostname or IP address of the server to which the computer is currently synchronized with.
The `Stratum` indicates the number of hops between your local computer and the reference clock computer.

### Checking chrony Sources

The sources command shows the information about the current time sources that chronyd is accessing.
```
chronyc sources
```
```console
210 Number of sources = 4
MS Name/IP address         Stratum Poll Reach LastRx Last sample               
===============================================================================
^* cacti.digital-satellites>     2   6    77    32    +34ms[  +25ms] +/-  136ms
^+ ntp2.inx.net.za               2   6    77    33    -58ms[  -67ms] +/-  206ms
^? 2a02:8106:1:8800::3           0   6     0     -     +0ns[   +0ns] +/-    0ns
^- cpt-ntp.mweb.co.za            2   6    77    34   -334ms[ -183ms] +/-  477ms
```

The **M** column indicates the mode of the source;

- ^ means a server
- = means a peer
- `#` indicates a locally connected reference clock

The **S** column indicates the state of the sources;

- “*” indicates the source to which chronyd is currently synchronized.
- “+” indicates acceptable sources which are combined with the selected source.
- “-” indicates acceptable sources which are excluded by the combining algorithm.
- “?” indicates sources to which connectivity has been lost or whose packets do not pass all tests. This condition is also shown at start-up, until at least 3 samples have been gathered from it.
- “x” indicates a clock which chronyd thinks is a falseticker (its time is inconsistent with a majority of other sources).
- “~” indicates a source whose time appears to have too much variability

### Checking chrony Source Statistics

The sourcestats command displays information about the drift rate and offset estimation process for each of the sources currently being examined by chronyd
```
chronyc sourcestats
```
```console
210 Number of sources = 4
Name/IP Address            NP  NR  Span  Frequency  Freq Skew  Offset  Std Dev
==============================================================================
cacti.digital-satellites>  12   7   26m    +18.050    176.634    -39ms    78ms
ntp2.inx.net.za             8   5  1194   +157.886    637.815  +9602us    94ms
2a02:8106:1:8800::3         0   0     0     +0.000   2000.000     +0ns  4000ms
cpt-ntp.mweb.co.za         13   8   20m    +21.438    131.489    +86ms    37ms
```

## Setup NTP Client

Setting NTP client on Fedora is the same as setting the NTP server. The difference is that NTP client time is synchronized with the NTP server, in this case the server you set above and it doesn’t have access permissions set hence no server can query time information from it.

To setup NTP client using the chrony suite, install chrony on the client.
```
dnf install chrony
```
Enable chronyd to start on system boot;
```
systemctl enable chronyd
```
### Configure Chrony

Edit the chronyd configuration file and set the time server address as shown below;
```ini
# Use public servers from the pool.ntp.org project.
# Please consider joining the pool (http://www.pool.ntp.org/join.html).
#pool 2.fedora.pool.ntp.org iburst
server 192.168.43.69
```
where `192.168.43.69` is the IP address of our NTP server.

After that, restart chronyd.
```
systemctl restart chronyd
```
### Check time synchronization

To verify that time synchronization is working, you can use the tracking or sources command with chronyc as shown below;
```
chronyc tracking
```
```console 
Reference ID    : C0A82B45 (192.168.43.69)
Stratum         : 4
Ref time (UTC)  : Sun Nov 18 07:04:29 2018
System time     : 0.004202977 seconds fast of NTP time
Last offset     : +0.007200314 seconds
RMS offset      : 0.107927606 seconds
Frequency       : 91.718 ppm fast
Residual freq   : +3.508 ppm
Skew            : 159.694 ppm
Root delay      : 0.299425781 seconds
Root dispersion : 0.080330342 seconds
Update interval : 64.2 seconds
Leap status     : Normal
```
From the reference ID, you can see that our client is connected to our NTP server.

You can also use the sources command;
```
chronyc sources
```
```console
210 Number of sources = 1
MS Name/IP address         Stratum Poll Reach LastRx Last sample               
===============================================================================
^* 192.168.43.69                 3   6   377    31  -3512us[  -13ms] +/-  213ms
```
As you can see, our client is now connected to our NTP server.