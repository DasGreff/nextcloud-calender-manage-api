# Nextcloud Calendar API

## Description

Cette API REST permet d'interagir avec les calendriers Nextcloud via le protocole CalDAV. Elle fournit une interface HTTP simple pour gérer les événements de calendrier : création, suppression, consultation et vérification d'existence. L'API est construite avec Flask et utilise la bibliothèque `caldav` pour communiquer avec Nextcloud.

**Basé sur le projet original :** [murajo/nextcloud-calender-manage-api](https://github.com/murajo/nextcloud-calender-manage-api)

Cette API est conçue pour être appelée depuis des scripts d'automatisation afin d'ajouter automatiquement des événements au calendrier de manière régulière.

## Fonctionnalités

- 📅 **Gestion des calendriers** : Liste tous les calendriers disponibles
- ➕ **Création d'événements** : Ajoute des événements avec date/heure, titre, description
- 🗑️ **Suppression d'événements** : Supprime des événements par nom
- 📋 **Consultation d'événements** : Liste tous les événements d'un calendrier
- ✅ **Vérification d'existence** : Vérifie si un événement existe déjà
- 🌐 **API REST** : Interface HTTP standardisée
- 🔒 **Support SSL optionnel** : Configuration flexible de la vérification SSL
- 🌍 **Support des fuseaux horaires** : Gestion configurable des timezones

## Prérequis

- Serveur Nextcloud avec CalDAV activé
- Compte utilisateur Nextcloud avec accès aux calendriers
- Docker (pour l'exécution containerisée)

## Configuration

### Variables d'environnement

Configurez les variables dans le fichier `env` :

```bash
# URL du serveur Nextcloud (endpoint CalDAV)
NEXTCLOUD_URL="https://votre-nextcloud.com/remote.php/dav"

# Identifiants Nextcloud
NEXTCLOUD_USERNAME="votre_utilisateur"
NEXTCLOUD_PASSWORD="votre_mot_de_passe"

# Vérification SSL (true/false)
VERIFY_SSL="true"
```

### Dépendances Python

Les dépendances principales incluent :
- `Flask` : Framework web
- `caldav` : Client CalDAV
- `icalendar` : Manipulation des événements iCal
- `recurring-ical-events` : Support des événements récurrents

## Installation et déploiement

### Avec Docker (recommandé)

#### 1. Construction de l'image
```bash
cd /srv/svc/nextcloud-calendar-api
docker build -t nextcloud-calendar-api:latest .
```

#### 2. Exécution du conteneur
```bash
docker run -d \
  --name nextcloud-calendar-api \
  --env-file env \
  -p 5000:5000 \
  nextcloud-calendar-api:latest
```

#### 3. Avec docker-compose
```yaml
services:
  nextcloud-calendar-api:
    build: .
    container_name: nextcloud-calendar-api
    env_file:
      - env
    ports:
      - "5000:5000"
    restart: unless-stopped
    environment:
      - NEXTCLOUD_URL=https://votre-nextcloud.com/remote.php/dav
      - NEXTCLOUD_USERNAME=votre_utilisateur
      - NEXTCLOUD_PASSWORD=votre_mot_de_passe
      - VERIFY_SSL=false
```

### Installation locale

```bash
# Installation des dépendances
pip install -r requirements.txt

# Configuration des variables d'environnement
export NEXTCLOUD_URL="https://votre-nextcloud.com/remote.php/dav"
export NEXTCLOUD_USERNAME="votre_utilisateur"
export NEXTCLOUD_PASSWORD="votre_mot_de_passe"
export VERIFY_SSL="true"

# Lancement de l'application
python src/app.py
```

## Utilisation de l'API

L'API écoute sur le port 5000 et expose les endpoints suivants :

### 📅 Lister les calendriers

```http
GET /calendars
```

**Réponse :**
```json
{
  "calendars": ["Personnel", "Travail", "Famille"]
}
```

### ➕ Ajouter un événement

```http
POST /add_event
Content-Type: application/json
```

**Payload :**
```json
{
  "calendar_name": "Personnel",
  "start_time": "2025-10-25T14:00:00",
  "end_time": "2025-10-25T15:00:00",
  "summary": "Réunion importante",
  "description": "Discussion sur le projet",
  "timezone": "Europe/Paris"
}
```

**Réponse :**
```json
{
  "message": "Event added to Personnel"
}
```

### 🗑️ Supprimer un événement

```http
DELETE /delete_event
Content-Type: application/json
```

**Payload :**
```json
{
  "calendar_name": "Personnel",
  "summary": "Réunion importante"
}
```

**Réponse :**
```json
{
  "message": "Event 'Réunion importante' deleted from Personnel"
}
```

### 📋 Lister les événements

```http
GET /events?calendar_name=Personnel
```

**Réponse :**
```json
{
  "events": ["Event1", "Event2"]
}
```

### ✅ Vérifier l'existence d'un événement

```http
GET /event_exists?calendar_name=Personnel&summary=Réunion importante
```

**Réponse :**
```json
{
  "exists": true
}
```

## Exemples d'utilisation

### Avec curl

#### Lister les calendriers
```bash
curl -X GET http://localhost:5000/calendars
```

#### Ajouter un événement
```bash
curl -X POST http://localhost:5000/add_event \
  -H "Content-Type: application/json" \
  -d '{
    "calendar_name": "Personnel",
    "start_time": "2025-12-25T10:00:00",
    "end_time": "2025-12-25T12:00:00",
    "summary": "Repas de Noël",
    "description": "Déjeuner en famille",
    "timezone": "Europe/Paris"
  }'
```

#### Supprimer un événement
```bash
curl -X DELETE http://localhost:5000/delete_event \
  -H "Content-Type: application/json" \
  -d '{
    "calendar_name": "Personnel",
    "summary": "Repas de Noël"
  }'
```

### Avec Python requests

```python
import requests
import json

API_BASE = "http://localhost:5000"

# Lister les calendriers
response = requests.get(f"{API_BASE}/calendars")
calendars = response.json()["calendars"]
print(f"Calendars: {calendars}")

# Ajouter un événement
event_data = {
    "calendar_name": "Personnel",
    "start_time": "2025-11-15T09:00:00",
    "end_time": "2025-11-15T10:00:00",
    "summary": "Rendez-vous médecin",
    "description": "Consultation annuelle",
    "timezone": "Europe/Paris"
}

response = requests.post(
    f"{API_BASE}/add_event",
    headers={"Content-Type": "application/json"},
    data=json.dumps(event_data)
)
print(response.json())

# Vérifier l'existence
response = requests.get(
    f"{API_BASE}/event_exists",
    params={
        "calendar_name": "Personnel",
        "summary": "Rendez-vous médecin"
    }
)
print(f"Event exists: {response.json()['exists']}")
```

## Format des données

### Événement complet

```json
{
  "calendar_name": "Personnel",
  "start_time": "2025-10-25T14:00:00",
  "end_time": "2025-10-25T15:00:00",
  "summary": "Titre de l'événement",
  "description": "Description détaillée (optionnel)",
  "timezone": "Europe/Paris"
}
```

### Fuseaux horaires supportés

Utilisez les identifiants IANA standard :
- `Europe/Paris`
- `Europe/London`
- `America/New_York`
- `Asia/Tokyo`
- `UTC`

### Format des dates

Les dates doivent être au format ISO 8601 : `YYYY-MM-DDTHH:MM:SS`

## Gestion des erreurs

L'API retourne des codes d'erreur HTTP standards :

- **200** : Succès
- **400** : Données invalides
- **500** : Erreur serveur

**Exemple de réponse d'erreur :**
```json
{
  "error": "Invalid event data"
}
```

## Dépannage

### Problèmes courants

#### "Error initializing client"
- **Cause** : URL Nextcloud incorrecte ou credentials invalides
- **Solution** : Vérifiez `NEXTCLOUD_URL`, `NEXTCLOUD_USERNAME`, `NEXTCLOUD_PASSWORD`

#### "Calendar not found"
- **Cause** : Le calendrier spécifié n'existe pas
- **Solution** : Utilisez `/calendars` pour lister les calendriers disponibles

#### Erreurs SSL
- **Cause** : Certificat SSL invalide ou auto-signé
- **Solution** : Définissez `VERIFY_SSL="False"` pour les environnements de test

#### "Failed to retrieve calendars"
- **Cause** : Problème de connexion ou permissions insuffisantes
- **Solution** : Vérifiez la connectivité réseau et les droits utilisateur

### Vérifications de base

```bash
# Test de connectivité
curl -X GET http://localhost:5000/calendars

# Vérification des logs Docker
docker logs nextcloud-calendar-api

# Test de l'endpoint CalDAV
curl -u username:password https://votre-nextcloud.com/remote.php/dav/calendars/username/
```

## Développement

### Structure du code

- **`app.py`** : Routes Flask et logique API
- **`calendar_client.py`** : Client CalDAV et manipulation des événements

### Ajout de fonctionnalités

Pour ajouter de nouveaux endpoints :

1. Ajoutez la méthode dans `calendar_client.py`
2. Créez la route correspondante dans `app.py`
3. Testez avec curl ou Postman

### Tests

```bash
# Test de connexion à l'API
curl -X GET http://localhost:5000/calendars

# Test unitaire basique
python -c "
from src.calendar_client import NextCloudCalendarClient
client = NextCloudCalendarClient('http://localhost', 'test', 'test')
print('Client initialized successfully')
"

# Test complet d'ajout d'événement
curl -X POST http://localhost:5000/add_event \
  -H "Content-Type: application/json" \
  -d '{
    "calendar_name": "Test",
    "start_time": "2025-10-26T10:00:00",
    "end_time": "2025-10-26T11:00:00",
    "summary": "Test Event",
    "description": "Test Description",
    "timezone": "Europe/Paris"
  }'
```

## Sécurité

### Bonnes pratiques

- 🔐 **Credentials** : Utilisez des variables d'environnement, jamais en dur
- 🔒 **SSL** : Activez `VERIFY_SSL=true` en production
- 🌐 **Réseau** : Limitez l'accès réseau au conteneur
- 👤 **Permissions** : Utilisez un compte Nextcloud dédié avec permissions minimales

### Configuration sécurisée

```bash
# Variables d'environnement sécurisées
NEXTCLOUD_URL="https://nextcloud.example.com/remote.php/dav"
NEXTCLOUD_USERNAME="api-calendar"
NEXTCLOUD_PASSWORD="mot_de_passe_fort_génère"
VERIFY_SSL="true"
```

## Cas d'usage

Cette API est conçue pour être appelée depuis des scripts d'automatisation afin d'ajouter automatiquement des événements au calendrier de manière régulière. Elle est particulièrement utile pour :

- **Scripts d'automatisation** : Ajout programmé d'événements via des scripts Python/Bash
- **Tâches cron récurrentes** : Création automatique d'événements selon un planning défini
- **Intégration dans des workflows** : Ajout d'événements basé sur des déclencheurs externes
- **Synchronisation de données** : Import automatique d'événements depuis d'autres sources
- **Gestion programmatique** : Manipulation des calendriers via des applications tierces

**Exemple typique :** Un script qui s'exécute quotidiennement pour ajouter automatiquement des événements de maintenance, des rappels ou des rendez-vous basés sur des données externes.

## Intégration dans des scripts

### Exemples d'automatisation

L'API est conçue pour être appelée depuis des scripts. Voici quelques exemples d'intégration :

#### Script cron pour événements récurrents
```bash
#!/bin/bash
# Script exécuté quotidiennement pour ajouter des événements de maintenance

curl -X POST http://localhost:5000/add_event \
  -H "Content-Type: application/json" \
  -d '{
    "calendar_name": "Maintenance",
    "start_time": "'$(date -d "tomorrow 02:00" +%Y-%m-%dT%H:%M:%S)'",
    "end_time": "'$(date -d "tomorrow 04:00" +%Y-%m-%dT%H:%M:%S)'",
    "summary": "Sauvegarde automatique",
    "description": "Sauvegarde planifiée du système"
  }'
```

#### Script Python pour import de données
```python
#!/usr/bin/env python3
# Script pour importer des événements depuis une source externe

import requests
import json
from datetime import datetime, timedelta

def add_events_from_data(events_data):
    api_url = "http://localhost:5000/add_event"
    
    for event in events_data:
        payload = {
            "calendar_name": "Import",
            "start_time": event["start"].isoformat(),
            "end_time": event["end"].isoformat(),
            "summary": event["title"],
            "description": f"Importé automatiquement: {event['source']}"
        }
        
        response = requests.post(api_url, json=payload)
        if response.status_code == 200:
            print(f"✓ Événement ajouté: {event['title']}")
        else:
            print(f"✗ Erreur: {response.json()}")

# Utilisation dans un script d'automatisation
if __name__ == "__main__":
    # Récupération des données depuis une source externe
    external_events = get_events_from_external_source()
    add_events_from_data(external_events)
```

## Crédits

Ce projet est basé sur [nextcloud-calender-manage-api](https://github.com/murajo/nextcloud-calender-manage-api) par [@murajo](https://github.com/murajo).
