{ pkgs, config, ... }: 
{
  imports = [
    ./hardware-configuration.nix
    ./../../modules/core
  ];

  environment.systemPackages = with pkgs; [
    acpi
    brightnessctl
    cpupower-gui
    powertop
  ];

  # Add Wayland environment variables for VM
  environment.variables = {
    MOZ_ENABLE_WAYLAND = "1";               # Mozilla apps (Firefox, Thunderbird, etc.)
    QT_QPA_PLATFORM = "wayland";            # Qt apps
    GDK_BACKEND = "wayland";                # GTK apps
    CLUTTER_BACKEND = "wayland";            # Clutter-based apps
    SDL_VIDEODRIVER = "wayland";            # SDL apps (games)
    XDG_SESSION_TYPE = "wayland";           # Set session type to Wayland
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";  # Disable Qt window decorations in Wayland
  };
  
  services = {    
    # thermald.enable = true;
    # cpupower-gui.enable = true;
    power-profiles-daemon.enable = true;
 
    upower = {
      enable = true;
      percentageLow = 20;
      percentageCritical = 5;
      percentageAction = 3;
      criticalPowerAction = "PowerOff";
    };

    # auto-cpufreq = {
    #   enable = true;
    #   settings = {
    #     battery = {
    #       governor = "performance";
    #       turbo = "auto";
    #     };
    #     charger = {
    #       governor = "performance";
    #       turbo = "auto";
    #     };
    #   };
    # };
  };

  powerManagement.cpuFreqGovernor = "performance";

  boot = {
    kernelModules = ["acpi_call"];
    extraModulePackages = with config.boot.kernelPackages;
      [
        acpi_call
        cpupower
      ]
      ++ [pkgs.cpupower-gui];
  };
}
