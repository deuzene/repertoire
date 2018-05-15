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
* tri par ordre alphabétique de prénom

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

Ce `@repertoire` est sauvegardé sur disque dans le fichier `repertoire` par défaut.

# Utilisation

 Ce programme fonctionne en ligne de commande sur GNU/Linux.

`$ ./repertoire [nom de fichier]`

ouvre `nom de fichier` (_repertoire_ par défaut). Vous pouvez de cette façon avoir plusieurs répertoires.

Suivez les propositions, elles sont assez simples.

Le mode de recherche fonctionne comme ceci : vous fournissez un motif et le
programme renvoie le ou les entrée(s) correspondante(s). Le motif peut être
trouvé dans : le prénom, le nom, les n° de téléphone, les adresses mail ou
encore l'adresse postale.

Le répertoire est sauvegarder automatiquement.

## Licence

Ce travail est placé sous double licences [WTFPL](http://www.wtfpl.net/ "wtfpl.net")/[LPRAB](http://sam.zoy.org/lprab/ "Sam Hocevar") et Beerware ([fr](https://fr.wikipedia.org/wiki/Beerware "wikipedia")) ([en](https://en.wikipedia.org/wiki/Beerware "wikipedia"))

Vous pouvez bien faire ce que vous voulez de ces lignes de code, vous n'êtes
pas obligé de me citer. Par contre si l'envie vous prends de m'offrir une
limonade ou quelques satoshis, à votre bon cœur :)

Bitcoin 1KhkC6U27B9fdzk4qiAF96RK4vpUGPbN7Z

Ether 0x02a611f0c15bccdb6fa8e5e4b0692ff6d77852bd

Litecoin LZz6RCcX8VXznwR4xdjdKLyAhEvB2Y2T8B

Doge DB4D3qwcWj6V6GHjeP88So1TC1SFhbSAfx
