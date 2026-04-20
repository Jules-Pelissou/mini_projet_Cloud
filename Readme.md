# Mini Projet Cloud - Jules PELISSOU

Lors de ce mini projet, j'ai du mettre en place une architecture donnée ainsi qu'ajouter un module de mon choix dans celle-ci.
Pour cela, j'ai choisi d'ajouter le module AWS Translate qui permet de traduire automatiquement les différents textes des pages web.
Au départ, mon choix s'était porté sur AWS CloudWatch toutefois, ce module était déjà présent dans le projet que nous devions reproduire, c'est pour cela que je me suis reporté sur AWS Translate.

# AWS Translate

AWS Translate est un service d'Amazon Cloud qui permet de trouver grâce à la localisation de l'utlisateur la langue qu'il parle et permet de traduire automatiquement la page web dans sa langue. Cela peut permettre de traduire automatiquement des forums par exemple ce qui donne la possibilité d'avoir des conversations compréhensibles par tous sans avoir des problèmes de barrière de langues ou de mauvaises traductions. 

## Les alternatives des autres fournisseurs

AWS n'est pas le seul fournisseur de cloud proposant la traduction automatique des contenus. Chez leurs concurents la même fonctionnalité est également présente. Chez Azure par exemple, il existe la fonctionnalité Azure Translator qui permet de faire essentiellement la même chose qu'AWS Translate. Avec Azure Translator, il est possible de traduire en temps réel une page web dans plus de 100 langues ou encore il est possible d'interroger une API de traduction en temps réel. 
L'autre gros concurrent du marché, Google, propose également la même fonctionnalité via Google Cloud Translation API. Google propose essentiellement le même service qu'AWS et Azure tout en ajoutant la possiblité de choisir le modèle de traduction entre la Traduction automatique neuronale (NMT) pour du texte d'ordre général dans des cas d'utilisation courants, comme le contenu de sites Web ou des articles d'actualité ou un modèle de LLM de traduction plus utile pour le conversationnel (forums).

# Les autres services

Dans ce projet nous avons utilisé d'autres services, à savoir CloudWatch (service que j'avais précédement pris comme service personnel à intégrer), RDS (Relational Database Service), S3 (Stockage d'objets dans le cloud), VPC (Virtual Private Cloud), ELB (Elastic Load Balancer).

Cloudwatch est un service qui permet d'envoyer des alertes dès qu'une machine virtuelle ou qu'un équipement virtualisé dépasse un certain seuil prédéfini d'utilisation de ses ressources. Ce service sert principalement pour le monitoring des ressources virtuelles déployées.

RDS permet la mise en place de bases de données relationnelles dans le cloud (MySQL, PostGreSQL, MariaDB (notre cas)). Cela permet d'avoir une base de données qui possède des sauvegardes automatiques configurables (backup), avec dans notre cas une backup d'un jour. Il est égalemetn possible de répliquer la base de données dans le cloud afin d'éviter les pannes. Cela évite d'avoir à gérer une base de données et son serveur associé. 

S3 permet de stocker des objets dans le cloud. Par cela nous entendons le stockage de données statiques telles que les vidéos ou images. Cela permet notamment de versionner les éléments ajoutés. 

VPC sert à la création de réseaux virtualisés. Cela permet de simuler des "discussions" entre différentes machines dans le cloud. De plus, cela permet également de créer des réseaux virtuels privés (VLAN) dans lesquels placer les machines virtuelles elles aussi. Pour faire simple, cela permet de recréer toute une architecture réseau sur le cloud.

ELB quand à lui est utilisé de concert avec CloudWatch. En effet, CloudWatch envoie les alertes de sur-utilisation des ressources d'un équipement et ELB se base sur ses alertes pour ensuite répartir les charges. En effet, il va créer de nouvelles instances ou détruire des instances de l'application pour supporter le traffic. Il ne va toutefois pas gérer les machines directement, seulement les instances de l'application déployée.

