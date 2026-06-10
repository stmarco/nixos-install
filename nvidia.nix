# nvidia.nix
{ config, pkgs, ... }:

{
  # 1. Sta niet-vrije software toe (nodig voor de officiële drivers)
  nixpkgs.config.allowUnfree = true;

  # 2. Zorg dat het grafische systeem de NVIDIA driver laadt
  services.xserver.videoDrivers = [ "nvidia" ];

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
