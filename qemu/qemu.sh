#! /bin/bash

echo "Starting VM"

sudo qemu-system-x86_64 \
  -name "Windows10-QEMU" \
  -machine type=q35,accel=kvm \
  -global ICH9-LPC.disable_s3=1 \
  -global ICH9-LPC.disable_s4=1 \
  -enable-kvm \
  -cpu host,kvm=off,hv_vapic,hv_relaxed,hv_spinlocks=0x1fff,hv_time,hv_vendor_id=12alphanum \
  -smp 6,sockets=1,cores=3,threads=2 \
  -m 8G \
  -rtc clock=host,base=localtime \
  -device ich9-intel-hda -device hda-output \
  -device qxl,bus=pcie.0,addr=1c.4,id=video.2 \
  -vga none \
  -nographic \
  -serial none \
  -parallel none \
  -k en-us \
  -spice port=5901,addr=127.0.0.1,disable-ticketing \
  -usb \
  -device ioh3420,bus=pcie.0,addr=00.0,multifunction=on,port=1,chassis=1,id=root.1 \
  -device vfio-pci,host=01:00.0,bus=root.1,addr=00.0,x-pci-sub-device-id=4136,x-pci-sub-vendor-id=1983,multifunction=on \
  -drive if=pflash,format=raw,readonly=on,file=/home/marcosscriven/Downloads/build/OVMF_CODE.fd \
  -drive if=pflash,format=raw,file=/home/marcosscriven/Downloads/build/OVMF_VARS.fd \
  -device ide-cd,bus=ide.0,drive=drive-sata0-0-0,id=sata0-0-0,bootindex=1 \
  -drive file=/var/lib/libvirt/images/win10-2-2.qcow2,format=qcow2,if=none,id=drive-sata0-0-2 \
  -boot menu=on \
  -boot order=c \
  -device pci-bridge,addr=12.0,chassis_nr=2,id=head.2 \
  -device usb-tablet
  