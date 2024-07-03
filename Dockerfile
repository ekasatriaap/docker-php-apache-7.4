
# Menggunakan image resmi PHP 7.4 dengan Apache
FROM php:7.4-apache
LABEL maintainer="Eka S Ariaputra <ekasatria.ariaputra@gmail.com>"

# Memperbarui repository package dan menginstal dependencies dasar
RUN apt-get update && apt-get install -y \
    git \
    zip \
    unzip \
    curl \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install -j$(nproc) mbstring \
    && docker-php-ext-install -j$(nproc) mysqli \
    && docker-php-ext-install -j$(nproc) pdo_mysql \
    && docker-php-ext-install -j$(nproc) zip \
    && docker-php-ext-install -j$(nproc) opcache \
    && docker-php-ext-install -j$(nproc) bcmath \
    && docker-php-ext-install -j$(nproc) intl \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Mengaktifkan modul Apache yang diperlukan
RUN a2enmod rewrite

# Menginstal Composer (Dependency Manager untuk PHP)
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Mengatur working directory di dalam container
WORKDIR /var/www/html

# Menyalin kode aplikasi ke dalam container
# COPY . /var/www/html

# Memberikan hak akses yang sesuai ke direktori penyimpanan yang diperlukan
RUN chown -R www-data:www-data /var/www
RUN chmod -R 777 /var/www


# Menentukan port yang akan digunakan
EXPOSE 80

# Perintah untuk menjalankan Apache saat container dimulai
CMD ["apache2-foreground"]
