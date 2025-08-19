# Weather MOTD Project

This project sets up a Linux VM with a **dynamic MOTD (Message of the Day)** showing:

* Weather for a configurable city
* Hostname
* Current date and time
* Uptime
* Disk usage
* CPU and memory usage

The MOTD updates automatically at boot via a **systemd service** and logs weather fetches to `/var/log/weather.log`.

---

## 1. Accessing the VM on Amazon EC2

1. **Get your VM details** from AWS:

   * PEM key file for SSH (e.g., `my-key.pem`)

2. **Set permissions on your PEM key**:

```bash
chmod 400 my-key.pem
```

3. **SSH into your VM**:

```bash
ssh -i my-key.pem ec2-user@<public-ip-or-dns>
```

Replace `<public-ip-or-dns>` with your EC2 public address.

---

## 2. Weather Configuration

* Environment variables are loaded from `/etc/default/weather`:

```text
CITY="Timisoara"
```

* If `CITY` is not set, the script defaults to **Timisoara**.

---

## 3. Script Location

The main script is `sbin/weather.sh`.

It does the following:

* Fetches current weather via `curl`
* Collects system information (uptime, disk, CPU, memory)
* Updates `/etc/motd`
* Logs weather fetches to `/var/log/weather.log`

---

## 4. Systemd Service

The service `/etc/systemd/system/weather.service` ensures the script runs at boot:

```ini
[Unit]
Description=Fetch weather and update MOTD
After=network.target

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/local/bin/weather.sh

[Install]
WantedBy=multi-user.target
```

* **Enable at boot**:

```bash
sudo systemctl enable weather.service
```

* **Start manually**:

```bash
sudo systemctl start weather.service
```

* **Check status**:

```bash
sudo systemctl status weather.service
```

---

## 5. Logs

Weather fetches are logged in `/var/log/weather.log`:

```bash
cat /var/log/weather.log
```

Example log entry:

```
[Mon Aug 19 12:45:00 UTC 2025] Weather fetched for Stockholm: Stockholm: 🌤 +22°C
```

---

## 6. Viewing the MOTD

After login, the MOTD appears automatically:

```text
~~~~~~~~~~~~Welcome to the Almighty Linux VM~~~~~~~~~~~~

City: Stockholm
Weather: ⛅️  +16°C
Hostname: ip-172-31-22-143.eu-north-1.compute.internal
Time: Tue Aug 19 11:42:44 UTC 2025
Uptime: up 3 hours, 11 minutes

Hint: Grab a beer and get coding !! xD

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
********************************************************
________________________________________________________
 __    __     __     ______     ______     __     __
/\ "-./  \   /\ \   /\  == \   /\  ___\   /\ \   /\ \
\ \ \-./\ \  \ \ \  \ \  __<   \ \ \____  \ \ \  \ \ \
 \ \_\ \ \_\  \ \_\  \ \_\ \_\  \ \_____\  \ \_\  \ \_\
  \/_/  \/_/   \/_/   \/_/ /_/   \/_____/   \/_/   \/_/
________________________________________________________
********************************************************
--------------------------------------------------------
```

---

## 7. Updating the City

* Edit `/etc/default/weather`:

```bash
sudo nano /etc/default/weather
```

* Change the `CITY` variable, save, and then restart the service:

```bash
sudo systemctl restart weather.service
```

---

## 8. Notes

* Script uses `set -euo pipefail` for safe execution
* Requires `curl` installed:

```bash
sudo yum install curl -y
```
