{ pkgs }:
{ 
users.users.marco = {
   isNormalUser = true;
   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
   packages = with pkgs; [
     tree
   ];
   shell = pkgs.bash;
   home = "/home/marco";
 };
 }