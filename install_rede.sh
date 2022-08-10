#!/bin/bash
#

################################################################
################################################################

seduc() {
cfdisk

mkfs.ext4 /dev/sda1

mkdir /hd
mkdir /sshfs

mount /dev/sda1 /hd

#sshfs root@10.15.20.87:/home/dirceu /sshfs
sshfs root@10.15.20.87:/home /sshfs

#tar -xvzf /sshfs/ubuntu_seduc.tar.gz -C /hd/

mkdir /iso
mount /sshfs/xubuntu_seduc.squashfs /iso

echo  "inicio da instalação : $(date)" > /hd/install.log
echo  "inicio da instalação : $(date)"
echo
echo "Copiando arquivos do sistema.........Aguarde..."
cp -ra /iso/* /hd

mount --bind /proc /hd/proc
mount --bind /sys /hd/sys
mount --bind /run /hd/run
mount --bind /tmp /hd/tmp
mount --bind /dev/ /hd/dev
mount --bind /dev/pts /hd/dev/pts

#chroot /hd apt update
#chroot /hd apt install grub-pc -y
chroot /hd update-grub
chroot /hd grub-install /dev/sda

echo "
/dev/sda1 /               ext4    errors=remount-ro 0       1
/swapfile                                 none            swap    sw              0       0
" > /hd/etc/fstab

echo "criando arquivo de SWAP...";echo
dd if=/dev/zero of=/hd/swapfile bs=1M count=4k
mkswap /hd/swapfile
echo
echo  "Fim da instalação : $(date)" >> /hd/install.log
echo  "Fim da instalação : $(date)" 
sleep 3

reboot

}
################################################################
################################################################
################################################################
################################################################

crede() {
cfdisk

mkfs.ext4 /dev/sda1

mkdir /hd
mkdir /sshfs

mount /dev/sda1 /hd

IP=$(dialog --stdout --inputbox "Digite o IP que hospeda a imagem :" 10 30)
IMG="/run/live/rootfs/debian10_CREDE_64Bits_15out2021.squashfs"
#sshfs root@10.15.20.87:/home/dirceu /sshfs
sshfs root@$IP:$IMG /sshfs

#tar -xvzf /sshfs/ubuntu_seduc.tar.gz -C /hd/

#mkdir /iso
#mount /sshfs/xubuntu_seduc.squashfs /iso

echo  "inicio da instalação : $(date)" > /hd/install.log
echo  "inicio da instalação : $(date)"
echo
echo "Copiando arquivos do sistema.........Aguarde..."
cp -ra /sshfs/* /hd

mount --bind /proc /hd/proc
mount --bind /sys /hd/sys
mount --bind /run /hd/run
mount --bind /tmp /hd/tmp
mount --bind /dev/ /hd/dev
mount --bind /dev/pts /hd/dev/pts

#chroot /hd apt update
#chroot /hd apt install grub-pc -y
chroot /hd update-grub
chroot /hd grub-install /dev/sda

echo "
/dev/sda1 /               ext4    errors=remount-ro 0       1
/swapfile                                 none            swap    sw              0       0
" > /hd/etc/fstab

echo "criando arquivo de SWAP...";echo
dd if=/dev/zero of=/hd/swapfile bs=1M count=4k
mkswap /hd/swapfile
echo
echo  "Fim da instalação : $(date)" >> /hd/install.log
echo  "Fim da instalação : $(date)" 
sleep 3

reboot

}
################################################################
################################################################



## MENU PRINCIPAL #############################

sistema=$(dialog --stdout --inputmenu "Instalação via rede : SISTEMAS" 30 40 30  "1" "UBUNTU SEDUC" "2" "DEBIAN CREDE")

if [ $sistema = "1" ] 
	then 
		dialog --yesno "Deseja instalar UBUNTU SEDUC ? ( TODO O DISCO SERÁ APAGADO)" 6 50 && seduc || dialog --infobox "Instalação abortada." 6 40
fi

if [ $sistema = "2" ] 
	then 
		dialog --yesno "Deseja instalar DEBIAN CREDE ? ( TODO O DISCO SERÁ APAGADO)" 6 50 && crede || dialog --infobox "Instalação abortada." 6 40
fi

#################################################
