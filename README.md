# Embedded Real-Time MIDI Synthesizer on Raspberry Pi Zero 2 W

## Overview

This is a demo repository for a **standalone MIDI synthesizer module** based on Raspberry Pi Zero 2 W, using **FluidSynth** to render audio from standard **General MIDI SF2 soundfonts**. The purpose of this project is to demonstrate and evaluate the overall viability of the solution.

The synthesizer receives MIDI input via USB and outputs stereo audio in real time. DIN input is not implemented in this demo; enabling it would require disabling the default serial console.

The system supports up to **64 voices of polyphony**, which is sufficient for full accompaniment in the instruments like my [Digital Flex Accordion](https://www.midiaccordion.com/flex) - including melody, bass, chords, and rhythm, all with active effects.

## Features:

* Runs on **minimal Linux with FluidSynth**
* **User-replaceable** `.sf2` sound banks
* Compact and efficient: Pi Zero 2 W is **small enough** for embedded use
* Read-only root filesystem: **safe to power off without shutdown**
* Average current consumption: **230 mA at 5 V** (governor: **performance**, attached MIDI keyboard is **self-powered**)

---

## Hardware Setup

First, you need to connect the [PCM5102](https://www.amazon.com/Interface-PCM5102A-GY-PCM5102-Converter-Raspberry/dp/B0DCFN2JGF/ref=asc_df_B0DCFN2JGF) DAC to Raspberry Pi Zero 2 W. Use the following wiring:

| Raspberry Pi Zero 2 W Pin | PCM5102 Pin     |
|---------------------------|-----------------|
| GPIO 18 (Pin **12**)      | BCK             |
| GPIO 19 (Pin **35**)      | LRCK            |
| GPIO 21 (Pin **40**)      | DIN             |
| 5V (Pin **4**)            | VIN             |
| GND (Pin **39**)          | GND             |
| (not connected)           | SCK             |

Use as short wires as possible.
Also, make sure the PCM5102 board mentioned above is configured as follows:

| Jumper | Position |
|--------|----------|
| 1      | L        |
| 2      | L        |
| 3      | H        |
| 4      | L        |

Optionally, you can connect a USB-UART adapter to GPIO 14/15 for console access (TXD/RXD). The default user name is `root`, and the password is `root` as well.

---

## Build Instructions

There are two supported build options:

### 1. Recommended: VSCode + Devcontainer
This repository includes a ready-to-use [devcontainer](https://code.visualstudio.com/docs/devcontainers/containers).
To get started:
- Open the repository in **VSCode with Remote Containers / Dev Containers extension**
- Choose: `Reopen in Container`
- Once the container builds, you're ready to run build commands inside the dev shell

### 2. Manual setup on Ubuntu 22
Alternatively, install required packages manually:
```bash
.devcontainer/install_packages.sh
```

---

## Building the Image

The project is implemented as a [Buildroot](https://github.com/buildroot/buildroot) external tree. It uses the mainline Linux 6.12.20.

> Run the following commands in your devcontainer or Ubuntu terminal

To build an image, first clone and initialize the repository:

```bash
git clone https://github.com/serganto/rpi-midi-synth.git
cd rpi-midi-synth
git submodule update --init --recursive
```

Then build the image:

```bash
cd buildroot
BR2_EXTERNAL=../rpi-midi-synth make rpi0_2w_64_usb_synth_defconfig
make
```

> The full build process may take up to 1 hour depending on your system.

When done, the image will be located at:
```
buildroot/output/images/sdcard.img
```

To flash it:
```bash
sudo dd if=buildroot/output/images/sdcard.img of=/dev/sdX bs=1M status=progress
sync
```
Replace `/dev/sdX` with your actual SD card device. Double check the device before proceeding, as you may loose the data if you specify an incorrect device.

---

## Running the Synthesizer

1. Insert the SD card into Raspberry Pi Zero 2 W
2. Power on - boot time is under 10 seconds, plus several seconds for FluidSynth init
3. Connect a **USB MIDI keyboard or other device**
4. Connect PCM5102 line output into speakers
5. The system auto-detects your USB MIDI device in 2 seconds
5. Start playing!

The system uses a **read-only root filesystem**, so it can be safely powered off at any time **without a shutdown sequence**.

---

## Replacing the SoundFont (.sf2)

This project uses the FluidR3 GM SoundFont as the default sound bank.
In accordance with the requirements and spirit of [its MIT license](https://member.keymusician.com/Member/FluidR3_GM/README.html), the synthesizer provides the technical ability to replace the default sound bank with an alternative, so you can replace the default sound bank with your own `.sf2` file.

**⚠️ Disclaimer:**

This synthesizer supports loading custom sound banks (e.g. SoundFont files) for maximum flexibility.
Please note that **the user is solely responsible** for ensuring that any third-party content - such as instruments, samples, or complete sound banks - is properly licensed for their intended use.
The author cannot verify or control what users choose to load, and therefore **assumes no responsibility** for the legal status, origin, or content of any externally loaded material.

**To replace the bank:**

1. After flashing the image via `dd`, mount the SD card's root partition
2. Delete the default soundfont from `/usr/share/soundfonts/FluidR3_GM.sf2`
3. Copy your new `.sf2` file to the same location using the same filename

Please have only one `.sf2` file inside `/usr/share/soundfonts`, otherwise the system will use the first found.

---

## License and Attribution

This project is licensed under the GNU GPLv3, and you are free to use, modify, and distribute it under those terms.

If you find this project useful or include it in your own work, a mention or link back would be greatly appreciated - though not required.

You're also welcome to reach out if you build something interesting with it - I'd love to see it!

---

## Collaboration and Media

This is an **independent project** developed in my personal time. I'm happy to share more **details**, provide **background materials**, or **support coverage** of the project in any form - whether it's for a blog, article, interview, or showcase.

I'm also open to **participating in exhibitions or events** with my [instruments](https://www.midiaccordion.com) and live demos - it's always pleasure to show these devices in action.

If you're working on something similar or want to collaborate on **embedded music tech**, feel free to reach out! This demo is part of a broader effort to explore open, flexible alternatives to closed hardware in digital musical instruments - and I'm always excited to connect with others who share that interest.

**More about my work and contact info: [midiaccordion.com](https://www.midiaccordion.com)**
