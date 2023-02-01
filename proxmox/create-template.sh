imageURL=https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img
imageName="ubuntu-22.04-cloudimg-amd64.img"
volumeName="local-lvm"
virtualMachineId="9000"
templateName="ubuntu-22.04-cloudimg-amd64"
tmp_cores="2"
tmp_memory="2048"

rm *.img
wget -O $imageName $imageURL
qm destroy $virtualMachineId
virt-customize -a $imageName --install qemu-guest-agent
virt-customize -a $imageName --run-command 'apt remove -y --purge --autoremove snapd && rm -rf /var/lib/apt/lists/* && cloud-init clean'
qm create $virtualMachineId --name $templateName --memory $tmp_memory --cores $tmp_cores --net0 virtio,bridge=vmbr1,tag=103
qm importdisk $virtualMachineId $imageName $volumeName
qm set $virtualMachineId --scsihw virtio-scsi-pci --scsi0 $volumeName:vm-$virtualMachineId-disk-0
qm set $virtualMachineId --boot c --bootdisk scsi0
qm set $virtualMachineId --ide2 $volumeName:cloudinit
qm set $virtualMachineId --serial0 socket --vga serial0
qm set 9000 --ipconfig0 "ip=dhcp,ip6=dhcp"
qm template $virtualMachineId
