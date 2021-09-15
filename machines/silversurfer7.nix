{ config, lib, pkgs, ... }:

{
  imports = [
    ./common.nix
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
  ];

  boot = {

    kernelParams = [ "acpi_osi=!" ''acpi_osi="Windows 2009"'' ];

    kernelModules = [ "kvm-intel" ];

    blacklistedKernelModules = [ "nouveau" "rivafb" "nvidiafb" "rivatv" "nv" ];

    extraModulePackages = [];

    supportedFilesystems = [ "ntfs" ];

    initrd = {
      availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
      kernelModules = [];
    };

    v4l2loopback.enable = true;

  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/d8e5c9de-6253-49bd-8b7e-20a84d53eb56";
    fsType = "btrfs";
    options = [ "subvol=root" "defaults" "compress=lzo" "ssd" "noatime" ];
  };

  boot.initrd.luks.devices."system".device = "/dev/disk/by-uuid/bfcfe079-80ee-4c84-a33d-711024384a82";

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/d8e5c9de-6253-49bd-8b7e-20a84d53eb56";
    fsType = "btrfs";
    options = [ "subvol=home" "defaults" "compress=lzo" "ssd" "noatime" ];
  };

  fileSystems."/var" = {
    device = "/dev/disk/by-uuid/d8e5c9de-6253-49bd-8b7e-20a84d53eb56";
    fsType = "btrfs";
    options = [ "subvol=var" "defaults" "compress=lzo" "ssd" "noatime" ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/d8e5c9de-6253-49bd-8b7e-20a84d53eb56";
    fsType = "btrfs";
    options = [ "subvol=nix" "defaults" "compress=lzo" "ssd" "noatime" ];
  };

  fileSystems."/.snapshots" = {
    device = "/dev/disk/by-uuid/d8e5c9de-6253-49bd-8b7e-20a84d53eb56";
    fsType = "btrfs";
    options = [ "subvol=snapshots" "defaults" "compress=lzo" "ssd" "noatime" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/2E0A-4BAC";
    fsType = "vfat";
  };

  swapDevices = [ ];

  nix.maxJobs = lib.mkDefault 12;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  home-manager.users.sballert = with pkgs; {
    programs = {
      zsh = {
        shellAliases = {
          s7vpn = "sudo ${openvpn}/bin/openvpn $HOME/s7/client.ovpn";
          s7gc = "s7_git_config";
        };
      };
    };
  };
}
