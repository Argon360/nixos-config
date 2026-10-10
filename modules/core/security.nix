{ ... }:

{
  # Realtime scheduling priority for audio/PipeWire
  security.rtkit.enable = true;

  # Polkit daemon for privilege escalation in GUI
  security.polkit.enable = true;

  # Sudo settings
  security.sudo = {
    enable = true;
    wheelNeedsPassword = true;
  };
}
