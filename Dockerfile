# Utilisez l'image de base PHP avec Apache
FROM php:apache

# Installe les dépendances nécessaires
RUN apt-get update && apt-get install -y \
    vim \
    git \
    unzip \
    libpng-dev \
    && rm -rf /var/lib/apt/lists/*

# Active l'extension GD dans PHP
RUN docker-php-ext-install gd

# Télécharge et extrait Drupal
WORKDIR /var/www/html
RUN curl -fSL "https://ftp.drupal.org/files/projects/drupal-10.1.6.tar.gz" -o drupal.tar.gz \
    && tar -xz --strip-components=1 -f drupal.tar.gz \
    && rm drupal.tar.gz
# Installation de Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Installation des dépendances de Drupal
RUN COMPOSER_ALLOW_SUPERUSER=1 composer install --no-interaction --ignore-platform-reqs

# Définit les permissions appropriées pour les fichiers Drupal
RUN chown -R www-data:www-data sites modules themes

# Expose le port 80 pour le serveur web
EXPOSE 80

# Démarre le serveur web Apache
CMD ["apache2-foreground"]

