    sudo useradd attacker
    sudo passwd attacker
    echo "*/5 * * * * /tmp/.hidden_script" | sudo crontab -u attacker -
    echo "malicious content" > /tmp/.hidden_file
    chmod 777 /tmp/.hidden_file
    echo "echo 'I am hidden'" > /tmp/.hidden_script
    chmod +x /tmp/.hidden_script
    sudo lvcreate -L 500M -n secure_data vg_secure
    sudo mkfs.ext4 /dev/vg_secure/secure_data
    sudo mkdir /mnt/secure_data
    sudo mount /dev/vg_secure/secure_data /mnt/secure_data
    echo "Fichier sensible 1" > /mnt/secure_data/sensitive1.txt
    echo "Fichier sensible 2" > /mnt/secure_data/sensitive2.txt
    echo "/dev/vg_secure/secure_data /mnt/secure_data ext4 defaults 0 0" | sudo tee -a /etc/fstab
    for i in {1..1000}; do
        echo "$(date -d "$((RANDOM%7)) days ago" +'%b %d %H:%M:%S') DEBUG: Random log message $RANDOM" >> /var/log/messy_logs.log
        echo "$(date -d "$((RANDOM%7)) days ago" +'%b %d %H:%M:%S') INFO: User logged in from $(shuf -n 1 -e 192.168.1.{1..255})" >> /var/log/messy_logs.log
    done
    sudo mkdir /home/hidden_data
    echo "This is an email: admin@example.com" > /home/hidden_data/file1.txt
    echo "IMPORTANT: IP address 10.0.0.1" > /home/hidden_data/file2.txt
    echo "SGVsbG8sIHRoZXJlIQ==" > /home/hidden_data/base64_file.txt
    echo "SECRET data found here" > /home/hidden_data/secret_data.txt
    sudo mkdir -p /opt/challenge
    echo "FRAGMENT 3: 0x212121" >> /opt/challenge/puzzle_data.txt
    echo "FRAGMENT 1: 0x48656c6c6f" >> /opt/challenge/puzzle_data.txt
    echo "FRAGMENT 2: 0x776f726c64" >> /opt/challenge/puzzle_data.txt
    echo "$(date) Failed password for invalid user root from 203.0.113.42 port 22 ssh2" >> /var/log/secure
    echo "$(date) Failed password for invalid user test from 198.51.100.23 port 22 ssh2" >> /var/log/secure
    echo "$(date) Failed password for invalid user admin from 192.0.2.55 port 22 ssh2" >> /var/log/secure
    sudo dnf install audit -y
    sudo systemctl enable auditd
    sudo systemctl start auditd
    sudo auditctl -w /etc/ -p wa -k etc_changes