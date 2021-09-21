{ config, lib, pkgs, modulesPath, ... }: let
  util = import ./util.nix {};
in with util; {
  imports =
    [
        ./common.nix
        ./pherseus.nix
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

  boot.initrd.luks.devices."system".device = "/dev/disk/by-label/luks_system";

  fileSystems."/boot" =
    { device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };

  fileSystems."/" =
    { device = "/dev/disk/by-label/system";
      fsType = "btrfs";
      options = [ "subvol=root" "defaults" "compress=lzo" "ssd" "noatime" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-label/system";
      fsType = "btrfs";
      options = [ "subvol=home" "defaults" "compress=lzo" "ssd" "noatime" ];
    };

  fileSystems."/var" =
    { device = "/dev/disk/by-label/system";
      fsType = "btrfs";
      options = [ "subvol=var" "defaults" "compress=lzo" "ssd" "noatime" ];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-label/system";
      fsType = "btrfs";
      options = [ "subvol=nix" "defaults" "compress=lzo" "ssd" "noatime" ];
    };

  fileSystems."/.snapshots" =
    { device = "/dev/disk/by-label/system";
      fsType = "btrfs";
      options = [ "subvol=snapshots" "defaults" "compress=lzo" "ssd" "noatime" ];
    };

  networking = {
    hostName = "andromeda";
    interfaces = {
      enp39s0 = {
        useDHCP = true;
      };
      wlo1 = {
        useDHCP = true;
      };
    };
  };

  home-manager.users.pherseus = with pkgs; {

    home = {
      file = {
        ".config/xmobar/xmobarrc".text = my.lib.readConfig "xmobarrc.andromeda";
      };
    };

  };
}
