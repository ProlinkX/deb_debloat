# <span style="color:blue">**Debian 12 Debloat**</span> 

<br>


This script is designed to debloat Debian-based systems, freeing up system resources and improving performance. 

<br>

**It performs the following actions:**

* <span style="color:green">**Disables unnecessary services:**</span> Bluetooth, CUPS, Avahi, and ModemManager.
* <span style="color:green">**Removes unnecessary packages:**</span>  bluetooth, cups, avahi-daemon, and modemmanager.
* <span style="color:green">**Performs cleanup:**</span> Removes orphaned packages and cleans up the package cache.
* <span style="color:green">**Optimizes system settings:**</span> Adjusts the `vm.swappiness` value to reduce swap usage.

<br> 

## Features

* **Progress bar:** Provides a visual indication of the script's progress.
* **Sudo check:** Ensures the script is run with root privileges.
* **Sudo installation:** Installs `sudo` if it's not already present.
* **Memory usage tracking:**  Displays initial and final memory usage, showing the amount of memory freed.

<br>

## Usage

1. **Clone the repository:** `git clone https://github.com/ProlinkX/deb_debloat`
2. **Navigate to the directory:** `cd deb_debloat`
3. **Make the script executable:** `chmod +x deb_debloat.sh`
4. **Run the script with sudo:** `sudo ./deb_debloat.sh`

<br>

## Disclaimer

* <span style="color:red">**Use at your own risk!**</span> This script modifies system settings and removes packages. 
* <span style="color:orange">**Back up your system**</span> before running this script.
* This script is designed for **Debian-based systems** and may not work on other distributions.

<br>

## Contributing

Contributions are welcome! Feel free to open issues or submit pull requests.

<br>

## License

This script is licensed under the MIT License. See the LICENSE file for details.
