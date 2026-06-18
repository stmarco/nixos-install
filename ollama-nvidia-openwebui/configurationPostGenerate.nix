# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos-llm2"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Brussels";
  i18n.defaultLocale = "nl_BE.UTF-8";
  console.keyMap = "be-latin1";

  # Define a user account. Don't forget to set a password with ‘passwd’.
    # programs.firefox.enable = true;
  users.users.marco = {
	isNormalUser = true;
	extraGroups = ["wheel"];
	packages = with pkgs; [
		tree
	];
	shell = pkgs.bash;
	home = "/home/marco";
    # Zorg dat je een wachtwoord instelt via `passwd` na de installatie
  };

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    btop
    git
    pciutils
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    
  ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
 # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?

}
