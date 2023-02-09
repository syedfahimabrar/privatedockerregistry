# privatedockerregistry

You can up and run your private docker registry by executing just two commands:

for the remote host:
```bash
git pull https://github.com/syedfahimabrar/privatedockerregistry.git
cd project
sudo chmod +x run-registry.sh
./run-registry.sh
```
from the machine you want access:
- Windows:
  1. Open Windows Explorer, right-click the `registry.crt` file copied from remote server, and choose Install certificate. When prompted, select the following options:
     ```Store location	local machine
      Place all certificates in the following store	selected
     ```
  2. Click Browser and select `Trusted Root Certificate Authorities`.
  3. Click Finish. Restart Docker.
  4. Go to `C:/Users/Your_User/.docker/certs.d/the_remote_machine_ip/` (if folder doesnt exist then make it)
  5. Copy `registry.crt` and `registry.key` file from remote server and paste here
  6. restart your docker
- Linux:
  Copy `registry.crt` and `registry.key` from remote server and paste it to your `/etc/docker/certs.d/remotemachineip:port/` folder
