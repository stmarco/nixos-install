# nvidia.nix
{ config, pkgs, ... }:

{
# 1. Sta onvrije software toe
nixpkgs.config.allowUnfree = true;

# 2. Activeer de NVIDIA driver op de officiële manier
services.xserver.videoDrivers = [ "nvidia" ];

# Zorg dat er GEEN grafische interface start (puur headless server)
services.xserver.enable = false; 
services.desktopManager.plasma6.enable = false; # Of gnome, xfce etc. indien van toepassing

hardware.graphics = {
  enable = true;
  enable32Bit = true;
};
  hardware.nvidia = {
    # Schakel modesetting in (is vaak verplicht voor moderne desktopomgevingen)
    modesetting.enable = true;
    
    # Schakel de NVIDIA instellingen-app in (optioneel)
    nvidiaSettings = true;

    # Kies de stabiele driverversie
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    # Gebruik de opensource kernel-module van NVIDIA (aanbevolen voor GTX 16xx / RTX of nieuwer)
    # Zet dit op 'false' als je een heel oude videokaart hebt.
    open = true; 
  };
}
