# Suricata Bad IP Reputation Updater

This repository contains a script to update the IP reputation list used by Suricata for network security monitoring. The script downloads an IP list from a specified URL, processes it to filter out valid IP addresses, and updates the Suricata reputation list.

### Description

The `bad_reputation_IPs_list_updater.sh` script performs the following tasks:
1. Downloads an IP list from a specified URL.
2. Filters out valid IP addresses and removes localhost IPs.
3. Updates the Suricata reputation list with the cleaned IP addresses.

### Usage

To use the script, run it with the `-u` option followed by the URL of the IP list:

```bash
sudo bash bad_reputation_IPs_list_updater.sh -u <URL>

