# Repertoire

## Introduction

Ce programme me sert d'exercice personnel pour apprendre à coder, notamment en
Perl5.

C'est un simple répertoire téléphonique comportant :

* prénom
* nom
* plusieurs n° de téléphone
* plusieurs adresses mail
* une adresse postale

Il permet :

* d'ajouter ou supprimer une entrée
* rechercher une entrée sur toutes les données
* afficher le répertoire
* afficher une entrée
* modifier une entrée

## Structure des données

Les données sont stockées dans un AoH un peu particulier :

```
@repertoire
          {
          prenom  => $prenom
          nom     => $nom
          tels    => [@tels]
          mail    => [@mail]
          adresse => [@adresse]
          }
```

Ce `@repertoire` est sauvegardé sur disque dans le fichier `repertoire`.

## Licence

Ce travail est placé sous double licences [WTFPL](http://www.wtfpl.net/)/[LPRAB](http://sam.zoy.org/lprab/) et Beerware ([fr](https://fr.wikipedia.org/wiki/Beerware)) ([en](https://en.wikipedia.org/wiki/Beerware))

Vous pouvez bien faire ce que vous voulez de ces lignes de code, vous n'êtes
pas obligé de me citer. Par contre si l'envie vous prends de m'offrir une
limonade ou quelques satoshis, à votre bon cœur :)

Bitcoin 1KhkC6U27B9fdzk4qiAF96RK4vpUGPbN7Z

Ether 0x02a611f0c15bccdb6fa8e5e4b0692ff6d77852bd

Litecoin LZz6RCcX8VXznwR4xdjdKLyAhEvB2Y2T8B

Doge DB4D3qwcWj6V6GHjeP88So1TC1SFhbSAfx