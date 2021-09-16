{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
        ./common.nix
        (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot = {
    kernelModules = [ "kvm-amd" ];

    extraModulePackages = [ ];

    initrd = {
      availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
      kernelModules = [ ];
    };
  };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/c8e2370a-7688-4d20-8df4-6af3dc999d45";
      fsType = "vfat";
    };

  boot.initrd.luks.devices."boot".device = "/dev/disk/by-uuid/655e3df2-480b-4f37-8ff8-4d109e182fb3";

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/bb8ece54-db67-4204-91e9-dfa042f26477";
      fsType = "btrfs";
      options = [ "subvol=root" "defaults" "compress=lzo" "ssd" "noatime" ];
    };

  boot.initrd.luks.devices."system".device = "/dev/disk/by-uuid/ac8130c3-81af-44bf-8293-fd396158b6d1";

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/bb8ece54-db67-4204-91e9-dfa042f26477";
      fsType = "btrfs";
      options = [ "subvol=home" "defaults" "compress=lzo" "ssd" "noatime" ];
    };

  fileSystems."/var" =
    { device = "/dev/disk/by-uuid/bb8ece54-db67-4204-91e9-dfa042f26477";
      fsType = "btrfs";
      options = [ "subvol=var" "defaults" "compress=lzo" "ssd" "noatime" ];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/bb8ece54-db67-4204-91e9-dfa042f26477";
      fsType = "btrfs";
      options = [ "subvol=nix" "defaults" "compress=lzo" "ssd" "noatime" ];
    };

  fileSystems."/.snapshots" =
    { device = "/dev/disk/by-uuid/bb8ece54-db67-4204-91e9-dfa042f26477";
      fsType = "btrfs";
      options = [ "subvol=snapshots" "defaults" "compress=lzo" "ssd" "noatime" ];
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/f4e09cd0-7b63-4be3-bc3d-757ff14e34b8"; }
    ];

  networking = {
    hostName = "andromeda";
  };

}
