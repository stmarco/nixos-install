{ config,pkgs, ... }:
{
 environment.systemPackages = (with pkgs; [
   btop
   git
   neofetch
   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
   wget
 ]) ++ [
  config.boot.kernelPackages.nvidiaPackages.stable
 ];
 environment.variables = {
    EDITOR = "vim";
    VISUAL = "vim";
 };
}