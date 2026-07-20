{ pkgs, ... }:
let
  scroll-debounce = pkgs.writers.writePython3Bin "scroll-debounce" {
    libraries = [ pkgs.python3Packages.evdev ];
  } ''
    import evdev
    from evdev import UInput, ecodes as e
    import time

    DEVICE_PATH = (
        "/dev/input/by-id/"
        "usb-Compx_NK_mouse_NANO_dongle-if02-event-mouse"
    )

    DEBOUNCE_WINDOW = 0.08

    dev = evdev.InputDevice(DEVICE_PATH)
    dev.grab()
    ui = UInput.from_device(dev, name="scroll-debounced-mouse")

    WHEEL_CODES = (e.REL_WHEEL, e.REL_WHEEL_HI_RES)

    last_dir = 0
    last_time = 0.0

    for event in dev.read_loop():
        if event.type == e.EV_REL and event.code in WHEEL_CODES:
            current_time = time.time()
            current_dir = 1 if event.value > 0 else -1

            if last_dir != 0 and current_dir != last_dir:
                if (current_time - last_time) < DEBOUNCE_WINDOW:
                    continue

            last_dir = current_dir
            last_time = current_time

        ui.write_event(event)
        ui.syn()
  '';
in {
  environment.systemPackages = [ scroll-debounce ];

  systemd.services.scroll-debounce = {
    description = "Filter scroll wheel chatter";
    wantedBy = [ "multi-user.target" ];
    after = [ "systemd-udevd.service" ];
    
    unitConfig.ConditionPathExists = "/dev/input/by-id/usb-Compx_NK_mouse_NANO_dongle-if02-event-mouse";
    serviceConfig = {
      ExecStart = "${scroll-debounce}/bin/scroll-debounce";
      Restart = "always";
      RestartSec = 2;
      User = "root";
    };
  };
}
