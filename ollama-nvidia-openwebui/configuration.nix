# /etc/nixos/configuration.nix

{ config, pkgs, ... }:

{
  imports = [
    # Zorg dat je hardware-configuration.nix hier geïmporteerd blijft!
    # Deze bevat de specifieke (nieuwe) UUID's van je sda1 en sda2 partities.
    ./hardware-configuration.nix
  ];

  # =========================================================================
  # 1. BOOTLOADER & KERNEL CONFIGURATIE
  # =========================================================================
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Schakel de open-source nouveau drivers hardhandig uit
  boot.blacklistedKernelModules = [ "nouveau" "nvidiafb" ];

  # =========================================================================
  # 2. HARDWARE & NVIDIA DRIVERS (HEADLESS COMPUTE)
  # =========================================================================
  nixpkgs.config.allowUnfree = true;

  # Officiële manier om de NVIDIA-driver te activeren in NixOS
  services.xserver.videoDrivers = [ "nvidia" ];
  
  # Zorg dat er GEEN grafische interface (X/Wayland/Desktop) wordt opgestart
  services.xserver.enable = false;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.nvidia = {
    modesetting.enable = true;
    
    # De open-source kernel-module is ideaal voor de RTX 50-serie (compute)
    open = true; 
    
    # 'latest' is vereist om ondersteuning te bieden voor de gloednieuwe RTX 5060 Ti
    package = config.boot.kernelPackages.nvidiaPackages.latest;
  };

  # =========================================================================
  # 3. AI SERVICES (OLLAMA)
  # =========================================================================
  services.ollama = {
    enable = true;
 # niet meer geldig in 26.5:   acceleration = "cuda"; # Dwing Ollama om de GPU te gebruiken
	package = pkgs.ollama-cuda;
  };

  # =========================================================================
  # 4. SYSTEEM PAKKETTEN (CLI TOOLS)
  # =========================================================================
  environment.systemPackages = (with pkgs; [
    git
    vim
    btop
    pciutils # Bevat 'lspci' voor toekomstige controles
  ]) ++ [
    # Voegt nvidia-smi en andere tools toe aan je PATH buiten de pkgs-scope
    config.boot.kernelPackages.nvidiaPackages.latest
  ];

  # =========================================================================
  # 5. BASIS NETWERK & SYSTEEM INSTELLINGEN
  # =========================================================================
  networking = {
	hostName = "nixos-lmm";
  	networkmanager.enable = true;
	firewall.allowedTCPPorts = [
		8080
	];
};
  time.timeZone = "Europe/Brussels"; # Pas aan naar jouw tijdzone indien nodig
  i18n.defaultLocale = "nl_BE.UTF-8";
  console.keyMap = "be-latin1";
  # SSH toegang (handig voor een headless VM)
  services = {
	openssh.enable = true;
	open-webui = {
		enable = true;
		host = "0.0.0.0";
		port = 8080;
		environment = {
			OLLAMA_BASE_URL = "http://127.0.0.1:11434";
			HOME = "/var/lib/open-webui";
			WEBUI_AUTH = "False"; # comment this if you want open-webui with a login before installing open-webui
		};
	};
	tailscale.enable = true;
};
  # Definieer je gebruikersaccount
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

  # Dit bepaalt de NixOS releaseversie waarmee je de installatie bent begonnen.
  # Laat dit bij voorkeur staan op de waarde die er al stond (bijv. "25.11").
  system.stateVersion = "25.11"; 
}
