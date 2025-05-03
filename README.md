# OCI-Port-Forwarder for Linux and MacOS

## Pre-Requisites ##
[a] Install OCI CLI on Linux or MacOS. Steps to install  OCI CLI : https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/cliinstall.htm

[b] Create API Key, configure OCI CLI and add your private key
    https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/cliconfigure.htm

## Install ##
### [1] Clone the repo using Git ###
```
git clone https://github.com/shadabshaukat/OCI-Port-Forwarder.git

cd OCI-Port-Forwarder/
```

### [2] Edit the Shell Script to add your Bastion Host and OCI Cli details ###

```
vim multiple_port_forward.sh
```

Change as per your OCI details

```
CONFIG_FILE="vm_services.json"
BASTION_ID="ocid1.bastion.oc1.ap-melbourne-1.axxxxxxxxxxxxxx"
PUBLIC_KEY_FILE="/Users/shadab/Downloads/xxxxx.pub"
PRIVATE_KEY_FILE="/Users/shadab/Downloads/xxxxx.priv"
PROFILE="apxxxxxxx"
STARTING_LOCAL_PORT=2222
```

- *CONFIG_FILE* --> Local file which has the information of your private ip's and port
- *BASTION_ID* --> OCI Bastion OCID
- *PUBLIC_KEY_FILE* --> Your OCI API public key
- *PRIVATE_KEY_FILE* --> Your OCI API private key
- *PROFILE* --> Name of your profile in the ~/.oci/config file
- *STARTING_LOCAL_PORT* --> Starting local port which will be forwarded to remote port. It auto-increments by 1 for every entry in the vm_services.json file

### [3] Supress Label Warnings ####

```
export SUPPRESS_LABEL_WARNING=True
```

### [4] Edit vm_services.json and add your private IP, port and instance details

```
vim vm_services.json
```

Example :
```
[
  {
    "label": "vm1-ssh",
    "resource_id": "ocid1.instance.oc1.ap-melbourne-1.anwwkljrwiclygacwfhiz3uyomzz5vw7vfbznekgpcnhvjpstoxwmdvfnyiq",
    "private_ip": "10.180.2.158",
    "services": [
      {"name": "ssh", "remote_port": 22},
      {"name": "vnc", "remote_port": 5901}
    ]
  },
  {
    "label": "ogg",
    "private_ip": "10.180.2.196",
    "services": [
      {"name": "ogg", "remote_port": 443}
    ]
  }
]
```

### [5] Run the Shell Script to Generate Bastion Host Port forwarding sessions
```
shadab@shadab-mac OCI-Port-Forwarder % ./multiple_port_forward.sh

Agent pid 11620
Identity added: /Users/shadab/Downloads/mydemo_vcn.priv (/Users/shadab/Downloads/mydemo_vcn.priv)

=== 🚀 Launching Port-Forwarding Sessions from vm_services.json ===

➡️  Creating session: [vm1-ssh - ssh] (10.180.2.158:22)...
🟢 Session ID: ocid1.bastionsession.oc1.ap-melbourne-1.amaaaaaawiclygaaj343nm7fqstmbncz5o5kvh65a6xq42ubmngvk6jxtfdq - waiting to be ACTIVE...
✅ ACTIVE: [vm1-ssh - ssh]
➡️  Creating session: [vm1-ssh - vnc] (10.180.2.158:5901)...
🟢 Session ID: ocid1.bastionsession.oc1.ap-melbourne-1.amaaaaaawiclygaaxen7fuvc532zb6flau4c4zyayg4n4quviekwbh4lctja - waiting to be ACTIVE...
✅ ACTIVE: [vm1-ssh - vnc]
➡️  Creating session: [ogg - ogg] (10.180.2.196:443)...
🟢 Session ID: ocid1.bastionsession.oc1.ap-melbourne-1.amaaaaaawiclygaash57krr2g627666bnuadptkc4mcxefluhgw5xxdvt32q - waiting to be ACTIVE...
✅ ACTIVE: [ogg - ogg]

=== 🧪 ALL SSH TUNNEL COMMANDS ===
################################################################
[vm1-ssh][ssh] localhost:2222 ➡ 10.180.2.158:22
ssh -i /Users/shadab/Downloads/mydemo_vcn.priv -N -L 2222:10.180.2.158:22 -p 22 ocid1.bastionsession.oc1.ap-melbourne-1.amaaaaaawiclygaaj343nm7fqstmbncz5o5kvh65a6xq42ubmngvk6jxtfdq@host.bastion.ap-melbourne-1.oci.oraclecloud.com

################################################################

################################################################
[vm1-ssh][vnc] localhost:2223 ➡ 10.180.2.158:5901
ssh -i /Users/shadab/Downloads/mydemo_vcn.priv -N -L 2223:10.180.2.158:5901 -p 22 ocid1.bastionsession.oc1.ap-melbourne-1.amaaaaaawiclygaaxen7fuvc532zb6flau4c4zyayg4n4quviekwbh4lctja@host.bastion.ap-melbourne-1.oci.oraclecloud.com

################################################################

################################################################
[ogg][ogg] localhost:2224 ➡ 10.180.2.196:443
ssh -i /Users/shadab/Downloads/mydemo_vcn.priv -N -L 2224:10.180.2.196:443 -p 22 ocid1.bastionsession.oc1.ap-melbourne-1.amaaaaaawiclygaash57krr2g627666bnuadptkc4mcxefluhgw5xxdvt32q@host.bastion.ap-melbourne-1.oci.oraclecloud.com

################################################################

🎉 All sessions active. Copy & paste your tunnel commands above into new terminal tabs!
```

### [6] Copy the commands and launch the SSH tunnels in seperate terminal windows

Tunnel 1
<img width="1126" alt="Screenshot 2025-04-30 at 16 16 12" src="https://github.com/user-attachments/assets/42078a97-2765-487a-9c8a-0a9c76345f23" />

Tunnel 2
<img width="1126" alt="Screenshot 2025-04-30 at 16 17 11" src="https://github.com/user-attachments/assets/5eba9660-8980-4ddf-98a6-9c7645d745de" />


