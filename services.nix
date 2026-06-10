{ pkgs, ... }: # <-- Hier vang je pkgs op!
# ai-services
{
  services.ollama = {
    enable = true;
    acceleration = "cuda"; 
    # Mocht je een specifieke ollama-versie willen forceren, 
    # dan kun je hier nu 'package = pkgs.ollama;' gebruiken.
  };

  services.open-webui = {
    enable = true;
    openFirewall = true;
    port = 8080;
  };
}
