{ ... }:

{
  # Disable legacy PulseAudio daemon
  services.pulseaudio.enable = false;

  # Modern PipeWire sound server
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    wireplumber.enable = true;
  };
}
