#!/bin/bash
amazon-linux-extras install php7.2
yum -y install httpd24 php-pdo php-mysqlnd git mysql

export COMPOSER_HOME=/usr/lib/composer
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
cd /tmp && curl -LO https://github.com/aws-samples/eb-demo-php-simple-app/releases/download/v1.3/eb-demo-php-simple-app-v1.3.zip

mkdir /var/www/html/testapp
chown apache: -R /var/www/html/testapp
unzip eb-demo-php-simple-app-v1.3.zip -d  /var/www/html/testapp/

cd /var/www/html/testapp/ && /usr/local/bin/composer install

/usr/bin/mysql \
  -u ${DatabaseUser} \
  -p${DatabasePassword} \
  -h ${DBEndpoint} \
  ${TestMysqlRDS} \
  -e 'CREATE TABLE IF NOT EXISTS urler(id INT UNSIGNED NOT NULL AUTO_INCREMENT, author VARCHAR(63) NOT NULL, message TEXT, PRIMARY KEY (id))'

echo "
<Directory /var/www/html/testapp>
  AllowOverride All
  SetEnv RDS_DB_NAME ${TestMysqlRDS}
  SetEnv RDS_USERNAME ${DatabaseUser}
  SetEnv RDS_PASSWORD ${DatabasePassword}
  SetEnv RDS_HOSTNAME ${DBEndpoint}
</Directory>
" >> /etc/httpd/conf.d/testapp.conf

systemctl httpd restart
chkconfig httpd on
