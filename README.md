# TV Box with Linux (Allwinner H3)

🇧🇷 Leia em Português: [README-pt.md](README-pt.md)

------------------------------------------------------------------------

## About This Project

In this repository, I document the process I used to transform a generic
TV Box (Allwinner H3) into a fully functional Linux environment.

The system can run:

-   Terminal-only (server mode)
-   Desktop environment (GUI)

This project does not modify the internal NAND memory.\
If you remove the SD card, the TV Box returns to its original factory
Android system.

------------------------------------------------------------------------

## Hardware Used

-   CPU: 4× ARM Cortex-A7 @ 1008 MHz\
-   GPU: Mali-400 MP\
-   RAM: 1 GiB\
-   Internal Storage: 8 GB NAND

Chipset: Allwinner H3 (sun8iw7p1)

More technical information:\
https://linux-sunxi.org/H3

------------------------------------------------------------------------

## SD Card Speed Test

``` bash
cd yoursdcard/
dd if=/dev/zero of=teste_escrita bs=1M count=100 conv=fdatasync
```

Minimum recommended: **12MB/s**\
Ideal: **20MB/s real write speed**

------------------------------------------------------------------------

## Compatible ISOs

  | ISO | Kernel | Status |
|-----|--------|--------|
| https://www.retrorangepi.org/images/Sunvell-r69/ | X | Retro build |
| https://www.armbian.com/orange-pi-pc/ | 6.12.68 | Works (reduced performance) |
| Orangepipc_2.0.8_debian_buster_server_linux5.4.65.7z | 5.4.65 | Recommended |
| Orangepipc_2.0.8_debian_buster_desktop_linux5.4.65.7z | 5.4.65 | Recommended |
| OrangePi_pc_debian_stretch_server_linux3.4.113_v1.0.tar.gz | 3.4.113 | Legacy |
| OrangePi_pc_debian_stretch_desktop_linux3.4.113_v1.0.tar.gz | 3.4.113 | Legacy |


### Recommended Version

**Orangepipc_2.0.8_debian_buster (Kernel 5.4.65)**

------------------------------------------------------------------------

## Image Gallery

<table>
  <tr>
    <td><img src="images/image1.webp" alt="Screenshot 1"></td>
    <td><img src="images/image2.webp" alt="Screenshot 2"></td>
  </tr>
  <tr>
    <td><img src="images/image3.webp" alt="Screenshot 3"></td>
    <td><img src="images/image4.webp" alt="Screenshot 4"></td>
  </tr>
  <tr>
    <td><img src="images/image5.webp" alt="Screenshot 5"></td>
    <td><img src="images/image6.webp" alt="Screenshot 6"></td>
  </tr>
</table>

## Project Structure

    Estrutura
    ├── README.md
    ├── README-pt.md
    ├── scripts/
    │   ├── script1.sh
    │   └── script2.sh
    |── images/

------------------------------------------------------------------------
# Alternative for Slow SD Card (Boot on SD + System on USB)

If your memory card is very slow and you still want to use it, the
following alternative exists:

### Separate boot from system

Boot on the SD card and system installed on a USB drive or external HDD.

Mechanical external HDD is **not recommended**, as the board normally
does not provide sufficient amperage to spin the disk. This may cause
voltage drop, affecting processor operation and resulting in immediate
system freeze.

A possible alternative is to power the external HDD directly with 5V
from the board's own power supply (using the same source). However,
there is a risk of damaging the HDD and corrupting data. (I did it and
it went wrong.)

Depending on the scenario, this configuration may result in better
performance.

Install the chosen distro on **both devices**. You may, for example:

-   Use the minimal version on the SD card (U-Boot).
-   Use the Desktop version on the external HDD.

------------------------------------------------------------------------

What we will do is a modification that needs to be performed **on the
computer (not on the TV Box)**. What we are going to do is:

> "Start the process normally, but instead of loading the system that is
> on the SD card, load the system that is on the external HDD."

Below is the step by step to perform this procedure on your computer.

------------------------------------------------------------------------

## 1. Identify the UUIDs (Unique Identifiers)

1.  Connect the **SD Card** and the **USB drive/external HDD** to your
    PC.
2.  In the PC terminal, run:

``` bash
lsblk -f
```

3.  Write down the **UUID** of the external HDD partition (it looks
    similar to `a1b2c3d4-e5f6-...`).

I also recommend writing down the SD card UUID for future reference, in
case it is necessary to revert the configuration.

------------------------------------------------------------------------

## 2. Configure Boot on the SD Card

Now we will instruct the SD card to look for the system on USB.

1.  Open the SD Card partition in your computer's file manager.
2.  Locate the `/boot` folder or check directly in the root of the card.
    Look for the file **`armbianEnv.txt`** (if using another distro,
    look for the corresponding file, such as `xxxEnv.txt`
    (orangepiEnv.txt)).
3.  Open this file with a text editor. If necessary, use:

``` bash
sudo nano /path/to/file
```

4.  Locate the line that starts with:

``` bash
rootdev=UUID=...
```

Replace the existing UUID with the **UUID of the external HDD** noted
earlier.

5.  Check whether the line exists:

``` bash
rootfstype=ext4
```

If it does not exist, add it.

6.  Save the file and close the editor.

------------------------------------------------------------------------

## 3. Adjust the "Map" inside the USB drive/external HDD (FSTAB)

If this adjustment is not made, the system may boot from the external
HDD, but will continue trying to write logs and temporary files to the
SD card.

1.  Open the **external HDD** partition on your PC.
2.  Access the `/etc` folder and open the **`fstab`** file.
3.  Locate the line that mounts `/` (system root). Verify that the UUID
    listed corresponds to the **UUID of the external HDD itself**.
4.  If there is any line pointing to the SD card or mounting `/boot`
    from it, you can add a `#` at the beginning of the line temporarily
    to avoid conflicts.
5.  Save and close the file.

## (it will probably already be correct here and you will not need to do anything, but it is good to check.)

## How to test

1.  Insert the external HDD and the SD card into the TV Box.
2.  Power on the device.

### What should happen

The processor reads the SD card → The SD card reads the `armbianEnv.txt`
file → The file instructs the processor to load the system that is on
the external HDD.

------------------------------------------------------------------------

The scripts were based on the manual process from the video:

https://www.youtube.com/watch?v=HaSdFQSUIho
