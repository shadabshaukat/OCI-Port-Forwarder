# OCI-Port-Forwarder for Linux and MacOS

### [1] Clone the repo using Git ###
```
git clone https://github.com/shadabshaukat/OCI-Port-Forwarder.git
cd OCI-Port-Forwarder/
```

### [2] Supress Label Warnings ####
```
export SUPPRESS_LABEL_WARNING=True
```

### [3] Edit vm_services.json and add your private IP, port and instance details

```
vim vm_services.json
```

### [4] Run the Shell Script to Generate Bastion Host Port forwarding sessions
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

### [5] Copy the commands and launch the SSH tunnels in seperate terminal windows

Tunnel 1
<img width="1126" alt="Screenshot 2025-04-30 at 16 16 12" src="https://github.com/user-attachments/assets/42078a97-2765-487a-9c8a-0a9c76345f23" />

Tunnel 2
<img width="1126" alt="Screenshot 2025-04-30 at 16 17 11" src="https://github.com/user-attachments/assets/5eba9660-8980-4ddf-98a6-9c7645d745de" />


